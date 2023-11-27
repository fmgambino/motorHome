#include <Wire.h>
#include <RTClib.h>
#include <WiFi.h>
#include <WiFiManager.h>  // Agregamos la librería WiFiManager
#include <NTPClient.h>
#include <WiFiUdp.h>

RTC_DS3231 rtc;

// ENTRADAS ANALOGICAS MOTOR HOME
float AI0 = 39;
float AI1 = 36;
float oneWire = 35;

// ENTRADAS DIGITALES MOTOR HOME
int dht22 = 34;
int bmp280SDA = 21;
int bmp280SCL = 22;
int MQ2 = 16;
int ultaSonicoTRIG01 = 25;
int ultaSonicoECHO01 = 26;
int ultaSonicoTRIG02 = 27;
int ultaSonicoECHO02 = 14;
int ultaSonicoTRIG03 = 12;
int ultaSonicoECHO03 = 13;


// SALIDAS MOTOR HOME
int buzzer = 5;
int relay1 = 4;
int mosfetQ2 = 16;   
int mosfetQ3 = 17;

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", -3*60*60);  // GMT-3 para Argentina

void configuraFechaHora() {
  while(!timeClient.update()) {
    timeClient.forceUpdate();
  }

  rtc.adjust(DateTime(timeClient.getEpochTime()));
}

void setup() {
  // Configuración de salidas
  pinMode(relay1, OUTPUT);
  pinMode(triacT1, OUTPUT);
  pinMode(mosfetQ2, OUTPUT);
  pinMode(mosfetQ3, OUTPUT);
  
  // Configuración de entradas
  pinMode(dht22, INPUT);


  Serial.begin(9600);

  // Inicialización de WiFiManager
  WiFiManager wifiManager;

  // Descomentar la siguiente línea para reiniciar las configuraciones en cada reinicio
  //wifiManager.resetSettings();

  // Intentar conectarse a la red WiFi almacenada
  if (!wifiManager.autoConnect("MOTOR HOME AP")) {
    Serial.println("Fallo al conectar y tiempo de espera alcanzado");
    delay(3000);
    // Reiniciar el dispositivo si no se pudo conectar
    ESP.restart();
  }

  Serial.println("Conectado al WiFi");

  // Inicialización del RTC
  if (!rtc.begin()) {
    Serial.println("Modulo RTC no encontrado !");
    while (1);
  }

  // Configuración automática de la fecha y hora desde Internet
  configuraFechaHora();
}

void loop() {
  // Tu código principal aquí, para ejecutar repetidamente:
  digitalWrite(relay1, HIGH);
  delay(500);
  digitalWrite(relay1, LOW);
  delay(500);
  digitalWrite(triacT1, HIGH);
  delay(500);
  digitalWrite(triacT1, LOW);
  delay(500);
  digitalWrite(mosfetQ0, HIGH);
  delay(500);
  digitalWrite(mosfetQ0, LOW);
  delay(500);
  digitalWrite(mosfetQ1, HIGH);
  delay(500);
  digitalWrite(mosfetQ1, LOW);
  delay(500);
  digitalWrite(mosfetQ2, HIGH);
  delay(500);
  digitalWrite(mosfetQ2, LOW);
  delay(500);
  digitalWrite(mosfetQ3, HIGH);
  delay(500);
  digitalWrite(mosfetQ3, LOW);
  delay(500);

  DateTime fecha = rtc.now();
  float temperature = analogRead(lm35Pin);
  float voltage = (temperature * 3.3) / 4095.0;
  float tempC = voltage * 100.0;

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

  Serial.println("Temperatura: " + String(tempC) + " °C");

  delay(1000);
}
