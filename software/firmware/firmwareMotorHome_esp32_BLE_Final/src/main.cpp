#include <Arduino.h>
#include <BluetoothSerial.h>
#include <DHT.h>

#include <ArduinoJson.h>
#include <vector>
#include <NewPing.h>
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <OneWire.h>
#include <DallasTemperature.h>

/* #include <Adafruit_BMP280.h>



#define BMP_SCK  (13)
#define BMP_MISO (12)
#define BMP_MOSI (11)
#define BMP_CS   (10)

Adafruit_BMP280 bmp; // I2C
*/

std::vector<String> actuators = {
    "bomb",
    "refrigerator",
    "lights",
    "boiler",
};
BluetoothSerial SerialBT;

#define DHT_PIN 32      // Pin donde está conectado el sensor DHT22
#define DHT_TYPE DHT22 // Tipo de sensor DHT22
#define MAX_SENSORS 21
DHT dht(DHT_PIN, DHT_TYPE); //Inicializa el sensor

// Definición de pines para sensores
const int AI0 = 39;
const int AI1 = 36;
const int ds18b20Pin = 35;
const int dht22Pin = 32;
const int bmp280SDA = 21;
const int bmp280SCL = 22;
const int MQ2Pin = 34;
const int ultaSonicoTRIG[3] = {25, 27, 12};
const int ultaSonicoECHO[3] = {26, 14, 13};

// Definiciones de Pines Actuadores
const int buzzer = 5;
const int relay1 = 4;
const int mosfetQ2 = 16;
const int mosfetQ3 = 17;

/*Adafruit_BMP280 bmp;*/
OneWire oneWire(ds18b20Pin);
DallasTemperature tempRefri(&oneWire);

NewPing sonar[3] = {
  NewPing(ultaSonicoTRIG[0], ultaSonicoECHO[0]),
  NewPing(ultaSonicoTRIG[1], ultaSonicoECHO[1]),
  NewPing(ultaSonicoTRIG[2], ultaSonicoECHO[2])
};


//DEFINICION DE VARIABLES

float tempDHT;
float humDHT;

// Constante de resistencia inicial del sensor (ajusta según la calibración)
const float Ro = 10000.0;  // Coloca el valor de resistencia en condiciones limpias del sensor

// Variables Gases para los valores de ppm
float ppm, butano, propano, metano, alcohol;

float tempRef; // Variable para almacenar la temperatura

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
    "indoor_hum_type_meteorology", // Sensor DTH22  - Humedad Digital Interior MotorHome
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
  // Esperamos a que el monitor serie esté listo
  while (!Serial);

  chipid_mac = ESP.getEfuseMac();
  sprintf(chipid_string, "antural/%04X%08X", (uint16_t)(chipid_mac >> 32), (uint32_t)chipid_mac);
  chipID = String(chipid_string);

  SerialBT.begin(chipID); // Inicia el Bluetooth
  Serial.println(chipID); // Imprime la cadena

  dht.begin();
  tempRefri.begin(); // Iniciar el sensor
//Declarando Actuadores como Salidas digitales

  pinMode(buzzer, OUTPUT);
  pinMode(relay1, OUTPUT);
  pinMode(mosfetQ2, OUTPUT);
  pinMode(mosfetQ3, OUTPUT);

 
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

  
        // Activa el actuador
        switch (i) {
          case 0:
            // Activar Caldera
            digitalWrite(relay1, HIGH);
            break;
          case 1:
            // Activar bomba
            digitalWrite(mosfetQ2, HIGH);
            break;
          case 2:
            // Activar luces
            digitalWrite(mosfetQ3, HIGH);
            break;
          default:
            // No hacer nada
            break;
        }
        // Se sale del bucle for
        return;
      }

  // Si el dato recibido no es un actuador, no se hace nada

          break;
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
// Desactiva el actuador
        switch (i) {
          case 0:
            digitalWrite(relay1, LOW); // Desactivar bomba
            break;
          case 1:
            digitalWrite(mosfetQ2, LOW); // Desactivar refrigerador
            break;
          case 2:
            digitalWrite(mosfetQ3, LOW); // Desactivar luces
            break;
        }

         // Se sale del bucle for
        return;
      }

  // Si el dato recibido no es un actuador, no se hace nada

          break;
        }
      }

  }

  if (!pauseData)
  {
    float Rs = analogRead(MQ2Pin);
    // Calculamos la concentración total en ppm
    ppm = (Rs / Ro) * 1000000;


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
       float tempDHT = dht.readTemperature();
       obj["valor"] = tempDHT; // aqui pone el valor real del sensor
       obj["unit"] = "C";
    }
    else if (obj["sensor"] == "refrigerator_temperature")
    {
       // Solicita la temperatura al sensor.
       tempRefri.requestTemperatures(); // Usando el nuevo nombre

       // Lee la temperatura en grados Celsius.
       tempRef = tempRefri.getTempCByIndex(0);
       obj["valor"] = tempRef; // aqui pone el valor real del sensor
       obj["unit"] = "C";
    }
    else if (obj["sensor"] == "atmospheric_pressure")
    {
        obj["valor"] = 1; // aqui pone el valor real del sensor
       obj["unit"] = "hPa";
      
    }
    else if (obj["sensor"] == "altitude")
    {
  
       obj["valor"] = 5; // aqui pone el valor real del sensor
       obj["unit"] = "msnm";
    }
    else if (obj["sensor"] == "ppm")
    {
       obj["valor"] = ppm; // aqui pone el valor real del sensor
       obj["unit"] = "ppm";
    }
    else if (obj["sensor"] == "butane")
    {
       butano = ppm * 0.02;
       obj["valor"] = butano; // aqui pone el valor real del sensor
       obj["unit"] = "ppm";
    }
    else if (obj["sensor"] == "propane")
    {
       propano = ppm * 0.01;
       obj["valor"] = propano; // aqui pone el valor real del sensor
       obj["unit"] = "ppm";
    }
    else if (obj["sensor"] == "methane")
    {
       metano = ppm * 0.06;
       obj["valor"] = metano; // aqui pone el valor real del sensor
       obj["unit"] = "ppm";
    }
    else if (obj["sensor"] == "alcohol")
    {
       alcohol = ppm * 0.08;
       obj["valor"] = alcohol; // aqui pone el valor real del sensor
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
       obj["valor"] = 3; // aqui pone el valor real del sensor

    } else if (obj["sensor"] == "indoor_hum")
    {  
       float humDHT = dht.readHumidity();
       obj["valor"] = humDHT; // aqui pone el valor real del sensor
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

  delay(700);
}


// FUNCION PARA RESETEO DE PLACA - HARDRESET
 
  int i;
  int count;
void fHardReset()
{

  Serial.print("RESETEO EN: ");
  Serial.println(i);

  if (i == count)
  {
    delay(300);
    ESP.restart(); // PARA ESP32
    Serial.print("HARD-RESET ACTIVADO: ");
    i = 0;
  }
}
