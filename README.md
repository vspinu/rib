

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

# Usage

`rib` `tws` client processes inbound and outbound messages with a set
of in- and out-handlers. Each handler receives the message and returns
an optionally modifies message. If a handler returns NULL, the message
is not passed to the next handler.


```R

library(rib)
tws <- tws(port = "twspaper",
           inHandlers =
             c("hlr_track_requests",      # standard handler that automatically saves and removes requess with an `id` field
               "hlr_process_callbacks",   # adds callback functionality
               "hlr_record_stdout_val"    # record messages to stdout
               ),
           outHandlers =
             c("hl_track_requests",
               "hl_record_stdout_val")
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
           inHandlers = c("hlr_record_stdout_val"),
           outHandlers = "hl_record_stdout_val")

tws$reqHistoricalData(twsCurrency(localSymbol = "EUR.USD"),
                      durationStr = "1 D",
                      whatToShow = "BID",
                      barSizeSetting = "1 min")


```

# Differences from the official cppclient implementation

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



### [For developers] On TWS client version update

   1. Add new entries to R/constants.R from
   https://github.com/InteractiveBrokers/tws-api/blob/master/source/javaclient/com/ib/client/EClient.java#L303
   https://github.com/InteractiveBrokers/tws-api/blob/master/source/javaclient/com/ib/client/EDecoder.java#L102

   2. Add new events to src/RWrapper.cpp within versioned ifelse pragmas
   https://github.com/InteractiveBrokers/tws-api/blob/master/source/cppclient/client/DefaultEWrapper.cpp#L106
   https://github.com/InteractiveBrokers/tws-api/blob/master/source/cppclient/client/EDecoder.cpp#L26

   3. Add new requests to R/client.R and src/rib.cpp accordingly
   https://github.com/InteractiveBrokers/tws-api/blob/master/source/cppclient/client/EClient.cpp#L34
