
#include "RWrapper.h"
#include "EDecoder.h"
#include "RClient.h"
#include "r2tws.h"
#include "R_ext/Print.h"

#include "cpp11.hpp"
using namespace cpp11::literals;
 
[[cpp11::register]]
cpp11::integers C_max_client_version() {
  return cpp11::integers({MAX_CLIENT_VER});  
} 

[[cpp11::register]]
cpp11::list C_decode_bin(int server_version, cpp11::raws bin) {
  int N = bin.size(), n = 0;
 
  const char* beg = reinterpret_cast<char*>(RAW(bin));
  const char* end = beg + N;


  RWrapper wrapper;
  EDecoder decoder(server_version, &wrapper);

  while (n < N) {
	int parsed = decoder.parseAndProcessMsg(beg, end);
	beg += parsed;
	n += parsed;
	if (n != N) {
	  REprintf("n(%d) != N (%d)\n", n, N);
	}
  }

  cpp11::writable::list out(wrapper.acc);
  out.attr("multi-message") = true;
  out.attr("class") = "strlist";
  return out;
} 

#define BEG											\
  RDummyWrapper wrapper;							\
  RClient client(twsServerVersion, &wrapper);

#define END															\
  cpp11::writable::raws out(client.retval.size());					\
  memcpy(RAW(out), client.retval.c_str(), client.retval.size());	\
  return out;

[[cpp11::register]]
cpp11::raws C_enc_reqMktData(int twsServerVersion,
							 long reqId,
							 cpp11::list contract,
							 std::string genericTicks,
							 bool snapshot,
							 bool regulatorySnaphsot,
							 cpp11::list mktDataOptions) {
  BEG;
  client.reqMktData(reqId,
					twsContract(contract),
					genericTicks,
					snapshot,
					regulatorySnaphsot,
					twsTagValueListSPtr(mktDataOptions));
  END;
} 

[[cpp11::register]]
cpp11::raws C_enc_cancelMktData(int twsServerVersion, long reqId) {
  BEG;
  client.cancelMktData(reqId);
  END;
}

cpp11::raws C_enc_reqMktDepth(int twsServerVersion, long reqId, cpp11::list contract,
							  int numRows, bool isSmartDepth, cpp11::list mktDepthOptions) {
  BEG;
  client.reqMktDepth(reqId, twsContract(contract),
					 numRows, isSmartDepth, twsTagValueListSPtr(mktDepthOptions));
  END;
}

cpp11::raws C_enc_cancelMktDepth(int twsServerVersion, long reqId, bool isSmartDepth) {
  BEG;
  client.cancelMktDepth(reqId, isSmartDepth);
  END;
}

cpp11::raws C_enc_reqHistoricalData(int twsServerVersion,
									cpp11::list contract,
									const std::string& endDateTime,
									const std::string& durationStr,
									const std::string& barSizeSetting,
									const std::string& whatToShow,
									bool useRTH, bool formatDate,
									bool keepUpToDate,
									cpp11::list chartOptions,
									long reqId) {
  BEG;
  client.reqHistoricalData(reqId,
						   twsContract(contract),
						   endDateTime, durationStr,
						   barSizeSetting, whatToShow,
						   useRTH, formatDate, keepUpToDate,
						   twsTagValueListSPtr(chartOptions));
  END;
}

cpp11::raws C_enc_cancelHistoricalData(int twsServerVersion, long reqId) {
  BEG;
  client.cancelHistoricalData(reqId);
  END;
}


cpp11::raws C_enc_reqRealTimeBars(int twsServerVersion, long reqId, cpp11::list contract,
								  int barSize, const std::string& whatToShow, bool useRTH,
								  cpp11::list realTimeBarsOptions) {
  BEG;
  client.reqRealTimeBars(reqId, twsContract(contract),
						 barSize, whatToShow, useRTH,
						 twsTagValueListSPtr(realTimeBarsOptions));
  END;
}

cpp11::raws C_enc_cancelRealTimeBars(int twsServerVersion, long reqId) {
  BEG;
  client.cancelRealTimeBars(reqId);
  END;
}

cpp11::raws C_enc_reqScannerParameters(int twsServerVersion) {
  BEG;
  client.reqScannerParameters();
  END;
}

cpp11::raws C_enc_reqScannerSubscription(int twsServerVersion,
										 int reqId,
										 cpp11::list subscription,
										 cpp11::list scannerSubscriptionOptions,
										 cpp11::list scannerSubscriptionFilterOptions) {
  BEG;
  client.reqScannerSubscription(reqId,
								twsScannerSubscription(subscription),
								twsTagValueListSPtr(scannerSubscriptionOptions),
								twsTagValueListSPtr(scannerSubscriptionFilterOptions));
  END;
}

cpp11::raws C_enc_cancelScannerSubscription(int twsServerVersion, int reqId) {
  BEG;
  client.cancelScannerSubscription(reqId);
  END;
}

cpp11::raws C_enc_reqFundamentalData(int twsServerVersion, long reqId,
									 cpp11::list contract,
									 const std::string& reportType,
									 const TagValueListSPtr& fundamentalDataOptions) {
  BEG;
  client.reqFundamentalData(reqId, twsContract(contract),
							reportType, fundamentalDataOptions);
  END;
}

cpp11::raws C_enc_cancelFundamentalData(int twsServerVersion, long reqId) {
  BEG;
  client.cancelFundamentalData(reqId);
  END;
}

cpp11::raws C_enc_calculateImpliedVolatility(int twsServerVersion, long reqId, cpp11::list contract, double optionPrice,
											 double underPrice, cpp11::list  options) {
  BEG;
  client.calculateImpliedVolatility(reqId, twsContract(contract), optionPrice, underPrice, twsTagValueListSPtr(options));
  END;
}

cpp11::raws C_enc_cancelCalculateImpliedVolatility(int twsServerVersion, long reqId) {
  BEG;
  client.cancelCalculateImpliedVolatility(reqId);
  END;
}

cpp11::raws C_enc_calculateOptionPrice(int twsServerVersion, long reqId, cpp11::list contract, double volatility,
									   double underPrice, cpp11::list options) {
  BEG;
  client.calculateOptionPrice(reqId, twsContract(contract), volatility, underPrice, twsTagValueListSPtr(options));
  END;
}

cpp11::raws C_enc_cancelCalculateOptionPrice(int twsServerVersion, long reqId) {
  BEG;
  client.cancelCalculateOptionPrice(reqId);
  END;
}

cpp11::raws C_enc_reqContractDetails(int twsServerVersion, int reqId, cpp11::list contract) {
  BEG;
  client.reqContractDetails(reqId, twsContract(contract));
  END;
}

cpp11::raws C_enc_reqCurrentTime(int twsServerVersion) {
  BEG;
  client.reqCurrentTime();
  END;
}

cpp11::raws C_enc_placeOrder(int twsServerVersion, OrderId id, cpp11::list contract, cpp11::list order) {
  BEG;
  client.placeOrder(id, twsContract(contract), twsOrder(order));
  END;
}

cpp11::raws C_enc_cancelOrder(int twsServerVersion, OrderId id) {
  BEG;
  client.cancelOrder(id);
  END;
}

cpp11::raws C_enc_reqAccountUpdates(int twsServerVersion, const std::string& accountCode) {
  BEG;
  client.reqAccountUpdates(true, accountCode);
  END;
}

cpp11::raws C_enc_cancelAccountUpdates(int twsServerVersion, const std::string& accountCode) {
  BEG;
  client.reqAccountUpdates(false, accountCode);
  END;
}

cpp11::raws C_enc_reqOpenOrders(int twsServerVersion) {
  BEG;
  client.reqOpenOrders();
  END;
}

cpp11::raws C_enc_reqAutoOpenOrders(int twsServerVersion, bool autoBind) {
  BEG;
  client.reqAutoOpenOrders(autoBind);
  END;
}

cpp11::raws C_enc_reqAllOpenOrders(int twsServerVersion) {
  BEG;
  client.reqAllOpenOrders();
  END;
}

cpp11::raws C_enc_reqExecutions(int twsServerVersion, int reqId, cpp11::list filter) {
  BEG;
  client.reqExecutions(reqId, twsExecutionFilter(filter));
  END;
}

cpp11::raws C_enc_reqIds(int twsServerVersion, int numIds) {
  BEG;
  client.reqIds(numIds);
  END;
}

cpp11::raws C_enc_reqNewsBulletins(int twsServerVersion, bool allMsgs) {
  BEG;
  client.reqNewsBulletins(allMsgs);
  END;
}

cpp11::raws C_enc_cancelNewsBulletins(int twsServerVersion)  {
  BEG;
  client.cancelNewsBulletins();
  END;
}

cpp11::raws C_enc_setServerLogLevel(int twsServerVersion, int logLevel) {
  BEG;
  client.setServerLogLevel(logLevel);
  END;
}

cpp11::raws C_enc_reqManagedAccounts(int twsServerVersion) {
  BEG;
  client.reqManagedAccts();
  END;
}

cpp11::raws C_enc_requestFA(int twsServerVersion, const string& faDataType) {
  BEG;
  client.requestFA(twsFaDataType(faDataType));
  END;
}

cpp11::raws C_enc_replaceFA(int twsServerVersion, int reqId, const string& faDataType,
							const std::string& xml) {
  BEG;
  client.replaceFA(reqId, twsFaDataType(faDataType), xml);
  END;
}

cpp11::raws C_enc_exerciseOptions(int twsServerVersion, long reqId, cpp11::list contract,
								  const std::string& exerciseAction, int exerciseQuantity,
								  const std::string& account, int override) {
  BEG;
  client.exerciseOptions(reqId, twsContract(contract),
						 exerciseAction == "exercise" ? 1 : 2,
						 exerciseQuantity, account, override);
  END;
}

cpp11::raws C_enc_reqGlobalCancel(int twsServerVersion) {
  BEG;
  client.reqGlobalCancel();
  END;
}

cpp11::raws C_enc_reqMktDataType(int twsServerVersion, int marketDataType) {
  BEG;
  client.reqMarketDataType(marketDataType);
  END;
}

cpp11::raws C_enc_reqPositions(int twsServerVersion) {
  BEG;
  client.reqPositions();
  END;
}

cpp11::raws C_enc_cancelPositions(int twsServerVersion) {
  BEG;
  client.cancelPositions();
  END;
}


cpp11::raws C_enc_reqAccountSummary(int twsServerVersion, int reqId, const std::string& groupName, const std::string& tags) {
  BEG;
  client.reqAccountSummary(reqId, groupName, tags);
  END;
}

cpp11::raws C_enc_cancelAccountSummary(int twsServerVersion, int reqId) {
  BEG;
  client.cancelAccountSummary(reqId);
  END;
}

cpp11::raws C_enc_verifyRequest(int twsServerVersion, const std::string& apiName, const std::string& apiVersion) {
  BEG;
  client.verifyRequest(apiName, apiVersion);
  END;
}

cpp11::raws C_enc_verifyMessage(int twsServerVersion, const std::string& apiData) {
  BEG;
  client.verifyMessage(apiData);
  END;
}

cpp11::raws C_enc_verifyAndAuthRequest(int twsServerVersion, const std::string& apiName, const std::string& apiVersion, const std::string& opaqueIsvKey) {
  BEG;
  client.verifyAndAuthRequest(apiName, apiVersion, opaqueIsvKey);
  END;
}

cpp11::raws C_enc_verifyAndAuthMessage(int twsServerVersion, const std::string& apiData, const std::string& xyzResponse) {
  BEG;
  client.verifyAndAuthMessage(apiData, xyzResponse);
  END;
}

cpp11::raws C_enc_queryDisplayGroups(int twsServerVersion, int reqId) {
  BEG;
  client.queryDisplayGroups(reqId);
  END;
}

cpp11::raws C_enc_subscribeToGroupEvents(int twsServerVersion, int reqId, int groupId) {
  BEG;
  client.subscribeToGroupEvents(reqId, groupId);
  END;
}

cpp11::raws C_enc_updateDisplayGroup(int twsServerVersion, int reqId, const std::string& contractInfo) {
  BEG;
  client.updateDisplayGroup(reqId, contractInfo);
  END;
}

cpp11::raws C_enc_startApi(int twsServerVersion) {
  BEG;
  client.startApi();
  END;
}


cpp11::raws C_enc_unsubscribeFromGroupEvents(int twsServerVersion, int reqId) {
  BEG;
  client.unsubscribeFromGroupEvents(reqId);
  END;
}

cpp11::raws C_enc_reqPositionsMulti(int twsServerVersion, int reqId, const std::string& account, const std::string& modelCode) {
  BEG;
  client.reqPositionsMulti(reqId, account, modelCode);
  END;
}

cpp11::raws C_enc_cancelPositionsMulti(int twsServerVersion, int reqId) {
  BEG;
  client.cancelPositionsMulti(reqId);
  END;
}

cpp11::raws C_enc_reqAccountUpdatesMulti(int twsServerVersion, int reqId, const std::string& account,
										 const std::string& modelCode, bool ledgerAndNLV) {
  BEG;
  client.reqAccountUpdatesMulti(reqId, account, modelCode, ledgerAndNLV);
  END;
}

cpp11::raws C_enc_cancelAccountUpdatesMulti(int twsServerVersion, int reqId) {
  BEG;
  client.cancelAccountUpdatesMulti(reqId);
  END;
}

cpp11::raws C_enc_reqSecDefOptParams(int twsServerVersion, int reqId, const std::string& underlyingSymbol,
									 const std::string& futFopExchange, const std::string& underlyingSecType,
									 int underlyingConId) {
  BEG;
  client.reqSecDefOptParams(reqId, underlyingSymbol, futFopExchange, underlyingSecType, underlyingConId);
  END;
}

cpp11::raws C_enc_reqSoftDollarTiers(int twsServerVersion, int reqId) {
  BEG;
  client.reqSoftDollarTiers(reqId);
  END;
}

cpp11::raws C_enc_reqFamilyCodes(int twsServerVersion) {
  BEG;
  client.reqFamilyCodes();
  END;
}

cpp11::raws C_enc_reqMatchingSymbols(int twsServerVersion, int reqId, const std::string& pattern) {
  BEG;
  client.reqMatchingSymbols(reqId, pattern);
  END;
}

cpp11::raws C_enc_reqMktDepthExchanges(int twsServerVersion) {
  BEG;
  client.reqMktDepthExchanges();
  END;
}

cpp11::raws C_enc_reqSmartComponents(int twsServerVersion, int reqId, std::string bboExchange) {
  BEG;
  client.reqSmartComponents(reqId, bboExchange);
  END;
}

cpp11::raws C_enc_reqNewsProviders(int twsServerVersion) {
  BEG;
  client.reqNewsProviders();
  END;
}

cpp11::raws C_enc_reqNewsArticle(int twsServerVersion, int requestId, const std::string& providerCode, const std::string& articleId, cpp11::list newsArticleOptions) {
  BEG;
  client.reqNewsArticle(requestId, providerCode, articleId, twsTagValueListSPtr(newsArticleOptions));
  END;
}

cpp11::raws C_enc_reqHistoricalNews(int twsServerVersion, int requestId, int conId, const std::string& providerCodes,
									const std::string& startDateTime, const std::string& endDateTime,
									int totalResults, cpp11::list historicalNewsOptions) {
  BEG;
  client.reqHistoricalNews(requestId, conId, providerCodes, startDateTime, endDateTime,
						   totalResults, twsTagValueListSPtr(historicalNewsOptions));
  END;
}

cpp11::raws C_enc_reqHeadTimestamp(int twsServerVersion, int reqId, cpp11::list contract, const std::string& whatToShow, int useRTH, int formatDate) {
  BEG;
  client.reqHeadTimestamp(reqId, twsContract(contract), whatToShow, useRTH, formatDate);
  END;
}

cpp11::raws C_enc_cancelHeadTimestamp(int twsServerVersion, int reqId) {
	BEG;
	client.cancelHeadTimestamp(reqId);
	END;
}

cpp11::raws C_enc_reqHistogramData(int twsServerVersion, int reqId, cpp11::list contract, bool useRTH, const std::string& timePeriod) {
  BEG;
  client.reqHistogramData(reqId, twsContract(contract), useRTH, timePeriod);
  END;
}

cpp11::raws C_enc_cancelHistogramData(int twsServerVersion, int reqId) {
  BEG;
  client.cancelHistogramData(reqId);
  END;
}

cpp11::raws C_enc_reqMarketRule(int twsServerVersion, int marketRuleId) {
  BEG;
  client.reqMarketRule(marketRuleId);
  END;
}

cpp11::raws C_enc_reqPnL(int twsServerVersion, int reqId, const std::string& account, const std::string& modelCode) {
  BEG;
  client.reqPnL(reqId, account, modelCode);
  END;
}

cpp11::raws C_enc_cancelPnL(int twsServerVersion, int reqId) {
  BEG;
  client.cancelPnL(reqId);
  END;
}

cpp11::raws C_enc_reqPnLSingle(int twsServerVersion, int reqId, const std::string& account, const std::string& modelCode, int conId) {
  BEG;
  client.reqPnLSingle(reqId, account, modelCode, conId);
  END;
}

cpp11::raws C_enc_cancelPnLSingle(int twsServerVersion, int reqId) {
  BEG;
  client.cancelPnLSingle(reqId);
  END;
}

cpp11::raws C_enc_reqHistoricalTicks(int twsServerVersion, int reqId, cpp11::list contract, const std::string& startDateTime,
									 const std::string& endDateTime, int numberOfTicks, const std::string& whatToShow,
									 int useRth, bool ignoreSize, cpp11::list options) {
  BEG;
  client.reqHistoricalTicks(reqId, twsContract(contract), startDateTime, endDateTime, numberOfTicks, whatToShow,
							useRth, ignoreSize, twsTagValueListSPtr(options));
  END;
}

cpp11::raws C_enc_reqTickByTickData(int twsServerVersion, int reqId, cpp11::list contract,
									const std::string& tickType, int numberOfTicks, bool ignoreSize) {
  BEG;
  client.reqTickByTickData(reqId, twsContract(contract), tickType, numberOfTicks, ignoreSize);
  END;
}

cpp11::raws C_enc_cancelTickByTickData(int twsServerVersion, int reqId) {
  BEG;
  client.cancelTickByTickData(reqId);
  END;
}

cpp11::raws C_enc_reqCompletedOrders(int twsServerVersion, bool apiOnly) {
  BEG;
  client.reqCompletedOrders(apiOnly);
  END;
}

cpp11::raws C_enc_reqWshMetaData(int twsServerVersion, int reqId) {
  BEG;
  client.reqWshMetaData(reqId);
  END;
}

cpp11::raws C_enc_reqWshEventData(int twsServerVersion, int reqId, int conId) {
  BEG;
  client.reqWshEventData(reqId, conId);
  END;
}

cpp11::raws C_enc_cancelWshMetaData(int twsServerVersion, int reqId) {
  BEG;
  client.cancelWshMetaData(reqId);
  END;
}

cpp11::raws C_enc_cancelWshEventData(int twsServerVersion, int reqId) {
  BEG;
  client.cancelWshEventData(reqId);
  END;
}

#undef BEG
#undef END
