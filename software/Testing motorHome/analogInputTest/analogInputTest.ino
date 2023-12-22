// ENTRADAS
const int DHT = 34;   // Sensor de temperatura
const int TEMP = 35;  // Sensor de temperatura ONE-WIRE
const int AOUT = 32;  // PIN Sensor de gas
const int DOUT = 16;  // PIN Sensor de gas
const int IN1 = 15;   // Entrada Digital 1
const int IN2 = 33;   // Entrada Digital 2
const int AI0 = 39;   // Entrada Analogica 1
const int AI1 = 36;   // Entrada Analogica 2

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
//const int SCL = 22;
//const int SDA = 21;

void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(Q2, OUTPUT);
  pinMode(Q3, OUTPUT);
  pinMode(RLY, OUTPUT);
  Serial.begin(9600);
}

// the loop function runs over and over again forever
void loop() {
  // Lee el valor de la entrada analógica en el pin AI0 o AI1
  int valorAnalogico = analogRead(AI0);

  // Muestra el valor en el puerto serial
  Serial.print("Valor analógico: ");
  Serial.println(valorAnalogico);

  // Espera un breve periodo de tiempo para evitar la saturación del puerto serial
  delay(500);
}
