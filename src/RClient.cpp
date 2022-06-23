
#include "RClient.h"
#include "assert.h"
#include <cstring>

const int HEADER_LEN = 4;

RClient::RClient(int serverVersion, RClientWrapper& rwrapper): EClient(&rwrapper, new RClientTransport) {
  assert(sizeof(unsigned) == HEADER_LEN);
  m_serverVersion = serverVersion;
}
RClient::~RClient() {}

REncoder::REncoder() : wrapper(), client(0, wrapper) {}
REncoder::~REncoder() {}

bool RClient::closeAndSend(std::string msg, unsigned offset) {
  assert(msg.size() > offset + HEADER_LEN);
  unsigned len = msg.size() - HEADER_LEN - offset;
  unsigned netlen = htonl(len);
  memcpy(&msg[offset], &netlen, HEADER_LEN);
  this->retval = std::move(msg);
  return true;
}

void RClient::prepareBuffer(std::ostream& buf) const {
  assert(sizeof(unsigned) == HEADER_LEN);
  char header[HEADER_LEN] = { 0 };
  buf.write(header, sizeof(header));
}

// used once in sendConnectRequest so inverting the role of impl
void RClient::prepareBufferImpl(std::ostream& buf) const {
  prepareBuffer(buf);
}

// UNUSED
void RClient::eDisconnect(bool resetState) { }
bool RClient::isSocketOK() const { return true; }
int RClient::receive(char* buf, size_t sz) { return 0; }
int RClient::bufferedSend(const std::string& msg) { return 0; }

// DUMMIES
void RClientWrapper::error(int id, int errorCode, const std::string& errorString) {
  REprintf("ENCODER: id:%d errorCode:%d %s\n", id, errorCode, errorString.c_str());
}
RClientTransport::RClientTransport() {}
RClientTransport::~RClientTransport() {}
int RClientTransport::send(EMessage *pMsg) { return 0; }
