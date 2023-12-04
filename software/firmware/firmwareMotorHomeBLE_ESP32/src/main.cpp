#include <Arduino.h>
#include <BluetoothSerial.h>
#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <Adafruit_BMP280.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <NewPing.h>
#include <ArduinoJson.h>
#include <cstdio>

// #include <cstdio.h>
BluetoothSerial SerialBT;

#define DHT_PIN 2      // Pin donde está conectado el sensor DHT22
#define DHT_TYPE DHT22 // Tipo de sensor DHT22
#define MAX_SENSORS 20
DHT dht(DHT_PIN, DHT_TYPE);

// Definición de pines para sensores
const int AI0 = 39;
const int AI1 = 36;
const int ds18b20Pin = 35;
const int dht22Pin = 34;
const int bmp280SDA = 21;
const int bmp280SCL = 22;
const int MQ2Pin = 16;
const int ultaSonicoTRIG[3] = {25, 27, 12};
const int ultaSonicoECHO[3] = {26, 14, 13};

// Definiciones de Pines Actuadores
const int buzzer = 5;
const int relay1 = 4;
const int mosfetQ2 = 16;
const int mosfetQ3 = 17;

Adafruit_BMP280 bmp;
OneWire oneWire(ds18b20Pin);
DallasTemperature sensors(&oneWire);
NewPing sonar[3] = {
  NewPing(ultaSonicoTRIG[0], ultaSonicoECHO[0]),
  NewPing(ultaSonicoTRIG[1], ultaSonicoECHO[1]),
  NewPing(ultaSonicoTRIG[2], ultaSonicoECHO[2])
};

#define TRIGGER_PIN_WHITE_WATER 25
#define ECHO_PIN_WHITE_WATER 26
#define TRIGGER_PIN_GRAY_WATER 27
#define ECHO_PIN_GRAY_WATER 14
#define TRIGGER_PIN_BLACK_WATER 12
#define ECHO_PIN_BLACK_WATER 13

NewPing sonarWW(TRIGGER_PIN_WHITE_WATER, ECHO_PIN_WHITE_WATER, 200);
NewPing sonarGW(TRIGGER_PIN_GRAY_WATER, ECHO_PIN_GRAY_WATER, 200);
NewPing sonarBW(TRIGGER_PIN_BLACK_WATER, ECHO_PIN_BLACK_WATER, 200);

StaticJsonDocument<4096> doc;
JsonArray data = doc.createNestedArray("data");





  


String sensorsArray[MAX_SENSORS] = {
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

int objIndices[MAX_SENSORS];

bool isValidSensor(String sensor) {
  for (int i = 0; i < MAX_SENSORS; i++) {
    if (sensorsArray[i] == sensor) {
      return true;
    }
  }
  return false;
}

// DECLARACION DE FUNCIONES SENSORES
void initializeSensors() {
  sensors.begin();
  if (!bmp.begin(bmp280SDA, bmp280SCL)) {
    Serial.println(F("No se pudo encontrar el sensor BMP280, verifica la conexión."));
    while (1);
  }
}

void readDHT22(float& temperature, float& humidity) {
  temperature = dht.readTemperature();
  humidity = dht.readHumidity();
}

float readTemperatureDS18B20() {
  sensors.requestTemperatures();
  return sensors.getTempCByIndex(0);
}

float readPressureBMP280() {
  return bmp.readPressure() / 100.0;
}

int readUltrasonicDistance(int sensorIndex) {
  return sonar[sensorIndex].ping_cm();
}

int whiteWater() {
int distancia = sonarWW.ping_cm();

  // Calcular el nivel de agua
  int nivel = 100 - distancia;
 return nivel;
}

int grayWater() {
int distancia = sonarGW.ping_cm();

  // Calcular el nivel de agua
  int nivel = 100 - distancia;
 return nivel;
}

int blackWater() {
int distancia = sonarBW.ping_cm();

  // Calcular el nivel de agua
  int nivel = 100 - distancia;
 return nivel;
}

float checkTankStatus();

int readMQ2Gas() {
  int sensorValue = analogRead(MQ2Pin);
  float voltage = sensorValue * (5.0 / 1023.0);
  float RS = (5.0 - voltage) / voltage;
  float MQ_Ro = RS / 9.8;  // Valor típico para el sensor MQ2 en aire limpio
  float MQ2Curve[2] = {2.0, 0.3};  // Ajusta la curva característica según la hoja de datos
  float ppm = pow(10, ((log10(RS / MQ_Ro) - MQ2Curve[1]) / MQ2Curve[0]));
  return int(ppm);
}

float readAnalogSensor(int pin) {
  return analogRead(pin);
}

void updateSensor(JsonObject& obj, const String& sensorName, int minVal, int maxVal, const String& unit) {




  if (obj["sensor"].as<String>().indexOf(sensorName) != -1) {
    if (sensorName == "temperature") {
      obj["valor"] = readTemperatureDS18B20();
    } else if (sensorName == "humidity") {
      float temperature, humidity;
      readDHT22(temperature, humidity);
      obj["valor"] = humidity;
    } else if (sensorName == "temperatureDHT22") {
      float temperature, humidity;
      readDHT22(temperature, humidity);
      obj["valor"] = temperature;
    } else if (sensorName == "pressure") {
      obj["valor"] = readPressureBMP280();
    } else if (sensorName.startsWith("ultasonic")) {
      int sensorIndex = sensorName.substring(9).toInt() - 1;
      obj["valor"] = readUltrasonicDistance(sensorIndex);
    } else if (sensorName == "MQ2") {
      obj["valor"] = readMQ2Gas();
    } else {
      obj["valor"] = readAnalogSensor(AI0);
    }
    obj["unit"] = unit;
  }
}

// DECLARACION DE FUNCIONES ACTUADORES

void controlBuzzer(int value) {
  // Lógica de control para el buzzer
  digitalWrite(buzzer, value == 1 ? HIGH : LOW);
}

void controlRelay(int value) {
  // Lógica de control para el relay
  digitalWrite(relay1, value == 1 ? HIGH : LOW);
}

void controlMosfetQ2(int value) {
  // Lógica de control para el Mosfet Q2
  digitalWrite(mosfetQ2, value == 1 ? HIGH : LOW);
}

void controlMosfetQ3(int value) {
  // Lógica de control para el Mosfet Q3
  digitalWrite(mosfetQ3, value == 1 ? HIGH : LOW);
}

void handleActuatorCommands(String actuatorName, int value) {
  if (actuatorName == "buzzer") {
    controlBuzzer(value);
  } else if (actuatorName == "relay1") {
    controlRelay(value);
  } else if (actuatorName == "mosfetQ2") {
    controlMosfetQ2(value);
  } else if (actuatorName == "mosfetQ3") {
    controlMosfetQ3(value);
  }
  // Agrega más condiciones según sea necesario para otros actuadores
}

void handleBluetoothCommands() {
  if (SerialBT.available()) {
    String receivedData = SerialBT.readString();
    receivedData.trim();

    Serial.println(receivedData);

    if (receivedData == "pause") {
      pauseData = true;
    }
    if (receivedData == "resume") {
      pauseData = false;
    }

    if (receivedData == "all") {
      for (int i = 0; i < MAX_SENSORS; i++) {
        JsonObject obj = data[objIndices[i]];
        obj["enabled"] = true;
      }
    }

    if (receivedData == "clear") {
      for (int i = 0; i < MAX_SENSORS; i++) {
        JsonObject obj = data[objIndices[i]];
        obj["enabled"] = false;
      }
    }

    if (isValidSensor(receivedData)) {
      for (int i = 0; i < MAX_SENSORS; i++) {
        JsonObject obj = data[objIndices[i]];
        if (obj["sensor"] == receivedData) {
          obj["enabled"] = true;
          break;
        }
      }
    } else if (receivedData.startsWith("deselect ")) {
      String sensor = receivedData.substring(9);
      for (int i = 0; i < MAX_SENSORS; i++) {
        JsonObject obj = data[objIndices[i]];
        if (obj["sensor"] == sensor) {
          obj["enabled"] = false;
          break;
        }
      }
    } else if (receivedData.startsWith("control ")) {
      String controlData = receivedData.substring(8);
      int separatorIndex = controlData.indexOf(' ');
      if (separatorIndex != -1) {
        String actuatorName = controlData.substring(0, separatorIndex);
        int value = controlData.substring(separatorIndex + 1).toInt();
        handleActuatorCommands(actuatorName, value);
      }
    }
  }
}

void sendSensorData() {
  if (!pauseData) {
    for (int i = 0; i < MAX_SENSORS; i++) {
      JsonObject obj = data[objIndices[i]];
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
    }

    StaticJsonDocument<4096> docToSend;
    docToSend["data"] = data;
    docToSend["is_complete"] = isComplete;
    docToSend["topic"] = chipID;

    String dataToSend;
    serializeJson(docToSend, dataToSend);
    SerialBT.println(dataToSend);
  }
}

void setup() {
  pinMode(buzzer, OUTPUT);
  pinMode(relay1, OUTPUT);
  pinMode(mosfetQ2, OUTPUT);
  pinMode(mosfetQ3, OUTPUT);

  Serial.begin(115200);
  chipid_mac = ESP.getEfuseMac(); // Obtiene el MAC del chip

  sprintf(chipid_string, "antural/%04X%08X", (uint16_t)(chipid_mac >> 32), (uint32_t)chipid_mac); // Formatea el ID del chip
  chipID = String(chipid_string);                                                                // Convierte a String
  SerialBT.begin(chipID);                                                                         // Inicia el Bluetooth
  Serial.println(chipID);                                                                         // Imprime la cadena

  dht.begin();
  initializeSensors();

  for (int i = 0; i < MAX_SENSORS; i++) {
    JsonObject obj = data.createNestedObject();

    String sensor = sensorsArray[i];
    int underscoreIndex = sensor.indexOf("_type_");

    if (underscoreIndex != -1) {
      String sensorName = sensor.substring(0, underscoreIndex);
      String sensorType = sensor.substring(underscoreIndex + 6);

      obj["sensor"] = sensorName;
      obj["enabled"] = true;
      obj["type"] = sensorType;
    } else {
      obj["sensor"] = sensor;
      obj["enabled"] = true;
    }

    objIndices[i] = data.size() - 1;
  }
}

void loop() {
  handleBluetoothCommands();
  sendSensorData();

  // Lógica de control de actuadores
  if (!pauseData) {
    checkTankStatus(); // Verifica niveles de tanques

    // Ejemplo: Si el nivel de butano es alto, activar el relay
    JsonObject butaneObj = data[objIndices[9]]; // Suponiendo que "butane_type_environmental_sensors" está en la posición 9
    int butaneValue = butaneObj["valor"];

    if (butaneValue > 500) {
      controlRelay(1);
    } else {
      controlRelay(0);
    }

    checkTankStatus();  // Comprobar estado de los tanques y niveles de gas

    // Puedes agregar más lógica de control de actuadores según tus necesidades
  }

  delay(10000); // Ajusta según la frecuencia deseada
}
