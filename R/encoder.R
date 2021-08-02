
encoder <- function(serverVersion = 0L) {
  rib:::C_encoder(serverVersion)
}

check_named_list <- function(x) {
  if (length(x) > 0 && (is.null(names(x)) || !all(nzchar(names(x)))))
    stop(sprintf("Argument '%s' must be a named vector", deparse(substitute(x))), call. = FALSE)
  as.list(x)
} 

##' enc_reqMktData()
# https://interactivebrokers.github.io/tws-api/md_request.html
# https://interactivebrokers.github.io/tws-api/classIBApi_1_1EClient.html#a7a19258a3a2087c07c1c57b93f659b63
enc_reqMktData <- function(self, contract, 
                           genericTicks = "100,101,104,106,165,221,225,236",
                           snapshot = FALSE,
                           regulatorySnaphsot = FALSE,
                           mktDataOptions = list(), 
                           reqId = self$nextId()) {
  C_enc_reqMktData(self$encoder,
                   reqId = reqId, 
                   contract = contract, 
                   genericTicks = genericTicks,
                   snapshot = snapshot,
                   regulatorySnaphsot = regulatorySnaphsot,
                   mktDataOptions = check_named_list(mktDataOptions))
}

enc_cancelMktData <- function(self, reqId) {
  C_enc_cancelMktData(self$encoder, reqId = reqId)
}

enc_reqMktDepth <- function(self, contract, numRows = 20, isSmartDepth = FALSE,
                            mktDepthOptions = list(), reqId = self$nextId()) {
  C_enc_reqMktDepth(self$encoder,
                    reqId = reqId, 
                    contract = contract,
                    numRows = numRows,
                    isSmartDepth = isSmartDepth,
                    mktDepthOptions = check_named_list(mktDataOptions))
}

enc_cancelMktDepth <- function(self, reqId, isSmartDepth = FALSE) {
  C_enc_cancelMktDepth(self$encoder, reqId = reqId, isSmartDepth = isSmartDepth)
}

enc_reqHistoricalData <- function(self, contract,
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
  endDateTime <- strftime(endDateTime, format='%Y%m%d %H:%M:%S', usetz = FALSE)
  enc_reqHistoricalData(self$encoder,
                        reqId = reqId, 
                        contract = contract, 
                        endDateTime = endDateTime, 
                        durationStr = durationStr, 
                        barSizeSetting = barSizeSetting, 
                        whatToShow = whatToShow, 
                        useRTH = useRTH, 
                        formatDate = formatDate, 
                        keepUpToDate = keepUpToDate, 
                        chartOptions = chartOptions)
}

enc_cancelHistoricalData <- function(self, reqId) {
  C_enc_cancelHistoricalData(self$encoder, reqId = reqId)
}

enc_reqRealTimeBars <- function(self, contract, barSize = 5,
                                whatToShow = c("TRADE", "MIDPOINT", "BID", "ASK"), 
                                useRTH = TRUE,
                                realTimeBarsOptions = list(), 
                                reqId = self$nextId()) {
  C_enc_reqRealTimeBars(self$encoder,
                        reqId = reqId, 
                        contract = contract,
                        barSize = barSize,
                        whatToShow = match.arg(whatToShow),
                        useRTH = useRTH,
                        realTimeBarsOptions = check_named_list(realTimeBarsOptions))
}

enc_cancelRealTimeBars <- function(self, reqId) {
  C_enc_cancelMktData(self$encoder, reqId)
}

enc_reqScannerParameters <- function(self) {
  C_enc_reqScannerParameters(self$encoder)
}

enc_reqScannerSubscription <- function(self,
                                       subscription,
                                       scannerSubscriptionOptions = list(),
                                       scannerSubscriptionFilterOptions = list(),
                                       reqId = self$nextId()) {
  C_enc_reqScannerSubscription(self$encoder,
                               reqId = reqId,
                               subscription = subscription,
                               scannerSubscriptionOptions = check_named_list(scannerSubscriptionOptions),
                               scannerSubscriptionFilterOptions = check_named_list(scannerSubscriptionFilterOptions))
}

enc_cancelScannerSubscription <- function(self, reqId) {
  C_enc_cancelScannerSubscription(self$encoder, reqId)
}

enc_reqFundamentalData <- function(self, contract, reportType = TWS_REPORT_TYPES,
                                   fundamentalDataOptions = list(),
                                   reqId = self$nextId()) {
  C_enc_reqFundamentalData(self$encoder,
                           reqId = reqId, 
                           contract = contract,
                           reportType = match.arg(reportType),
                           fundamentalDataOptions = check_named_list(fundamentalDataOptions))
}

enc_cancelFundamentalData <- function(self, reqId) {
  C_enc_cancelFundamentalData(self$encoder, reqId = reqId)
}

enc_calculateImpliedVolatility <- function(self, contract, optionPrice, underPrice, options = list(), reqId = self$nextId()) {
  C_enc_calculateImpliedVolatility(self$encoder, reqId = reqId, contract = contract, optionPrice = optionPrice,
                                   underPrice = underPrice, options = check_named_list(options))
}

enc_cancelCalculateImpliedVolatility <- function(self, reqId) {
  C_enc_cancelCalculateImpliedVolatility(self$encoder, reqId);
}

enc_calculateOptionPrice <- function(self, contract, volatility, underPrice, options = list(), reqId = self$nextId()) {
  C_enc_calculateOptionPrice(self$encoder, reqId = reqId, contract = contract, volatility = volatility,
                             underPrice = underPrice, options = check_named_list(options));
}

enc_cancelCalculateOptionPrice <- function(self, reqId) {
  C_enc_cancelCalculateOptionPrice(self$encoder, reqId);
}

enc_reqContractDetails <- function(self, contract, reqId = self$nextId()) {
  C_enc_reqContractDetails(self$encoder, reqId = reqId, contract = contract)
}

enc_reqCurrentTime <- function(self) {
  C_enc_reqCurrentTime(self$encoder)
}

enc_placeOrder <- function(self, contract, order, id = self$nextId()) {
  C_enc_placeOrder(self$encoder, id = id, contract = contract, order = order);
}

enc_cancelOrder <- function(self, id) {
  C_enc_cancelOrder(self$encoder, id);
}

enc_reqAccountUpdates <- function(self, accountCode = "1") {
  C_enc_reqAccountUpdates(self$encoder, accountCode = accountCode)
}

enc_cancelAccountUpdates <- function(self, accountCode = "1") {
  C_enc_cancelAccountUpdates(self$encoder, accountCode = accountCode)
}

enc_reqOpenOrders <- function(self) {
  C_enc_reqOpenOrders(self$encoder)
}

enc_reqAutoOpenOrders <- function(self, autoBind = TRUE) {
  C_enc_reqAutoOpenOrders(self$encoder, autoBind = autoBind)
}

enc_reqAllOpenOrders <- function(self) {
  C_enc_reqAllOpenOrders(self$encoder)
}

enc_reqExecutions <- function(self, filter, reqId = self$nextId()) {
  C_enc_reqExecutions(self$encoder, reqId, filter);
}

enc_reqIds <- function(self, numIds) {
  C_enc_reqIds(self$encoder, numIds);
}

enc_reqNewsBulletins <- function(self, allMsgs = FALSE) {
  C_enc_reqNewsBulletins(self$encoder, allMsgs);
}

enc_cancelNewsBulletins <- function(self)  {
  C_enc_cancelNewsBulletins(self$encoder)
}

enc_setServerLogLevel <- function(self, logLevel = c("system", "error", "warn", "info", "detail")) {
  logLevel <- match.arg(logLevel)
  logLevel <- match(logLevel, c("system", "error", "warn", "info", "detail"))
  C_enc_setServerLogLevel(self$encoder, logLevel);
}

enc_reqManagedAccounts <- function(self) {
  C_enc_reqManagedAccunts(self$encoder)
}

enc_requestFA <- function(self, faDataType = c("groups", "profiles", "aliases")) {
  faDataType <- match.arg(faDataType)
  C_enc_requestFA(self$encoder, faDataType = faDataType)
}

enc_requestFA <- function(self, faDataType = c("groups", "profiles", "aliases"),
                          xml = "") {
  faDataType <- match.arg(faDataType)
  C_enc_replaceFA(self$encoder, faDataType = faDataType, xml = xml)
}


enc_exerciseOptions <- function(self, contract, exerciseQuantity,
                                exerciseAction = c("exercise", "lapse"),
                                account = "", override = FALSE,
                                reqId = self$nextId()) {
  exerciseAction <- match.arg(exerciseAction)
  C_enc_exerciseOptions(self$encoder, reqId, contract, exerciseAction, exerciseQuantity, account, override)
}

enc_reqGlobalCancel <- function(self) {
  C_enc_reqGlobalCancel(self$encoder)
}

enc_reqMarketDataType <- function(self, marketDataType = c("realtime", "frozen", "delayed", "delayed_frozen")) {
  #  1: realtime       Frozen, Delayed, and Delayed-Frozen data are disabled
  #  2: frozen         Frozen data is enabled
  #  3: delayed        Delayed data is enabled, Delayed-Frozen data is disabled
  #  4: delayed_frozen Delayed and Delayed-Frozen data are enabled
  marketDataType <- match.arg(marketDataType)
  marketDataType <- match(marketDataType, c("realtime", "frozen", "delayed", "delayed_frozen"))
  C_enc_reqMarketDataType(self$encoder, marketDataType = marketDataType)
}

enc_reqPositions <- function(self) {
  C_enc_reqPositions(self$encoder)
}

enc_cancelPositions <- function(self) {
  C_enc_cancelPositions(self$encoder)
}

enc_reqPositionsMulti <- function(self, account = "", modelCode = "", reqId = self$nextId()) {
  C_enc_reqPositionsMulti(self$encoder, reqId, account, modelCode)
}

enc_cancelPositionsMulti <- function(self, reqId) {
  C_enc_cancelPositionsMulti(self$encoder, reqId)
}


enc_reqAccountSummary <- function(self, tags = "", groupName = "All", reqId = self$nextId()) {
  C_enc_reqAccountSummary(self$encoder, reqId, groupName, tags)
}

enc_cancelAccountSummary <- function(self, reqId) {
  C_enc_cancelAccountSummary(self$encoder, reqId)
}

## enc_verifyRequest <- function(self, apiName, apiVersion) {
##   C_enc_verifyRequest(self$encoder, apiName, apiVersion)
## }

## enc_verifyMessage <- function(self, apiData) {
##   C_enc_verifyMessage(self$encoder, apiData)
## }

## enc_verifyAndAuthRequest <- function(self, apiName, apiVersion, opaqueIsvKey) {
##   C_enc_verifyAndAuthRequest(self$encoder, apiName, apiVersion, opaqueIsvKey)
## }

## enc_verifyAndAuthMessage <- function(self, apiData, xyzResponse) {
##   C_enc_verifyAndAuthMessage(self$encoder, apiData, xyzResponse)
## }

enc_queryDisplayGroups <- function(self, reqId = self$nextId()) {
  C_enc_queryDisplayGroups(self$encoder, reqId)
}

enc_subscribeToGroupEvents <- function(self, groupId, reqId = self$nextId()) {
  C_enc_subscribeToGroupEvents(self$encoder, reqId, groupId)
}

enc_unsubscribeFromGroupEvents <- function(self, reqId) {
  C_enc_unsubscribeFromGroupEvents(self$encoder, reqId)
}

enc_updateDisplayGroup <- function(self, contractInfo = "none", reqId = self$nextId()) {
  C_enc_updateDisplayGroup(self$encoder, reqId, contractInfo)
}

## enc_startApi <- function(self) {
##   C_enc_startApi(self$encoder)
## }

enc_reqAccountUpdatesMulti <- function(self, account = "", modelCode = "", ledgerAndNLV = FALSE, reqId = self$nextId()) {
  C_enc_reqAccountUpdatesMulti(self$encoder, reqId = reqId, account = account,
                               modelCode = modelCode, ledgerAndNLV = ledgerAndNLV)
}

enc_cancelAccountUpdatesMulti <- function(self, reqId) {
  C_enc_cancelAccountUpdatesMulti(self$encoder, reqId)
}

enc_reqSecDefOptParams <- function(self, underlyingSymbol, futFopExchange, underlyingSecType, underlyingConId, reqId = self$nextId()) {
  C_enc_reqSecDefOptParams(self$encoder, reqId, underlyingSymbol, futFopExchange, underlyingSecType, underlyingConId)
}

enc_reqSoftDollarTiers <- function(self, reqId) {
  C_enc_reqSoftDollarTiers(self$encoder, reqId)
}

enc_reqFamilyCodes <- function(self) {
  C_enc_reqFamilyCodes(self$encoder)
}

enc_reqMatchingSymbols <- function(self, pattern, reqId = self$nextId()) {
  C_enc_reqMatchingSymbols(self$encoder, reqId, pattern)
}

enc_reqMktDepthExchanges <- function(self) {
  C_enc_reqMktDepthExchanges(self$encoder)
}

enc_reqSmartComponents <- function(self, bboExchange = "", reqId = self$nextId()) {
  C_enc_reqSmartComponents(self$encoder, reqId, bboExchange)
}

enc_reqNewsProviders <- function(self) {
  C_enc_reqNewsProviders(self$encoder)
}

enc_reqNewsArticle <- function(self, providerCode, articleId, newsArticleOptions = list(), reqId = self$nextId()) {
  C_enc_reqNewsArticle(self$encoder, reqId, providerCode, articleId, check_named_list(newsArticleOptions))
}

enc_reqHistoricalNews <- function(self, conId, startDateTime, endDateTime, providerCodes = "", 
                                  totalResults = 300, historicalNewsOptions = list(), reqId = self$nextId()) {
  C_enc_reqHistoricalNews(self$encoder, reqId, conId = conId, providerCodes = providerCodes,
                          startDateTime = startDateTime, endDateTime = endDateTime,
                          totalResults = totalResults, historicalNewsOptions = check_named_list(historicalNewsOptions))
}

enc_reqHeadTimestamp <- function(self, contract, whatToShow = WHAT_TO_SHOW_TYPES, useRTH = TRUE, formatDate = TRUE, reqId = self$nextId()) {
  C_enc_reqHeadTimestamp(self$encoder, reqId = reqId, contract = contract,
                         whatToShow = match.arg(whatToShow), useRTH = useRTH, formatDate = formatDate)
}

enc_cancelHeadTimestamp <- function(self, reqId) {
  C_enc_cancelHeadTimestamp(self$encoder, reqId)
}

enc_reqHistogramData <- function(self, contract, timePeriod = "3 days", useRTH = TRUE, reqId = self$nextId()) {
  C_enc_reqHistogramData(self$encoder, reqId = reqId, contract = contract,
                         useRTH = useRTH, timePeriod = timePeriod)
}

enc_cancelHistogramData <- function(self, reqId) {
  C_enc_cancelHistogramData(self$encoder, reqId)
}

enc_reqMarketRule <- function(self, marketRuleId) {
  C_enc_reqMarketRule(self$encoder, marketRuleId)
}

enc_reqPnL <- function(self, account = "", modelCode = "", reqId = self$nextId()) {
  C_enc_reqPnL(self$encoder, reqId = reqId, account = account, modelCode = modelCode)
}

enc_cancelPnL <- function(self, reqId) {
  C_enc_cancelPnL(self$encoder, reqId)
}

enc_reqPnLSingle <- function(self, conId, account = "", modelCode = "", reqId = self$nextId()) {
  C_enc_reqPnLSingle(self$encoder, reqId, account = account, modelCode = modelCode, conId = conId)
}

enc_cancelPnLSingle <- function(self, reqId) {
  C_enc_cancelPnLSingle(self$encoder, reqId)
}

enc_reqHistoricalTicks <- function(self, contract, startDateTime = "", endDateTime = "", numberOfTicks = 1000,
                                   whatToShow = c("BID_ASK", "MIDPOINT", "TRADES"), useRTH = TRUE, ignoreSize = FALSE,
                                   options = list(), reqId = self$nextId()) {
  C_enc_reqHistoricalTicks(self$encoder, reqId = reqId,
                           contract = contract, startDateTime = startDateTime, endDateTime = endDateTime, numberOfTicks = numberOfTicks,
                           whatToShow = match.arg(whatToShow), useRth = useRth, ignoreSize = ignoreSize,
                           options = check_named_list(options))
}

enc_reqTickByTickData <- function(self, contract, tickType = c("Last", "AllLast", "BidAsk", "MidPoint"),
                                  numberOfTicks = 1000, ignoreSize = FALSE, reqId = self$nextId()) {
  C_enc_reqTickByTickData(self$encoder, reqId = reqId, contract = contract,
                          tickType = match.arg(tickType), numberOfTicks = numberOfTicks, ignoreSize = ignoreSize)
}

enc_cancelTickByTickData <- function(self, reqId) {
  C_enc_cancelTickByTickData(self$encoder, reqId)
}

enc_reqCompletedOrders <- function(self, apiOnly = FALSE) {
  C_enc_reqCompletedOrders(self$encoder, apiOnly)
}

enc_reqWshMetaData <- function(self, reqId) {
  C_enc_reqWshMetaData(self$encoder, reqId)
}

enc_reqWshEventData <- function(self, conId, reqId = self$nextId()) {
  C_enc_reqWshEventData(self$encoder, reqId, conId)
}

enc_cancelWshMetaData <- function(self, reqId) {
  C_enc_cancelWshMetaData(self$encoder, reqId)
}

enc_cancelWshEventData <- function(self, reqId) {
  C_enc_cancelWshEventData(self$encoder, reqId)
}


ENC_NAMES <- ls(pattern = "^enc_")
REQ_FUNCTIONS <-
  structure(map(ENC_NAMES,
                function(nm) {
                  fmls <- formals(getFunction(nm))[-1]
                  args <- structure(map(names(fmls), as.name), names = names(fmls))
                  lst <- call2("list", !!!args)
                  out_val <- if ('reqId' %in% names(fmls)) as.name("reqId")
                  event <- sub("enc_", "", nm)
                  encoder <- parse_expr(sprintf("rib:::%s", nm))
                  fn <- new_function(fmls, body = expr({
                    msg <- !!lst
                    tws_handle_outmsg(self, !!event, !!encoder, msg)
                    invisible(!!out_val)
                  }))
                  fn
                }),
            names = sub("enc_", "", ENC_NAMES))
