
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


/// DECODER

[[cpp11::register]]
cpp11::list C_decode_bin(int serverVersion, cpp11::raws bin) {
  int N = bin.size(), n = 0;
 
  const char* beg = reinterpret_cast<char*>(RAW(bin));
  const char* end = beg + N;

  RWrapper wrapper;
  EDecoder decoder(serverVersion, &wrapper);

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


/// ENCODER
 
[[cpp11::register]]
PREncoder C_encoder(int serverVersion = 0) {
  PREncoder encoder = new REncoder;
  encoder->client.connectionRequest(); // set m_connState so that isConnected() is true
  encoder->client.setServerVersion(serverVersion);
  return encoder;
}

#define BEG										\
  encoder->init();								\
  RClient& client = encoder->client;

#define END												\
  const std::string& retval = encoder->client.retval;	\
  cpp11::writable::raws out(retval.size());				\
  memcpy(RAW(out), retval.c_str(), retval.size());		\
  return out;


[[cpp11::register]]
void C_set_serverVersion(PREncoder encoder, int serverVersion) {
  encoder->client.setServerVersion(serverVersion);
}

[[cpp11::register]]
int C_get_serverVersion(PREncoder encoder) {
  return encoder->client.getServerVersion();
}

[[cpp11::register]]
cpp11::raws C_enc_connectionRequest(PREncoder encoder) {
  // Sets by side effect m_connState = true
  BEG;
  client.connectionRequest();
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_startApi(PREncoder encoder, int clientId, const std::string& optionalCapabilities) {
  BEG;
  client.setClientId(clientId);
  client.setOptionalCapabilities(optionalCapabilities);
  client.startApi();
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqMktData(PREncoder encoder,
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
cpp11::raws C_enc_cancelMktData(PREncoder encoder, long reqId) {
  BEG;
  client.cancelMktData(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqMktDepth(PREncoder encoder, long reqId, cpp11::list contract,
							  int numRows, bool isSmartDepth, cpp11::list mktDepthOptions) {
  BEG;
  client.reqMktDepth(reqId, twsContract(contract),
					 numRows, isSmartDepth, twsTagValueListSPtr(mktDepthOptions));
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelMktDepth(PREncoder encoder, long reqId, bool isSmartDepth) {
  BEG;
  client.cancelMktDepth(reqId, isSmartDepth);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqHistoricalData(PREncoder encoder,
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

[[cpp11::register]]
cpp11::raws C_enc_cancelHistoricalData(PREncoder encoder, long reqId) {
  BEG;
  client.cancelHistoricalData(reqId);
  END;
}


[[cpp11::register]]
cpp11::raws C_enc_reqRealTimeBars(PREncoder encoder, long reqId, cpp11::list contract,
								  int barSize, const std::string& whatToShow, bool useRTH,
								  cpp11::list realTimeBarsOptions) {
  BEG;
  client.reqRealTimeBars(reqId, twsContract(contract),
						 barSize, whatToShow, useRTH,
						 twsTagValueListSPtr(realTimeBarsOptions));
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelRealTimeBars(PREncoder encoder, long reqId) {
  BEG;
  client.cancelRealTimeBars(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqScannerParameters(PREncoder encoder) {
  BEG;
  client.reqScannerParameters();
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqScannerSubscription(PREncoder encoder,
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

[[cpp11::register]]
cpp11::raws C_enc_cancelScannerSubscription(PREncoder encoder, int reqId) {
  BEG;
  client.cancelScannerSubscription(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqFundamentalData(PREncoder encoder, long reqId,
									 cpp11::list contract,
									 const std::string& reportType,
									 cpp11::list fundamentalDataOptions) {
  BEG;
  client.reqFundamentalData(reqId, twsContract(contract), reportType,
							twsTagValueListSPtr(fundamentalDataOptions));
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelFundamentalData(PREncoder encoder, long reqId) {
  BEG;
  client.cancelFundamentalData(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_calculateImpliedVolatility(PREncoder encoder, long reqId, cpp11::list contract, double optionPrice,
											 double underPrice, cpp11::list  options) {
  BEG;
  client.calculateImpliedVolatility(reqId, twsContract(contract), optionPrice, underPrice, twsTagValueListSPtr(options));
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelCalculateImpliedVolatility(PREncoder encoder, long reqId) {
  BEG;
  client.cancelCalculateImpliedVolatility(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_calculateOptionPrice(PREncoder encoder, long reqId, cpp11::list contract, double volatility,
									   double underPrice, cpp11::list options) {
  BEG;
  client.calculateOptionPrice(reqId, twsContract(contract), volatility, underPrice, twsTagValueListSPtr(options));
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelCalculateOptionPrice(PREncoder encoder, long reqId) {
  BEG;
  client.cancelCalculateOptionPrice(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqContractDetails(PREncoder encoder, int reqId, cpp11::list contract) {
  BEG;
  client.reqContractDetails(reqId, twsContract(contract));
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqCurrentTime(PREncoder encoder) {
  BEG;
  client.reqCurrentTime();
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_placeOrder(PREncoder encoder, OrderId id, cpp11::list contract, cpp11::list order) {
  BEG;
  client.placeOrder(id, twsContract(contract), twsOrder(order));
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelOrder(PREncoder encoder, OrderId id) {
  BEG;
  client.cancelOrder(id);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqAccountUpdates(PREncoder encoder, const std::string& accountCode) {
  BEG;
  client.reqAccountUpdates(true, accountCode);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelAccountUpdates(PREncoder encoder, const std::string& accountCode) {
  BEG;
  client.reqAccountUpdates(false, accountCode);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqOpenOrders(PREncoder encoder) {
  BEG;
  client.reqOpenOrders();
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqAutoOpenOrders(PREncoder encoder, bool autoBind) {
  BEG;
  client.reqAutoOpenOrders(autoBind);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqAllOpenOrders(PREncoder encoder) {
  BEG;
  client.reqAllOpenOrders();
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqExecutions(PREncoder encoder, int reqId, cpp11::list filter) {
  BEG;
  client.reqExecutions(reqId, twsExecutionFilter(filter));
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqIds(PREncoder encoder, int numIds) {
  BEG;
  client.reqIds(numIds);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqNewsBulletins(PREncoder encoder, bool allMsgs) {
  BEG;
  client.reqNewsBulletins(allMsgs);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelNewsBulletins(PREncoder encoder)  {
  BEG;
  client.cancelNewsBulletins();
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_setServerLogLevel(PREncoder encoder, int logLevel) {
  BEG;
  client.setServerLogLevel(logLevel);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqManagedAccounts(PREncoder encoder) {
  BEG;
  client.reqManagedAccts();
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_requestFA(PREncoder encoder, const std::string& faDataType) {
  BEG;
  client.requestFA(twsFaDataType(faDataType));
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_replaceFA(PREncoder encoder, int reqId, const std::string& faDataType,
							const std::string& xml) {
  BEG;
  client.replaceFA(reqId, twsFaDataType(faDataType), xml);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_exerciseOptions(PREncoder encoder, long reqId, cpp11::list contract,
								  const std::string& exerciseAction, int exerciseQuantity,
								  const std::string& account, int override) {
  BEG;
  client.exerciseOptions(reqId, twsContract(contract),
						 exerciseAction == "exercise" ? 1 : 2,
						 exerciseQuantity, account, override);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqGlobalCancel(PREncoder encoder) {
  BEG;
  client.reqGlobalCancel();
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqMarketDataType(PREncoder encoder, int marketDataType) {
  BEG;
  client.reqMarketDataType(marketDataType);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqPositions(PREncoder encoder) {
  BEG;
  client.reqPositions();
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelPositions(PREncoder encoder) {
  BEG;
  client.cancelPositions();
  END;
}


[[cpp11::register]]
cpp11::raws C_enc_reqAccountSummary(PREncoder encoder, int reqId, const std::string& groupName, const std::string& tags) {
  BEG;
  client.reqAccountSummary(reqId, groupName, tags);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelAccountSummary(PREncoder encoder, int reqId) {
  BEG;
  client.cancelAccountSummary(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_verifyRequest(PREncoder encoder, const std::string& apiName, const std::string& apiVersion) {
  BEG;
  client.verifyRequest(apiName, apiVersion);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_verifyMessage(PREncoder encoder, const std::string& apiData) {
  BEG;
  client.verifyMessage(apiData);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_verifyAndAuthRequest(PREncoder encoder, const std::string& apiName, const std::string& apiVersion, const std::string& opaqueIsvKey) {
  BEG;
  client.verifyAndAuthRequest(apiName, apiVersion, opaqueIsvKey);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_verifyAndAuthMessage(PREncoder encoder, const std::string& apiData, const std::string& xyzResponse) {
  BEG;
  client.verifyAndAuthMessage(apiData, xyzResponse);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_queryDisplayGroups(PREncoder encoder, int reqId) {
  BEG;
  client.queryDisplayGroups(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_subscribeToGroupEvents(PREncoder encoder, int reqId, int groupId) {
  BEG;
  client.subscribeToGroupEvents(reqId, groupId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_updateDisplayGroup(PREncoder encoder, int reqId, const std::string& contractInfo) {
  BEG;
  client.updateDisplayGroup(reqId, contractInfo);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_unsubscribeFromGroupEvents(PREncoder encoder, int reqId) {
  BEG;
  client.unsubscribeFromGroupEvents(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqPositionsMulti(PREncoder encoder, int reqId, const std::string& account, const std::string& modelCode) {
  BEG;
  client.reqPositionsMulti(reqId, account, modelCode);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelPositionsMulti(PREncoder encoder, int reqId) {
  BEG;
  client.cancelPositionsMulti(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqAccountUpdatesMulti(PREncoder encoder, int reqId, const std::string& account,
										 const std::string& modelCode, bool ledgerAndNLV) {
  BEG;
  client.reqAccountUpdatesMulti(reqId, account, modelCode, ledgerAndNLV);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelAccountUpdatesMulti(PREncoder encoder, int reqId) {
  BEG;
  client.cancelAccountUpdatesMulti(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqSecDefOptParams(PREncoder encoder, int reqId, const std::string& underlyingSymbol,
									 const std::string& futFopExchange, const std::string& underlyingSecType,
									 int underlyingConId) {
  BEG;
  client.reqSecDefOptParams(reqId, underlyingSymbol, futFopExchange, underlyingSecType, underlyingConId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqSoftDollarTiers(PREncoder encoder, int reqId) {
  BEG;
  client.reqSoftDollarTiers(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqFamilyCodes(PREncoder encoder) {
  BEG;
  client.reqFamilyCodes();
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqMatchingSymbols(PREncoder encoder, int reqId, const std::string& pattern) {
  BEG;
  client.reqMatchingSymbols(reqId, pattern);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqMktDepthExchanges(PREncoder encoder) {
  BEG;
  client.reqMktDepthExchanges();
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqSmartComponents(PREncoder encoder, int reqId, std::string bboExchange) {
  BEG;
  client.reqSmartComponents(reqId, bboExchange);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqNewsProviders(PREncoder encoder) {
  BEG;
  client.reqNewsProviders();
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqNewsArticle(PREncoder encoder, int requestId, const std::string& providerCode, const std::string& articleId, cpp11::list newsArticleOptions) {
  BEG;
  client.reqNewsArticle(requestId, providerCode, articleId, twsTagValueListSPtr(newsArticleOptions));
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqHistoricalNews(PREncoder encoder, int requestId, int conId, const std::string& providerCodes,
									const std::string& startDateTime, const std::string& endDateTime,
									int totalResults, cpp11::list historicalNewsOptions) {
  BEG;
  client.reqHistoricalNews(requestId, conId, providerCodes, startDateTime, endDateTime,
						   totalResults, twsTagValueListSPtr(historicalNewsOptions));
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqHeadTimestamp(PREncoder encoder, int reqId, cpp11::list contract, const std::string& whatToShow, int useRTH, int formatDate) {
  BEG;
  client.reqHeadTimestamp(reqId, twsContract(contract), whatToShow, useRTH, formatDate);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelHeadTimestamp(PREncoder encoder, int reqId) {
  BEG;
  client.cancelHeadTimestamp(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqHistogramData(PREncoder encoder, int reqId, cpp11::list contract, bool useRTH, const std::string& timePeriod) {
  BEG;
  client.reqHistogramData(reqId, twsContract(contract), useRTH, timePeriod);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelHistogramData(PREncoder encoder, int reqId) {
  BEG;
  client.cancelHistogramData(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqMarketRule(PREncoder encoder, int marketRuleId) {
  BEG;
  client.reqMarketRule(marketRuleId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqPnL(PREncoder encoder, int reqId, const std::string& account, const std::string& modelCode) {
  BEG;
  client.reqPnL(reqId, account, modelCode);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelPnL(PREncoder encoder, int reqId) {
  BEG;
  client.cancelPnL(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqPnLSingle(PREncoder encoder, int reqId, const std::string& account, const std::string& modelCode, int conId) {
  BEG;
  client.reqPnLSingle(reqId, account, modelCode, conId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelPnLSingle(PREncoder encoder, int reqId) {
  BEG;
  client.cancelPnLSingle(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqHistoricalTicks(PREncoder encoder, int reqId, cpp11::list contract, const std::string& startDateTime,
									 const std::string& endDateTime, int numberOfTicks, const std::string& whatToShow,
									 int useRth, bool ignoreSize, cpp11::list options) {
  BEG;
  client.reqHistoricalTicks(reqId, twsContract(contract), startDateTime, endDateTime, numberOfTicks, whatToShow,
							useRth, ignoreSize, twsTagValueListSPtr(options));
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqTickByTickData(PREncoder encoder, int reqId, cpp11::list contract,
									const std::string& tickType, int numberOfTicks, bool ignoreSize) {
  BEG;
  client.reqTickByTickData(reqId, twsContract(contract), tickType, numberOfTicks, ignoreSize);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelTickByTickData(PREncoder encoder, int reqId) {
  BEG;
  client.cancelTickByTickData(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqCompletedOrders(PREncoder encoder, bool apiOnly) {
  BEG;
  client.reqCompletedOrders(apiOnly);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqWshMetaData(PREncoder encoder, int reqId) {
  BEG;
  client.reqWshMetaData(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_reqWshEventData(PREncoder encoder, int reqId, int conId) {
  BEG;
  client.reqWshEventData(reqId, conId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelWshMetaData(PREncoder encoder, int reqId) {
  BEG;
  client.cancelWshMetaData(reqId);
  END;
}

[[cpp11::register]]
cpp11::raws C_enc_cancelWshEventData(PREncoder encoder, int reqId) {
  BEG;
  client.cancelWshEventData(reqId);
  END;
}

#undef BEG
#undef END
