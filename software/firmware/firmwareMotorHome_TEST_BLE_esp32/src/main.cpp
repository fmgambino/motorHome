#include <Arduino.h>
#include <BluetoothSerial.h>
#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <ArduinoJson.h>

BluetoothSerial SerialBT;

#define DHT_PIN 2      // Pin donde está conectado el sensor DHT22
#define DHT_TYPE DHT22 // Tipo de sensor DHT22
#define MAX_SENSORS 20
DHT dht(DHT_PIN, DHT_TYPE);

// JsonObject *obj[MAX_SENSORS];
int objIndices[MAX_SENSORS];
StaticJsonDocument<4096> doc;
JsonArray data = doc.createNestedArray("data");

String sensors[MAX_SENSORS] = {
    "white_water_type_level", // ultaSonicoTRIG[0]
    "gray_water_type_level",  // ultaSonicoTRIG[1]
    "black_water_type_level", // ultaSonicoTRIG[2]
    "boiler_diesel_type_level", // ultaSonicoTRIG[3] - La placa solo tiene capacidad de 3 Ultrasónicos
    "outdoor_temperature_type_meteorology", // Sensor BMP280 - Temperatura Digital Exterior
    "indoor_temperature_type_meteorology", // Sensor DTH22  - Temperatura Digital Interior MotorHome
    "refrigerator_temperature_type_meteorology", // DS18b20 - Temperatura Análoga
    "atmospheric_pressure_type_meteorology", // Sensor BMP280 - Presión Atmosférica -  ofrece un rango de medición de 300 a 1100 hPa (Hecto Pascal)
    "altitude_type_meteorology",            // Sensor BMP280
    "ppm_type_environmental_sensors",       // Sensor MQ2 - PPM
    "butane_type_environmental_sensors",    // Sensor MQ2 - Butano
    "propane_type_environmental_sensors",   // Sensor MQ2 - Propano
    "methane_type_environmental_sensors",   // Sensor MQ2 - Metano
    "alcohol_type_environmental_sensors",   // Sensor MQ2 - Alcohol
    "hall_type_battery",                    // Sensor Efecto Hall Interno ESP32 (hallRead()) - Voltaje entrada Placa
    "starter_type_battery",                 // Sensor que Mide la Bateria Eterna del Motor Home 
    "bomb_type_switches",                   // Actuador Bomba - MOSFETQ2
    "refrigerator_type_switches",           // Actuador Refri - La Placa solo tiene capacidad de 3 Actuadores
    "lights_type_switches",                   // Iluminación MotorHome - MOSFETQ3
    "boiler_type_switches",                 // Actuador Caldera - RELAY1
};

bool pauseData = false;
bool isComplete = false;
uint64_t chipid_mac;
char chipid_string[20];
String chipID;
bool isValidSensor(String sensor)
{
  for (int i = 0; i < MAX_SENSORS; i++)
  {
    if (sensors[i] == sensor)
    {
      return true;
    }
  }
  return false;
}

void setup()
{
  Serial.begin(115200);
  chipid_mac = ESP.getEfuseMac(); // Obtiene el MAC del chip
  
  sprintf(chipid_string, "antural/%04X%08X", (uint16_t)(chipid_mac>>32), (uint32_t)chipid_mac); // Formatea el ID del chip
  chipID = String(chipid_string); // Convierte a String
  SerialBT.begin(chipID); // Inicia el Bluetooth
  Serial.println(chipID); // Imprime la cadena

  dht.begin();
  for (int i = 0; i < MAX_SENSORS; i++)
  {
    JsonObject obj = data.createNestedObject();

    String sensor = sensors[i];
    int underscoreIndex = sensor.indexOf("_type_");

    if (underscoreIndex != -1)
    {
      String sensorName = sensor.substring(0, underscoreIndex);
      String sensorType = sensor.substring(underscoreIndex + 6);

      obj["sensor"] = sensorName;
      obj["enabled"] = true;
      obj["type"] = sensorType;
    }
    else
    {
      obj["sensor"] = sensor;
      obj["enabled"] = true;
    }

    objIndices[i] = data.size() - 1;
  }

}

void updateSensor(JsonObject& obj, const String& sensorName, int minVal, int maxVal, const String& unit) {
  if (obj["sensor"].as<String>().indexOf(sensorName) != -1) {
    obj["valor"] = random(minVal, maxVal);
    obj["unit"] = unit;
  }
}

void loop()
{

  static int currentSensorIndex = 0;

  if (currentSensorIndex >= MAX_SENSORS)
  {

    currentSensorIndex = 0;
    if (!isComplete)
    {
      isComplete = true;
    }
  }

  JsonObject obj = data[objIndices[currentSensorIndex]];

  if (SerialBT.available())
  {
    String receivedData = SerialBT.readString();
    receivedData.trim();

    Serial.println(receivedData);

    if (receivedData == "pause")
    {
      pauseData = true;
    }
    if (receivedData == "resume")
    {
      pauseData = false;
    }

    if (receivedData == "all")
    {
      for (int i = 0; i < MAX_SENSORS; i++)
      {
        JsonObject obj = data[objIndices[i]];
        obj["enabled"] = true;
      }
    }

    if (receivedData == "clear")
    {
      for (int i = 0; i < MAX_SENSORS; i++)
      {
        JsonObject obj = data[objIndices[i]];
        obj["enabled"] = false;
      }
    }

    if (isValidSensor(receivedData))
    {
      for (int i = 0; i < MAX_SENSORS; i++)
      {
        JsonObject obj = data[objIndices[i]];
        if (obj["sensor"] == receivedData)
        {
          obj["enabled"] = true;
          break;
        }
      }
    }
    else if (receivedData.startsWith("deselect "))
    {
      String sensor = receivedData.substring(9);
      for (int i = 0; i < MAX_SENSORS; i++)
      {
        JsonObject obj = data[objIndices[i]];
        if (obj["sensor"] == sensor)
        {
          obj["enabled"] = false;
          break;
        }
      }
    }
  }

  if (!pauseData)
  {
    updateSensor(obj, "level", 0, 300, "L");
    updateSensor(obj, "temperature", -10, 60, "C");
    updateSensor(obj, "pressure", 900, 1100, "hPa");
    updateSensor(obj, "altitude", 0, 1000, "msnm");
    updateSensor(obj, "butane", 0, 1000, "ppm");
    updateSensor(obj, "propane", 0, 1000, "ppm");
    updateSensor(obj, "methane", 0, 1000, "ppm");
    updateSensor(obj, "alcohol", 0, 1000, "ppm");
    updateSensor(obj, "ppm", 0, 1000, "ppm");
    updateSensor(obj, "hall", 0, 12, "V");
    updateSensor(obj, "starter", 0, 12, "V");

    StaticJsonDocument<4096> docToSend;
    docToSend["data"] = obj;
    docToSend["is_complete"] = isComplete;
    docToSend["topic"] = chipID;

    String dataToSend;
    ArduinoJson::serializeJson(docToSend, dataToSend);
    SerialBT.println(dataToSend);
  }

  currentSensorIndex++;

  delay(10000);
}
