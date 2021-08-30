
#' TWS object constructors
#'
#' @name tws-objects
#' @export
twsContract <- function(conId = 0,
                        symbol = "",
                        secType = "",
                        strike = 0,
                        right = "",
                        multiplier = "",
                        exchange = "",
                        primaryExchange = "",
                        currency = "",
                        localSymbol = "",
                        tradingClass = "",
                        includeExpired = FALSE,
                        secIdType = "",
                        secId = "",
                        comboLegsDescrip = "",
                        lastTradeDateOrContractMonth = "",
                        comboLegs = list(),
                        ...) {
  structure(
    dots_list(conId = conId,
              symbol = symbol,
              secType = secType,
              lastTradeDateOrContractMonth = lastTradeDateOrContractMonth,
              strike = strike,
              right = right,
              multiplier = multiplier,
              exchange = exchange,
              primaryExchange = primaryExchange,
              currency = currency,
              localSymbol = localSymbol,
              tradingClass = tradingClass,
              includeExpired = includeExpired,
              secIdType = secIdType,
              secId = secId,
              comboLegsDescrip = comboLegsDescrip,
              comboLegs = comboLegs,
              ...,
              .named = TRUE,
              .ignore_empty = "all"),
    class = c('twsContract', "strlist"))
}

#' @rdname tws-objects
#' @export
twsCurrency <- function(symbol = "", strike = 0, currency = "", exchange = "IDEALPRO", ...) {
  twsContract(symbol = symbol, strike = strike, secType = "CASH",
              currency = currency, exchange = exchange, ...)
}

#' @rdname tws-objects
#' @export
twsSTK <- twsEquity <- function(symbol = "", strike = 0, currency = "", exchange = "SMART",
                                primaryExchange = "", localSymbol = "", ...) {
  twsContract(symbol = symbol, localSymbol = localSymbol, strike = strike, secType = "STK",
              currency = currency, exchange = exchange, primaryExchange = primaryExchange, ...)
}

#' @rdname tws-objects
#' @export
twsCFD <- function(symbol = "", currency = "", strike = 0, exchange = "", localSymbol = "",
                   primaryExchange = "", ...) {
  twsContract(symbol = symbol, localSymbol = localSymbol, strike = strike, secType = "CFD",
              currency = currency, exchange = exchange, primaryExchange = primaryExchange, ...)
}

#' @rdname tws-objects
#' @export
twsTagValue <- function(tag = "", value = "") {
  structure(list(tag = tag, value = value), class = c("twsTagValue", "strlist"))
}

#' @rdname tws-objects
#' @export
twsComboLeg <- function(conId = 0,
                        ratio = 0,
                        action = c("BUY","SELL","SSHORT"),
                        exchange = "",
                        openClose = c("same", "open", "close", "unknown"),
                        shortSaleSlot = 0, # 1 = clearing broker, 2 = third party
                        designatedLocation = "",
                        exemptCode = -1) {
  if (is.character(openClose)) {
    openClose <- match.arg(openClose)
    openClose <- match(openClose, c("same", "open", "close", "unknown")) - 1L
  }
  structure(list(conId = conId,
                 ratio = ratio,
                 action = match.arg(action), #//BUY/SELL/SSHORT
                 exchange = exchange,
                 openClose = openClose, #LegOpenClose enum values
                 shortSaleSlot = shortSaleSlot, # 1 = clearing broker, 2 = third party
                 designatedLocation = designatedLocation,
                 exemptCode = exemptCode),
            class = c("twsComboLeg", "strlist"))
}

#' @rdname tws-objects
#' @export
twsScannerSubscription <- function(numberOfRows = -1,
                                   instrument = "",
                                   locationCode = "",
                                   scanCode = "",
                                   abovePrice = NA_real_,
                                   belowPrice = NA_real_,
                                   aboveVolume = NA_integer_,
                                   marketCapAbove = NA_real_,
                                   marketCapBelow = NA_real_,
                                   moodyRatingAbove = "",
                                   moodyRatingBelow = "",
                                   spRatingAbove = "",
                                   spRatingBelow = "",
                                   maturityDateAbove = "",
                                   maturityDateBelow = "",
                                   couponRateAbove = NA_real_,
                                   couponRateBelow = NA_real_,
                                   excludeConvertible = NA_integer_,
                                   averageOptionVolumeAbove = NA_integer_,
                                   scannerSettingPairs = "",
                                   stockTypeFilter = "") {
  structure(list(numberOfRows = -1,
                 instrument = "",
                 locationCode = "",
                 scanCode = "",
                 abovePrice = NA_real_,
                 belowPrice = NA_real_,
                 aboveVolume = NA_integer_,
                 marketCapAbove = NA_real_,
                 marketCapBelow = NA_real_,
                 moodyRatingAbove = "",
                 moodyRatingBelow = "",
                 spRatingAbove = "",
                 spRatingBelow = "",
                 maturityDateAbove = "",
                 maturityDateBelow = "",
                 couponRateAbove = NA_real_,
                 couponRateBelow = NA_real_,
                 excludeConvertible = NA_integer_,
                 averageOptionVolumeAbove = NA_integer_,
                 scannerSettingPairs = "",
                 stockTypeFilter = ""),
            class = c("twsScannerSubscription", "strlist"))
}

#' @rdname tws-objects
#' @export
twsSoftDollarTier <- function(name = "", val = "", displayName = "") {
  structure(list(name = name, val = val, displayName = displayName),
            class = c("twsSoftDollarTier", "strlist"))
}

#' @rdname tws-objects
#' @export
twsOrder <- function(orderId = 0,
                     clientId = 0,
                     permId = 0,
                     action = "",
                     totalQuantity = 0,
                     orderType = "",
                     lmtPrice = NA_real_,
                     auxPrice = NA_real_,
                     tif = "",
                     activeStartTime = "",
                     activeStopTime = "",
                     ocaGroup = "",
                     ocaType = 0,
                     orderRef = "",
                     transmit = TRUE,
                     parentId = 0,
                     blockOrder = FALSE,
                     sweepToFill = FALSE,
                     displaySize = 0,
                     triggerMethod = 0,
                     outsideRth = FALSE,
                     hidden = FALSE,
                     goodAfterTime = "",
                     goodTillDate = "",
                     rule80A = "",
                     allOrNone = FALSE,
                     minQty = NA_integer_,
                     percentOffset = NA_real_,
                     overridePercentageConstraints = FALSE,
                     trailStopPrice = NA_real_,
                     trailingPercent = NA_real_,
                     faGroup = "",
                     faProfile = "",
                     faMethod = "",
                     faPercentage = "",
                     openClose = "",
                     origin = c("customer", "firm", "unknown"),
                     shortSaleSlot = 0,
                     designatedLocation = "",
                     exemptCode = -1,
                     discretionaryAmt = 0,
                     optOutSmartRouting = FALSE,
                     auctionStrategy = c("unset", "match", "improvement", "transparent"),
                     startingPrice = NA_real_,
                     stockRefPrice = NA_real_,
                     delta = NA_real_,
                     stockRangeLower = NA_real_,
                     stockRangeUpper = NA_real_,
                     randomizeSize = FALSE,
                     randomizePrice = FALSE,
                     volatility = NA_real_,
                     volatilityType = NA_integer_,
                     deltaNeutralOrderType = "",
                     deltaNeutralAuxPrice = NA_real_,
                     deltaNeutralConId = 0,
                     deltaNeutralSettlingFirm = "",
                     deltaNeutralClearingAccount = "",
                     deltaNeutralClearingIntent = "",
                     deltaNeutralOpenClose = "",
                     deltaNeutralShortSale = FALSE,
                     deltaNeutralShortSaleSlot = 0,
                     deltaNeutralDesignatedLocation = "",
                     continuousUpdate = FALSE,
                     referencePriceType = NA_integer_,
                     basisPoints = NA_real_,
                     basisPointsType = NA_integer_,
                     scaleInitLevelSize = NA_integer_,
                     scaleSubsLevelSize = NA_integer_,
                     scalePriceIncrement = NA_real_,
                     scalePriceAdjustValue = NA_real_,
                     scalePriceAdjustInterval = NA_integer_,
                     scaleProfitOffset = NA_real_,
                     scaleAutoReset = FALSE,
                     scaleInitPosition = NA_integer_,
                     scaleInitFillQty = NA_integer_,
                     scaleRandomPercent = FALSE,
                     scaleTable = "",
                     hedgeType = "",
                     hedgeParam = "",
                     account = "",
                     settlingFirm = "",
                     clearingAccount = "",
                     clearingIntent = "",
                     algoStrategy = "",
                     algoParams = list(),
                     smartComboRoutingParams = list(),
                     algoId = "",
                     whatIf = FALSE,
                     notHeld = FALSE,
                     solicited = FALSE,
                     modelCode = "",
                     orderComboLegs = list(),
                     orderMiscOptions = list(),
                     referenceContractId = NA_integer_,
                     peggedChangeAmount = NA_real_,
                     isPeggedChangeAmountDecrease = FALSE,
                     referenceChangeAmount = NA_real_,
                     referenceExchangeId = "",
                     adjustedOrderType = "",
                     triggerPrice = NA_real_,
                     adjustedStopPrice = NA_real_,
                     adjustedStopLimitPrice = NA_real_,
                     adjustedTrailingAmount = NA_real_,
                     adjustableTrailingUnit = NA_integer_,
                     lmtPriceOffset = NA_real_,
                     conditions = list(),
                     conditionsCancelOrder = FALSE,
                     conditionsIgnoreRth = FALSE,
                     extOperator = "",
                     softDollarTier = twsSoftDollarTier(),
                     cashQty = NA_real_,
                     mifid2DecisionMaker = "",
                     mifid2DecisionAlgo = "",
                     mifid2ExecutionTrader = "",
                     mifid2ExecutionAlgo = "",
                     dontUseAutoPriceForHedge = FALSE,
                     isOmsContainer = FALSE,
                     discretionaryUpToLimitPrice = FALSE,
                     autoCancelDate = "",
                     filledQuantity = NA_real_,
                     refFuturesConId = NA_integer_,
                     autoCancelParent = FALSE,
                     shareholder = "",
                     imbalanceOnly = FALSE,
                     routeMarketableToBbo = FALSE,
                     parentPermId = NA_real_,
                     usePriceMgmtAlgo = c("default", "dont_use", "use"),
                     duration = NA_integer_,
                     postToAts = NA_integer_) {
  cl <- match.call()
  cl[[1]] <- as.name("list")
  env <- parent.frame()
  out <- structure(eval(cl, envir = env), class = c("twsOrder", "strlist"))
  for (nm in names(order_par_options)) {
    if (is.character(arg <- out[[nm]][[1]])) {
      if (!arg %in% order_par_options[[nm]])
        stop(sprintf("'%s' should be one of %s. Supplied: %s", nm,
                     paste(dQuote(order_par_options[[nm]]), collapse = ", "),
                     dQuote(arg)),
             call. = FALSE)
      out[[nm]] <- arg
    }
  }
  out
}

order_par_options <-
  list(usePriceMgmtAlgo = c("default", "dont_use", "use"),
       auctionStrategy = c("unset", "match", "improvement", "transparent"),
       origin = c("customer", "firm", "unknown"))


twsExecutionFilter <- function(...) {
  stop("TODO")
}
