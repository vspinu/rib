
#include "RWrapper.h"


inline double unset2na(const double x) {
  return (x == UNSET_DOUBLE) ? NA_REAL : x;
}

lst RSoftDollarTier(const SoftDollarTier& sdt) {
  return lst({
	  "name"_nm = sdt.name(),
	  "val"_nm = sdt.val(),
	  "displayName"_nm = sdt.displayName()
	});
};

std::string RUsePriceMmgtAlgo(const UsePriceMmgtAlgo upma) {
  switch(upma) {
   case UsePriceMmgtAlgo::DONT_USE: return "DONT_USE";
   case UsePriceMmgtAlgo::USE: return "USE";
   case UsePriceMmgtAlgo::DEFAULT: return "DEFAULT";
  }
};
 
std::string ROrigin(const Origin& origin) {
  switch(origin) {
   case Origin::CUSTOMER: return "CUSTOMER";
   case Origin::FIRM: return "FIRM";
   case Origin::UNKNOWN: return "UNKNON";
  }
};

std::string RAuctionStrategy (int as){
  switch(as) {
   case 1: return "MATCH";
   case 2: return "IMPROVEMENT";
   case 3: return "TRANSPARENT";
   default: return "UNSET";
  }
};


lst RWrapper::RContract(const Contract& contract) {
  return lst({
	  "conId"_nm = contract.conId,
	  "symbol"_nm = contract.symbol,
	  "secType"_nm = contract.secType,
	  "lastTradeDateOrContractMonth"_nm = contract.lastTradeDateOrContractMonth,
	  "strike"_nm = contract.strike,
	  "right"_nm = contract.right,
	  "multiplier"_nm = contract.multiplier,
	  "exchange"_nm = contract.exchange,
	  "primaryExchange"_nm = contract.primaryExchange,
	  "currency"_nm = contract.currency,
	  "localSymbol"_nm = contract.localSymbol,
	  "tradingClass"_nm = contract.tradingClass,
	  "includeExpired"_nm = contract.includeExpired,
	  "secIdType"_nm = contract.secIdType,
	  "secId"_nm = contract.secId,
	  "comboLegsDescrip"_nm = contract.comboLegsDescrip

	  // TODO
	  /* typedef std::shared_ptr<ComboLegList> ComboLegListSPtr comboLegs; */

	  // This one is a pointer which seems to be GC collected before it's even available:
	  // https://github.com/InteractiveBrokers/tws-api/blob/63403247a1c710fb41891581a60574ed623a17e6/source/cppclient/client/EOrderDecoder.cpp#L499
	  /* "deltaNeutralContract"_nm = contrac.deltaNeutralContract */ 
	});
};

lst RWrapper::RContractDetails(const ContractDetails& cd) {
  return lst({

	  "contract"_nm = RContract(cd.contract),

	  "marketName"_nm = cd.marketName,
	  "minTick"_nm = cd.minTick,
	  "orderTypes"_nm = cd.orderTypes,
	  "validExchanges"_nm = cd.validExchanges,
	  "priceMagnifier"_nm = cd.priceMagnifier,
	  "underConId"_nm = cd.underConId,
	  "longName"_nm = cd.longName,
	  "contractMonth"_nm = cd.contractMonth,
	  "industry"_nm = cd.industry,
	  "category"_nm = cd.category,
	  "subcategory"_nm = cd.subcategory,
	  "timeZoneId"_nm = cd.timeZoneId,
	  "tradingHours"_nm = cd.tradingHours,
	  "liquidHours"_nm = cd.liquidHours,
	  "evRule"_nm = cd.evRule,
	  "evMultiplier"_nm = cd.evMultiplier,
	  "mdSizeMultiplier"_nm = cd.mdSizeMultiplier,
	  "aggGroup"_nm = cd.aggGroup,
	  "underSymbol"_nm = cd.underSymbol,
	  "underSecType"_nm = cd.underSecType,
	  "marketRuleIds"_nm = cd.marketRuleIds,
	  "realExpirationDate"_nm = cd.realExpirationDate,
	  "lastTradeTime"_nm = cd.lastTradeTime,
	  "stockType"_nm = cd.stockType,

	  //Todo
	  /* TagValueListSPtr secIdList; */

	  // BOND values
	  "cusip"_nm = cd.cusip,
	  "ratings"_nm = cd.ratings,
	  "descAppend"_nm = cd.descAppend,
	  "bondType"_nm = cd.bondType,
	  "couponType"_nm = cd.couponType,
	  "callable"_nm = cd.callable,
	  "putable"_nm = cd.putable,
	  "coupon"_nm = cd.coupon,
	  "convertible"_nm = cd.convertible,
	  "maturity"_nm = cd.maturity,
	  "issueDate"_nm = cd.issueDate,
	  "nextOptionDate"_nm = cd.nextOptionDate,
	  "nextOptionType"_nm = cd.nextOptionType,
	  "nextOptionPartial"_nm = cd.nextOptionPartial,
	  "notes"_nm = cd.notes
	});
}

lst RWrapper::ROrderState(const OrderState& os) {
  return lst({
	  "status"_nm = os.status,
	  "initMarginBefore"_nm = os.initMarginBefore,
	  "maintMarginBefore"_nm = os.maintMarginBefore,
	  "equityWithLoanBefore"_nm = os.equityWithLoanBefore,
	  "initMarginChange"_nm = os.initMarginChange,
	  "maintMarginChange"_nm = os.maintMarginChange,
	  "equityWithLoanChange"_nm = os.equityWithLoanChange,
	  "initMarginAfter"_nm = os.initMarginAfter,
	  "maintMarginAfter"_nm = os.maintMarginAfter,
	  "equityWithLoanAfter"_nm = os.equityWithLoanAfter,
	  "commission"_nm = os.commission,
	  "minCommission"_nm = os.minCommission,
	  "maxCommission"_nm = os.maxCommission,
	  "commissionCurrency"_nm = os.commissionCurrency,
	  "warningText"_nm = os.warningText,
	  "completedTime"_nm = os.completedTime,
	  "completedStatus"_nm = os.completedStatus
	});
}

lst RWrapper::ROrder(const Order& order) {
  return lst({
	  // order identifier
	  "orderId"_nm = order.orderId,
	  "clientId"_nm = order.clientId,
	  "permId"_nm = order.permId,

	  // main order fields
	  "action"_nm = order.action,
	  "totalQuantity"_nm = order.totalQuantity,
	  "orderType"_nm = order.orderType,
	  "lmtPrice"_nm = unset2na(order.lmtPrice),
	  "auxPrice"_nm = unset2na(order.auxPrice),

	  // extended order fields
	  "tif"_nm = order.tif,
	  "activeStartTime"_nm = order.activeStartTime,
	  "activeStopTime"_nm = order.activeStopTime,
	  "ocaGroup"_nm = order.ocaGroup,
	  "ocaType"_nm = order.ocaType,
	  "orderRef"_nm = order.orderRef,
	  "transmit"_nm = order.transmit,
	  "parentId"_nm = order.parentId,
	  "blockOrder"_nm = order.blockOrder,
	  "sweepToFill"_nm = order.sweepToFill,
	  "displaySize"_nm = order.displaySize,
	  "triggerMethod"_nm = order.triggerMethod,
	  "outsideRth"_nm = order.outsideRth,
	  "hidden"_nm = order.hidden,
	  "goodAfterTime"_nm = order.goodAfterTime,
	  "goodTillDate"_nm = order.goodTillDate,
	  "rule80A"_nm = order.rule80A,
	  "allOrNone"_nm = order.allOrNone,
	  "minQty"_nm = unset2na(order.minQty),
	  "percentOffset"_nm = unset2na(order.percentOffset),
	  "overridePercentageConstraints"_nm = order.overridePercentageConstraints,
	  "trailStopPrice"_nm = unset2na(order.trailStopPrice),
	  "trailingPercent"_nm = unset2na(order.trailingPercent),

	  // financial advisors only
	  "faGroup"_nm = order.faGroup,
	  "faProfile"_nm = order.faProfile,
	  "faMethod"_nm = order.faMethod,
	  "faPercentage"_nm = order.faPercentage,

	  // institutional (ie non-cleared) only
	  "openClose"_nm = order.openClose,
	  "origin"_nm = ROrigin(order.origin),
	  "shortSaleSlot"_nm = order.shortSaleSlot,
	  "designatedLocation"_nm = order.designatedLocation,
	  "exemptCode"_nm = order.exemptCode,

	  // SMART routing only
	  "discretionaryAmt"_nm = order.discretionaryAmt,
	  "optOutSmartRouting"_nm = order.optOutSmartRouting,

	  // BOX exchange orders only
	  "auctionStrategy"_nm = RAuctionStrategy(order.auctionStrategy),
	  "startingPrice"_nm = unset2na(order.startingPrice),
	  "stockRefPrice"_nm = unset2na(order.stockRefPrice),
	  "delta"_nm = unset2na(order.delta),

	  // pegged to stock and VOL orders only
	  "stockRangeLower"_nm = unset2na(order.stockRangeLower),
	  "stockRangeUpper"_nm = unset2na(order.stockRangeUpper),

	  "randomizeSize"_nm = order.randomizeSize,
	  "randomizePrice"_nm = order.randomizePrice,

	  // VOLATILITY ORDERS ONLY
	  "volatility"_nm = unset2na(order.volatility),
	  "volatilityType"_nm = unset2na(order.volatilityType),
	  "deltaNeutralOrderType"_nm = order.deltaNeutralOrderType,
	  "deltaNeutralAuxPrice"_nm = unset2na(order.deltaNeutralAuxPrice),
	  "deltaNeutralConId"_nm = order.deltaNeutralConId,
	  "deltaNeutralSettlingFirm"_nm = order.deltaNeutralSettlingFirm,
	  "deltaNeutralClearingAccount"_nm = order.deltaNeutralClearingAccount,
	  "deltaNeutralClearingIntent"_nm = order.deltaNeutralClearingIntent,
	  "deltaNeutralOpenClose"_nm = order.deltaNeutralOpenClose,
	  "deltaNeutralShortSale"_nm = order.deltaNeutralShortSale,
	  "deltaNeutralShortSaleSlot"_nm = order.deltaNeutralShortSaleSlot,
	  "deltaNeutralDesignatedLocation"_nm = order.deltaNeutralDesignatedLocation,
	  "continuousUpdate"_nm = order.continuousUpdate,
	  "referencePriceType"_nm = unset2na(order.referencePriceType),

	  // COMBO ORDERS ONLY
	  "basisPoints"_nm = unset2na(order.basisPoints),
	  "basisPointsType"_nm = unset2na(order.basisPointsType),

	  // SCALE ORDERS ONLY
	  "scaleInitLevelSize"_nm = unset2na(order.scaleInitLevelSize),
	  "scaleSubsLevelSize"_nm = unset2na(order.scaleSubsLevelSize),
	  "scalePriceIncrement"_nm = unset2na(order.scalePriceIncrement),
	  "scalePriceAdjustValue"_nm = unset2na(order.scalePriceAdjustValue),
	  "scalePriceAdjustInterval"_nm = unset2na(order.scalePriceAdjustInterval),
	  "scaleProfitOffset"_nm = unset2na(order.scaleProfitOffset),
	  "scaleAutoReset"_nm = order.scaleAutoReset,
	  "scaleInitPosition"_nm = unset2na(order.scaleInitPosition),
	  "scaleInitFillQty"_nm = unset2na(order.scaleInitFillQty),
	  "scaleRandomPercent"_nm = order.scaleRandomPercent,
	  "scaleTable"_nm = order.scaleTable,
		
	  // HEDGE ORDERS
	  "hedgeType"_nm = order.hedgeType,
	  "hedgeParam"_nm = order.hedgeParam,
		
	  // Clearing info
	  "account"_nm = order.account,
	  "settlingFirm"_nm = order.settlingFirm,
	  "clearingAccount"_nm = order.clearingAccount,
	  "clearingIntent"_nm = order.clearingIntent,
		
	  // ALGO ORDERS ONLY
	  "algoStrategy"_nm = order.algoStrategy,

	  // TODO:
	  /* "algoParams"_nm = order.algoParams, */
	  /* "smartComboRoutingParams"_nm = order.smartComboRoutingParams, */
	  "algoId"_nm = order.algoId,
		
	  // What-if
	  "whatIf"_nm = order.whatIf,
		
	  // Not Held
	  "notHeld"_nm = order.notHeld,
	  "solicited"_nm = order.solicited,
		
	  // models
	  "modelCode"_nm = order.modelCode,

	  // TODO
	  // order combo legs
	  /* OrderComboLegListSPtr orderComboLegs; */
	  /* TagValueListSPtr orderMiscOptions; */

	  //VER PEG2BENCH fields:
	  "referenceContractId"_nm = order.referenceContractId,
	  "peggedChangeAmount"_nm = order.peggedChangeAmount,
	  "isPeggedChangeAmountDecrease"_nm = order.isPeggedChangeAmountDecrease,
	  "referenceChangeAmount"_nm = order.referenceChangeAmount,
	  "referenceExchangeId"_nm = order.referenceExchangeId,
	  "adjustedOrderType"_nm = order.adjustedOrderType,
	  "triggerPrice"_nm = order.triggerPrice,
	  "adjustedStopPrice"_nm = order.adjustedStopPrice,
	  "adjustedStopLimitPrice"_nm = order.adjustedStopLimitPrice,
	  "adjustedTrailingAmount"_nm = order.adjustedTrailingAmount,
	  "adjustableTrailingUnit"_nm = order.adjustableTrailingUnit,
	  "lmtPriceOffset"_nm = order.lmtPriceOffset,

	  // TODO:
	  // std::vector<std::shared_ptr<OrderCondition>> conditions;
	  "conditionsCancelOrder"_nm = order.conditionsCancelOrder,
	  "conditionsIgnoreRth"_nm = order.conditionsIgnoreRth,
	  "extOperator"_nm = order.extOperator,
	  "softDollarTier"_nm = RSoftDollarTier(order.softDollarTier),
	  "cashQty"_nm = order.cashQty,
	  "mifid2DecisionMaker"_nm = order.mifid2DecisionMaker,
	  "mifid2DecisionAlgo"_nm = order.mifid2DecisionAlgo,
	  "mifid2ExecutionTrader"_nm = order.mifid2ExecutionTrader,
	  "mifid2ExecutionAlgo"_nm = order.mifid2ExecutionAlgo,
	  "dontUseAutoPriceForHedge"_nm = order.dontUseAutoPriceForHedge,
	  "isOmsContainer"_nm = order.isOmsContainer,
	  "discretionaryUpToLimitPrice"_nm = order.discretionaryUpToLimitPrice,
	  "autoCancelDate"_nm = order.autoCancelDate,
	  "filledQuantity"_nm = order.filledQuantity,
	  "refFuturesConId"_nm = order.refFuturesConId,
	  "autoCancelParent"_nm = order.autoCancelParent,
	  "shareholder"_nm = order.shareholder,
	  "imbalanceOnly"_nm = order.imbalanceOnly,
	  "routeMarketableToBbo"_nm = order.routeMarketableToBbo,
	  "parentPermId"_nm = order.parentPermId,
	  "usePriceMgmtAlgo"_nm = RUsePriceMmgtAlgo(order.usePriceMgmtAlgo),
	  "duration"_nm = order.duration,
	  "postToAts"_nm = order.postToAts
	});
}

lst RWrapper::RExecution(const Execution& e) {
  return lst({
	  "execId"_nm = e.execId,
	  "time"_nm = e.time,
	  "acctNumber"_nm = e.acctNumber,
	  "exchange"_nm = e.exchange,
	  "side"_nm = e.side,
	  "shares"_nm = e.shares,
	  "price"_nm = e.price,
	  "permId"_nm = e.permId,
	  "clientId"_nm = e.clientId,
	  "orderId"_nm = e.orderId,
	  "liquidation"_nm = e.liquidation,
	  "cumQty"_nm = e.cumQty,
	  "avgPrice"_nm = e.avgPrice,
	  "orderRef"_nm = e.orderRef,
	  "evRule"_nm = e.evRule,
	  "evMultiplier"_nm = e.evMultiplier,
	  "modelCode"_nm = e.modelCode,
	  "lastLiquidity"_nm = e.lastLiquidity
	});
}

 
lst RWrapper::RBar(const Bar& bar) {
  return lst({
	  "time"_nm = bar.time,
	  "high"_nm = bar.high,
	  "low"_nm = bar.low,
	  "open"_nm = bar.open,
	  "close"_nm = bar.close,
	  "wap"_nm = bar.wap,
	  "volume"_nm = bar.volume,
	  "count"_nm = bar.count,
	});
}

lst RWrapper::RContractDescription(const ContractDescription& cd) {
  return(lst({
		"contract"_nm = RContract(cd.contract),
		"derivativeSecTypes"_nm = cd.derivativeSecTypes
	  }));
}
 
/* std::string RWrapper::RFaDataType(faDataType fdt) { */
/*   switch(fdt) { */
/*    case faDataType::GROUPS: return "GROUPS"; */
/*    case faDataType::PROFILES: return "PROFILES"; */
/*    case faDataType::ALIASES: return "ALIASES"; */
/*   } */
/* } */