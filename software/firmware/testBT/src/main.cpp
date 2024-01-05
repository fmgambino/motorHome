#include <Arduino.h>
#include <BluetoothSerial.h>
#include <Adafruit_Sensor.h>
#include <DHT.h>

BluetoothSerial SerialBT;

#define DHT_PIN 2       // Pin donde está conectado el sensor DHT22
#define DHT_TYPE DHT22  // Tipo de sensor DHT22

DHT dht(DHT_PIN, DHT_TYPE);

void setup() {
  Serial.begin(115200);
  SerialBT.begin("ESP32_BT"); // Nombre del dispositivo Bluetooth
  Serial.println("ESP32 Bluetooth Serial Listo");

  dht.begin();
}

void loop() {
  /* Lee la humedad y la temperatura del sensor DHT22

  float hum = dht.readHumidity();
  float temp = dht.readTemperature();*/
  
  // Actualiza el valor de humedad y temperatura (simulado)
  float hum = random(0, 100);
  float temp = random(10, 30);

  // Verifica si la lectura del sensor fue exitosa
  if (!isnan(hum) && !isnan(temp)) {
    // Crea una cadena con los datos de humedad y temperatura
    String dataToSend = "Humedad: " + String(hum) + "%, Temperatura: " + String(temp) + "°C";

    // Envía los datos a través de Bluetooth
    SerialBT.println(dataToSend);

    // Intenta leer datos desde el dispositivo Bluetooth
    if (SerialBT.available()) {
      String receivedData = SerialBT.readStringUntil('\n'); // Lee hasta encontrar un salto de línea
      Serial.print("Recibido: ");
      Serial.println(receivedData);
    }
  }

  // Espera un tiempo antes de enviar/recibir datos nuevamente
  delay(5000); // Puedes ajustar el intervalo según tus necesidades
}
