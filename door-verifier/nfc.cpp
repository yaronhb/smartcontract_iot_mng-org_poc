#include "nfc.h"


#include "NdefMessage.h"


NFC::NFC(HardwareSerial &serial, int8_t rxPin, int8_t txPin) 
  : pn532hsu(serial, rxPin, txPin), tag(pn532hsu) {}

void NFC::setup(uint8_t uid[3]) {
  // uid must be 3 bytes!
  tag.setUid(uid);

  tag.init();
}

READ_RESULT NFC::try_get() {
  READ_RESULT result;
  result.good = false;

  // start emulation (blocks)
  tag.emulate();

  // allow writing to the tag
  tag.setTagWriteable(true);

  if (tag.writeOccured()) {
    Serial.println("NFC Write occured !");

    uint8_t *tag_buf;
    uint16_t length;
    tag.getContent(&tag_buf, &length);
    NdefMessage msg = NdefMessage(tag_buf, length);
    msg.print();

    int count = 0;
    for (unsigned int i = 0; i < msg.getRecordCount(); i++) {
      auto record = msg[i];
      auto key = record.getType() + "/" + record.getId();
      if (key == "key/uid/") {
          if (record.getPayloadLength() == 64) {
            record.getPayload((byte*)result.uid);
            result.uid[64] = '\0';
            count++;
          }
      } else if (key == "key/otp/") {
          if (record.getPayloadLength() == 6) {
            record.getPayload((byte*)result.code);
            result.code[6] = '\0';
            count++;
          }
      }
    }
    if (count == 2) {
      result.good = true;
    }
  }

  return result;
}
