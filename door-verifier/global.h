#ifndef GLOBAL_H
#define GLOBAL_H

#include "nfc.h"
#include "tft.h"
#include "door.h"
#include "wifi.h"
#include "redis.h"

namespace devs {
  extern TFT tft;
  extern Door door;
  extern NFC nfc;
  extern WIFI wifi;
  extern REDISCONN redis;
}

#endif /* GLOBAL_H */