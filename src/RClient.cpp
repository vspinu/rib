
#include "RClient.h"
#include "assert.h"
#include <cstring>

RClient::RClient(int serverVersion, RDummyWrapper *ptr): EClient(ptr, new RDummyTransport) {
  m_serverVersion = serverVersion;
}
RClient::~RClient() {}

bool RClient::closeAndSend(std::string msg, unsigned offset) {
  assert(msg.size() > offset + 4);
  unsigned len = msg.size() - 4 - offset;
  unsigned netlen = htonl(len);
  memcpy(&msg[offset], &netlen, 4);
  this->retval = std::move(msg);
  return true;
}

void RClient::prepareBuffer(std::ostream& buf) const {
  assert(sizeof(unsigned) == 4);
  char header[4] = { 0 };
  buf.write(header, sizeof(header));
}

void RClient::prepareBufferImpl(std::ostream& buf) const {
  prepareBuffer(buf);
}
 
bool RClient::isConnected() const {
  return true;
}

// UNUSED
void RClient::eDisconnect(bool resetState) { }
bool RClient::isSocketOK() const { return true; }
int RClient::receive(char* buf, size_t sz) { return 0; }
int RClient::bufferedSend(const std::string& msg) { return 0; }

// DUMMIES
void RDummyWrapper::error(int id, int errorCode, const std::string& errorString) {
  REprintf("ENCODER: id:%d errorCode:%d %s\n", id, errorCode, errorString.c_str());
};
RDummyTransport::RDummyTransport() {}
RDummyTransport::~RDummyTransport() {}
int RDummyTransport::send(EMessage *pMsg) { return 0; }


