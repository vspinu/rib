#pragma once

#include "EWrapper.h"
#include "EClient.h"
#include "ETransport.h"
#include "DefaultEWrapper.h"
#include <vector>
#include <string>
#include <type_traits>
#include "version.h"

#include "cpp11.hpp"
#include "R_ext/Print.h"

class RClientTransport : public ETransport {
 public:
  RClientTransport();
  virtual ~RClientTransport(void);
 private:
  virtual int send(EMessage *pMsg);
};

class RClientWrapper : public DefaultEWrapper {
 public:
  void error(int id, int errorCode, const std::string& errorString);
};

class RClient : public EClient {
 public:
  std::string retval;
  RClient(int serverVersion, RClientWrapper& rwrapper);
  virtual ~RClient();
  // virtual methods from EClient
  virtual void eDisconnect(bool resetState = true);
  virtual bool isSocketOK() const;
  virtual int receive(char* buf, size_t sz);
  /* virtual bool isConnected() const; */

  void setServerVersion(int version) {
	m_serverVersion = version;
  }

  void setClientId(int clientId) {
	EClient::setClientId(clientId);
  }

  int getServerVersion() {
	return(m_serverVersion);
  }

  void connectionRequest() {
	sendConnectRequest();
  }

  using EClient::sendConnectRequest;

 protected:
  virtual bool closeAndSend(std::string msg, unsigned offset = 0);
  virtual void prepareBuffer(std::ostream&) const;
  virtual void prepareBufferImpl(std::ostream&) const;
  virtual int bufferedSend(const std::string& msg);

 public:

#define STOP(X) {cpp11::stop("'%s' not available with your version of TWS-API", X);}

#if MAX_SERVER_VERSION < 161
  void reqWshMetaData(int reqId) STOP("reqWshMetaData");
  void reqWshEventData(int reqId, int conId) STOP("reqWshEventData");
  void cancelWshMetaData(int reqId) STOP("cancelWshMetaData");
  void cancelWshEventData(int reqId) STOP("cancelWshEventData");
#endif

};

struct REncoder {
  RClientWrapper wrapper;
  RClient client;
  REncoder();
  virtual ~REncoder();
  void init() {
	client.retval = "";
  }
};

using PREncoder = cpp11::external_pointer<REncoder>;

