// ENTRADAS
const int DHT = 32;   // Sensor de temperatura
const int AOUT = 34;  // PIN Sensor de gas
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
  Serial.begin(9600);  // Inicializar la comunicación serial a 9600 bps
}

void loop() {
  // Leer el valor analógico del sensor
  int valorSensor = analogRead(AOUT);

  // Imprimir el valor en el monitor serial
  Serial.print("Valor del sensor de gas: ");
  Serial.println(valorSensor);

  delay(1000);  // Esperar 1 segundo antes de la próxima lectura
}