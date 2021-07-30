

check_named_list <- function(x) {
  if (length(x) > 0 && (is.null(names(x)) || !all(nzchar(names(x)))))
    stop(sprintf("Argument '%s' must be a named vector", deparse(substitute(x))), call. = FALSE)
  as.list(x)
} 

## This brings 2-3x overhead. TODO: refactor all functions place with new_function ...
dispatch_encoder <- function(name) {
  fn <- sys.function(sys.parent(1))
  cl <- sys.call(sys.parent(1L))
  nms <- names(formals(fn))[-1]
  args <- structure(lapply(nms, as.name), names = nms)
  cname <- paste0("C_", substitute(name))
  call <- rlang::call2(cname, quote(self$twsServerVersion), !!!args)
  eval(call, parent.frame())
}

##' enc_reqMktData()
# https://interactivebrokers.github.io/tws-api/md_request.html
# https://interactivebrokers.github.io/tws-api/classIBApi_1_1EClient.html#a7a19258a3a2087c07c1c57b93f659b63
enc_reqMktData <- function(self, contract, 
                           genericTicks = '100,101,104,106,165,221,225,236',
                           snapshot = FALSE,
                           regulatorySnaphsot = FALSE,
                           mktDataOptions = list(), 
                           reqId = self$nextId()) {
  mktDataOptions <- check_named_list(mktDataOptions)
  dispatch_encoder(enc_reqMktData)
}

enc_cancelMktData <- function(self, reqId) {
  dispatch_encoder(enc_cancelMktData)
}

enc_reqMktDepth <- function(self, contract, numRows = 20, isSmartDepth = FALSE,
                            mktDepthOptions = list(), reqId = self$nextId()) {
  mktDataOptions <- check_named_list(mktDataOptions)
  dispatch_encoder(enc_reqMktDepth)
}

enc_cancelMktDepth <- function(self, reqId, isSmartDepth = FALSE) {
  dispatch_encoder(enc_cancelMktDepth)
}

enc_reqHistoricalData <-
  function(self, contract,
           endDateTime = NULL,
           durationStr = "1 M",
           barSizeSetting = BAR_SIZE_TYPES,
           whatToShow = WHAT_TO_SHOW_TYPES,
           useRTH = TRUE,
           formatDate = TRUE,
           keepUpToDate = FALSE,
           chartOptions = list(),
           reqId = self$nextId()) {
    whatToShow <- match.arg(whatToShow)
    endDateTime <-
      if (is.null(endDateTime)) now() + 100
      else as_datetime(endDateTime)
    endDateTime <-  strftime(endDateTime, format='%Y%m%d %H:%M:%S', usetz = FALSE)
    dispatch_encoder(enc_reqHistoricalData)
  }

enc_cancelHistoricalData <- function(self, reqId) {
  dispatch_encoder(enc_cancelHistoricalData)
}

enc_reqRealTimeBars <- function(self, contract, barSize = 5,
                                whatToShow = c("TRADE", "MIDPOINT", "BID", "ASK"), 
                                useRTH = TRUE,
                                realTimeBarsOptions = list(), 
                                reqId = self$nextId()) {
  realTimeBarsOptions <- check_named_list(realTimeBarsOptions)
  dispatch_encoder(enc_reqRealTimeBars)
}

enc_cancelRealTimeBars <- function(self, reqId) {
  C_enc_cancelMktData(self$twsServerVersion, reqId)
}

enc_reqScannerParameters <- function(self) {
  C_enc_reqScannerParameters(self$twsServerVersion)
}

enc_reqScannerSubscription <- function(self,
                                       subscription,
                                       scannerSubscriptionOptions = list(),
                                       scannerSubscriptionFilterOptions = list(),
                                       reqId = self$nextId()) {
  C_enc_reqScannerSubscription(self$twsServerVersion,
                               reqId = reqId,
                               subscription = subscription,
                               scannerSubscriptionOptions = check_named_list(scannerSubscriptionOptions),
                               scannerSubscriptionFilterOptions = check_named_list(scannerSubscriptionFilterOptions))
}

enc_cancelScannerSubscription <- function(self, reqId) {
  C_enc_cancelScannerSubscription(self$twsServerVersion, reqId)
}

enc_reqFundamentalData <- function(self, contract, reportType = TWS_REPORT_TYPES,
                                   fundamentalDataOptions = list(),
                                   reqId = self$nextId()) {
  reportType <- match.arg(reportType)
  fundamentalDataOptions <- check_named_list(fundamentalDataOptions)
  dispatch_encoder(enc_reqFundamentalData)
}

enc_cancelFundamentalData <- function(self, reqId) {
  dispatch_encoder(enc_cancelFundamentalData)
}

enc_calculateImpliedVolatility <- function(self, contract, optionPrice, underPrice, options = list(), reqId = self$nextId()) {
  C_enc_calculateImpliedVolatility(self$twsServerVersion, reqId = reqId, contract = contract, optionPrice = optionPrice,
                                   underPrice = underPrice, options = check_named_list(options))
}

enc_cancelCalculateImpliedVolatility <- function(self, reqId) {
  C_enc_cancelCalculateImpliedVolatility(self$twsServerVersion, reqId);
}

enc_calculateOptionPrice <- function(self, contract, volatility, underPrice, options = list(), reqId = self$nextId()) {
  C_enc_calculateOptionPrice(self$twsServerVersion, reqId = reqId, contract = contract, volatility = volatility,
                             underPrice = underPrice, options = check_named_list(options));
}

enc_cancelCalculateOptionPrice <- function(self, reqId) {
  C_enc_cancelCalculateOptionPrice(self$twsServerVersion, reqId);
}

enc_reqContractDetails <- function(self, contract, reqId = self$nextId()) {
  dispatch_encoder(enc_reqContractDetails)
}

enc_reqCurrentTime <- function(self) {
  C_enc_reqCurrentTime(self$twsServerVersion)
}

enc_placeOrder <- function(self, contract, order, id = self$nextId()) {
  C_enc_placeOrder(self$twsServerVersion, id = id, contract = contract, order = order);
}

enc_cancelOrder <- function(self, id) {
  C_enc_cancelOrder(self$twsServerVersion, id);
}

enc_reqAccountUpdates <- function(self, accountCode = "1") {
  dispatch_encoder(enc_reqAccountUpdates)
}

enc_cancelAccountUpdates <- function(self, accountCode = "1") {
  dispatch_encoder(enc_cancelAccountUpdates)
}

enc_reqOpenOrders <- function(self) {
  C_enc_reqOpenOrders(self$twsServerVersion)
}

enc_reqAutoOpenOrders <- function(self, autoBind = TRUE) {
  C_enc_reqAutoOpenOrders(self$twsServerVersion, autoBind = autoBind)
}

enc_reqAllOpenOrders <- function(self) {
  C_enc_reqAllOpenOrders(self$twsServerVersion)
}

enc_reqExecutions <- function(self, filter, reqId = self$nextId()) {
  C_enc_reqExecutions(self$twsServerVersion, reqId, filter);
}

enc_reqIds <- function(self, numIds) {
  C_enc_reqIds(self$twsServerVersion, numIds);
}

enc_reqNewsBulletins <- function(self, allMsgs = FALSE) {
  C_enc_reqNewsBulletins(self$twsServerVersion, allMsgs);
}

enc_cancelNewsBulletins <- function(self)  {
  C_enc_cancelNewsBulletins(self$twsServerVersion)
}

enc_setServerLogLevel <- function(self, logLevel = c("system", "error", "warn", "info", "detail")) {
  logLevel <- match.arg(logLevel)
  logLevel <- match(logLevel, c("system", "error", "warn", "info", "detail"))
  C_enc_setServerLogLevel(self$twsServerVersion, logLevel);
}

enc_reqManagedAccounts <- function(self) {
  C_enc_reqManagedAccunts(self$twsServerVersion)
}

enc_requestFA <- function(self, faDataType = c("groups", "profiles", "aliases")) {
  faDataType <- match.arg(faDataType)
  C_enc_requestFA(self$twsServerVersion, faDataType = faDataType)
}

enc_requestFA <- function(self, faDataType = c("groups", "profiles", "aliases"),
                          xml = "") {
  faDataType <- match.arg(faDataType)
  C_enc_replaceFA(self$twsServerVersion, faDataType = faDataType, xml = xml)
}


enc_exerciseOptions <- function(self, contract, exerciseQuantity,
                                exerciseAction = c("exercise", "lapse"),
                                account = "", override = FALSE,
                                reqId = self$nextId()) {
  exerciseAction <- match.arg(exerciseAction)
  C_enc_exerciseOptions(self$twsServerVersion, reqId, contract, exerciseAction, exerciseQuantity, account, override)
}

enc_reqGlobalCancel <- function(self) {
  C_enc_reqGlobalCancel(self$serverVersion)
}

enc_reqMktDataType <- function(self, mktDataType = c("realtime", "frozen", "delayed", "delayed_frozen")) {
  #  1: realtime       Frozen, Delayed, and Delayed-Frozen data are disabled
  #  2: frozen         Frozen data is enabled
  #  3: delayed        Delayed data is enabled, Delayed-Frozen data is disabled
  #  4: delayed_frozen Delayed and Delayed-Frozen data are enabled
  mktDataType <- match.arg(mktDataType)
  mktDataType <- match(mktDataType, c("realtime", "frozen", "delayed", "delayed_frozen"))
  C_enc_reqMktDataType(self$twsServerVersion, mktDataType = mktDataType)
}

enc_reqPositions <- function(self) {
  C_enc_reqPositions(self$twsServerVersion)
}

enc_cancelPositions <- function(self) {
  C_enc_cancelPositions(self$twsServerVersion)
}

enc_reqPositionsMulti <- function(self, account = "", modelCode = "", reqId = self$nextId()) {
  C_enc_reqPositionsMulti(self$twsServerVersion, reqId, account, modelCode)
}

enc_cancelPositionsMulti <- function(self, reqId) {
  C_enc_cancelPositionsMulti(self$twsServerVersion, reqId)
}


enc_reqAccountSummary <- function(self, tags = "", groupName = "All", reqId = self$nextId()) {
  C_enc_reqAccountSummary(self$twsServerVersion, reqId, groupName, tags)
}

enc_cancelAccountSummary <- function(self, reqId) {
  C_enc_cancelAccountSummary(self$twsServerVersion, reqId)
}

## enc_verifyRequest <- function(self, apiName, apiVersion) {
##   C_enc_verifyRequest(self$twsServerVersion, apiName, apiVersion)
## }

## enc_verifyMessage <- function(self, apiData) {
##   C_enc_verifyMessage(self$twsServerVersion, apiData)
## }

## enc_verifyAndAuthRequest <- function(self, apiName, apiVersion, opaqueIsvKey) {
##   C_enc_verifyAndAuthRequest(self$twsServerVersion, apiName, apiVersion, opaqueIsvKey)
## }

## enc_verifyAndAuthMessage <- function(self, apiData, xyzResponse) {
##   C_enc_verifyAndAuthMessage(self$twsServerVersion, apiData, xyzResponse)
## }

enc_queryDisplayGroups <- function(self, reqId = self$nextId()) {
  C_enc_queryDisplayGroups(self$twsServerVersion, reqId)
}

enc_subscribeToGroupEvents <- function(self, groupId, reqId = self$nextId()) {
  C_enc_subscribeToGroupEvents(self$twsServerVersion, reqId, groupId)
}

enc_unsubscribeFromGroupEvents <- function(self, reqId) {
  C_enc_unsubscribeFromGroupEvents(self$twsServerVersion, reqId)
}

enc_updateDisplayGroup <- function(self, contractInfo = "none", reqId = self$nextId()) {
  C_enc_updateDisplayGroup(self$twsServerVersion, reqId, contractInfo)
}

## enc_startApi <- function(self) {
##   C_enc_startApi(self$serverVersion)
## }

enc_reqAccountUpdatesMulti <- function(self, account = "", modelCode = "", ledgerAndNLV = FALSE, reqId = self$nextId()) {
  C_enc_reqAccountUpdatesMulti(self$twsServerVersion, reqId = reqId, account = account,
                               modelCode = modelCode, ledgerAndNLV = ledgerAndNLV)
}

enc_cancelAccountUpdatesMulti <- function(self, reqId) {
  C_enc_cancelAccountUpdatesMulti(self$twsServerVersion, reqId)
}

enc_reqSecDefOptParams <- function(self, underlyingSymbol, futFopExchange, underlyingSecType, underlyingConId, reqId = self$nextId()) {
  C_enc_reqSecDefOptParams(self$twsServerVersion, reqId, underlyingSymbol, futFopExchange, underlyingSecType, underlyingConId)
}

enc_reqSoftDollarTiers <- function(self, reqId) {
  C_enc_reqSoftDollarTiers(self$twsServerVersion, reqId)
}

enc_reqFamilyCodes <- function(self) {
  C_enc_reqFamilyCodes(self$serverVersion)
}

enc_reqMatchingSymbols <- function(self, pattern, reqId = self$nextId()) {
  C_enc_reqMatchingSymbols(self$twsServerVersion, reqId, pattern)
}

enc_reqMktDepthExchanges <- function(self) {
  C_enc_reqMktDepthExchanges(self$serverVersion)
}

enc_reqSmartComponents <- function(self, bboExchange = "", reqId = self$nextId()) {
  C_enc_reqSmartComponents(self$twsServerVersion, reqId, bboExchange)
}

enc_reqNewsProviders <- function(self) {
  C_enc_reqNewsProviders(self$serverVersion)
}

enc_reqNewsArticle <- function(self, providerCode, articleId, newsArticleOptions = list(), reqId = self$nextId()) {
  C_enc_reqNewsArticle(self$twsServerVersion, reqId, providerCode, articleId, check_named_list(newsArticleOptions))
}

enc_reqHistoricalNews <- function(self, conId, startDateTime, endDateTime, providerCodes = "", 
                                  totalResults = 300, historicalNewsOptions = list(), reqId = self$nextId()) {
  C_enc_reqHistoricalNews(self$twsServerVersion, reqId, conId = conId, providerCodes = providerCodes,
                          startDateTime = startDateTime, endDateTime = endDateTime,
                          totalResults = totalResults, historicalNewsOptions = check_named_list(historicalNewsOptions))
}

enc_reqHeadTimestamp <- function(self, contract, whatToShow = WHAT_TO_SHOW_TYPES, useRTH = TRUE, formatDate = TRUE, reqId = self$nextId()) {
  C_enc_reqHeadTimestamp(self$twsServerVersion, reqId = reqId, contract = contract,
                         whatToShow = match.arg(whatToShow), useRTH = useRTH, formatDate = formatDate)
}

enc_cancelHeadTimestamp <- function(self, reqId) {
  C_enc_cancelHeadTimestamp(self$twsServerVersion, reqId)
}

enc_reqHistogramData <- function(self, contract, timePeriod = "3 days", useRTH = TRUE, reqId = self$nextId()) {
  C_enc_reqHistogramData(self$twsServerVersion, reqId = reqId, contract = contract,
                         useRTH = useRTH, timePeriod = timePeriod)
}

enc_cancelHistogramData <- function(self, reqId) {
  C_enc_cancelHistogramData(self$twsServerVersion, reqId)
}

enc_reqMarketRule <- function(self, marketRuleId) {
  C_enc_reqMarketRule(self$twsServerVersion, marketRuleId)
}

enc_reqPnL <- function(self, account = "", modelCode = "", reqId = self$nextId()) {
  C_enc_reqPnL(self$twsServerVersion, reqId = reqId, account = account, modelCode = modelCode)
}

enc_cancelPnL <- function(self, reqId) {
  C_enc_cancelPnL(self$twsServerVersion, reqId)
}

enc_reqPnLSingle <- function(self, conId, account = "", modelCode = "", reqId = self$nextId()) {
  C_enc_reqPnLSingle(self$twsServerVersion, reqId, account = account, modelCode = modelCode, conId = conId)
}

enc_cancelPnLSingle <- function(self, reqId) {
  C_enc_cancelPnLSingle(self$twsServerVersion, reqId)
}

enc_reqHistoricalTicks <- function(self, contract, startDateTime = "", endDateTime = "", numberOfTicks = 1000,
                                   whatToShow = c("BID_ASK", "MIDPOINT", "TRADES"), useRTH = TRUE, ignoreSize = FALSE,
                                   options = list(), reqId = self$nextId()) {
  C_enc_reqHistoricalTicks(self$twsServerVersion, reqId = reqId,
                           contract = contract, startDateTime = startDateTime, endDateTime = endDateTime, numberOfTicks = numberOfTicks,
                           whatToShow = match.arg(whatToShow), useRth = useRth, ignoreSize = ignoreSize,
                           options = check_named_list(options))
}

enc_reqTickByTickData <- function(self, contract, tickType = c("Last", "AllLast", "BidAsk", "MidPoint"),
                                  numberOfTicks = 1000, ignoreSize = FALSE, reqId = self$nextId()) {
  C_enc_reqTickByTickData(self$twsServerVersion, reqId = reqId, contract = contract,
                          tickType = match.arg(tickType), numberOfTicks = numberOfTicks, ignoreSize = ignoreSize)
}

enc_cancelTickByTickData <- function(self, reqId) {
  C_enc_cancelTickByTickData(self$twsServerVersion, reqId)
}

enc_reqCompletedOrders <- function(self, apiOnly = FALSE) {
  C_enc_reqCompletedOrders(self$twsServerVersion, apiOnly)
}

enc_reqWshMetaData <- function(self, reqId) {
  C_enc_reqWshMetaData(self$twsServerVersion, reqId)
}

enc_reqWshEventData <- function(self, conId, reqId = self$nextId()) {
  C_enc_reqWshEventData(self$twsServerVersion, reqId, conId)
}

enc_cancelWshMetaData <- function(self, reqId) {
  C_enc_cancelWshMetaData(self$twsServerVersion, reqId)
}

enc_cancelWshEventData <- function(self, reqId) {
  C_enc_cancelWshEventData(self$twsServerVersion, reqId)
}


ENC_NAMES <- ls(pattern = "^enc_")
ENC_FUNCTIONS <-
  structure(map(ENC_NAMES,
                function(nm) {
                  fmls <- formals(getFunction(nm))[-1]
                  args <- structure(map(names(fmls), as.name), names = names(fmls))
                  cl <- call2(nm, as.name("self"), !!!args)
                  fn <- new_function(fmls, body = expr({
                    bin <- !!cl
                    writeBin(bin, self$con)
                  }))
                  fn
                }),
            names = sub("enc_", "", ENC_NAMES))
