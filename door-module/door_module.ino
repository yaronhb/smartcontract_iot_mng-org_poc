#include <SoftwareSerial.h>

const byte rxPin = 2;
const byte txPin = 3;
SoftwareSerial serial(rxPin, txPin);

#define wait(x) {while (x){}}

#define RELAY_IN_PIN 7
#define RELAY_OFF HIGH
#define RELAY_ON LOW

void relayOn(bool on) {
  if (on) {
    digitalWrite(RELAY_IN_PIN, RELAY_ON);
  } else {
    digitalWrite(RELAY_IN_PIN, RELAY_OFF);
  }
}

#define SERIAL_BAUD     9600
#define READY_STATUS    "0x10"
#define NOTREADY_STATUS "0x11"
#define OPEN_CMD        "0x21"
#define CLOSED_RSP      "0x22"
void setup() {
  pinMode(RELAY_IN_PIN, OUTPUT);
  pinMode(LED_BUILTIN, OUTPUT);

  relayOn(false);

  Serial.begin(SERIAL_BAUD);
  serial.begin(SERIAL_BAUD);
  
  // Serial.println(READY_STATUS);
  // Serial.flush();

  // String status = "";
  // while (!status.equals(READY_STATUS)){
  //   wait(!Serial.available());
  //   status = Serial.readString();
  //   status.trim();
  //   //Serial.print("Received: ");
  //   //Serial.print(status);
  //   //Serial.println();
  // }
   //Serial.println("Finished Setup");
}

void loop() {
  wait(serial.available()==0);
  String line = serial.readString();
  line.trim();
  Serial.println(line);
  if(!line.equals(OPEN_CMD)) {
    return;
  }
  relayOn(true);
  digitalWrite(LED_BUILTIN, HIGH);
  delay(7000);
  relayOn(false);
  digitalWrite(LED_BUILTIN, LOW);
  delay(10);
  serial.println(CLOSED_RSP);
  serial.flush();
  delay(1000);
}


