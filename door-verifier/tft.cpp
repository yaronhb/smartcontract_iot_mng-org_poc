#include "tft.h"

TFT::TFT() : tft(TFT_eSPI()) {}

void TFT::setup() {
  tft.init();
  // Rotation horizontal with usb port on the right
  tft.setRotation(1); 
  
  tft.fillScreen(TFT_BLUE);
}
