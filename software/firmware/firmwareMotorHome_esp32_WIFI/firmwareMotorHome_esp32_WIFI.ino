#include <Wire.h>
#include <RTClib.h>
#include <WiFi.h>
#include <WiFiManager.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <Adafruit_BMP280.h>
#include <PubSubClient.h>
#include <DallasTemperature.h>

RTC_DS3231 rtc;

// ENTRADAS ANALÓGICAS MOTOR HOME
const int AI0 = 39;
const int AI1 = 36;
const int ds18b20Pin = 35; // Cambiado el nombre de oneWirePin a ds18b20Pin

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

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", -3 * 60 * 60); // GMT-3 para Argentina

Adafruit_BMP280 bmp;
DallasTemperature sensors(&ds18b20Pin); // Cambiado de oneWirePin a ds18b20Pin

const char *mqtt_server = "broker.emqx.io";
const int mqtt_port = 1883;
const char *mqtt_topic = "motorhome/data";

WiFiClient espClient;
PubSubClient client(espClient);

// Inicialización de funciones
void configuraFechaHora();
void inicializarSensores();
void inicializarActuadores();
void conectarWiFi();
void conectarMQTT();
void publicarDatosMQTT(String payload);

// Funciones para lectura de sensores
float leerTemperaturaDHT22();
float leerHumedadDHT22();
float leerTemperaturaDS18B20();
float leerPresionBMP280();
float medirNivelLiquidoTanque(int trigPin, int echoPin);
void leerHumoMQ2();

// Funciones para controlar actuadores
void controlarRelay1();
void controlarMosfetQ2();
void controlarMosfetQ3();

void setup()
{
  Serial.begin(9600);

  // Inicialización de WiFi y conexión
  conectarWiFi();

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

  // Inicialización de MQTT
  client.setServer(mqtt_server, mqtt_port);
}

void loop()
{
  // Tu código principal aquí, para ejecutar repetidamente:
  controlarRelay1();
  controlarMosfetQ2();
  controlarMosfetQ3();

  float temperaturaDHT22 = leerTemperaturaDHT22();
  float humedadDHT22 = leerHumedadDHT22();
  float temperaturaDS18B20 = leerTemperaturaDS18B20(); // Agregado para el sensor DS18B20
  float presionBMP280 = leerPresionBMP280();
  float nivelTanque01 = medirNivelLiquidoTanque(ultaSonicoTRIG01, ultaSonicoECHO01);
  float nivelTanque02 = medirNivelLiquidoTanque(ultaSonicoTRIG02, ultaSonicoECHO02);
  float nivelTanque03 = medirNivelLiquidoTanque(ultaSonicoTRIG03, ultaSonicoECHO03);
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

  Serial.print("Temperatura DS18B20: "); // Agregado para el sensor DS18B20
  Serial.print(temperaturaDS18B20);
  Serial.println(" °C");

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

  // Construir un string con los datos para MQTT
  String mqttPayload = "Fecha: " + String(fecha.day()) + "/" + String(fecha.month()) + "/" + String(fecha.year()) +
                      " Hora: " + String(fecha.hour()) + ":" + String(fecha.minute()) + ":" + String(fecha.second()) +
                      " Temperatura DHT22: " + String(temperaturaDHT22) + " °C" +
                      " Humedad DHT22: " + String(humedadDHT22) + " %" +
                      " Temperatura DS18B20: " + String(temperaturaDS18B20) + " °C" + // Agregado para el sensor DS18B20
                      " Presión BMP280: " + String(presionBMP280) + " hPa" +
                      " Nivel Tanque 01: " + String(nivelTanque01) + " cm" +
                      " Nivel Tanque 02: " + String(nivelTanque02) + " cm" +
                      " Nivel Tanque 03: " + String(nivelTanque03) + " cm";

  // Publicar datos en MQTT
  if (client.connected())
  {
    publicarDatosMQTT(mqttPayload);
  }

  delay(1000);
}

// Resto de las funciones

void conectarWiFi()
{
  WiFiManager wifiManager;

  if (!wifiManager.autoConnect("MOTOR HOME AP"))
  {
    Serial.println("Fallo al conectar y tiempo de espera alcanzado");
    delay(3000);
    ESP.restart();
  }

  Serial.println("Conectado al WiFi");
}

void conectarMQTT()
{
  while (!client.connected())
  {
    Serial.println("Conectando al servidor MQTT...");
    if (client.connect("ESP32Client"))
    {
      Serial.println("Conectado al servidor MQTT");
    }
    else
    {
      Serial.print("Error en la conexión, rc=");
      Serial.print(client.state());
      Serial.println(". Intentando de nuevo en 5 segundos...");
      delay(5000);
    }
  }
}

void publicarDatosMQTT(String payload)
{
  if (!client.connected())
  {
    conectarMQTT();
  }

  client.publish(mqtt_topic, payload.c_str());
  Serial.println("Datos publicados en MQTT: " + payload);
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

float leerTemperaturaDS18B20()
{
  sensors.requestTemperatures(); // Se solicita la temperatura al sensor DS18B20
  return sensors.getTempCByIndex(0); // Se obtiene la temperatura en grados Celsius
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


