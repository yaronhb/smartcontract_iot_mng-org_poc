#include <Redis.h>
#include <WiFiClient.h>
#include <WiFi.h>

#ifndef REDISCONN_H
#define REDISCONN_H

#define REDIS_ADDR "192.168.31.137"
#define REDIS_PORT 6379
#define REDIS_PASSWORD ""

class REDISCONN {
  public:
  void setup();
  Redis redis;
  REDISCONN() : redis(redisConn) {}
  private:
  WiFiClient redisConn;
  
};

#endif /* REDISCONN_H */