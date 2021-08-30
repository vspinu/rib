


* Hopefully a comprehensive set of differences from the official cppclient implementation:

  - Ticker messages:
    - `tickerId` is converted to `reqId` for consistency with other events
    - `ticker` and `tick` field prefixes are removed. For example `tickAttrib`
      -> `attrib`, `tickType` -> `type`.

  - smartComponents returns a `smartComponents` list of named lists instead of the
    `theMap` map of tuples.

  - When TWS returns a list of structured objects, a data.frame is returned
    whenever makes sense (`histogramData`, `softDollarTiers`, `familyCodes`,
    `mktDepthExchanges`, `smartComponents`, `newsProviders`)

  - Streamline some parameter names for consistency and readability:
      `acctCode` -> `accountCode`,
      `reqMarketDataType`->`reqMktDataType`,
      `miscOptions` -> `options` etc

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
