#define HEATER_PIN 26 //A3/T1
#define TANK_PIN 19 //A6/JP6
#define SWITCH_PIN 22 //A7/JP7
#define RELAY_PIN 16 //D12/C
#define TEMPERATURE_SAMPLES 5

// max adc: 305
#define NUMTEMPS 19
short temptable[NUMTEMPS][2] = {
   {1, 341},
   {17, 150},
   {33, 120},
   {49, 103},
   {65, 91},
   {81, 81},
   {97, 73},
   {113, 66},
   {129, 60},
   {145, 54},
   {161, 49},
   {177, 43},
   {193, 38},
   {209, 32},
   {225, 26},
   {241, 20},
   {257, 12},
   {273, 3},
   {289, -10}
};

int read_thermistor(uint8_t sample_pin)
{
  int raw = sample_temperature(sample_pin);

  int celsius = 0;
  byte i;

  for (i=1; i<NUMTEMPS; i++)
  {
    if (temptable[i][0] > raw)
    {
      celsius  = temptable[i-1][1] + 
        (raw - temptable[i-1][0]) * 
        (temptable[i][1] - temptable[i-1][1]) /
        (temptable[i][0] - temptable[i-1][0]);

      if (celsius > 255)
        celsius = 255; 

      break;
    }
  }

  // Overflow: We just clamp to 0 degrees celsius
  if (i == NUMTEMPS)
    celsius = 0;

  return celsius;
}

int sample_temperature(uint8_t pin)
{
  int raw = 0;

  //read in a certain number of samples
  for (byte i=0; i<TEMPERATURE_SAMPLES; i++)
    raw += analogRead(pin);

  //average the samples
  raw = raw/TEMPERATURE_SAMPLES;

  //send it back.
  return raw;
}

void setup(){
  pinMode(RELAY_PIN, OUTPUT);
  pinMode(SWITCH_PIN, INPUT);
  pinMode(HEATER_PIN, INPUT);
  pinMode(TANK_PIN, INPUT);
}

int main(){
  if (read_thermistor(TANK_PIN) < 50 and read_thermistor(HEATER_PIN) > 40) { // 50 degrees C, 120 F
    digitalWrite(RELAY_PIN, HIGH);
  } else {
    digitalWrite(RELAY_PIN, LOW);
  }
  
  // if (digitalRead(SWITCH_PIN == LOW) { digitalWrite(RELAY_PIN, HIGH); }
  
  delay(1000);
}
