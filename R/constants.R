
WHAT_TO_SHOW_TYPES <- c("MIDPOINT", "BID", "ASK", "BID_ASK", "TRADES",
                        "HISTORICAL_VOLATILITY", "OPTION_IMPLIED_VOLATILITY",
                        "FEE_RATE", "REBATE_RATE")

BAR_SIZE_TYPES <- c("1 sec", "5 secs", "15 secs", "30 secs", "1 min", "2 mins",
                    "3 mins", "5 mins", "15 mins", "30 mins", "1 hour", "1 day")

TWS_REPORT_TYPES <- c("ReportSnapshot", "ReportsFinSummary",
                      "ReportRatios", "ReportsFinStatements", "RESC")


TS_FORMAT <-
"%Y%m%dT%H:%M:%S"

NULLSTR <- as.raw(0)

VALID_BAR_SIZES <- c('1 secs','5 secs','15 secs','30 secs',
                     '1 min', '2 mins','3 mins','5 mins','15 mins',
                     '30 mins','1 hour','1 day','1 week','1 month',
                     '3 months','1 year')

ACCOUNT_SUMMARY_TAGS <-
  c("AccountType", "NetLiquidation", "TotalCashValue", "SettledCash",
    "AccruedCash", "BuyingPower", "EquityWithLoanValue",
    "PreviousEquityWithLoanValue", "GrossPositionValue", "ReqTEquity",
    "ReqTMargin", "SMA", "InitMarginReq", "MaintMarginReq",
    "AvailableFunds", "ExcessLiquidity", "Cushion", "FullInitMarginReq",
    "FullMaintMarginReq", "FullAvailableFunds", "FullExcessLiquidity",
    "LookAheadNextChange", "LookAheadInitMarginReq",
    "LookAheadMaintMarginReq", "LookAheadAvailableFunds",
    "LookAheadExcessLiquidity", "HighestSeverity", "DayTradesRemaining",
    "Leverage")

## [[file:~/vc/tws-api/source/javaclient/com/ib/client/EClient.java::protected static final int MIN_SERVER_VER_WSHE_CALENDAR = 161;][<no description>]]
REQ2ID <-
  list(REQ_MKT_DATA = "1",
       CANCEL_MKT_DATA = "2",
       PLACE_ORDER = "3",
       CANCEL_ORDER = "4",
       REQ_OPEN_ORDERS = "5",
       REQ_ACCOUNT_DATA = "6",
       REQ_EXECUTIONS = "7",
       REQ_IDS = "8",
       REQ_CONTRACT_DATA = "9",
       REQ_MKT_DEPTH = "10",
       CANCEL_MKT_DEPTH = "11",
       REQ_NEWS_BULLETINS = "12",
       CANCEL_NEWS_BULLETINS = "13",
       SET_SERVER_LOGLEVEL = "14",
       REQ_AUTO_OPEN_ORDERS = "15",
       REQ_ALL_OPEN_ORDERS = "16",
       REQ_MANAGED_ACCTS = "17",
       REQ_FA = "18",
       REPLACE_FA = "19",
       REQ_HISTORICAL_DATA = "20",
       EXERCISE_OPTIONS = "21",
       REQ_SCANNER_SUBSCRIPTION = "22",
       CANCEL_SCANNER_SUBSCRIPTION = "23",
       REQ_SCANNER_PARAMETERS = "24",
       CANCEL_HISTORICAL_DATA = "25",
       REQ_CURRENT_TIME = "49",
       REQ_REAL_TIME_BARS = "50",
       CANCEL_REAL_TIME_BARS = "51",
       REQ_FUNDAMENTAL_DATA = "52",
       CANCEL_FUNDAMENTAL_DATA = "53",
       REQ_CALC_IMPLIED_VOLAT = "54",
       REQ_CALC_OPTION_PRICE = "55",
       CANCEL_CALC_IMPLIED_VOLAT = "56",
       CANCEL_CALC_OPTION_PRICE = "57",
       REQ_GLOBAL_CANCEL = "58",
       REQ_MARKET_DATA_TYPE = "59",
       REQ_POSITIONS = "61",
       REQ_ACCOUNT_SUMMARY = "62",
       CANCEL_ACCOUNT_SUMMARY = "63",
       CANCEL_POSITIONS = "64",
       VERIFY_REQUEST = "65",
       VERIFY_MESSAGE = "66",
       QUERY_DISPLAY_GROUPS = "67",
       SUBSCRIBE_TO_GROUP_EVENTS = "68",
       UPDATE_DISPLAY_GROUP = "69",
       UNSUBSCRIBE_FROM_GROUP_EVENTS = "70",
       START_API = "71",
       VERIFY_AND_AUTH_REQUEST = "72",
       VERIFY_AND_AUTH_MESSAGE = "73",
       REQ_POSITIONS_MULTI = "74",
       CANCEL_POSITIONS_MULTI = "75",
       REQ_ACCOUNT_UPDATES_MULTI = "76",
       CANCEL_ACCOUNT_UPDATES_MULTI = "77",
       REQ_SEC_DEF_OPT_PARAMS     = "78",
       REQ_SOFT_DOLLAR_TIERS     = "79",
       REQ_FAMILY_CODES = "80",
       REQ_MATCHING_SYMBOLS = "81",
       REQ_MKT_DEPTH_EXCHANGES = "82",
       REQ_SMART_COMPONENTS = "83",
       REQ_NEWS_ARTICLE = "84",
       REQ_NEWS_PROVIDERS = "85",
       REQ_HISTORICAL_NEWS = "86",
       REQ_HEAD_TIMESTAMP = "87",
       REQ_HISTOGRAM_DATA = "88",
       CANCEL_HISTOGRAM_DATA = "89",
       CANCEL_HEAD_TIMESTAMP = "90",
       REQ_MARKET_RULE = "91",
       REQ_PNL = "92",
       CANCEL_PNL = "93",
       REQ_PNL_SINGLE = "94",
       CANCEL_PNL_SINGLE = "95",
       REQ_HISTORICAL_TICKS = "96",
       REQ_TICK_BY_TICK_DATA = "97",
       CANCEL_TICK_BY_TICK_DATA = "98",
       REQ_COMPLETED_ORDERS = "99",
       REQ_WSH_META_DATA = "100",
       CANCEL_WSH_META_DATA = "101",
       REQ_WSH_EVENT_DATA = "102",
       CANCEL_WSH_EVENT_DATA = "103")

## [[file:~/vc/tws-api/source/javaclient/com/ib/client/EDecoder.java::private static final int WSH_EVENT_DATA = 105;][<no description>]]
## [[file:~/vc/tws-api/source/javaclient/com/ib/client/EDecoder.java::public int processMsg(EMessage msg) throws IOException {][<no description>]]
EVENT2ID <- list(tickPrice = "1", tickSize = "2", orderStatus = "3",
                 error = "4", openOrder = "5", updateAccountValue = "6",
                 updatePortfolio = "7", updateAccountTime = "8",
                 nextValidId = "9", contractDetails = "10", execDetails = "11",
                 updateMktDepth = "12", updateMktDepthL2 = "13",
                 newsBulletins = "14", managedAccounts = "15", receiveFa = "16",
                 historicalData = "17", bondContractDetails = "18",
                 scannerParameters = "19", scannerData = "20",
                 tickOptionComputation = "21", tickGeneric = "45",
                 tickString = "46", tickEFP = "47", currentTime = "49",
                 realTimeBars = "50", fundamentalData = "51",
                 contractDetailsEnd = "52", openOrderEnd = "53",
                 accountDownloadEnd = "54", execDetailsEnd = "55",
                 deltaNeutralValidation = "56", tickSnapshotEnd = "57",
                 marketDataType = "58", commissionReport = "59",
                 positionData = "61", positionEnd = "62", accountSummary = "63",
                 accountSummaryEnd = "64", verifyMessageApi = "65",
                 verifyCompleted = "66", displayGroupList = "67",
                 displayGroupUpdated = "68", verifyAndAuthMessageAPI = "69",
                 verifyAndAuthCompleted = "70", positionMulti = "71",
                 positionMultiEnd = "72", accountUpdateMulti = "73",
                 accountUpdateMultiEnd = "74",
                 securityDefinitionOptionParameter = "75",
                 securityDefinitionOptionParameterEnd = "76",
                 softDollarTiers = "77", familyCodes= "78", symbolSamples= "79",
                 mktDepthExchanges = "80", tickReqParams = "81",
                 smartComponents = "82", newsArticle = "83", tickNews = "84",
                 newsProviders = "85", historicalNews = "86",
                 historicalNewsEnd = "87", headTimestamp = "88",
                 histogramData = "89", historicalDataUpdate = "90",
                 rerouteMktDataReq = "91", rerouteMktDepthReq = "92",
                 marketRule= "93", pnl = "94", pnlSingle= "95",
                 historicalTicks= "96", historicalTicksBidAsk = "97",
                 historicalTicksLast = "98", tickByTick = "99",
                 orderBound= "100", completedOrder= "101",
                 completedOrdersEnd = "102", replaceFaEnd = "103",
                 wshMetaData = "104", wshEventData = "105",
                 ## Generated by the wrapper itself
                 historicalDataEnd = "-1")

ID2EVENT <- structure(as.list(names(EVENT2ID)),
                      names = as.character(EVENT2ID))

COUNTERS <- list2env(list(error = 1,
                          id = 1))

next_id <- function() {
  id <- COUNTERS[["id"]]
  COUNTERS[["id"]] <- id + 1
  as.character(id)
}
