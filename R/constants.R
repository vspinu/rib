
WHAT_TO_SHOW_TYPES <- c("TRADES", "MIDPOINT", "BID", "ASK", "BID_ASK",
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
       START_API = "71")

