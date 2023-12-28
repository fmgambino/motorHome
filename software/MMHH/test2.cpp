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
    "white_water_type_level",
    "gray_water_type_level",
    "black_water_type_level",
    "boiler_diesel_type_level",
    "outdoor_temperature_type_meteorology",
    "indoor_temperature_type_meteorology",
    "refrigerator_temperature_type_meteorology",
    "atmospheric_pressure_type_meteorology",
    "altitude_type_meteorology",
    "ppm_type_environmental_sensors",
    "butane_type_environmental_sensors",
    "propane_type_environmental_sensors",
    "methane_type_environmental_sensors",
    "alcohol_type_environmental_sensors",
    "hall_type_battery",
    "starter_type_battery",
    "bomb_type_switches",
    "refrigerator_type_switches",
    "lights_type_switches",
    "boiler_type_switches",
    "indoor_hum_type_meteorology"
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
          // AQUI SE ACTIVA EL ACTUADOR
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
        //  AQUI SE DESACTIVA EL ACTUADOR
          break;
        }
      }
    }
  }

  if (!pauseData)
  {


     if (obj["sensor"] == "white_water")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "L";
    }
    else if (obj["sensor"] == "gray_water")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "L";
    }
    else if (obj["sensor"] == "black_water")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "L";
    }
    else if (obj["sensor"] == "boiler_diesel")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "L";
    }
    else if (obj["sensor"] == "outdoor_temperature")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "C";
    }
    else if (obj["sensor"] == "indoor_temperature")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "C";
    }
    else if (obj["sensor"] == "refrigerator_temperature")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "C";
    }
    else if (obj["sensor"] == "atmospheric_pressure")
    {
        obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "hPa";
      
    }
    else if (obj["sensor"] == "altitude")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "msnm";
    }
    else if (obj["sensor"] == "ppm")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "ppm";
    }
    else if (obj["sensor"] == "butane")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "ppm";
    }
    else if (obj["sensor"] == "propane")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "ppm";
    }
    else if (obj["sensor"] == "methane")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "ppm";
    }
    else if (obj["sensor"] == "alcohol")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "ppm";
    } else if (obj["sensor"] == "hall")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "V";
    }
    else if (obj["sensor"] == "starter")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "V";
    }
    else if (obj["sensor"] == "bomb")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor

    }
    else if (obj["sensor"] == "refrigerator")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
    }
    else if (obj["sensor"] == "lights")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
    }
    else if (obj["sensor"] == "boiler")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
    } else if (obj["sensor"] == "indoor_hum")
    {
       obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "%";
    }
    else
    {
      Serial.println("Sensor no encontrado");
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

  delay(2000);
}
