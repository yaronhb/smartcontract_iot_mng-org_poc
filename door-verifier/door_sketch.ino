#include "global.h"

#include <TOTP.h>

#define ENDPOINT_ID "0xf3308b44f566cc09a64772b46773f9e933c43c791ab17147336b60c1dcb0154f"

void setup() {  
  Serial.begin(115200);
  Serial.println("Starting");
  devs::tft.setup();
  Serial.println("TFT Initialized");
  uint8_t uid[3] = {0x12, 0x34, 0x56};
  devs::nfc.setup(uid);
  Serial.println("NFC Initialized");
  devs::wifi.setup();
  Serial.println("WiFi Initialized");
  devs::redis.setup();
  Serial.println("REDIS Initialized");
  devs::door.setup();
  Serial.println("Door ready");
}

void loop() {
  {
  auto result = devs::nfc.try_get();
  if (!result.good) {
    goto reject;
  }
  auto key = std::string("endpoint_") + ENDPOINT_ID + "/tickets/employee_0x" + result.uid + "/secret";
  auto value  = devs::redis.redis.get(key.c_str());
  if (value == "") {
    goto reject;
  }
  TOTP totp = TOTP((uint8_t*) value.c_str(), value.length());

  char* code = totp.getCode(0);
  Serial.println(code);
  if(strcmp(code, result.code) != 0) {
    goto reject;
  }
  devs::tft.OK();
  devs::door.open();
  Serial.println("Door closed");

  goto end;
}
reject:
  devs::tft.Reject();
    delay(2000);
end:
  devs::tft.Normal();
  delay(250);
  // loop2();
}