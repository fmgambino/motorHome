#include <DHT.h>

// Pin de conexión del sensor DHT22 al Arduino
#define DHT_PIN 32

// Tipo de sensor DHT utilizado (DHT22)
#define DHT_TYPE DHT22

// Crear un objeto DHT
DHT dht(DHT_PIN, DHT_TYPE);

void setup() {
  Serial.begin(9600);
  Serial.println("Leyendo datos del sensor DHT22...");
  
  // Inicializar el sensor DHT
  dht.begin();
}

void loop() {
  // Retraso para evitar lecturas demasiado frecuentes
  delay(2000);

  // Leer la temperatura y la humedad del sensor DHT22
  float temperatura = dht.readTemperature();
  float humedad = dht.readHumidity();

  // Verificar si la lectura fue exitosa
  if (isnan(temperatura) || isnan(humedad)) {
    Serial.println("Error al leer el sensor DHT22. ¡Intentando nuevamente!");
    return;
  }

  // Imprimir los resultados en el puerto serie
  Serial.print("Temperatura: ");
  Serial.print(temperatura);
  Serial.println(" °C");

  Serial.print("Humedad: ");
  Serial.print(humedad);
  Serial.println(" %");
}