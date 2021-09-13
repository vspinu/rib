#include "r2tws.h"

#define STREQ(X, Y) !strcmp(X, Y)
#define NMEQ(Y) !strcmp(nm, Y)

#define CONVBEG															\
  SEXP nms = in.names();												\
  if (in.size() > 0 && nms == R_NilValue)								\
	cpp11::stop("List arguments for the TWS encoder must be named");	\
  size_t N = in.size();													\
  for (size_t i = 0; i < N; i++) {										\
  const char* nm = CHAR(STRING_ELT(nms, i));

#define CONVEND									\
  }												\
  return out;

#define CLOSEPAREN }

faDataType twsFaDataType(const string& faDataType) {
  if (faDataType == "groups") return GROUPS;
  if (faDataType == "profiles") return PROFILES;
  if (faDataType == "aliases") return ALIASES;
  cpp11::stop("Invalid faDataType argument");
}

TagValueListSPtr twsTagValueListSPtr(lst in) {
  TagValueListSPtr out;
  CONVBEG;
  TagValueSPtr tv(new TagValue);
  tv->tag = nm;
  setcpp(tv->value, in[i]);
  out->push_back(tv);
  CONVEND;
}

ComboLegSPtr twsComboLegSPtr(lst in) {
  ComboLegSPtr out;
  CONVBEG;
  if (NMEQ("conId")) setcpp(out->conId, in[i]);
  else if (NMEQ("ratio")) setcpp(out->ratio, in[i]);
  else if (NMEQ("action")) setcpp(out->action, in[i]);
  else if (NMEQ("exchange")) setcpp(out->exchange, in[i]);
  else if (NMEQ("openClose")) setcpp(out->openClose, in[i]);
  else if (NMEQ("shortSaleSlot")) setcpp(out->shortSaleSlot, in[i]);
  else if (NMEQ("designatedLocation")) setcpp(out->designatedLocation, in[i]);
  else if (NMEQ("exemptCode")) setcpp(out->exemptCode, in[i]);
  CONVEND;
}

Contract::ComboLegListSPtr twsComboLegsSPtr(lst in) {
  size_t N = in.size();
  Contract::ComboLegListSPtr cll(new Contract::ComboLegList);
  for (size_t i = 0; i < N; i++) {
	cll->push_back(twsComboLegSPtr(in[i]));
  }
  return cll;
}

SoftDollarTier twsSoftDollarTier(lst in) {
  std::string name, val, displayName;
  CONVBEG;
  if (NMEQ("name")) setcpp(name, in[i]);
  else if (NMEQ("val")) setcpp(val, in[i]);
  else if (NMEQ("displayName")) setcpp(displayName, in[i]);
  else cpp11::stop("Invalid 'twsSoftDollarTier' field '%s'", nm);
  CLOSEPAREN;
  return (SoftDollarTier(name, val, displayName));
}

ExecutionFilter twsExecutionFilter(lst in) {
  ExecutionFilter out;
  CONVBEG;
  if (NMEQ("clientId")) setcpp(out.m_clientId, in[i]);
  else if (NMEQ("acctCode")) setcpp(out.m_acctCode, in[i]);
  else if (NMEQ("time")) setcpp(out.m_time, in[i]);
  else if (NMEQ("symbol")) setcpp(out.m_symbol, in[i]);
  else if (NMEQ("secType")) setcpp(out.m_secType, in[i]);
  else if (NMEQ("exchange")) setcpp(out.m_exchange, in[i]);
  else if (NMEQ("side")) setcpp(out.m_side, in[i]);
  else cpp11::stop("Invalid 'twsExecutionFilter' field '%s'", nm);
  CONVEND;
}

Contract twsContract(lst in) {
  Contract out;
  CONVBEG;
  if (NMEQ("conId")) setcpp(out.conId, in[i]);
  else if (NMEQ("symbol")) setcpp(out.symbol, in[i]);
  else if (NMEQ("secType")) setcpp(out.secType, in[i]);
  else if (NMEQ("lastTradeDateOrContractMonth")) setcpp(out.lastTradeDateOrContractMonth, in[i]);
  else if (NMEQ("strike")) setcpp(out.strike, in[i]);
  else if (NMEQ("right")) setcpp(out.right, in[i]);
  else if (NMEQ("multiplier")) setcpp(out.multiplier, in[i]);
  else if (NMEQ("exchange")) setcpp(out.exchange, in[i]);
  else if (NMEQ("primaryExchange")) setcpp(out.primaryExchange, in[i]);
  else if (NMEQ("currency")) setcpp(out.currency, in[i]);
  else if (NMEQ("localSymbol")) setcpp(out.localSymbol, in[i]);
  else if (NMEQ("tradingClass")) setcpp(out.tradingClass, in[i]);
  else if (NMEQ("includeExpired")) setcpp(out.includeExpired, in[i]);
  else if (NMEQ("secIdType")) setcpp(out.secIdType, in[i]);
  else if (NMEQ("secId")) setcpp(out.secId, in[i]);
  else if (NMEQ("comboLegsDescrip")) setcpp(out.comboLegsDescrip, in[i]);
  else if (NMEQ("comboLegs")) out.comboLegs = twsComboLegsSPtr(in[i]);
  else cpp11::stop("Invalid 'twsContract' field '%s'", nm);
  CONVEND;
}

Order twsOrder(lst in) {
  Order out;
  CONVBEG;
  if (NMEQ("orderId")) setcpp(out.orderId, in[i]);
  else if (NMEQ("id")) setcpp(out.orderId, in[i]);
  else if (NMEQ("clientId")) setcpp(out.clientId, in[i]);
  else if (NMEQ("permId")) setcpp(out.permId, in[i]);
  else if (NMEQ("action")) setcpp(out.action, in[i]);
  else if (NMEQ("totalQuantity")) setcpp(out.totalQuantity, in[i]);
  else if (NMEQ("orderType")) setcpp(out.orderType, in[i]);
  else if (NMEQ("lmtPrice")) setcpp(out.lmtPrice, in[i]);
  else if (NMEQ("auxPrice")) setcpp(out.auxPrice, in[i]);
  else if (NMEQ("tif")) setcpp(out.tif, in[i]);
  else if (NMEQ("activeStartTime")) setcpp(out.activeStartTime, in[i]);
  else if (NMEQ("activeStopTime")) setcpp(out.activeStopTime, in[i]);
  else if (NMEQ("ocaGroup")) setcpp(out.ocaGroup, in[i]);
  else if (NMEQ("ocaType")) setcpp(out.ocaType, in[i]);
  else if (NMEQ("orderRef")) setcpp(out.orderRef, in[i]);
  else if (NMEQ("transmit")) setcpp(out.transmit, in[i]);
  else if (NMEQ("parentId")) setcpp(out.parentId, in[i]);
  else if (NMEQ("blockOrder")) setcpp(out.blockOrder, in[i]);
  else if (NMEQ("sweepToFill")) setcpp(out.sweepToFill, in[i]);
  else if (NMEQ("displaySize")) setcpp(out.displaySize, in[i]);
  else if (NMEQ("triggerMethod")) setcpp(out.triggerMethod, in[i]);
  else if (NMEQ("outsideRth")) setcpp(out.outsideRth, in[i]);
  else if (NMEQ("hidden")) setcpp(out.hidden, in[i]);
  else if (NMEQ("goodAfterTime")) setcpp(out.goodAfterTime, in[i]);
  else if (NMEQ("goodTillDate")) setcpp(out.goodTillDate, in[i]);
  else if (NMEQ("rule80A")) setcpp(out.rule80A, in[i]);
  else if (NMEQ("allOrNone")) setcpp(out.allOrNone, in[i]);
  else if (NMEQ("minQty")) setcpp(out.minQty, in[i]);
  else if (NMEQ("percentOffset")) setcpp(out.percentOffset, in[i]);
  else if (NMEQ("overridePercentageConstraints")) setcpp(out.overridePercentageConstraints, in[i]);
  else if (NMEQ("trailStopPrice")) setcpp(out.trailStopPrice, in[i]);
  else if (NMEQ("trailingPercent")) setcpp(out.trailingPercent, in[i]);
  else if (NMEQ("faGroup")) setcpp(out.faGroup, in[i]);
  else if (NMEQ("faProfile")) setcpp(out.faProfile, in[i]);
  else if (NMEQ("faMethod")) setcpp(out.faMethod, in[i]);
  else if (NMEQ("faPercentage")) setcpp(out.faPercentage, in[i]);
  else if (NMEQ("openClose")) setcpp(out.openClose, in[i]);
  else if (NMEQ("origin"))
	out.origin = sexp2twsType(in[i], "origin",
							  std::vector<Origin>{CUSTOMER, FIRM, UNKNOWN},
							  std::vector<std::string>{"customer", "firm", "unknown"});
  else if (NMEQ("shortSaleSlot")) setcpp(out.shortSaleSlot, in[i]);
  else if (NMEQ("designatedLocation")) setcpp(out.designatedLocation, in[i]);
  else if (NMEQ("exemptCode")) setcpp(out.exemptCode, in[i]);
  else if (NMEQ("discretionaryAmt")) setcpp(out.discretionaryAmt, in[i]);
  else if (NMEQ("optOutSmartRouting")) setcpp(out.optOutSmartRouting, in[i]);
  else if (NMEQ("auctionStrategy"))
	out.auctionStrategy = sexp2twsType(in[i], "auctionStrategy",
									   std::vector<AuctionStrategy>{AUCTION_UNSET, AUCTION_MATCH, AUCTION_IMPROVEMENT, AUCTION_TRANSPARENT},
									   std::vector<std::string>{"unset", "match", "improvement", "transparent"});
  else if (NMEQ("usePriceMgmtAlgo"))
	out.usePriceMgmtAlgo = sexp2twsType(in[i], "usePriceMgmtAlgo",
										std::vector<UsePriceMmgtAlgo>{DONT_USE, USE, DEFAULT},
										std::vector<std::string>{"dont_use", "use", "default"});
  else if (NMEQ("startingPrice")) setcpp(out.startingPrice, in[i]);
  else if (NMEQ("stockRefPrice")) setcpp(out.stockRefPrice, in[i]);
  else if (NMEQ("delta")) setcpp(out.delta, in[i]);
  else if (NMEQ("stockRangeLower")) setcpp(out.stockRangeLower, in[i]);
  else if (NMEQ("stockRangeUpper")) setcpp(out.stockRangeUpper, in[i]);
  else if (NMEQ("randomizeSize")) setcpp(out.randomizeSize, in[i]);
  else if (NMEQ("randomizePrice")) setcpp(out.randomizePrice, in[i]);
  else if (NMEQ("volatility")) setcpp(out.volatility, in[i]);
  else if (NMEQ("volatilityType")) setcpp(out.volatilityType, in[i]);
  else if (NMEQ("deltaNeutralOrderType")) setcpp(out.deltaNeutralOrderType, in[i]);
  else if (NMEQ("deltaNeutralAuxPrice")) setcpp(out.deltaNeutralAuxPrice, in[i]);
  else if (NMEQ("deltaNeutralConId")) setcpp(out.deltaNeutralConId, in[i]);
  else if (NMEQ("deltaNeutralSettlingFirm")) setcpp(out.deltaNeutralSettlingFirm, in[i]);
  else if (NMEQ("deltaNeutralClearingAccount")) setcpp(out.deltaNeutralClearingAccount, in[i]);
  else if (NMEQ("deltaNeutralClearingIntent")) setcpp(out.deltaNeutralClearingIntent, in[i]);
  else if (NMEQ("deltaNeutralOpenClose")) setcpp(out.deltaNeutralOpenClose, in[i]);
  else if (NMEQ("deltaNeutralShortSale")) setcpp(out.deltaNeutralShortSale, in[i]);
  else if (NMEQ("deltaNeutralShortSaleSlot")) setcpp(out.deltaNeutralShortSaleSlot, in[i]);
  else if (NMEQ("deltaNeutralDesignatedLocation")) setcpp(out.deltaNeutralDesignatedLocation, in[i]);
  else if (NMEQ("continuousUpdate")) setcpp(out.continuousUpdate, in[i]);
  else if (NMEQ("referencePriceType")) setcpp(out.referencePriceType, in[i]);
  else if (NMEQ("basisPoints")) setcpp(out.basisPoints, in[i]);
  else if (NMEQ("basisPointsType")) setcpp(out.basisPointsType, in[i]);
  else if (NMEQ("scaleInitLevelSize")) setcpp(out.scaleInitLevelSize, in[i]);
  else if (NMEQ("scaleSubsLevelSize")) setcpp(out.scaleSubsLevelSize, in[i]);
  else if (NMEQ("scalePriceIncrement")) setcpp(out.scalePriceIncrement, in[i]);
  else if (NMEQ("scalePriceAdjustValue")) setcpp(out.scalePriceAdjustValue, in[i]);
  else if (NMEQ("scalePriceAdjustInterval")) setcpp(out.scalePriceAdjustInterval, in[i]);
  else if (NMEQ("scaleProfitOffset")) setcpp(out.scaleProfitOffset, in[i]);
  else if (NMEQ("scaleAutoReset")) setcpp(out.scaleAutoReset, in[i]);
  else if (NMEQ("scaleInitPosition")) setcpp(out.scaleInitPosition, in[i]);
  else if (NMEQ("scaleInitFillQty")) setcpp(out.scaleInitFillQty, in[i]);
  else if (NMEQ("scaleRandomPercent")) setcpp(out.scaleRandomPercent, in[i]);
  else if (NMEQ("scaleTable")) setcpp(out.scaleTable, in[i]);
  else if (NMEQ("hedgeType")) setcpp(out.hedgeType, in[i]);
  else if (NMEQ("hedgeParam")) setcpp(out.hedgeParam, in[i]);
  else if (NMEQ("account")) setcpp(out.account, in[i]);
  else if (NMEQ("settlingFirm")) setcpp(out.settlingFirm, in[i]);
  else if (NMEQ("clearingAccount")) setcpp(out.clearingAccount, in[i]);
  else if (NMEQ("clearingIntent")) setcpp(out.clearingIntent, in[i]);
  else if (NMEQ("algoStrategy")) setcpp(out.algoStrategy, in[i]);
  else if (NMEQ("algoId")) setcpp(out.algoId, in[i]);
  else if (NMEQ("whatIf")) setcpp(out.whatIf, in[i]);
  else if (NMEQ("notHeld")) setcpp(out.notHeld, in[i]);
  else if (NMEQ("solicited")) setcpp(out.solicited, in[i]);
  else if (NMEQ("modelCode")) setcpp(out.modelCode, in[i]);
  else if (NMEQ("referenceContractId")) setcpp(out.referenceContractId, in[i]);
  else if (NMEQ("peggedChangeAmount")) setcpp(out.peggedChangeAmount, in[i]);
  else if (NMEQ("isPeggedChangeAmountDecrease")) setcpp(out.isPeggedChangeAmountDecrease, in[i]);
  else if (NMEQ("referenceChangeAmount")) setcpp(out.referenceChangeAmount, in[i]);
  else if (NMEQ("referenceExchangeId")) setcpp(out.referenceExchangeId, in[i]);
  else if (NMEQ("adjustedOrderType")) setcpp(out.adjustedOrderType, in[i]);
  else if (NMEQ("triggerPrice")) setcpp(out.triggerPrice, in[i]);
  else if (NMEQ("adjustedStopPrice")) setcpp(out.adjustedStopPrice, in[i]);
  else if (NMEQ("adjustedStopLimitPrice")) setcpp(out.adjustedStopLimitPrice, in[i]);
  else if (NMEQ("adjustedTrailingAmount")) setcpp(out.adjustedTrailingAmount, in[i]);
  else if (NMEQ("adjustableTrailingUnit")) setcpp(out.adjustableTrailingUnit, in[i]);
  else if (NMEQ("lmtPriceOffset")) setcpp(out.lmtPriceOffset, in[i]);
  else if (NMEQ("conditionsCancelOrder")) setcpp(out.conditionsCancelOrder, in[i]);
  else if (NMEQ("conditionsIgnoreRth")) setcpp(out.conditionsIgnoreRth, in[i]);
  else if (NMEQ("extOperator")) setcpp(out.extOperator, in[i]);
  else if (NMEQ("cashQty")) setcpp(out.cashQty, in[i]);
  else if (NMEQ("mifid2DecisionMaker")) setcpp(out.mifid2DecisionMaker, in[i]);
  else if (NMEQ("mifid2DecisionAlgo")) setcpp(out.mifid2DecisionAlgo, in[i]);
  else if (NMEQ("mifid2ExecutionTrader")) setcpp(out.mifid2ExecutionTrader, in[i]);
  else if (NMEQ("mifid2ExecutionAlgo")) setcpp(out.mifid2ExecutionAlgo, in[i]);
  else if (NMEQ("dontUseAutoPriceForHedge")) setcpp(out.dontUseAutoPriceForHedge, in[i]);
  else if (NMEQ("isOmsContainer")) setcpp(out.isOmsContainer, in[i]);
  else if (NMEQ("discretionaryUpToLimitPrice")) setcpp(out.discretionaryUpToLimitPrice, in[i]);
  else if (NMEQ("autoCancelDate")) setcpp(out.autoCancelDate, in[i]);
  else if (NMEQ("filledQuantity")) setcpp(out.filledQuantity, in[i]);
  else if (NMEQ("refFuturesConId")) setcpp(out.refFuturesConId, in[i]);
  else if (NMEQ("autoCancelParent")) setcpp(out.autoCancelParent, in[i]);
  else if (NMEQ("shareholder")) setcpp(out.shareholder, in[i]);
  else if (NMEQ("imbalanceOnly")) setcpp(out.imbalanceOnly, in[i]);
  else if (NMEQ("routeMarketableToBbo")) setcpp(out.routeMarketableToBbo, in[i]);
  else if (NMEQ("parentPermId")) setcpp(out.parentPermId, in[i]);
#if MAX_SERVER_VERSION >= 157
  else if (NMEQ("duration")) setcpp(out.duration, in[i]);
#endif
#if MAX_SERVER_VERSION >= 160
  else if (NMEQ("postToAts")) setcpp(out.postToAts, in[i]);
#endif
  else if (NMEQ("softDollarTier")) out.softDollarTier = twsSoftDollarTier(in[i]);
  else if (NMEQ("algoParams")) out.algoParams = twsTagValueListSPtr(in[i]);
  else if (NMEQ("smartComboRoutingParams")) out.smartComboRoutingParams = twsTagValueListSPtr(in[i]);
  else if (NMEQ("orderMiscOptions")) out.orderMiscOptions = twsTagValueListSPtr(in[i]);
  // TODO:
  else if (NMEQ("conditions")) cpp11::stop("'conditions' not implemented yet");
  /* vector<shared_ptr<OrderCondition>> conditions; */
  else if (NMEQ("orderComboLegs")) cpp11::stop("'orderComboLegs' not implemented yet");
  /* OrderComboLegListSPtr orderComboLegs; */
  else cpp11::stop("Invalid 'twsOrder' field '%s'", nm);
  CONVEND;
}

ScannerSubscription twsScannerSubscription(lst in) {
  ScannerSubscription out;
  CONVBEG;
  if (NMEQ("numberOfRows")) setcpp(out.numberOfRows, in[i]);
  else if (NMEQ("instrument")) setcpp(out.instrument, in[i]);
  else if (NMEQ("locationCode")) setcpp(out.locationCode, in[i]);
  else if (NMEQ("scanCode")) setcpp(out.scanCode, in[i]);
  else if (NMEQ("abovePrice")) setcpp(out.abovePrice, in[i]);
  else if (NMEQ("belowPrice")) setcpp(out.belowPrice, in[i]);
  else if (NMEQ("aboveVolume")) setcpp(out.aboveVolume, in[i]);
  else if (NMEQ("marketCapAbove")) setcpp(out.marketCapAbove, in[i]);
  else if (NMEQ("marketCapBelow")) setcpp(out.marketCapBelow, in[i]);
  else if (NMEQ("moodyRatingAbove")) setcpp(out.moodyRatingAbove, in[i]);
  else if (NMEQ("moodyRatingBelow")) setcpp(out.moodyRatingBelow, in[i]);
  else if (NMEQ("spRatingAbove")) setcpp(out.spRatingAbove, in[i]);
  else if (NMEQ("spRatingBelow")) setcpp(out.spRatingBelow, in[i]);
  else if (NMEQ("maturityDateAbove")) setcpp(out.maturityDateAbove, in[i]);
  else if (NMEQ("maturityDateBelow")) setcpp(out.maturityDateBelow, in[i]);
  else if (NMEQ("couponRateAbove")) setcpp(out.couponRateAbove, in[i]);
  else if (NMEQ("couponRateBelow")) setcpp(out.couponRateBelow, in[i]);
  else if (NMEQ("excludeConvertible")) setcpp(out.excludeConvertible, in[i]);
  else if (NMEQ("averageOptionVolumeAbove")) setcpp(out.averageOptionVolumeAbove, in[i]);
  else if (NMEQ("scannerSettingPairs")) setcpp(out.scannerSettingPairs, in[i]);
  else if (NMEQ("stockTypeFilter")) setcpp(out.stockTypeFilter, in[i]);
  else cpp11::stop("Invalid 'twsScannerSubscription' field '%s'", nm);
  CONVEND;
}
