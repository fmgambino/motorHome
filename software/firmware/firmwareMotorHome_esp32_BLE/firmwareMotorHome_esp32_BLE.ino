#include <Wire.h>
#include <RTClib.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BMP280.h>
#include <OneWire.h>
#include <DallasTemperature.h>

RTC_DS3231 rtc;

// ENTRADAS ANALÓGICAS MOTOR HOME
const int AI0 = 39;
const int AI1 = 36;
const int ds18b20Pin = 35;  // Cambiado a ds18b20

// ENTRADAS DIGITALES MOTOR HOME
const int dht22Pin = 34;
const int bmp280SDA = 21;
const int bmp280SCL = 22;
const int MQ2Pin = 16;
const int ultaSonicoTRIG01 = 25;
const int ultaSonicoECHO01 = 26;
const int ultaSonicoTRIG02 = 27;
const int ultaSonicoECHO02 = 14;
const int ultaSonicoTRIG03 = 12;
const int ultaSonicoECHO03 = 13;

// SALIDAS MOTOR HOME
const int buzzer = 5;
const int relay1 = 4;
const int mosfetQ2 = 16;
const int mosfetQ3 = 17;

Adafruit_BMP280 bmp;

OneWire oneWire(ds18b20Pin);
DallasTemperature sensors(&oneWire);

// Inicialización de funciones
void configuraFechaHora();
void inicializarSensores();
void inicializarActuadores();

// Funciones para lectura de sensores
float leerTemperaturaDHT22();
float leerHumedadDHT22();
float leerPresionBMP280();
float medirNivelLiquidoTanque(int trigPin, int echoPin);
void leerHumoMQ2();
float leerTemperaturaDS18B20();

// Funciones para controlar actuadores
void controlarRelay1();
void controlarMosfetQ2();
void controlarMosfetQ3();

void setup()
{
  Serial.begin(9600);
  Serial2.begin(9600); // Inicializa el puerto serie Serial2 para Bluetooth

  // Configuración del nombre del dispositivo Bluetooth
  Serial2.println("AT+NAME=MI_ESP32"); // Cambia "MI_ESP32" al nombre que desees


  // Inicialización del RTC
  if (!rtc.begin())
  {
    Serial.println("Modulo RTC no encontrado !");
    while (1);
  }

  // Configuración automática de la fecha y hora desde Internet
  configuraFechaHora();

  // Inicialización de sensores y actuadores
  inicializarSensores();
  inicializarActuadores();
}

void loop()
{
  // Tu código principal aquí, para ejecutar repetidamente:
  controlarRelay1();
  controlarMosfetQ2();
  controlarMosfetQ3();

  float temperaturaDHT22 = leerTemperaturaDHT22();
  float humedadDHT22 = leerHumedadDHT22();
  float presionBMP280 = leerPresionBMP280();
  float nivelTanque01 = medirNivelLiquidoTanque(ultaSonicoTRIG01, ultaSonicoECHO01);
  float nivelTanque02 = medirNivelLiquidoTanque(ultaSonicoTRIG02, ultaSonicoECHO02);
  float nivelTanque03 = medirNivelLiquidoTanque(ultaSonicoTRIG03, ultaSonicoECHO03);
  float temperaturaDS18B20 = leerTemperaturaDS18B20();
  leerHumoMQ2();

  DateTime fecha = rtc.now();

  Serial.print("Fecha y Hora: ");
  Serial.print(fecha.day());
  Serial.print("/");
  Serial.print(fecha.month());
  Serial.print("/");
  Serial.print(fecha.year());
  Serial.print(" ");
  Serial.print(fecha.hour());
  Serial.print(":");
  Serial.print(fecha.minute());
  Serial.print(":");
  Serial.println(fecha.second());

  Serial.print("Temperatura DHT22: ");
  Serial.print(temperaturaDHT22);
  Serial.println(" °C");

  Serial.print("Humedad DHT22: ");
  Serial.print(humedadDHT22);
  Serial.println(" %");

  Serial.print("Presión BMP280: ");
  Serial.print(presionBMP280);
  Serial.println(" hPa");

  Serial.print("Nivel Tanque 01: ");
  Serial.print(nivelTanque01);
  Serial.println(" cm");

  Serial.print("Nivel Tanque 02: ");
  Serial.print(nivelTanque02);
  Serial.println(" cm");

  Serial.print("Nivel Tanque 03: ");
  Serial.print(nivelTanque03);
  Serial.println(" cm");

  Serial.print("Temperatura DS18B20: ");
  Serial.print(temperaturaDS18B20);
  Serial.println(" °C");

  // Construir un string con los datos para Bluetooth
  String bluetoothPayload = "Fecha: " + String(fecha.day()) + "/" + String(fecha.month()) + "/" + String(fecha.year()) +
                            " Hora: " + String(fecha.hour()) + ":" + String(fecha.minute()) + ":" + String(fecha.second()) +
                            " Temperatura DHT22: " + String(temperaturaDHT22) + " °C" +
                            " Humedad DHT22: " + String(humedadDHT22) + " %" +
                            " Presión BMP280: " + String(presionBMP280) + " hPa" +
                            " Nivel Tanque 01: " + String(nivelTanque01) + " cm" +
                            " Nivel Tanque 02: " + String(nivelTanque02) + " cm" +
                            " Nivel Tanque 03: " + String(nivelTanque03) + " cm" +
                            " Temperatura DS18B20: " + String(temperaturaDS18B20) + " °C";

  // Enviar datos por Bluetooth
  Serial2.println(bluetoothPayload);

  delay(1000);
}

// Resto de las funciones

float leerTemperaturaDS18B20()
{
  sensors.requestTemperatures();
  return sensors.getTempCByIndex(0);
}

void configuraFechaHora()
{
  while (!rtc.begin())
  {
    Serial.println("No se pudo iniciar el módulo RTC. Intentando de nuevo...");
    delay(1000);
  }

  if (rtc.lostPower())
  {
    Serial.println("RTC perdido poder, ajustando la hora!");
    rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));
  }
}

void inicializarSensores()
{
  pinMode(dht22Pin, INPUT);
  bmp.begin();
  sensors.begin();
}

void inicializarActuadores()
{
  pinMode(relay1, OUTPUT);
  pinMode(mosfetQ2, OUTPUT);
  pinMode(mosfetQ3, OUTPUT);
}

float leerTemperaturaDHT22()
{
  // Implementa la lectura de temperatura desde el sensor DHT22
  // y devuelve el valor leído.
}

float leerHumedadDHT22()
{
  // Implementa la lectura de humedad desde el sensor DHT22
  // y devuelve el valor leído.
}

float leerPresionBMP280()
{
  // Implementa la lectura de presión desde el sensor BMP280
  // y devuelve el valor leído.
  return bmp.readPressure() / 100.0F; // Divide por 100 para obtener el valor en hPa
}

float medirNivelLiquidoTanque(int trigPin, int echoPin)
{
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH);
  // La velocidad del sonido es de 343 metros por segundo
  // Dividimos por 2 porque el sonido va de ida y vuelta
  return (duration * 0.0343) / 2;
}

void leerHumoMQ2()
{
  // Implementa la lectura de humo desde el sensor MQ2
  // y realiza las acciones necesarias.
}

void controlarRelay1()
{
  // Implementa el control del relay1
  // y realiza las acciones necesarias.
}

void controlarMosfetQ2()
{
  // Implementa el control del mosfetQ2
  // y realiza las acciones necesarias.
}

void controlarMosfetQ3()
{
  // Implementa el control del mosfetQ3
  // y realiza las acciones necesarias.
}
