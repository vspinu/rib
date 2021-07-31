
#include "version.h"
#include "RWrapper.h"
#include "CommonDefs.h"

#if MAX_SERVER_VERSION >= 160
using SizeType = long long;
#else
using SizeType = int;
#endif

std::unordered_map<TickType, std::string> tickType2Name({
	{BID_SIZE, "BID_SIZE"},
	{BID, "BID"},
	{ASK, "ASK"},
	{ASK_SIZE, "ASK_SIZE"},
	{LAST, "LAST"},
	{LAST_SIZE, "LAST_SIZE"},
	{HIGH, "HIGH"},
	{LOW, "LOW"},
	{VOLUME, "VOLUME"},
	{CLOSE, "CLOSE"},
	{BID_OPTION_COMPUTATION, "BID_OPTION_COMPUTATION"},
	{ASK_OPTION_COMPUTATION, "ASK_OPTION_COMPUTATION"},
	{LAST_OPTION_COMPUTATION, "LAST_OPTION_COMPUTATION"},
	{MODEL_OPTION, "MODEL_OPTION"},
	{OPEN, "OPEN"},
	{LOW_13_WEEK, "LOW_13_WEEK"},
	{HIGH_13_WEEK, "HIGH_13_WEEK"},
	{LOW_26_WEEK, "LOW_26_WEEK"},
	{HIGH_26_WEEK, "HIGH_26_WEEK"},
	{LOW_52_WEEK, "LOW_52_WEEK"},
	{HIGH_52_WEEK, "HIGH_52_WEEK"},
	{AVG_VOLUME, "AVG_VOLUME"},
	{OPEN_INTEREST, "OPEN_INTEREST"},
	{OPTION_HISTORICAL_VOL, "OPTION_HISTORICAL_VOL"},
	{OPTION_IMPLIED_VOL, "OPTION_IMPLIED_VOL"},
	{OPTION_BID_EXCH, "OPTION_BID_EXCH"},
	{OPTION_ASK_EXCH, "OPTION_ASK_EXCH"},
	{OPTION_CALL_OPEN_INTEREST, "OPTION_CALL_OPEN_INTEREST"},
	{OPTION_PUT_OPEN_INTEREST, "OPTION_PUT_OPEN_INTEREST"},
	{OPTION_CALL_VOLUME, "OPTION_CALL_VOLUME"},
	{OPTION_PUT_VOLUME, "OPTION_PUT_VOLUME"},
	{INDEX_FUTURE_PREMIUM, "INDEX_FUTURE_PREMIUM"},
	{BID_EXCH, "BID_EXCH"},
	{ASK_EXCH, "ASK_EXCH"},
	{AUCTION_VOLUME, "AUCTION_VOLUME"},
	{AUCTION_PRICE, "AUCTION_PRICE"},
	{AUCTION_IMBALANCE, "AUCTION_IMBALANCE"},
	{MARK_PRICE, "MARK_PRICE"},
	{BID_EFP_COMPUTATION, "BID_EFP_COMPUTATION"},
	{ASK_EFP_COMPUTATION, "ASK_EFP_COMPUTATION"},
	{LAST_EFP_COMPUTATION, "LAST_EFP_COMPUTATION"},
	{OPEN_EFP_COMPUTATION, "OPEN_EFP_COMPUTATION"},
	{HIGH_EFP_COMPUTATION, "HIGH_EFP_COMPUTATION"},
	{LOW_EFP_COMPUTATION, "LOW_EFP_COMPUTATION"},
	{CLOSE_EFP_COMPUTATION, "CLOSE_EFP_COMPUTATION"},
	{LAST_TIMESTAMP, "LAST_TIMESTAMP"},
	{SHORTABLE, "SHORTABLE"},
	{FUNDAMENTAL_RATIOS, "FUNDAMENTAL_RATIOS"},
	{RT_VOLUME, "RT_VOLUME"},
	{HALTED, "HALTED"},
	{BID_YIELD, "BID_YIELD"},
	{ASK_YIELD, "ASK_YIELD"},
	{LAST_YIELD, "LAST_YIELD"},
	{CUST_OPTION_COMPUTATION, "CUST_OPTION_COMPUTATION"},
	{TRADE_COUNT, "TRADE_COUNT"},
	{TRADE_RATE, "TRADE_RATE"},
	{VOLUME_RATE, "VOLUME_RATE"},
	{LAST_RTH_TRADE, "LAST_RTH_TRADE"},
	{RT_HISTORICAL_VOL, "RT_HISTORICAL_VOL"},
	{IB_DIVIDENDS, "IB_DIVIDENDS"},
	{BOND_FACTOR_MULTIPLIER, "BOND_FACTOR_MULTIPLIER"},
	{REGULATORY_IMBALANCE, "REGULATORY_IMBALANCE"},
	{NEWS_TICK, "NEWS_TICK"},
	{SHORT_TERM_VOLUME_3_MIN, "SHORT_TERM_VOLUME_3_MIN"},
	{SHORT_TERM_VOLUME_5_MIN, "SHORT_TERM_VOLUME_5_MIN"},
	{SHORT_TERM_VOLUME_10_MIN, "SHORT_TERM_VOLUME_10_MIN"},
	{DELAYED_BID, "DELAYED_BID"},
	{DELAYED_ASK, "DELAYED_ASK"},
	{DELAYED_LAST, "DELAYED_LAST"},
	{DELAYED_BID_SIZE, "DELAYED_BID_SIZE"},
	{DELAYED_ASK_SIZE, "DELAYED_ASK_SIZE"},
	{DELAYED_LAST_SIZE, "DELAYED_LAST_SIZE"},
	{DELAYED_HIGH, "DELAYED_HIGH"},
	{DELAYED_LOW, "DELAYED_LOW"},
	{DELAYED_VOLUME, "DELAYED_VOLUME"},
	{DELAYED_CLOSE, "DELAYED_CLOSE"},
	{DELAYED_OPEN, "DELAYED_OPEN"},
	{RT_TRD_VOLUME, "RT_TRD_VOLUME"},
	{CREDITMAN_MARK_PRICE, "CREDITMAN_MARK_PRICE"},
	{CREDITMAN_SLOW_MARK_PRICE, "CREDITMAN_SLOW_MARK_PRICE"},
	{DELAYED_BID_OPTION_COMPUTATION, "DELAYED_BID_OPTION_COMPUTATION"},
	{DELAYED_ASK_OPTION_COMPUTATION, "DELAYED_ASK_OPTION_COMPUTATION"},
	{DELAYED_LAST_OPTION_COMPUTATION, "DELAYED_LAST_OPTION_COMPUTATION"},
	{DELAYED_MODEL_OPTION_COMPUTATION, "DELAYED_MODEL_OPTION_COMPUTATION"},
	{LAST_EXCH, "LAST_EXCH"},
	{LAST_REG_TIME, "LAST_REG_TIME"},
	{FUTURES_OPEN_INTEREST, "FUTURES_OPEN_INTEREST"},
	{AVG_OPT_VOLUME, "AVG_OPT_VOLUME"},
	{DELAYED_LAST_TIMESTAMP, "DELAYED_LAST_TIMESTAMP"},
	{SHORTABLE_SHARES, "SHORTABLE_SHARES"},
#if MAX_SERVER_VERSION > 160
	{DELAYED_HALTED, "DELAYED_HALTED"},
	{REUTERS_2_MUTUAL_FUNDS, "REUTERS_2_MUTUAL_FUNDS"},
	{ETF_NAV_CLOSE, "ETF_NAV_CLOSE"},
	{ETF_NAV_PRIOR_CLOSE, "ETF_NAV_PRIOR_CLOSE"},
	{ETF_NAV_BID, "ETF_NAV_BID"},
	{ETF_NAV_ASK, "ETF_NAV_ASK"},
	{ETF_NAV_LAST, "ETF_NAV_LAST"},
	{ETF_FROZEN_NAV_LAST, "ETF_FROZEN_NAV_LAST"},
	{ETF_NAV_HIGH, "ETF_NAV_HIGH"},
	{ETF_NAV_LOW, "ETF_NAV_LOW"},
#endif
	{NOT_SET, "NOT_SET"}
  });

void RWrapper::tickPrice(TickerId tickerId, TickType field, double price,
						 const TickAttrib& attribs) {
  acc.push_back(lst({
		"event"_nm = "tickPrice",
		"reqId"_nm = tickerId,
		"type"_nm = tickType2Name[field],
		"price"_nm = price,
		"atrribs"_nm = lst({
			"canAutoExecute"_nm = attribs.canAutoExecute,
			"pastLimit"_nm = attribs.pastLimit,
			"preOpen"_nm = attribs.preOpen
		  })
	}));
}

void RWrapper::tickSize(TickerId tickerId, TickType field, SizeType size) {
  acc.push_back(lst({
		"event"_nm = "tickSize",
		"reqId"_nm = tickerId,
		"type"_nm = tickType2Name[field],
		"size"_nm = size
	  }));
}

void RWrapper::tickOptionComputation(TickerId tickerId, TickType tickType,
#if MAX_SERVER_VERSION >= 156
									 int tickAttrib,
#endif
									 double impliedVol, double delta,
									 double optPrice, double pvDividend, double gamma,
									 double vega, double theta, double undPrice) {
  acc.push_back(lst({
		"event"_nm = "tickOptionComputation",
		"reqId"_nm = tickerId,
		"type"_nm = tickType2Name[tickType],
#if MAX_SERVER_VERSION >= 156
		"attrib"_nm = tickAttrib,
#endif
		"impliedVol"_nm = impliedVol,
		"delta"_nm = delta,
		"optPrice"_nm = optPrice,
		"pvDividend"_nm = pvDividend,
		"gamma"_nm = gamma,
		"vega"_nm = vega,
		"theta"_nm = theta,
		"undPrice"_nm = undPrice,
	  }));
}

void RWrapper::tickGeneric(TickerId tickerId, TickType tickType, double value) {
  acc.push_back(lst({
		"event"_nm = "tickGeneric",
		"reqId"_nm = tickerId,
		"type"_nm = tickType2Name[tickType],
		"value"_nm = value
	  }));
}

void RWrapper::tickString(TickerId tickerId, TickType tickType, const std::string& value) {
  acc.push_back(lst({
		"event"_nm = "tickString",
		"reqId"_nm = tickerId,
		"type"_nm = tickType2Name[tickType],
		"value"_nm = value
	  }));
}

void RWrapper::tickEFP(TickerId tickerId, TickType tickType, double basisPoints,
					   const std::string& formattedBasisPoints, double totalDividends,
					   int holdDays, const std::string& futureLastTradeDate,
					   double dividendImpact, double dividendsToLastTradeDate) {
  acc.push_back(lst({
		"event"_nm = "tickEFP",
		"reqId"_nm = tickerId,
		"type"_nm = tickType2Name[tickType],
		"basisPoints"_nm = basisPoints,
		"formattedBasisPoints"_nm = formattedBasisPoints,
		"totalDividends"_nm = totalDividends,
		"holdDays"_nm = holdDays,
		"futureLastTradeDate"_nm = futureLastTradeDate,
		"dividendImpact"_nm = dividendImpact,
		"dividendsToLastTradeDate"_nm = dividendsToLastTradeDate,
	  }));
}

void RWrapper::orderStatus(OrderId orderId, const std::string& status, double filled,
						   double remaining, double avgFillPrice, int permId, int parentId,
						   double lastFillPrice, int clientId,
						   const std::string& whyHeld, double mktCapPrice) {
  acc.push_back(lst({
		"event"_nm = "orderStatus",
		"orderId"_nm = orderId,
		"status"_nm = status,
		"filled"_nm = filled,
		"remaining"_nm = remaining,
		"avgFillPrice"_nm = avgFillPrice,
		"permId"_nm = permId,
		"parentId"_nm = parentId,
		"lastFillPrice"_nm = lastFillPrice,
		"clientId"_nm = clientId,
		"whyHeld"_nm = whyHeld,
		"mktCapPrice"_nm = mktCapPrice
	  }));
}

void RWrapper::openOrder(OrderId orderId, const Contract& contract,
						 const Order& order, const OrderState& orderState) {
  acc.push_back(lst({
		"event"_nm = "openOrder",
		"orderId"_nm = orderId,
		"contract"_nm = RContract(contract), 
		"order"_nm = ROrder(order),
		"orderState"_nm = ROrderState(orderState)
	  }));
}

void RWrapper::openOrderEnd() {
  acc.push_back(lst({
		"event"_nm = "openOrderEnd",
	  }));
}

void RWrapper::connectionClosed() {
  acc.push_back(lst({
		"event"_nm = "connectionClosed"
	  }));
}

void RWrapper::updateAccountValue(const std::string& key, const std::string& val,
								  const std::string& currency, const std::string& accountName) {
  acc.push_back(lst({
		"event"_nm = "updateAccountValue",
		"key"_nm = key,
		"val"_nm = val,
		"currency"_nm = currency,
		"accountName"_nm = accountName
	  }));
}

void RWrapper::updatePortfolio(const Contract& contract, double position,
							   double marketPrice, double marketValue, double averageCost,
							   double unrealizedPNL, double realizedPNL,
							   const std::string& accountName) {
  acc.push_back(lst({
		"event"_nm = "updatePortfolio",
		"contract"_nm = RContract(contract),
		"position"_nm = position,
		"marketPrice"_nm = marketPrice,
		"marketValue"_nm = marketValue,
		"averageCost"_nm = averageCost,
		"unrealizedPNL"_nm = unrealizedPNL,
		"realizedPNL"_nm = realizedPNL,
		"accountName"_nm = accountName
	  }));
}

void RWrapper::updateAccountTime(const std::string& accountTime) {
  acc.push_back(lst({
		"event"_nm = "updateAccountTime",
		"accountTime"_nm = accountTime
	  }));
}

void RWrapper::accountDownloadEnd(const std::string& accountName) {
  acc.push_back(lst({
		"event"_nm = "accountDownloadEnd",
		"accountName"_nm = accountName
	  }));
}

void RWrapper::nextValidId(OrderId orderId) {
  acc.push_back(lst({
		"event"_nm = "nextValidId"
		"orderId"_nm = orderId
	  }));
}

void RWrapper::contractDetails(int reqId, const ContractDetails& contractDetails) {
  acc.push_back(lst({
		"event"_nm = "contractDetails",
		"reqId"_nm = reqId,
		"contractDetails"_nm = RContractDetails(contractDetails)
	  }));
}

void RWrapper::bondContractDetails(int reqId, const ContractDetails& contractDetails) {
  acc.push_back(lst({
		"event"_nm = "bondContractDetails",
		"reqId"_nm = reqId,
		"contractDetails"_nm = RContractDetails(contractDetails)
	  }));
}

void RWrapper::contractDetailsEnd(int reqId) {
  acc.push_back(lst({
		"event"_nm = "contractDetailsEnd",
		"reqId"_nm = reqId
	  }));
}

void RWrapper::execDetails(int reqId, const Contract& contract,
						   const Execution& execution) {
  acc.push_back(lst({
		"event"_nm = "execDetails",
		"contract"_nm = RContract(contract),
		"execution"_nm = RExecution(execution)
	  }));
}

void RWrapper::execDetailsEnd(int reqId) {
  acc.push_back(lst({
		"event"_nm = "execDetailsEnd",
		"reqId"_nm = reqId
	  }));
}
  
void RWrapper::error(int id, int errorCode, const std::string& errorString) {;
  acc.push_back(lst({
		"event"_nm = id == -1 ? "info" : "error",
		"reqId"_nm = id,
		"code"_nm = errorCode,
		"message"_nm = errorString,
	  }));
}

void RWrapper::updateMktDepth(TickerId id, int position, int operation, int side,
							  double price, SizeType size) {
  acc.push_back(lst({
		"event"_nm = "updateMktDepth",
		"reqId"_nm = id,
		"position"_nm = position,
		"operation"_nm = operation,
		"side"_nm = side,
		"price"_nm = price,
		"size"_nm = size,
	  }));
}

void RWrapper::updateMktDepthL2(TickerId id, int position, const std::string& marketMaker,
								int operation, int side, double price, SizeType size,
								bool isSmartDepth) {
  acc.push_back(lst({
		"event"_nm = "updateMktDepthL2",
		"id"_nm = id,
		"position"_nm = position,
		"marketMaker"_nm = marketMaker,
		"operation"_nm = operation,
		"side"_nm = side,
		"price"_nm = price,
		"size"_nm = size,
		"isSmartDepth"_nm = isSmartDepth
	  }));
}

void RWrapper::updateNewsBulletin(int msgId, int msgType, const std::string& newsMessage,
								  const std::string& originExch) {
  acc.push_back(lst({
		"event"_nm = "updateNewsBulletin",
		"msgId"_nm = msgId,
		"msgType"_nm = msgType,
		"newsMessage"_nm = newsMessage,
		"originExch"_nm = originExch,
	  }));
}

void RWrapper::managedAccounts(const std::string& accountsList) {
  acc.push_back(lst({
		"event"_nm = "managedAccounts",
		"accountsList"_nm = accountsList
	  }));
}

void RWrapper::receiveFA(faDataType faDataType, const std::string& cxml) {
  acc.push_back(lst({
		"event"_nm = "receiveFA",
		"faDataType"_nm = faDataTypeStr(faDataType),
		"cxml"_nm = cxml
	  }));
}

void RWrapper::historicalData(TickerId reqId, const Bar& bar) {
  acc.push_back(lst({
		"event"_nm = "historicalData",
		"reqId"_nm = reqId,
		"bar"_nm = RBar(bar),
	  }));
}

void RWrapper::historicalDataEnd(int reqId, const std::string& startDateStr,
								 const std::string& endDateStr) {
  acc.push_back(lst({
		"event"_nm = "historicalDataEnd",
		"reqId"_nm = reqId,
		"startDateStr"_nm = startDateStr,
		"endDateStr"_nm = endDateStr,
	  }));
}

void RWrapper::scannerParameters(const std::string& xml) {
  acc.push_back(lst({
		"event"_nm = "scannerParameters",
		"xml"_nm = xml,
	  }));
}

void RWrapper::scannerData(int reqId, int rank, const ContractDetails& contractDetails,
						   const std::string& distance, const std::string& benchmark,
						   const std::string& projection, const std::string& legsStr) {
  acc.push_back(lst({
		"event"_nm = "scannerData",
		"reqId"_nm = reqId,
		"rank"_nm = rank,
		"contractDetails"_nm = RContractDetails(contractDetails),
		"distance"_nm = distance,
		"benchmark"_nm = benchmark,
		"projection"_nm = projection,
		"legsStr"_nm = legsStr,
	  }));
}

void RWrapper::scannerDataEnd(int reqId) {
  acc.push_back(lst({
		"event"_nm = "scannerDataEnd",
		"reqId"_nm = reqId,
	  }));
}

void RWrapper::realtimeBar(TickerId reqId, long time, double open, double high,
						   double low, double close,
						   long volume, double wap, int count) {
  acc.push_back(lst({
		"event"_nm = "realtimeBar",
		"reqId"_nm = reqId,
		"time"_nm = time,
		"open"_nm = open,
		"high"_nm = high,
		"low"_nm = low,
		"close"_nm = close,
		"volume"_nm = volume,
		"wap"_nm = wap,
		"count"_nm = count,
	  }));
}

void RWrapper::currentTime(long time) {
  acc.push_back(lst({
		"event"_nm = "currentTime",
		"time"_nm = time,
	  }));
}

void RWrapper::fundamentalData(TickerId reqId, const std::string& data) {
  acc.push_back(lst({
		"event"_nm = "fundamentalData",
		"reqId"_nm = reqId,
		"data"_nm = data,
	  }));
}

void RWrapper::deltaNeutralValidation(int reqId, const DeltaNeutralContract& deltaNeutralContract) {
  acc.push_back(lst({
		"event"_nm = "deltaNeutralValidation",
		"reqId"_nm = reqId,
		"deltaNeutralContract"_nm = lst({
			"conId"_nm = deltaNeutralContract.conId,
			"delta"_nm = deltaNeutralContract.delta,
			"price"_nm = deltaNeutralContract.price
		  }),
	  }));
}

void RWrapper::tickSnapshotEnd(int reqId) {
  acc.push_back(lst({
		"event"_nm = "tickSnapshotEnd",
		"reqId"_nm = reqId,
	  }));
}

void RWrapper::marketDataType(TickerId reqId, int marketDataType) {
  acc.push_back(lst({
		"event"_nm = "marketDataType",
		"reqId"_nm = reqId,
		"marketDataType"_nm = marketDataType,
	  }));
}

void RWrapper::commissionReport(const CommissionReport& cr) {
  acc.push_back(lst({
		"event"_nm = "commissionReport",
		"commissionReport"_nm = lst({
			"execId"_nm = cr.execId,
			"commission"_nm = cr.commission,
			"currency"_nm = cr.currency,
			"realizedPNL"_nm = cr.realizedPNL,
			"yield"_nm = cr.yield,
			"yieldRedemptionDate"_nm = cr.yieldRedemptionDate, // YYYYMMDD format
		  })
	  }));
}

void RWrapper::position(const std::string& account, const Contract& contract,
						double position, double avgCost) {
  acc.push_back(lst({
		"event"_nm = "position",
		"account"_nm = account,
		"position"_nm = position,
		"avgCost"_nm = avgCost,
		"contract"_nm = RContract(contract)
	  }));
}

void RWrapper::positionEnd() {
  acc.push_back(lst({
		"event"_nm = "positionEnd",
	  }));
}

void RWrapper::accountSummary(int reqId, const std::string& account,
							  const std::string& tag, const std::string& value,
							  const std::string& curency) {
  acc.push_back(lst({
		"event"_nm = "accountSummary",
		"reqId"_nm = reqId,
		"account"_nm = account,
		"tag"_nm = tag,
		"value"_nm = value,
		"curency"_nm = curency,
	  }));
}

void RWrapper::accountSummaryEnd(int reqId) {
  acc.push_back(lst({
		"event"_nm = "accountSummaryEnd",
		"reqId"_nm = reqId,
	  }));
}

void RWrapper::verifyMessageAPI(const std::string& apiData) {
  acc.push_back(lst({
		"event"_nm = "verifyMessageAPI",
		"apiData"_nm = apiData,
	  }));
}

void RWrapper::verifyCompleted(bool isSuccessful, const std::string& errorText) {
  acc.push_back(lst({
		"event"_nm = "verifyCompleted",
		"isSuccessful"_nm = isSuccessful,
		"errorText"_nm = errorText,
	  }));
}

void RWrapper::displayGroupList(int reqId, const std::string& groups) {
  acc.push_back(lst({
		"event"_nm = "displayGroupList",
		"reqId"_nm = reqId,
		"groups"_nm = groups,
	  }));
}

void RWrapper::displayGroupUpdated(int reqId, const std::string& contractInfo) {
  acc.push_back(lst({
		"event"_nm = "displayGroupUpdated",
		"reqId"_nm = reqId,
		"contractInfo"_nm = contractInfo,
	  }));
}

void RWrapper::verifyAndAuthMessageAPI(const std::string& apiData, const std::string& xyzChallange) {
  acc.push_back(lst({
		"event"_nm = "verifyAndAuthMessageAPI",
		"apiData"_nm = apiData,
		"xyzChallange"_nm = xyzChallange,
	  }));
}

void RWrapper::verifyAndAuthCompleted(bool isSuccessful, const std::string& errorText) {
  acc.push_back(lst({
		"event"_nm = "verifyAndAuthCompleted",
		"isSuccessful"_nm = isSuccessful,
		"errorText"_nm = errorText,
	  }));
}

void RWrapper::positionMulti(int reqId, const std::string& account,
							 const std::string& modelCode, const Contract& contract,
							 double pos, double avgCost) {
  acc.push_back(lst({
		"event"_nm = "positionMulti",
		"reqId"_nm = reqId,
		"account"_nm = account,
		"modelCode"_nm = modelCode,
		"pos"_nm = pos,
		"avgCost"_nm = avgCost,
		"contract"_nm = RContract(contract),
	  }));
}

void RWrapper::positionMultiEnd(int reqId) {
  acc.push_back(lst({
		"event"_nm = "positionMultiEnd",
		"reqId"_nm = reqId,
	  }));
}

void RWrapper::accountUpdateMulti(int reqId, const std::string& account,
								  const std::string& modelCode, const std::string& key,
								  const std::string& value, const std::string& currency) {
  acc.push_back(lst({
		"event"_nm = "accountUpdateMulti",
		"reqId"_nm = reqId,
		"account"_nm = account,
		"modelCode"_nm = modelCode,
		"key"_nm = key,
		"value"_nm = value,
		"currency"_nm = currency,
	  }));
}

void RWrapper::accountUpdateMultiEnd(int reqId) {
  acc.push_back(lst({
		"event"_nm = "accountUpdateMultiEnd",
		"reqId"_nm = reqId,
	  }));
}

void RWrapper::securityDefinitionOptionalParameter(int reqId, const std::string& exchange,
												   int underlyingConId,
												   const std::string& tradingClass,
												   const std::string& multiplier,
												   const std::set<std::string>& expirations,
												   const std::set<double>& strikes) {
  acc.push_back(lst({
		"event"_nm = "securityDefinitionOptionalParameter",
		"reqId"_nm = reqId,
		"exchange"_nm = exchange,
		"underlyingConId"_nm = underlyingConId,
		"tradingClass"_nm = tradingClass,
		"multiplier"_nm = multiplier,
		"expirations"_nm = expirations,
		"strikes"_nm = strikes,
	  }));
}

void RWrapper::securityDefinitionOptionalParameterEnd(int reqId) {
  acc.push_back(lst({
		"event"_nm = "securityDefinitionOptionalParameterEnd",
		"reqId"_nm = reqId,
	  }));
}

void RWrapper::softDollarTiers(int reqId, const std::vector<SoftDollarTier> &tiers) {
  size_t N = tiers.size();
  cpp11::writable::strings name(N), val(N), displayName(N);
  for (size_t i = 0; i < N; i++) {
	name[i] = tiers[i].name();
	val[i] = tiers[i].val();
	displayName[i] = tiers[i].displayName();
  }
  acc.push_back(lst({
		"event"_nm = "softDollarTiers",
		"reqId"_nm = reqId,
		"tiers"_nm = df({
			"name"_nm = name,
			"val"_nm = val,
			"displayName"_nm = displayName,
		  }),
	  }));
}

void RWrapper::familyCodes(const std::vector<FamilyCode> &familyCodes) {
  size_t N = familyCodes.size();
  cpp11::writable::strings accountID(N), familyCodeStr(N);
  for (size_t i = 0; i < N; i++) {
	accountID[i] = familyCodes[i].accountID;
	familyCodeStr[i] = familyCodes[i].familyCodeStr;
  }
  acc.push_back(lst({
		"event"_nm = "familyCodes",
		"familyCodes"_nm = df({
			"accountID"_nm = accountID,
			"familyCodeStr"_nm = familyCodeStr,
		  }),
	  }));
}

void RWrapper::symbolSamples(int reqId, const std::vector<ContractDescription> &contractDescriptions) {
  wlst cds(contractDescriptions.size());
  for (size_t i = 0; i < contractDescriptions.size(); i++) {
	cds[i] = RContractDescription(contractDescriptions[i]);
  }
  acc.push_back(lst({
		"event"_nm = "symbolSamples",
		"reqId"_nm = reqId,
		"contractDescriptions"_nm = cds,
	  }));
}

void RWrapper::mktDepthExchanges(const std::vector<DepthMktDataDescription> &depthMktDataDescriptions) {
  size_t N = depthMktDataDescriptions.size();
  cpp11::writable::strings exchange(N), secType(N), listingExch(N), serviceDataType(N);
  cpp11::writable::integers aggGroup(N);
  for (size_t i = 0; i < depthMktDataDescriptions.size(); i++) {
	exchange[i] = depthMktDataDescriptions[i].exchange;
	secType[i] = depthMktDataDescriptions[i].secType;
	listingExch[i] = depthMktDataDescriptions[i].listingExch;
	serviceDataType[i] = depthMktDataDescriptions[i].serviceDataType;
	aggGroup[i] = depthMktDataDescriptions[i].aggGroup;
  }
  acc.push_back(lst({
		"event"_nm = "mktDepthExchanges",
		"depthMktDataDescriptions"_nm = df({
			"exchange"_nm = exchange,
			"secType"_nm = secType,
			"listingExch"_nm = listingExch,
			"serviceDataType"_nm = serviceDataType,
			"aggGroup"_nm = aggGroup,
		  }),
	  }));
}

void RWrapper::tickNews(int tickerId, time_t timeStamp, const std::string& providerCode,
						const std::string& articleId, const std::string& headline,
						const std::string& extraData) {
  acc.push_back(lst({
		"event"_nm = "tickNews",
		"tickerId"_nm = tickerId,
		"timeStamp"_nm = timeStamp,
		"providerCode"_nm = providerCode,
		"articleId"_nm = articleId,
		"headline"_nm = headline,
		"extraData"_nm = extraData,
	  }));
}

void RWrapper::smartComponents(int reqId, const SmartComponentsMap& theMap) {
  size_t N = theMap.size();
  cpp11::writable::integers bitNumber(N);
  cpp11::writable::strings exchange(N), exchangeLetter(N);
  size_t i = 0;
  for (auto it = theMap.begin(); it != theMap.end(); i++) {
	bitNumber[i] = it->first;
	exchange[i] = std::get<0>(it->second);
	exchangeLetter[i] = std::string(1, std::get<1>(it->second));
	i++;
  }
  acc.push_back(lst({
		"event"_nm = "smartComponents",
		"reqId"_nm = reqId,
		"smartComponents"_nm = df({
			"bitNumber"_nm = bitNumber,
			"exchange"_nm = exchange,
			"exchangeLetter"_nm = exchangeLetter,
		  }),
	  }));
}

void RWrapper::tickReqParams(int tickerId, double minTick, const std::string& bboExchange
							 , int snapshotPermissions) {
  acc.push_back(lst({
		"event"_nm = "tickReqParams",
		"tickerId"_nm = tickerId,
		"minTick"_nm = minTick,
		"bboExchange"_nm = bboExchange,
		"snapshotPermissions"_nm = snapshotPermissions,
	  }));
}

void RWrapper::newsProviders(const std::vector<NewsProvider> &newsProviders) {
  size_t N = newsProviders.size();
  cpp11::writable::strings providerCode(N), providerName(N);
  for (size_t i = 0; i < N; i++) {
	providerCode[i] = newsProviders[i].providerCode;
	providerName[i] = newsProviders[i].providerName;
  }
  acc.push_back(lst({
		"event"_nm = "newsProviders",
		"newsProviders"_nm = df({
			"providerCode"_nm = providerCode,
			"providerName"_nm = providerName,
		  })
	  }));
}

void RWrapper::newsArticle(int requestId, int articleType, const std::string& articleText) {
  acc.push_back(lst({
		"event"_nm = "newsArticle",
		"requestId"_nm = requestId,
		"articleType"_nm = articleType,
		"articleText"_nm = articleText,
	  }));
}

void RWrapper::historicalNews(int requestId, const std::string& time,
							  const std::string& providerCode,
							  const std::string& articleId,
							  const std::string& headline) {
  acc.push_back(lst({
		"event"_nm = "historicalNews",
		"requestId"_nm = requestId,
		"time"_nm = time,
		"providerCode"_nm = providerCode,
		"articleId"_nm = articleId,
		"headline"_nm = headline,
	  }));
}

void RWrapper::historicalNewsEnd(int requestId, bool hasMore) {
  acc.push_back(lst({
		"event"_nm = "historicalNewsEnd",
		"requestId"_nm = requestId,
		"hasMore"_nm = hasMore,
	  }));
}

void RWrapper::headTimestamp(int reqId, const std::string& headTimestamp) {
  acc.push_back(lst({
		"event"_nm = "headTimestamp",
		"reqId"_nm = reqId,
		"headTimestamp"_nm = headTimestamp,
	  }));
}

void RWrapper::histogramData(int reqId, const HistogramDataVector& data) {
  cpp11::writable::doubles price(data.size()), size(data.size());
  for (size_t i = 0; i < data.size(); i++) {
	price[i] = data[i].price;
	size[i] = data[i].size;
  }
  acc.push_back(lst({
		"event"_nm = "histogramData",
		"reqId"_nm = reqId,
		"data"_nm = df({
			"price"_nm = price,
			"size"_nm = size
		  })
	  }));
}

void RWrapper::historicalDataUpdate(TickerId reqId, const Bar& bar) {
  acc.push_back(lst({
		"event"_nm = "historicalDataUpdate",
		"reqId"_nm = reqId,
		"bar"_nm = RBar(bar),
	  }));
}

void RWrapper::rerouteMktDataReq(int reqId, int conId, const std::string& exchange) {
  acc.push_back(lst({
		"event"_nm = "rerouteMktDataReq",
		"reqId"_nm = reqId,
		"conId"_nm = conId,
		"exchange"_nm = exchange,
	  }));
}

void RWrapper::rerouteMktDepthReq(int reqId, int conid, const std::string& exchange) {
  acc.push_back(lst({
		"event"_nm = "rerouteMktDepthReq",
		"reqId"_nm = reqId,
		"conid"_nm = conid,
		"exchange"_nm = exchange,
	  }));
}

void RWrapper::marketRule(int marketRuleId,
						  const std::vector<PriceIncrement> &priceIncrements) {
  size_t N = priceIncrements.size();
  cpp11::writable::doubles lowEdge(N), increment(N);
  for (size_t i = 0; i < N; i++) {
	lowEdge[i] = priceIncrements[i].lowEdge;
	increment[i] = priceIncrements[i].increment;
  }
  acc.push_back(lst({
		"event"_nm = "marketRule",
		"marketRuleId"_nm = marketRuleId,
		"priceIncrements"_nm = df({
			"lowEdge"_nm = lowEdge,
			"increment"_nm = increment
		  }),
	  }));
}

void RWrapper::pnl(int reqId, double dailyPnL, double unrealizedPnL, double realizedPnL) {
  acc.push_back(lst({
		"event"_nm = "pnl",
		"reqId"_nm = reqId,
		"dailyPnL"_nm = dailyPnL,
		"unrealizedPnL"_nm = unrealizedPnL,
		"realizedPnL"_nm = realizedPnL,
	  }));
}

void RWrapper::pnlSingle(int reqId, int pos, double dailyPnL, double unrealizedPnL,
						 double realizedPnL, double value) {
  acc.push_back(lst({
		"event"_nm = "pnlSingle",
		"reqId"_nm = reqId,
		"pos"_nm = pos,
		"dailyPnL"_nm = dailyPnL,
		"unrealizedPnL"_nm = unrealizedPnL,
		"realizedPnL"_nm = realizedPnL,
		"value"_nm = value,
	  }));
}

void RWrapper::historicalTicks(int reqId, const std::vector<HistoricalTick>& ticks,
							   bool done) {
  size_t N = ticks.size();
  cpp11::writable::doubles time(N), price(N), size(N);
  for (size_t i = 0; i < N; i++) {
	time[i] = ticks[i].time;
	price[i] = ticks[i].price;
	size[i] = ticks[i].size;
  }
  acc.push_back(lst({
		"event"_nm = "historicalTicks",
		"reqId"_nm = reqId,
		"done"_nm = done,
		"ticks"_nm = df({
			"time"_nm = time,
			"price"_nm = price,
			"size"_nm = size,
		  }),
	  }));
}

void RWrapper::historicalTicksBidAsk(int reqId,
									 const std::vector<HistoricalTickBidAsk>& ticks,
									 bool done) {
  size_t N = ticks.size();
  cpp11::writable::doubles time(N),
	priceBid(N), priceAsk(N),
	sizeBid(N), sizeAsk(N),
	bidPastLow(N), askPastHigh(N);
  for (size_t i = 0; i < N; i++) {
	time[i] = ticks[i].time;
	priceAsk[i] = ticks[i].priceAsk;
	priceBid[i] = ticks[i].priceBid;
	sizeAsk[i] = ticks[i].sizeAsk;
	sizeBid[i] = ticks[i].sizeBid;
	askPastHigh[i] = ticks[i].tickAttribBidAsk.askPastHigh;
	bidPastLow[i] = ticks[i].tickAttribBidAsk.bidPastLow;
  }
  acc.push_back(lst({
		"event"_nm = "historicalTicksBidAsk",
		"reqId"_nm = reqId,
		"done"_nm = done,
		"ticks"_nm = df({
			"time"_nm = time,
			"priceAsk"_nm = priceAsk,
			"priceBid"_nm = priceBid,
			"sizeAsk"_nm = sizeAsk,
			"sizeBid"_nm = sizeBid,
			"askPastHigh"_nm = askPastHigh,
			"bidPastLow"_nm = bidPastLow,
		  }),
	  }));
}

void RWrapper::historicalTicksLast(int reqId,
								   const std::vector<HistoricalTickLast>& ticks,
								   bool done) {
  size_t N = ticks.size();
  cpp11::writable::doubles time(N), price(N), size(N);
  cpp11::writable::strings exchange(N), specialConditions(N);
  for (size_t i = 0; i < N; i++) {
	time[i] = ticks[i].time;
	price[i] = ticks[i].price;
	size[i] = ticks[i].size;
	exchange[i] = ticks[i].exchange;
	specialConditions[i] = ticks[i].specialConditions;
  }
  acc.push_back(lst({
		"event"_nm = "historicalTicksLast",
		"reqId"_nm = reqId,
		"done"_nm = done,
		"ticks"_nm = df({
			"time"_nm = time,
			"price"_nm = price,
			"size"_nm = size,
			"exchange"_nm = exchange,
			"specialConditions"_nm = specialConditions,
		  })
	  }));
}

void RWrapper::tickByTickAllLast(int reqId, int tickType, time_t time,
								 double price, SizeType size,
								 const TickAttribLast& tickAttribLast,
								 const std::string& exchange,
								 const std::string& specialConditions) {
  acc.push_back(lst({
		"event"_nm = "tickByTickAllLast",
		"reqId"_nm = reqId,
		"tickType"_nm = tickType,
		"time"_nm = time,
		"price"_nm = price,
		"size"_nm = size,
		"exchange"_nm = exchange,
		"specialConditions"_nm = specialConditions,
		"pastLimit"_nm = tickAttribLast.pastLimit,
		"unreported"_nm = tickAttribLast.unreported,
	  }));
}

void RWrapper::tickByTickBidAsk(int reqId, time_t time,
								double bidPrice, double askPrice,
								SizeType bidSize, SizeType askSize,
								const TickAttribBidAsk& tickAttribBidAsk) {
  acc.push_back(lst({
		"event"_nm = "tickByTickBidAsk",
		"reqId"_nm = reqId,
		"time"_nm = time,
		"bidPrice"_nm = bidPrice,
		"askPrice"_nm = askPrice,
		"bidSize"_nm = bidSize,
		"askSize"_nm = askSize,
		"bidPastLow"_nm = tickAttribBidAsk.bidPastLow,
		"askPastHigh"_nm = tickAttribBidAsk.askPastHigh,
	  }));
}

void RWrapper::tickByTickMidPoint(int reqId, time_t time, double midPoint) {
  acc.push_back(lst({
		"event"_nm = "tickByTickMidPoint",
		"reqId"_nm = reqId,
		"time"_nm = time,
		"midPoint"_nm = midPoint,
	  }));
}

void RWrapper::orderBound(long long orderId, int apiClientId, int apiOrderId) {
  acc.push_back(lst({
		"event"_nm = "orderBound",
		"orderId"_nm = orderId,
		"apiClientId"_nm = apiClientId,
		"apiOrderId"_nm = apiOrderId,
	  }));
}

void RWrapper::completedOrder(const Contract& contract, const Order& order,
							  const OrderState& orderState) {
  acc.push_back(lst({
		"event"_nm = "completedOrder",
		"contract"_nm = RContract(contract),
		"order"_nm = ROrder(order),
		"orderState"_nm = ROrderState(orderState),
	  }));
}

void RWrapper::completedOrdersEnd() {
  acc.push_back(lst({
		"event"_nm = "completedOrdersEnd",
	  }));
}

#if MAX_SERVER_VERSION >= 157
void RWrapper::replaceFAEnd(int reqId, const std::string& text) {
  acc.push_back(lst({
		"event"_nm = "replaceFAEnd",
		"reqId"_nm = reqId,
		"text"_nm = text,
	  }));
}
#endif

#if MAX_SERVER_VERSION >= 161
void RWrapper::wshMetaData(int reqId, const std::string& dataJson) {
  acc.push_back(lst({
		"event"_nm = "wshMetaData",
		"reqId"_nm = reqId,
		"dataJson"_nm = dataJson,
	  }));
}

void RWrapper::wshEventData(int reqId, const std::string& dataJson) {
  acc.push_back(lst({
		"event"_nm = "wshEventData",
		"reqId"_nm = reqId,
		"dataJson"_nm = dataJson,
	  }));
}
#endif


/// Unused
void RWrapper::winError( const std::string& str, int lastError) { }
void RWrapper::connectAck() { }
