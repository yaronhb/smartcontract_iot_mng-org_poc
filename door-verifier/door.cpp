#include "door.h"

Door::Door(HardwareSerial& serial) : serial(serial) {

}

#define SERIAL_BAUD     9600
#define READY_STATUS    "0x10"
#define NOTREADY_STATUS "0x11"
#define OPEN_CMD        "0x21"
#define CLOSED_RSP      "0x22"


void Door::setup() {
  serial.begin(SERIAL_BAUD, SERIAL_8N1, RX_REMAP1, TX_REMAP1);
}

void Door::open() {
  serial.println(OPEN_CMD);

  String line = "";
  while (!line.equals(CLOSED_RSP)){
    while(serial.available() == 0);
    line = serial.readString();
    line.trim();
  }
}


