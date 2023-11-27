#include <Arduino.h>

#include <SPI.h>
#include <Wire.h>
#include <RTClib.h>
#include <OneWire.h>
#include <DallasTemperature.h>

#if defined(ESP8266)
#include <ESP8266WiFi.h>
#else
#include <WiFi.h>
#endif

#include <WiFiManager.h>
#include <Separador.h>
#include <WiFiClientSecure.h>


#include <NTPClient.h>
#include <WiFiUdp.h>
#include <Adafruit_BMP280.h>
#include <Adafruit_Sensor.h>
#include <BluetoothSerial.h>

// Definiciones de pines
const int ds18b20Pin = 35;
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

const int buzzer = 5;
const int relay1 = 4;
const int mosfetQ2 = 16;
const int mosfetQ3 = 17;

// Objetos y variables globales
OneWire ourWire(ds18b20Pin);
DallasTemperature sensors(&ourWire);
RTC_DS3231 rtc;
BluetoothSerial SerialBT;
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", -3 * 60 * 60); // GMT-3 para Argentina
Adafruit_BMP280 bmp;

// Prototipos de funciones
void conectarWiFi();
void configuraFechaHora();
void inicializarSensores();
void inicializarActuadores();
float leerTemperaturaDHT22();
float leerHumedadDHT22();
float leerTemperaturaDS18B20();
float leerPresionBMP280();
float medirNivelLiquidoTanque(int trigPin, int echoPin);
void leerHumoMQ2();
void controlarRelay1();
void controlarMosfetQ2();
void controlarMosfetQ3();

void setup() {
  Serial.begin(9600);
  SerialBT.begin("MOTOR-HOME"); // Nombre del dispositivo Bluetooth

  // Inicialización de WiFi y conexión
  conectarWiFi();

  // Inicialización del RTC
  if (!rtc.begin()) {
    Serial.println("Modulo RTC no encontrado !");
    while (1);
  }

  // Configuración automática de la fecha y hora desde Internet
  configuraFechaHora();

  // Inicialización de sensores y actuadores
  inicializarSensores();
  inicializarActuadores();
}

void loop() {
  controlarRelay1();
  controlarMosfetQ2();
  controlarMosfetQ3();

  float temperaturaDHT22 = leerTemperaturaDHT22();
  float humedadDHT22 = leerHumedadDHT22();
  float temperaturaDS18B20 = leerTemperaturaDS18B20();
  float presionBMP280 = leerPresionBMP280();
  float nivelTanque01 = medirNivelLiquidoTanque(ultaSonicoTRIG01, ultaSonicoECHO01);
  float nivelTanque02 = medirNivelLiquidoTanque(ultaSonicoTRIG02, ultaSonicoECHO02);
  float nivelTanque03 = medirNivelLiquidoTanque(ultaSonicoTRIG03, ultaSonicoECHO03);
  leerHumoMQ2();

  DateTime fecha = rtc.now();

  SerialBT.print("Fecha y Hora: ");
  SerialBT.print(fecha.day());
  SerialBT.print("/");
  SerialBT.print(fecha.month());
  SerialBT.print("/");
  SerialBT.print(fecha.year());
  SerialBT.print(" ");
  SerialBT.print(fecha.hour());
  SerialBT.print(":");
  SerialBT.print(fecha.minute());
  SerialBT.print(":");
  SerialBT.println(fecha.second());

  SerialBT.print("Temperatura DHT22: ");
  SerialBT.print(temperaturaDHT22);
  SerialBT.println(" °C");

  SerialBT.print("Humedad DHT22: ");
  SerialBT.print(humedadDHT22);
  SerialBT.println(" %");

  SerialBT.print("Temperatura DS18B20: ");
  SerialBT.print(temperaturaDS18B20);
  SerialBT.println(" °C");

  SerialBT.print("Presión BMP280: ");
  SerialBT.print(presionBMP280);
  SerialBT.println(" hPa");

  SerialBT.print("Nivel Tanque 01: ");
  SerialBT.print(nivelTanque01);
  SerialBT.println(" cm");

  SerialBT.print("Nivel Tanque 02: ");
  SerialBT.print(nivelTanque02);
  SerialBT.println(" cm");

  SerialBT.print("Nivel Tanque 03: ");
  SerialBT.print(nivelTanque03);
  SerialBT.println(" cm");

  delay(1000);
}

// Resto de las funciones

void conectarWiFi() {
  WiFiManager wifiManager;

  if (!wifiManager.autoConnect("MOTOR HOME AP")) {
    Serial.println("Fallo al conectar y tiempo de espera alcanzado");
    delay(3000);
    ESP.restart();
  }

  Serial.println("Conectado al WiFi");
}

void configuraFechaHora() {
  // Implementa la configuración automática de la fecha y hora desde Internet
}

void inicializarSensores() {
  // Implementa la inicialización de sensores
  sensors.begin(); // Inicializa el sensor DS18B20
  bmp.begin();
}

void inicializarActuadores() {
  // Implementa la inicialización de actuadores
  pinMode(relay1, OUTPUT);
  pinMode(mosfetQ2, OUTPUT);
  pinMode(mosfetQ3, OUTPUT);
}

float leerTemperaturaDHT22() {
  // Implementa la lectura de temperatura desde el sensor DHT22
  // y devuelve el valor leído.
  // (Agregar código necesario aquí)
  return 0.0; // Placeholder
}

float leerHumedadDHT22() {
  // Implementa la lectura de humedad desde el sensor DHT22
  // y devuelve el valor leído.
  // (Agregar código necesario aquí)
  return 0.0; // Placeholder
}

float leerTemperaturaDS18B20() {
  sensors.requestTemperatures();
  return sensors.getTempCByIndex(0);
}

float leerPresionBMP280() {
  // Implementa la lectura de presión desde el sensor BMP280
  // y devuelve el valor leído.
  return bmp.readPressure() / 100.0F; // Divide por 100 para obtener el valor en hPa
}

float medirNivelLiquidoTanque(int trigPin, int echoPin) {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH);
  return (duration * 0.0343) / 2;
}

void leerHumoMQ2() {
  // Implementa la lectura de humo desde el sensor MQ2
  // y realiza las acciones necesarias.
}

void controlarRelay1() {
  // Implementa el control del relay1
  // y realiza las acciones necesarias.
}

void controlarMosfetQ2() {
  // Implementa el control del mosfetQ2
  // y realiza las acciones necesarias.
}

void controlarMosfetQ3() {
  // Implementa el control del mosfetQ3
  // y realiza las acciones necesarias.
}
