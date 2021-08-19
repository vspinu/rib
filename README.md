


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
    + `currentTime`,`realtimeBar`, `tickNews`, `historicalTicksBidAsk`, etc.: `time` numeric argument is converted to POSIXct.
