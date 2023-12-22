#include <OneWire.h>                
#include <DallasTemperature.h>
 


// ENTRADAS
OneWire ourWire(35);  // Se establece el pin 35 como bus OneWire
const int DHT = 34;   // Sensor de temperatura
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

DallasTemperature sensors(&ourWire); //Se declara una variable u objeto para nuestro sensor

void setup() {
  delay(1000);
  pinMode(Q2, OUTPUT);
  pinMode(Q3, OUTPUT);
  pinMode(RLY, OUTPUT);
  Serial.begin(9600);
  sensors.begin();   //Se inicia el sensor  
}

void loop() {
  sensors.requestTemperatures();   //Se envía el comando para leer la temperatura
  float temp = sensors.getTempCByIndex(0); //Se obtiene la temperatura en ºC

  Serial.print("Temperatura= ");
  Serial.print(temp);
  Serial.println(" C");
  delay(1000); 
}
