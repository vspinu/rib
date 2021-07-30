
## NB: need lists to avoid out-of-bound errors
EVENT2ID <- list(tickPrice = "1", tickSize = "2", orderStatus = "3", error = "4", 
                 openOrder = "5", updateAccountValue = "6", updatePortfolio = "7", 
                 updateAccountTime = "8", nextValidId = "9", contractDetails = "10", 
                 execDetails = "11", updateMktDepth = "12", updateMktDepthL2 = "13", 
                 newsBulletins = "14", managedAccounts = "15", receiveFa = "16", 
                 historicalData = "17", bondContractData = "18", scannerParameters = "19", 
                 scannerData = "20", tickOptionComputation = "21", tickGeneric = "45", 
                 tickString = "46", tickEFP = "47", currentTime = "49", realTimeBars = "50", 
                 fundamentalData = "51", contractDataEnd = "52", openOrderEnd = "53", 
                 accountDownloadEnd = "54", execDataEnd = "55", deltaNeutralValidation = "56", 
                 tickSnapshotEnd = "57", marketDataType = "58", commissionReport = "59", 
                 positionData = "61", positionEnd = "62", accountSummary = "63", 
                 accountSummaryEnd = "64", verifyMessageApi = "65", verifyCompleted = "66", 
                 displayGroupList = "67", displayGroupUpdated = "68")

ID2EVENT <- structure(as.list(names(EVENT2ID)),
                      names = as.character(EVENT2ID))

## read_scanner_data_msg <- function(con) {
##   cD <- IBrokers:::twsContractDetails()
##   version <- readBin(con, character(), 1L)
##   ticker_id <- readBin(con, character(), 1L)
##   n <- as.integer(readBin(con, character(), 1L))
##   msg <- readBin(con, "character", 16*n)
##   c(version, ticker_id, n, msg)
## }

## read_contract_details_msg <- function(con) {
##   msg <- readBin(con, "character", 1)
##   version <- as.integer(msg[1])
##   if (version >= 3) {
##     msg <- c(msg, readBin(con, "character", 1))
##   }
##   msg <- c(msg, readBin(con, "character", 16))
##   if (version >= 4) {
##     msg <- c(msg, readBin(con, "character", 1))
##   }
##   if (version >= 5) {
##     msg <- c(msg, readBin(con, "character", 2))
##   }
##   if (version >= 6) {
##     msg <- c(msg, readBin(con, "character", 7))
##   }
##   if (version >= 8) {
##     msg <- c(msg, readBin(con, "character", 2))
##   }
##   if (version >= 7) {
##     msg <- c(msg, secIdListCount <- readBin(con, "character", 1))
##     if (as.integer(secIdListCount) > 0) {
##       msg <- c(msg, readBin(con, "character", as.integer(secIdListCount) * 2))
##     }
##   }
##   msg
## }

## read_historical_data_msg <- function(con) {
##   header <- readBin(con, character(), 5)
##   nbin <- as.numeric(header[5]) * 9
##   msg <- readBin(con, character(), as.integer(nbin))
##   msg
## }

## read_execution_data_msg <- function(con) {
##   msg <- readBin(con, "character", 1)
##   version <- as.integer(msg[1])
##   if (version >= 7) {
##     msg <- c(msg, readBin(con, "character", 1))
##   }
##   msg <- c(msg, readBin(con, "character", 7))
##   if (version >= 9) {
##     msg <- c(msg, readBin(con, "character", 1))
##   }
##   msg <- c(msg, readBin(con, "character", 3))
##   if (version >= 10) {
##     msg <- c(msg, readBin(con, "character", 1))
##   }
##   msg <- c(msg, readBin(con, "character", 10))
##   if (version >= 6) {
##     msg <- c(msg, readBin(con, "character", 2))
##   }
##   if (version >= 8) {
##     msg <- c(msg, readBin(con, "character", 1))
##   }
##   if (version >= 9) {
##     msg <- c(msg, readBin(con, "character", 2))
##   }
##   msg
## }

## read_scanner_parameters_msg <- function(con) {
##   version <- readBin(con, "character", 1L) 
##   msg <- readBin(con, raw(), 1e6L)
##   msg
## }

## read_open_order_msg <- function(con) {
##   msg <- readBin(con, "character", 1)
##   version <- as.integer(msg[1])
##   msg <- c(msg, readBin(con, "character", 7))
##   if(version >= 32) {
##     msg <- c(msg, readBin(con, "character", 1))
##   }
##   msg <- c(msg, readBin(con, "character", 3))
##   if(version >= 32) {
##     msg <- c(msg, readBin(con, "character", 1))
##   }
##   msg <- c(msg, tmp <- readBin(con, "character", 50))
##   order.deltaNeutralOrderType <- tmp[49]
##   if(order.deltaNeutralOrderType != "") {
##     if(version >= 27 & !is.na(order.deltaNeutralOrderType)) {
##       msg <- c(msg, readBin(con, "character", 4))
##     }
##     if(version >= 31 & !is.na(order.deltaNeutralOrderType)) {
##       msg <- c(msg, readBin(con, "character", 4))
##     }
##   }
##   msg <- c(msg, tmp <- readBin(con, "character", 3))
##   if(version >= 30) {
##     msg <- c(msg, readBin(con, "character", 1))
##   }
##   msg <- c(msg, tmp <- readBin(con, "character", 3))
##   if(version >= 29) {
##     msg <- c(msg, tmp <- readBin(con, "character", 1))
##     if(tmp[1] != "") {
##       comboLegsCount <- as.integer(tmp[1])
##       if(comboLegsCount > 0) {
##         msg <- c(msg, readBin(con, "character", comboLegsCount * 8))
##       }
##     }
##     msg <- c(msg, tmp <- readBin(con, "character", 1))
##     if(tmp[1] != "") {
##       orderComboLegsCount <- as.integer(tmp[1])
##       if(orderComboLegsCount > 0) {
##         msg <- c(msg, readBin(con, "character", orderComboLegsCount * 1L))
##       }
##     }
##   }
##   if(version >= 26) {
##     msg <- c(msg, tmp <- readBin(con, "character", 1))
##     if(tmp[1] != "") {
##       smartComboRoutingParamsCount <- as.integer(tmp[1])
##       if(smartComboRoutingParamsCount > 0) {
##         msg <- c(msg, readBin(con, "character", smartComboRoutingParamsCount * 2L))
##       }
##     }
##   }
##   msg <- c(msg, tmp <- readBin(con, "character", 3))
##   order.scalePriceIncrement <- as.integer(tmp[3])
##   if(!is.na(order.scalePriceIncrement)) {
##     if(version >= 28 & order.scalePriceIncrement > 0) {
##       msg <- c(msg, readBin(con, "character", 7))
##     }
##   }
##   if(version >= 24) {
##     msg <- c(msg, tmp <- readBin(con, "character", 1))
##     order.hedgeType <- tmp[1]
##     if(order.hedgeType != "") {
##       msg <- c(msg, tmp <- readBin(con, "character", 1))
##     }
##   }
##   if(version >= 25) {
##     msg <- c(msg, tmp <- readBin(con, "character", 1))
##   }
##   msg <- c(msg, tmp <- readBin(con, "character", 2))
##   if(version >= 22) {
##     msg <- c(msg, tmp <- readBin(con, "character", 1))
##   }
##   if(version >= 20) {
##     msg <- c(msg, tmp <- readBin(con, "character", 1))
##     underCompPresent <- as.integer(tmp[1])
##     if(!is.na(underCompPresent)) {
##       if(underCompPresent > 0) {
##         msg <- c(msg, tmp <- readBin(con, "character", 3))
##       }
##     }
##   }
##   if(version >= 21) {
##     msg <- c(msg, tmp <- readBin(con, "character", 1))
##     order.algoStrategy <- tmp[1]
##     if(order.algoStrategy != "") {
##       msg <- c(msg, tmp <- readBin(con, "character", 1))
##       algoParamsCount <- as.integer(tmp[1])
##       if(algoParamsCount > 0) {
##         msg <- c(msg, tmp <- readBin(con, "character", algoParamsCount * 2))
##       }
##     }
##   }
##   msg <- c(msg, tmp <- readBin(con, "character", 10))
## }
