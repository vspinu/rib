#pragma once

#include "CommonDefs.h"
#include "Contract.h"
#include "Execution.h"
#include "MarginCondition.h"
#include "Order.h"
#include "OrderCondition.h"
#include "PercentChangeCondition.h"
#include "PriceCondition.h"
#include "ScannerSubscription.h"
#include "TagValue.h"
#include "TimeCondition.h"
#include "VolumeCondition.h"
#include "executioncondition.h"

#include <memory>
#include "assert.h"

#include "cpp11.hpp"
using lst = cpp11::list;
using cpp11::as_cpp;
using std::string;

namespace cpp11 {
template <>
inline bool is_na(const SEXP& x) {
  if (TYPEOF(x) == INTSXP) return INTEGER_ELT(x, 0) == NA_INTEGER;
  if (TYPEOF(x) == REALSXP) return ISNA(REAL_ELT(x, 0));
  if (TYPEOF(x) == STRSXP) return STRING_ELT(x, 0) == NA_STRING;
  if (TYPEOF(x) == LGLSXP) return LOGICAL_ELT(x, 0) == NA_LOGICAL;
  else return false;
}
}


template <typename T>
void setcpp(T& obj, SEXP value) {
  if (!cpp11::is_na(value))
	obj = cpp11::as_cpp<T>(value);
}

template <typename T>
T sexp2twsType(SEXP val, const std::string& name,
			   const std::vector<T>& enums,
			   const std::vector<std::string>& options) {
  assert(enums.size() == options.size());
  if (TYPEOF(val) == STRSXP) {
	std::string sval(CHAR(STRING_ELT(val, 0)));
	for (size_t i = 0; i < enums.size(); i++) {
	  if (sval == options[i]) return enums[i];
	}
  } else if (TYPEOF(val) == INTSXP ||
			 TYPEOF(val) == REALSXP) {
	int ival = cpp11::as_cpp<int>(val);
	for (size_t i = 0; i < enums.size(); i++) {
	  if (ival == static_cast<int>(enums[i])) return enums[i];
	}
  }
  cpp11::stop("Invalid '%s' argument", name);
}

// Not defined in Order.h
typedef std::shared_ptr<OrderCondition> OrderConditionSPtr;
typedef std::vector<OrderConditionSPtr> OrderConditionListSPtr;
OrderConditionSPtr twsOrderConditionSPtr(lst in);
OrderConditionListSPtr twsOrderConditionListSPtr(lst in);

OrderComboLegSPtr twsOrderComboLegSPtr(lst in);
Order::OrderComboLegListSPtr twsOrderComboLegListSPtr(lst in);
ComboLegSPtr twsComboLegSPtr(lst in);
Contract::ComboLegListSPtr twsComboLegsSPtr(lst in);
TagValueListSPtr twsTagValueListSPtr(lst in);

Contract twsContract(lst in);
Order twsOrder(lst in);
SoftDollarTier twsSoftDollarTier(lst in);
faDataType twsFaDataType(const string& faDataType);
ScannerSubscription twsScannerSubscription(lst in);
ExecutionFilter twsExecutionFilter(lst in);
