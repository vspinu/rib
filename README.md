

# Installation

Either download the stable client from
https://interactivebrokers.github.io request access rights at the
official [tws-api](https://github.com/InteractiveBrokers/tws-api)
repo and pull directly from git.


Set the path `TWS_API_LIB_PATH` env variable to
`source/cppclient/client` directory from unpacked directory.

Get the source of `rib` package:

```
git clone git@github.com:vspinu/rib.git
```

From R with devtools:

```R
Sys.setenv(TWS_API_LIB_PATH="/path/to/tws-api/source/cppclient/client")
devtools::install("/path/to/rib/")
```

Or from CLI:

```sh
## instal deps from R if you don't have them
# install.packages(c("rlang", "glue", "later"))

cd /path/to/rib
export TWS_API_LIB_PATH=/path/to/tws-api/source/cppclient/client
R CMD install .
```

## Concepts

### Handlers

`rib` `tws` client implements an [interceptor pattern](https://en.wikipedia.org/wiki/Interceptor_pattern) by processing inbound and outbound messages with a set of in-/out-handlers. Each handler receives the message and returns an optionally modifies message. If a handler returns NULL, the message is not passed to the next handler.

The convention is that handlers start with `hlr_` prefix and builder functions which produce handler functions start with `bld_` prefix. There are a few of them defined in the core package.

### Messages

Inbound messages travel on the inbound pipeline and are handled by `inHandlers`. Usually these are messages received from the TWS client, but can also be messages sent by the handlers themselves. For example, `hlr_save_history` handler will send an informative event to the inbound pipeline whenever data is saved to the disk. This is preferred to simple printing to stdout because downstream handlers can decide what to do with the message - log to stdout, to a file etc.

Each inbound message the following components:

```
id: unique incremented id for current R session (produced by rib)
ts: time stamp
ix: index of the event within a TWS message. Usually 1 because one event is normally sent in one message.
event: name of the event
val: value of the event which is event specific
```

```R
##
[inmsg strlist]
 $ id   :"18"
 $ ts   : POSIXct, format: "2022-06-19 17:38:04.97273"
 $ ix   :1
 $ event:"historicalData"
 $ val  :List of 3
  ..$ event:"historicalData"
  ..$ reqId:1655660265
  ..$ bar  :List of 8
  .. ..$ time  :"1655414100"
  .. ..$ high  :1.0549
  .. ..$ low   :1.0546
  .. ..$ open  :1.0546
  .. ..$ close :1.0549
  .. ..$ wap   :NA
  .. ..$ volume:NA
  .. ..$ count :NA

## historicalDataEnd
[inmsg strlist]
 $ id   :"1482"
 $ ts   : POSIXct, format: "2022-06-19 18:16:49.35881"
 $ ix   :1426
 $ event:"historicalDataEnd"
 $ val  :List of 4
  ..$ event       :"historicalDataEnd"
  ..$ reqId       :1655660265
  ..$ startDateStr:"20220618  20:18:29"
  ..$ endDateStr  :"20220619  20:18:29"

```

Outbound messages have similar structure:

```
[outmsg strlist]
 $ ts   : POSIXct, format: "2022-06-23 09:13:06.580041"
 $ event:"reqAccountSummary"
 $ val  :List of 3
  ..$ tags :"AccountType" "NetLiquidation" "TotalCashValue" "SettledCash" "AccruedCash" "BuyingPower" "EquityWithLoanValue" "PreviousEquityWithLoanValue" "GrossPositionValue" "ReqTEquity" "ReqTMargin" "SMA" "InitMarginReq" "MaintMarginReq" "AvailableFunds" "ExcessLiquidity" "Cushion" "FullInitMarginReq" "FullMaintMarginReq" "FullAvailableFunds" ...
  ..$ group:"All"
  ..$ reqId:1655974441
```

Simple constructors for inbound and outbound messages are exported functions `inmsg` and `outmsg`.

## Usage

```R
library(rib)
tws <- tws(port = "twspaper",
           inHandlers =
             c("hlr_track_requests",      # remove requess from tws$requests on xyzEnd events
               "hlr_process_callbacks",   # adds callback functionality
               "hlr_record_stdout_val"    # record messages to stdout
             ),
           outHandlers =
             c("hlr_track_requests",      # add requests to tws$requests environment
               "hlr_record_stdout_val")
           )
tws$open()

tws$reqPositions()
tws$reqAccountUpdates()
tws$reqAccountSummary()

contract <- twsCurrency(localSymbol = "EUR.USD")
tws$reqContractDetails(contract)

tws$close()

```

## Historical Data


```R
hlr_save_history <-
  bld_save_history(contract_fields = c(symbol = "localSymbol"),
                   req_fields = c(wts = "whatToShow", bar = "barSize"),
                   partition = "parquet")

tws <- tws(port = "twspaper",
           inHandlers = "hlr_record_stdout_val",
           outHandlers = "hlr_record_stdout_val")

tws$reqHistoricalData(twsCurrency(localSymbol = "EUR.USD"),
                      duration = "3 D",
                      endDateTime = ymd_hms("2021-01-27 00:00:00", tz = "UTC"),
                      whatToShow = "BID",
                      barSize = "1 min")
```

`reqHistoricalData` is a internally rationed by TWS operation. `rib` provides an extension `reqHistoricalDataBatched` that iterates over smaller time windows.

`rib` also provides a simple handler for saving received data to disk. It can save data in `rds` or `parquet` format . For the latter, `arrow` package must be available. You can use `arrow::dataset` functionality on the resulting data directory.

The batched collection logic will likely result in duplicated data due to slightly overlapping fetch windows. It's is the user's responsibility to de-duplicate the data.

```R

tws <- rib::tws(port = "gwpaper",
                inHandlers = c(
                  c(bld_save_history("./history",
                                     contract_fields = c(symbol = "localSymbol"),
                                     req_fields = c(wts = "whatToShow", bar = "barSize"),
                                     format = "parquet",
                                     partition = "hive"),
                    "hlr_process_callbacks",
                    "hlr_track_requests",
                    bld_recorder(exclude = "[hH]istoricalData"))),
                outHandlers =
                  c("hlr_track_requests"))
tws$open()

tws$reqHistoricalDataBatched(twsCurrency(localSymbol = "EUR.USD"),
                             barSize = "1 min",
                             whatToShow = "BID",
                             startDateTime = "2022-01-01",
                             endDateTime = "2022-01-20")

```

Examples of `partition` argument to the `bld_save_history` builder:

```
# "none" - no partition, all the fields are stored part of the data in each row
20220623T10:34:09 -> save_history (N = 11300, file = "./history/2021-01-04 22:15:00..2021-01-14 20:19:00.parquet")
20220623T10:34:44 -> save_history (N = 11220, file = "./history/2021-01-11 22:15:00..2021-01-21 18:59:00.parquet")

# "fields" - all fields form a partion at ones (1-level hierarchy)
20220623T10:57:05 -> save_history (N = 16000, file = "./history/EUR.USD:BID:5secs/2021-12-30 23:46:40..2021-12-31 21:59:55.parquet")
20220623T10:57:59 -> save_history (N = 16000, file = "./history/EUR.USD:BID:5secs/2021-12-31 19:11:40..2022-01-03 17:39:55.parquet")

# "hive" - hive style partitioning with one level per field
20220623T11:04:07 -> save_history (N = 11380, file = "./history/symbol=EUR.USD/wts=BID/bar=1min/2021-12-28 22:15:00..2022-01-07 21:39:00.parquet")
20220623T11:04:55 -> save_history (N = 11300, file = "./history/symbol=EUR.USD/wts=BID/bar=1min/2022-01-04 22:15:00..2022-01-14 20:19:00.parquet")

```


## Bot Development

### Event Loop Considerations

[TODO]

### Async Calls and Callbacks

[TODO]

### `tws` Constructor

[TODO]

### `strenv` and `strenvdf` Helper Collections

[TODO]

## Differences from the Official tws-api C++ Client

Arguments of TWS Methods are not always consistent and even differ
across different client implementations. `rib` package takes the
liberty to streamline some of the inconsistencies and produce friendly
data types automatically whenever it makes sense.

  - Ticker messages:
    - `tickerId` is converted to `reqId` for consistency with other events
    - `ticker` and `tick` field prefixes are removed. For example `tickAttrib`
      -> `attrib`, `tickType` -> `type`.

  - smartComponents returns a `smartComponents` list of named lists instead of the
    `theMap` map of tuples.

  - When TWS returns a list of structured objects, a data.frame is returned
    whenever makes sense (`histogramData`, `softDollarTiers`, `familyCodes`,
    `mktDepthExchanges`, `smartComponents`, `newsProviders`)

  - Streamline some parameter names for consistency, simplicity or readability:
      `acctCode` -> `accountCode`,
      `reqMarketDataType`->`reqMktDataType`,
      `miscOptions` -> `options` etc
      `durationStr` -> `duration` (string)
      `barSizeSetting` -> `barSize` (string)

  - Convert string values to apropriate R types:
    + `updateAccountValue`: convert values to numeric whenever makes sense
    + `execDetails`,`orderStatus`,`comissionReport`: whenever makes sense convert string fields to numeric and `MAX_DOUBLE`, `MAX_INTEGER` etc to `NA`
    + `currentTime`,`realtimeBar`, `tickNews`, `historicalTicksBidAsk`, etc.: `time` numeric argument is converted to POSIXct.



## For Developers

I order to upgrade the package to the new version of TWS client the
following steps are necessary:

   1. Add new entries to R/constants.R from
   https://github.com/InteractiveBrokers/tws-api/blob/master/source/javaclient/com/ib/client/EClient.java#L303
   https://github.com/InteractiveBrokers/tws-api/blob/master/source/javaclient/com/ib/client/EDecoder.java#L102

   2. Add new events to [src/RWrapper.cpp](src/RWrapper.cpp) within versioned ifelse pragmas
   https://github.com/InteractiveBrokers/tws-api/blob/master/source/cppclient/client/DefaultEWrapper.cpp#L106
   https://github.com/InteractiveBrokers/tws-api/blob/master/source/cppclient/client/EDecoder.cpp#L26

   3. Add new requests to [R/client.R](R/client.R) and [src/rib.cpp](src/rib.cpp) accordingly
   https://github.com/InteractiveBrokers/tws-api/blob/master/source/cppclient/client/EClient.cpp#L34
