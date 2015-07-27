/**
 * Atmega 324p datasheet: http://atmega32-avr.com/Download/atmega328_datasheet.pdf
 *
 * 32kb flash
 * 1kb EEPROM
 * 2kb SRAM
 * 2x 8 bit timer / counters - prescaler, compare
 * 1x 16bit timer / counter - prescaler, compare, capture
 * 1x real time counter
 * 6x PWM channels
 * 8-channel 10-bit ADC
 * programmable uart
 * master / slave SPI interface
 * i2c interface
 * watchdog
 * analog comparator
 * interrupt and wake-up on pin change
 * programmable brown-out protection
 * Six Sleep Modes: Idle, ADC Noise Reduction, Power-save, Power-down, Standby, and Extended Standby
 * 32 Programmable I/O Lines
 *
 */

#define GROVE_ANALOG_0  0  // A0 - displayed on the connector "Analog" (the other two pin connector - VCC and GND for sensor supply)
#define GROVE_ANALOG_1  1  // A1 - displayed on the connector "Analog" (the other two pin connector - VCC and GND for sensor supply)
#define GROVE_DIGITAL_0 3  // D3 - displayed on the connector "Digital" (the other two pin connector - VCC and GND for sensor supply)
#define GROVE_DIGITAL_1 4  // D4 - displayed on the connector "Digital" (the other two pin connector - VCC and GND for sensor supply)
#define GROVE_I2C_0     4  // A4 (SDA) - displayed on the connector "I2C" (the other two pin connector - VCC and GND for sensor supply)
#define GROVE_I2C_1     5  // A5 (SCL) - displayed on the connector "I2C" (the other two pin connector - VCC and GND for sensor supply)
#define RF_MOSI         11 // Interface for RF-module nRF24L01 +:
#define RF_MISO         12 // Interface for RF-module nRF24L01 +:
#define RF_SCK          13 // Interface for RF-module nRF24L01 +:
#define RF_CE           8  // Interface for RF-module nRF24L01 +:
#define RF_CSN          7  // Interface for RF-module nRF24L01 +:
#define RF_IRQ          2  // Interface for RF-module nRF24L01 +:
#define BUTTON          4  // D4 - on-board button
#define LED             9  // D9 - on-board LED
#define VOLTAGE         2  // A2 - voltage divider to monitor the battery level
#define TEMP            3  // A3 - MCP9700 temperature sensor

/*  Job button

Button connected to digital pin of D4 without external pull-up resistor. This connection is necessary to use the built-in pull-up resistor microcontroller.

This is done as follows (in the example being polled button once 0.5s and if it is pressed - LED lights):
*/

void setup (){
  // button
  pinMode(4, INPUT);
  // enable pull-up resistor
  digitalWrite(4, HIGH);

  // LED
  pinMode(9, OUTPUT);
}

void loop(){
  if(digitalRead(4) == LOW) {
    digitalWrite(9, HIGH);
  }
  else {
    digitalWrite(9, LOW);
  }
  delay(500);
}

/*  Measurement voltage power

Besides measuring the voltage at the voltage divider with a simple analogRead (A2), you can use more "advanced" way - use the built-in capabilities of the microcontroller.

You can use the following universal function:
*/

long readVcc() {
  // Read 1.1V reference against AVcc
  // set the reference to Vcc and the measurement to the internal 1.1V reference
  #if defined(__AVR_ATmega32U4__) || defined(__AVR_ATmega1280__) || defined(__AVR_ATmega2560__)
    ADMUX = _BV(REFS0) | _BV(MUX4) | _BV(MUX3) | _BV(MUX2) | _BV(MUX1);
  #elif defined (__AVR_ATtiny24__) || defined(__AVR_ATtiny44__) || defined(__AVR_ATtiny84__)
    ADMUX = _BV(MUX5) | _BV(MUX0);
  #elif defined (__AVR_ATtiny25__) || defined(__AVR_ATtiny45__) || defined(__AVR_ATtiny85__)
    ADMUX = _BV(MUX3) | _BV(MUX2);
  #else
    ADMUX = _BV(REFS0) | _BV(MUX3) | _BV(MUX2) | _BV(MUX1);
  #endif

  delay(75); // Wait for Vref to settle
  ADCSRA |= _BV(ADSC); // Start conversion
  while (bit_is_set(ADCSRA,ADSC)); // measuring

  uint8_t low  = ADCL; // must read ADCL first - it then locks ADCH
  uint8_t high = ADCH; // unlocks both

  long result = (high<<8) | low;

  result = 1125300L / result; // Calculate Vcc (in mV); 1125300 = 1.1*1023*1000
  return result; // Vcc in millivolts
}

