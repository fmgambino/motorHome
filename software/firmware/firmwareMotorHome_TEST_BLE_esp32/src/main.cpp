#include <Arduino.h>
#include <BluetoothSerial.h>
#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <ArduinoJson.h>
#include <vector>

std::vector<String> actuators = {
    "bomb",
    "refrigerator",
    "lights",
    "boiler",
};
BluetoothSerial SerialBT;

#define DHT_PIN 2      // Pin donde está conectado el sensor DHT22
#define DHT_TYPE DHT22 // Tipo de sensor DHT22
#define MAX_SENSORS 21
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
    "indoor_hum_type_meteorology", // Sensor DTH22  - Humedad Digital Interior MotorHome
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

bool isActuator(String sensor)
{ 
  return std::find(actuators.begin(), actuators.end(), sensor) != actuators.end();
}

void setup()
{
  Serial.begin(115200);
  chipid_mac = ESP.getEfuseMac();
  sprintf(chipid_string, "antural/%04X%08X", (uint16_t)(chipid_mac >> 32), (uint32_t)chipid_mac);
  chipID = String(chipid_string);

  SerialBT.begin(chipID); // Inicia el Bluetooth
  Serial.println(chipID); // Imprime la cadena

  dht.begin();
  for (int i = 0; i < MAX_SENSORS; i++)
  {
    JsonObject obj = data.createNestedObject();

    String sensor = sensors[i];
    int underscoreIndex = sensor.indexOf("_type_");
    String sensorName = sensor.substring(0, underscoreIndex);
    String sensorType = sensor.substring(underscoreIndex + 6);
    // imprime un log con el nombre del sensor y el tipo y un salto de linea al ultimo
    // Serial.println(sensorName + " " + sensorType + "\n");


      obj["sensor"] = sensorName;
      obj["enabled"] = true;
      obj["type"] = sensorType;


    objIndices[i] = data.size() - 1;
  }
}

void updateSensor(JsonObject &obj, const String &sensorName, int minVal, int maxVal, const String &unit)
{
  // imprime un log con el nombre del sensor y el tipo y un salto de linea al ultimo

    obj["valor"] = random(minVal, maxVal);
    obj["unit"] = unit;

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
  // imprimir el obj
  Serial.println(obj);
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

    if(isActuator(receivedData)){
      for (int i = 0; i < MAX_SENSORS; i++)
      {
        JsonObject obj = data[objIndices[i]];
        if (obj["sensor"] == receivedData)
        {
          Serial.println("is actuator");
          obj["enabled"] = true;
          break;
        }
      }
    }

    if (isValidSensor(receivedData))
    {
      for (int i = 0; i < MAX_SENSORS; i++)
      {
        JsonObject obj = data[objIndices[i]];
        if (obj["sensor"] == receivedData)
        {
          Serial.println("is actuator 2");
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
          Serial.println('is actuator deselect');
          obj["enabled"] = false;
          break;
        }
      }
    }
  }

  if (!pauseData)
  {


    // updateSensor(obj, "white_water", 0, 300, "L");
    // updateSensor(obj, "gray_water", 0, 200, "L");
    // updateSensor(obj, "black_water", 0, 200, "L");
    // updateSensor(obj, "boiler_diesel", 0, 1000, "L");
    // updateSensor(obj, "outdoor_temperature", -20, 100, "C");
    // updateSensor(obj, "indoor_temperature", -20, 100, "C");
    // updateSensor(obj, "refrigerator_temperature", -20, 100, "C");
    // updateSensor(obj, "atmospheric_pressure", 0,  4000, "hPa");
    // updateSensor(obj, "altitude", 0, 8848 , "msnm");
    // updateSensor(obj, "ppm", 0, 209500, "ppm");
    // updateSensor(obj, "butane", 0, 800 , "ppm");
    // updateSensor(obj, "propane", 0, 1000, "ppm");
    // updateSensor(obj, "methane", 0, 1000, "ppm");
    // updateSensor(obj, "alcohol", 0, 1000, "ppm");
    // updateSensor(obj, "hall", 0, 12, "V");
    // updateSensor(obj, "starter", 0, 12, "V");

    // updateSensor(obj, "bomb", 0, 0, "");
    // updateSensor(obj, "refrigerator", 0, 0, "");
    // updateSensor(obj, "lights", 0, 0, "");
    // updateSensor(obj, "boiler", 0, 0, "");

     if (obj["sensor"] == "white_water")
    {
      updateSensor(obj, "white_water", 0, 300, "L");
    }
    else if (obj["sensor"] == "gray_water")
    {
      updateSensor(obj, "gray_water", 0, 200, "L");
    }
    else if (obj["sensor"] == "black_water")
    {
      updateSensor(obj, "black_water", 0, 200, "L");
    }
    else if (obj["sensor"] == "boiler_diesel")
    {
      updateSensor(obj, "boiler_diesel", 0, 1000, "L");
    }
    else if (obj["sensor"] == "outdoor_temperature")
    {
      updateSensor(obj, "outdoor_temperature", -20, 100, "C");
    }
    else if (obj["sensor"] == "indoor_temperature")
    {
      updateSensor(obj, "indoor_temperature", -20, 100, "C");
    }
    else if (obj["sensor"] == "refrigerator_temperature")
    {
      updateSensor(obj, "refrigerator_temperature", -20, 100, "C");
    }
    else if (obj["sensor"] == "atmospheric_pressure")
    {
      updateSensor(obj, "atmospheric_pressure", 0, 4000, "hPa");
    }
    else if (obj["sensor"] == "altitude")
    {
      updateSensor(obj, "altitude", 0, 8848, "msnm");
    }
    else if (obj["sensor"] == "ppm")
    {
      updateSensor(obj, "ppm", 0, 209500, "ppm");
    }
    else if (obj["sensor"] == "butane")
    {
      updateSensor(obj, "butane", 0, 800, "ppm");
    }
    else if (obj["sensor"] == "propane")
    {
      updateSensor(obj, "propane", 0, 1000, "ppm");
    }
    else if (obj["sensor"] == "methane")
    {
      updateSensor(obj, "methane", 0, 1000, "ppm");
    }
    else if (obj["sensor"] == "alcohol")
    {
      updateSensor(obj, "alcohol", 0, 1000, "ppm"); 
    } else if (obj["sensor"] == "hall")
    {
      updateSensor(obj, "hall", 0, 12, "V");
    }
    else if (obj["sensor"] == "starter")
    {
      updateSensor(obj, "starter", 0, 12, "V");
    }
    else if (obj["sensor"] == "bomb")
    {
      updateSensor(obj, "bomb", 0, 0, "");
    }
    else if (obj["sensor"] == "refrigerator")
    {
      updateSensor(obj, "refrigerator", 0, 0, "");
    }
    else if (obj["sensor"] == "lights")
    {
      updateSensor(obj, "lights", 0, 0, "");
    }
    else if (obj["sensor"] == "boiler")
    {
      updateSensor(obj, "boiler", 0, 0, "");
    }
   

    StaticJsonDocument<4096> docToSend;
    docToSend["data"] = obj;
    docToSend["is_complete"] = isComplete;
    docToSend["topic"] = chipID;

    String dataToSend;
    ArduinoJson::serializeJson(docToSend, dataToSend);
    // imprimir el json antes de enviarlo
    Serial.println(dataToSend);
    SerialBT.println(dataToSend);
  }

  currentSensorIndex++;

  delay(3000);
}
