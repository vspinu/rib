# Generated by cpp11: do not edit by hand

C_max_client_version <- function() {
  .Call(`_rib_C_max_client_version`)
}

C_decode_bin <- function(serverVersion, bin) {
  .Call(`_rib_C_decode_bin`, serverVersion, bin)
}

C_encoder <- function(serverVersion) {
  .Call(`_rib_C_encoder`, serverVersion)
}

C_set_serverVersion <- function(encoder, serverVersion) {
  invisible(.Call(`_rib_C_set_serverVersion`, encoder, serverVersion))
}

C_get_serverVersion <- function(encoder) {
  .Call(`_rib_C_get_serverVersion`, encoder)
}

C_enc_connectionRequest <- function(encoder) {
  .Call(`_rib_C_enc_connectionRequest`, encoder)
}

C_enc_startApi <- function(encoder, clientId, optionalCapabilities) {
  .Call(`_rib_C_enc_startApi`, encoder, clientId, optionalCapabilities)
}

C_enc_reqMktData <- function(encoder, reqId, contract, genericTicks, snapshot, regulatorySnaphsot, mktDataOptions) {
  .Call(`_rib_C_enc_reqMktData`, encoder, reqId, contract, genericTicks, snapshot, regulatorySnaphsot, mktDataOptions)
}

C_enc_cancelMktData <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelMktData`, encoder, reqId)
}

C_enc_reqMktDepth <- function(encoder, reqId, contract, numRows, isSmartDepth, mktDepthOptions) {
  .Call(`_rib_C_enc_reqMktDepth`, encoder, reqId, contract, numRows, isSmartDepth, mktDepthOptions)
}

C_enc_cancelMktDepth <- function(encoder, reqId, isSmartDepth) {
  .Call(`_rib_C_enc_cancelMktDepth`, encoder, reqId, isSmartDepth)
}

C_enc_reqHistoricalData <- function(encoder, contract, endDateTime, duration, barSize, whatToShow, useRTH, formatDate, keepUpToDate, chartOptions, reqId) {
  .Call(`_rib_C_enc_reqHistoricalData`, encoder, contract, endDateTime, duration, barSize, whatToShow, useRTH, formatDate, keepUpToDate, chartOptions, reqId)
}

C_enc_cancelHistoricalData <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelHistoricalData`, encoder, reqId)
}

C_enc_reqRealTimeBars <- function(encoder, reqId, contract, barSize, whatToShow, useRTH, realTimeBarsOptions) {
  .Call(`_rib_C_enc_reqRealTimeBars`, encoder, reqId, contract, barSize, whatToShow, useRTH, realTimeBarsOptions)
}

C_enc_cancelRealTimeBars <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelRealTimeBars`, encoder, reqId)
}

C_enc_reqScannerParameters <- function(encoder) {
  .Call(`_rib_C_enc_reqScannerParameters`, encoder)
}

C_enc_reqScannerSubscription <- function(encoder, reqId, subscription, scannerSubscriptionOptions, scannerSubscriptionFilterOptions) {
  .Call(`_rib_C_enc_reqScannerSubscription`, encoder, reqId, subscription, scannerSubscriptionOptions, scannerSubscriptionFilterOptions)
}

C_enc_cancelScannerSubscription <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelScannerSubscription`, encoder, reqId)
}

C_enc_reqFundamentalData <- function(encoder, reqId, contract, reportType, fundamentalDataOptions) {
  .Call(`_rib_C_enc_reqFundamentalData`, encoder, reqId, contract, reportType, fundamentalDataOptions)
}

C_enc_cancelFundamentalData <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelFundamentalData`, encoder, reqId)
}

C_enc_calculateImpliedVolatility <- function(encoder, reqId, contract, optionPrice, underPrice, options) {
  .Call(`_rib_C_enc_calculateImpliedVolatility`, encoder, reqId, contract, optionPrice, underPrice, options)
}

C_enc_cancelCalculateImpliedVolatility <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelCalculateImpliedVolatility`, encoder, reqId)
}

C_enc_calculateOptionPrice <- function(encoder, reqId, contract, volatility, underPrice, options) {
  .Call(`_rib_C_enc_calculateOptionPrice`, encoder, reqId, contract, volatility, underPrice, options)
}

C_enc_cancelCalculateOptionPrice <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelCalculateOptionPrice`, encoder, reqId)
}

C_enc_reqContractDetails <- function(encoder, reqId, contract) {
  .Call(`_rib_C_enc_reqContractDetails`, encoder, reqId, contract)
}

C_enc_reqCurrentTime <- function(encoder) {
  .Call(`_rib_C_enc_reqCurrentTime`, encoder)
}

C_enc_placeOrder <- function(encoder, orderId, contract, order) {
  .Call(`_rib_C_enc_placeOrder`, encoder, orderId, contract, order)
}

C_enc_cancelOrder <- function(encoder, orderId) {
  .Call(`_rib_C_enc_cancelOrder`, encoder, orderId)
}

C_enc_reqAccountUpdates <- function(encoder, accountCode) {
  .Call(`_rib_C_enc_reqAccountUpdates`, encoder, accountCode)
}

C_enc_cancelAccountUpdates <- function(encoder, accountCode) {
  .Call(`_rib_C_enc_cancelAccountUpdates`, encoder, accountCode)
}

C_enc_reqOpenOrders <- function(encoder) {
  .Call(`_rib_C_enc_reqOpenOrders`, encoder)
}

C_enc_reqAutoOpenOrders <- function(encoder, autoBind) {
  .Call(`_rib_C_enc_reqAutoOpenOrders`, encoder, autoBind)
}

C_enc_reqAllOpenOrders <- function(encoder) {
  .Call(`_rib_C_enc_reqAllOpenOrders`, encoder)
}

C_enc_reqExecutions <- function(encoder, reqId, filter) {
  .Call(`_rib_C_enc_reqExecutions`, encoder, reqId, filter)
}

C_enc_reqIds <- function(encoder, numIds) {
  .Call(`_rib_C_enc_reqIds`, encoder, numIds)
}

C_enc_reqNewsBulletins <- function(encoder, allMsgs) {
  .Call(`_rib_C_enc_reqNewsBulletins`, encoder, allMsgs)
}

C_enc_cancelNewsBulletins <- function(encoder) {
  .Call(`_rib_C_enc_cancelNewsBulletins`, encoder)
}

C_enc_setServerLogLevel <- function(encoder, logLevel) {
  .Call(`_rib_C_enc_setServerLogLevel`, encoder, logLevel)
}

C_enc_reqManagedAccounts <- function(encoder) {
  .Call(`_rib_C_enc_reqManagedAccounts`, encoder)
}

C_enc_requestFA <- function(encoder, faDataType) {
  .Call(`_rib_C_enc_requestFA`, encoder, faDataType)
}

C_enc_replaceFA <- function(encoder, reqId, faDataType, xml) {
  .Call(`_rib_C_enc_replaceFA`, encoder, reqId, faDataType, xml)
}

C_enc_exerciseOptions <- function(encoder, reqId, contract, exerciseAction, exerciseQuantity, account, override) {
  .Call(`_rib_C_enc_exerciseOptions`, encoder, reqId, contract, exerciseAction, exerciseQuantity, account, override)
}

C_enc_reqGlobalCancel <- function(encoder) {
  .Call(`_rib_C_enc_reqGlobalCancel`, encoder)
}

C_enc_reqMarketDataType <- function(encoder, marketDataType) {
  .Call(`_rib_C_enc_reqMarketDataType`, encoder, marketDataType)
}

C_enc_reqPositions <- function(encoder) {
  .Call(`_rib_C_enc_reqPositions`, encoder)
}

C_enc_cancelPositions <- function(encoder) {
  .Call(`_rib_C_enc_cancelPositions`, encoder)
}

C_enc_reqAccountSummary <- function(encoder, reqId, group, tags) {
  .Call(`_rib_C_enc_reqAccountSummary`, encoder, reqId, group, tags)
}

C_enc_cancelAccountSummary <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelAccountSummary`, encoder, reqId)
}

C_enc_verifyRequest <- function(encoder, apiName, apiVersion) {
  .Call(`_rib_C_enc_verifyRequest`, encoder, apiName, apiVersion)
}

C_enc_verifyMessage <- function(encoder, apiData) {
  .Call(`_rib_C_enc_verifyMessage`, encoder, apiData)
}

C_enc_verifyAndAuthRequest <- function(encoder, apiName, apiVersion, opaqueIsvKey) {
  .Call(`_rib_C_enc_verifyAndAuthRequest`, encoder, apiName, apiVersion, opaqueIsvKey)
}

C_enc_verifyAndAuthMessage <- function(encoder, apiData, xyzResponse) {
  .Call(`_rib_C_enc_verifyAndAuthMessage`, encoder, apiData, xyzResponse)
}

C_enc_queryDisplayGroups <- function(encoder, reqId) {
  .Call(`_rib_C_enc_queryDisplayGroups`, encoder, reqId)
}

C_enc_subscribeToGroupEvents <- function(encoder, reqId, groupId) {
  .Call(`_rib_C_enc_subscribeToGroupEvents`, encoder, reqId, groupId)
}

C_enc_updateDisplayGroup <- function(encoder, reqId, contractInfo) {
  .Call(`_rib_C_enc_updateDisplayGroup`, encoder, reqId, contractInfo)
}

C_enc_unsubscribeFromGroupEvents <- function(encoder, reqId) {
  .Call(`_rib_C_enc_unsubscribeFromGroupEvents`, encoder, reqId)
}

C_enc_reqPositionsMulti <- function(encoder, reqId, account, modelCode) {
  .Call(`_rib_C_enc_reqPositionsMulti`, encoder, reqId, account, modelCode)
}

C_enc_cancelPositionsMulti <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelPositionsMulti`, encoder, reqId)
}

C_enc_reqAccountUpdatesMulti <- function(encoder, reqId, account, modelCode, ledgerAndNLV) {
  .Call(`_rib_C_enc_reqAccountUpdatesMulti`, encoder, reqId, account, modelCode, ledgerAndNLV)
}

C_enc_cancelAccountUpdatesMulti <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelAccountUpdatesMulti`, encoder, reqId)
}

C_enc_reqSecDefOptParams <- function(encoder, reqId, underlyingSymbol, futFopExchange, underlyingSecType, underlyingConId) {
  .Call(`_rib_C_enc_reqSecDefOptParams`, encoder, reqId, underlyingSymbol, futFopExchange, underlyingSecType, underlyingConId)
}

C_enc_reqSoftDollarTiers <- function(encoder, reqId) {
  .Call(`_rib_C_enc_reqSoftDollarTiers`, encoder, reqId)
}

C_enc_reqFamilyCodes <- function(encoder) {
  .Call(`_rib_C_enc_reqFamilyCodes`, encoder)
}

C_enc_reqMatchingSymbols <- function(encoder, reqId, pattern) {
  .Call(`_rib_C_enc_reqMatchingSymbols`, encoder, reqId, pattern)
}

C_enc_reqMktDepthExchanges <- function(encoder) {
  .Call(`_rib_C_enc_reqMktDepthExchanges`, encoder)
}

C_enc_reqSmartComponents <- function(encoder, reqId, bboExchange) {
  .Call(`_rib_C_enc_reqSmartComponents`, encoder, reqId, bboExchange)
}

C_enc_reqNewsProviders <- function(encoder) {
  .Call(`_rib_C_enc_reqNewsProviders`, encoder)
}

C_enc_reqNewsArticle <- function(encoder, requestId, providerCode, articleId, newsArticleOptions) {
  .Call(`_rib_C_enc_reqNewsArticle`, encoder, requestId, providerCode, articleId, newsArticleOptions)
}

C_enc_reqHistoricalNews <- function(encoder, requestId, conId, providerCodes, startDateTime, endDateTime, totalResults, historicalNewsOptions) {
  .Call(`_rib_C_enc_reqHistoricalNews`, encoder, requestId, conId, providerCodes, startDateTime, endDateTime, totalResults, historicalNewsOptions)
}

C_enc_reqHeadTimestamp <- function(encoder, reqId, contract, whatToShow, useRTH, formatDate) {
  .Call(`_rib_C_enc_reqHeadTimestamp`, encoder, reqId, contract, whatToShow, useRTH, formatDate)
}

C_enc_cancelHeadTimestamp <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelHeadTimestamp`, encoder, reqId)
}

C_enc_reqHistogramData <- function(encoder, reqId, contract, useRTH, timePeriod) {
  .Call(`_rib_C_enc_reqHistogramData`, encoder, reqId, contract, useRTH, timePeriod)
}

C_enc_cancelHistogramData <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelHistogramData`, encoder, reqId)
}

C_enc_reqMarketRule <- function(encoder, marketRuleId) {
  .Call(`_rib_C_enc_reqMarketRule`, encoder, marketRuleId)
}

C_enc_reqPnL <- function(encoder, reqId, account, modelCode) {
  .Call(`_rib_C_enc_reqPnL`, encoder, reqId, account, modelCode)
}

C_enc_cancelPnL <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelPnL`, encoder, reqId)
}

C_enc_reqPnLSingle <- function(encoder, reqId, account, modelCode, conId) {
  .Call(`_rib_C_enc_reqPnLSingle`, encoder, reqId, account, modelCode, conId)
}

C_enc_cancelPnLSingle <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelPnLSingle`, encoder, reqId)
}

C_enc_reqHistoricalTicks <- function(encoder, reqId, contract, startDateTime, endDateTime, numberOfTicks, whatToShow, useRTH, ignoreSize, options) {
  .Call(`_rib_C_enc_reqHistoricalTicks`, encoder, reqId, contract, startDateTime, endDateTime, numberOfTicks, whatToShow, useRTH, ignoreSize, options)
}

C_enc_reqTickByTickData <- function(encoder, reqId, contract, tickType, numberOfTicks, ignoreSize) {
  .Call(`_rib_C_enc_reqTickByTickData`, encoder, reqId, contract, tickType, numberOfTicks, ignoreSize)
}

C_enc_cancelTickByTickData <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelTickByTickData`, encoder, reqId)
}

C_enc_reqCompletedOrders <- function(encoder, apiOnly) {
  .Call(`_rib_C_enc_reqCompletedOrders`, encoder, apiOnly)
}

C_enc_reqWshMetaData <- function(encoder, reqId) {
  .Call(`_rib_C_enc_reqWshMetaData`, encoder, reqId)
}

C_enc_reqWshEventData <- function(encoder, reqId, conId) {
  .Call(`_rib_C_enc_reqWshEventData`, encoder, reqId, conId)
}

C_enc_cancelWshMetaData <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelWshMetaData`, encoder, reqId)
}

C_enc_cancelWshEventData <- function(encoder, reqId) {
  .Call(`_rib_C_enc_cancelWshEventData`, encoder, reqId)
}
