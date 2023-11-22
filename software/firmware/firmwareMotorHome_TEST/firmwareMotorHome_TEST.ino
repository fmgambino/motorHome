#include <Wire.h>
#include <RTClib.h>
#include <WiFi.h>
#include <WiFiManager.h>
#include <NTPClient.h>
#include <WiFiUdp.h>

RTC_DS3231 rtc;
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", -3 * 60 * 60);  // GMT-3 para Argentina

void configuraFechaHora() {
  while (!timeClient.update()) {
    timeClient.forceUpdate();
  }

  DateTime now = timeClient.getEpochTime();
  rtc.adjust(now);

  Serial.print("Fecha y Hora actualizadas: ");
  imprimirFechaHora(now);
}

void configurarWiFi() {
  WiFiManager wifiManager;

  // Descomentar la siguiente línea para reiniciar las configuraciones en cada reinicio
  // wifiManager.resetSettings();

  if (!wifiManager.autoConnect("ANTURAL AP")) {
    Serial.println("Fallo al conectar y tiempo de espera alcanzado");
    delay(3000);
    ESP.restart();
  }

  Serial.println("Conectado al WiFi");
}

void imprimirFechaHora(const DateTime &fecha) {
  Serial.print("Fecha y Hora: ");
  Serial.print(fecha.year(), DEC);
  Serial.print('/');
  Serial.print(fecha.month(), DEC);
  Serial.print('/');
  Serial.print(fecha.day(), DEC);
  Serial.print(" ");
  Serial.print(fecha.hour(), DEC);
  Serial.print(':');
  Serial.print(fecha.minute(), DEC);
  Serial.print(':');
  Serial.println(fecha.second(), DEC);
}

void setup() {
  Serial.begin(9600);

  if (!rtc.begin()) {
    Serial.println("Módulo RTC no encontrado !");
    while (1);
  }

  configurarWiFi();
  configuraFechaHora();
}

void loop() {
  DateTime fecha = rtc.now();

  imprimirFechaHora(fecha);

  delay(1000);
}
