#pragma once

#include "EWrapper.h"
#include "EClient.h"
#include "ETransport.h"
#include "DefaultEWrapper.h"
#include <vector>
#include <string>

#include "cpp11.hpp"
#include "R_ext/Print.h"


class RDummyTransport : public ETransport {
 public:
  RDummyTransport();
  virtual ~RDummyTransport(void);

 private:
  virtual int send(EMessage *pMsg);
};

class RDummyWrapper : public DefaultEWrapper {
 public:
  void error(int id, int errorCode, const std::string& errorString);
};

class RClient : public EClient {

 public:
  std::string retval;
  explicit RClient(int serverVersion, RDummyWrapper *wrapper);
  virtual ~RClient();

  // virtual methods from EClient
  virtual void eDisconnect(bool resetState = true);
  virtual bool isSocketOK() const;
  virtual int receive(char* buf, size_t sz);
  virtual bool isConnected() const;

 protected:
  virtual bool closeAndSend(std::string msg, unsigned offset = 0);
  virtual void prepareBuffer(std::ostream&) const;
  virtual void prepareBufferImpl(std::ostream&) const;
  virtual int bufferedSend(const std::string& msg);
	
};
