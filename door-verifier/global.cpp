#include "global.h"

namespace devs {
  TFT tft;
  Door door(SERIAL_REMAP1);
  NFC nfc(SERIAL_REMAP2, RX_REMAP2, TX_REMAP2);
  WIFI wifi;
  REDISCONN redis;
}