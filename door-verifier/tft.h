#ifndef TFT_H
#define TFT_H

#include <SPI.h>
#include <TFT_eSPI.h> // Hardware-specific library


class TFT {
  public:
  TFT();
  void setup();

  void Normal() {
    tft.fillScreen(TFT_BLUE);
  }

  void OK() {
    tft.fillScreen(TFT_GREEN);
  }

  void Reject() {
    tft.fillScreen(TFT_RED);
  }
  
  private:
  TFT_eSPI tft;
};

#endif /* TFT_H */