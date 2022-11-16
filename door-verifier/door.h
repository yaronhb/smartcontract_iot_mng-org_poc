#ifndef DOOR_H
#define DOOR_H

#define SERIAL_REMAP1 Serial1
#define TX_REMAP1 25
#define RX_REMAP1 33
// #define TX_REMAP1 27
// #define RX_REMAP1 26

#include <Arduino.h>

class Door {
  public:
  Door(HardwareSerial &serial);

  void setup();
  void open();

  private:
  HardwareSerial& serial; 
};

#endif /* DOOR_H */