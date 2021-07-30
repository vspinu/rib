#pragma once

#include "EWrapper.h"
#include "Order.h"
#include "OrderState.h"
#include "Contract.h"
#include "CommissionReport.h"
#include "Execution.h"
#include "bar.h"

#include <unordered_map>
#include <string>
#include <vector>

#include "cpp11.hpp"
using namespace cpp11::literals;
using lst = cpp11::list;
using wlst = cpp11::writable::list;
using df = cpp11::data_frame;
using wdf = cpp11::writable::data_frame;

struct RWrapper : public EWrapper {
#include "EWrapper_prototypes.h"

 
  lst RContract(const Contract& contract);
  lst ROrder(const Order& order);
  lst ROrderState(const OrderState& os);
  lst RContractDetails(const ContractDetails& cd);
  lst RExecution(const Execution& e);
  lst RBar(const Bar& bar);
  lst RContractDescription(const ContractDescription& cd);
  
  std::vector<lst> acc;
};

