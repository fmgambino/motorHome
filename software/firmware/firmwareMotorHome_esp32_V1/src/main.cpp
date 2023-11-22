#include <Arduino.h>

int led01 = 35;

void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(led01, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
  digitalWrite(led01, HIGH);  // turn the LED on (HIGH is the voltage level)
  delay(1000);                      // wait for a second
  digitalWrite(led01, LOW);   // turn the LED off by making the voltage LOW
  delay(1000);                      // wait for a second
}
