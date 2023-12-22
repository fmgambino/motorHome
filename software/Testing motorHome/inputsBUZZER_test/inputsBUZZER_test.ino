// ENTRADAS
const int DHT = 34;   // Sensor de temperatura
const int AOUT = 32;  // PIN Sensor de gas
const int DOUT = 16;  // PIN Sensor de gas
const int IN0 = 33;   // Entrada Digital 0
const int IN1 = 15;   // Entrada Digital 1
const int AI0 = 39;   // Entrada Analogica 0
const int AI1 = 36;   // Entrada Analogica 1

// SENSORES DE ULTRASONIDO
const int ECHO1 = 26;
const int TRIG1 = 25;
const int ECHO2 = 14;
const int TRIG2 = 27;
const int ECHO3 = 13;
const int TRIG3 = 12;

// SALIDAS
const int Q2 = 16;
const int Q3 = 17;
const int RLY = 4;
const int BUZZER = 5;

// I2C
// SCL = 22;
// SDA = 21;

void setup() {
  pinMode(IN0, INPUT);
  pinMode(IN1, INPUT);
  pinMode(RLY, OUTPUT);
  pinMode(BUZZER, OUTPUT);
}

void loop() {
  if (digitalRead(IN0) == HIGH) digitalWrite(RLY, HIGH);
  else digitalWrite(RLY, LOW);
  if (digitalRead(IN1) == HIGH) digitalWrite(BUZZER, HIGH);
  else digitalWrite(BUZZER, LOW);
  delay(20);
}
