#include "MY_PN532_HSU.h"
#include "emulatetag.h"

#ifndef NFC_H
#define NFC_H


#define SERIAL_REMAP2 Serial2
#define TX_REMAP2 27
#define RX_REMAP2 26

void setup1();
void loop2();

struct READ_RESULT{
  bool good;
  char uid[65];
  char code[7];
};

class NFC {
  public:
  NFC(HardwareSerial &serial, int8_t rxPin, int8_t txPin);
  void setup(uint8_t uid[3]);
  
  READ_RESULT try_get();
  
  private:
  MY_PN532_HSU pn532hsu;
  EmulateTag tag; 
};

#endif /* NFC_H */