### ENGLISH
# Motor Home

Apk Android para Tarjeta de Control y Monitoreo IoT basado en una ESP32.

[circleci-image]: https://img.shields.io/circleci/build/github/nestjs/nest/master?token=abc123def456
[circleci-url]: https://circleci.com/gh/nestjs/nest

![MI-iPhone](https://electronicagambino.com/wp-content/uploads/elementor/thumbs/cropped-Electronica-Gambino-e1684335474114-q6losum0uq8caxhait9doqxx83gv53yq2d8g8oiv7o.png)

![version](https://img.shields.io/badge/version-1.0.0-blue.svg?longCache=true&style=flat-square)
![license](https://img.shields.io/badge/license-MIT-green.svg?longCache=true&style=flat-square)
![theme](https://img.shields.io/badge/theme-Matrix--Admin-lightgrey.svg?longCache=true&style=flat-square)


### Contacto: electronicagambino@gmail.com
### [Web](https://electronicagambino.com) - ELECTRÓNICA GAMBINO

![Eduino32-Lite](https://i.ibb.co/NjThz31/eduino32-Lite-3-D.png)


## Description

This project involves the ESP32 and Raspberry Pi, both of which must send data in the following format:

```json
{
  "data": {
    "sensor": "alcohol",
    "enabled": true,
    "type": "environmental_sensors",
    "valor": 715,
    "unit": "ppm"
  },
  "is_complete": true,
  "topic": "antural/ID_MAC"
}
```

## Types

- `environmental_sensors`
- `level`
- `meteorology`
- `battery`
- `switches`

## Sensors
- `white_water`
- `gray_water`
- `black_water`
- `boiler_diesel`
- `outdoor_temperature`
- `indoor_temperature`
- `refrigerator_temperature`
- `atmospheric_pressure`
- `altitude`
- `ppm`
- `butane`
- `propane`
- `methane`
- `alcohol`
- `hall`
- `starter`
- `indoor_hum`

## Actuators
- `bomb`
- `refrigerator`
- `lights`
- `boiler`

## Data

- `unit` and `valor` should be in the largest unit, for example, L.
- `enabled` can be true or false, indicating whether the sensor is active or not.
- `is_complete` can be true or false, indicating whether the ESP32 has sent all the sensors.
- `topic` will be the name of the device that involves the word `antural`, separated by `/`, followed by its `ID_MAC`.

## Commands Sent by the App to the ESP32

- `pause` - The ESP32 should pause data transmission.
- `resume` - The ESP32 should resume data transmission.
- `name_sensor` - The ESP32 should activate the specified sensor.
- `deselect name_sensor` - The ESP32 should deactivate the specified sensor.

## Testing - ESP32

- The tests were conducted by sending data from each sensor every 3 seconds.

 ### The application transmits metrics to a broker using the `MQTT` protocol in the following manner: 
 * when internet access is available, it sends metrics each time it receives data from the device `(ESP32/Raspberry Pi)`. 
 * In the absence of internet access, it stores the metrics, and every `15 minutes`, it checks for internet connectivity. If available, it sends all the stored metrics and then clears them from the app to prevent unnecessary storage usage.

```json
[
  {
    "id": "ID_MAC",
    "is_complete": true,
    "data": [
      {
        "type": "environmental_sensors",
        "sensors": [
          {
            "name": "alcohol",
            "enabled": true,
            "value": 715,
            "unit": "ppm",
            "timestamp": 1701268981
          }
        ]
      }
    ]
  }
]
```
---

### ESPAÑOL

# Motor Home

## Descripción

Este proyecto involucra el uso de ESP32 y Raspberry Pi, ambos deben enviar datos en el siguiente formato:

```json
{
  "data": {
    "sensor": "alcohol",
    "enabled": true,
    "type": "environmental_sensors",
    "valor": 715,
    "unit": "ppm"
  },
  "is_complete": true,
  "topic": "antural/ID_MAC"
}
```

## Tipos

- `environmental_sensors`
- `level`
- `meteorology`
- `battery`
- `switches`

## Sensores
- `white_water`
- `gray_water`
- `black_water`
- `boiler_diesel`
- `outdoor_temperature`
- `indoor_temperature`
- `refrigerator_temperature`
- `atmospheric_pressure`
- `altitude`
- `ppm`
- `butane`
- `propane`
- `methane`
- `alcohol`
- `hall`
- `starter`
- `indoor_hum`

## Actuatores
- `bomb`
- `refrigerator`
- `lights`
- `boiler`

## Datos

- `unit` y `valor` deben estar en la unidad más grande, por ejemplo, L.
- `enabled` puede ser true o false, indicando si el sensor está activo o no.
- `is_complete` puede ser true o false, indicando si el ESP32 ha enviado todos los sensores.
- `topic` sera el nombre del dispositivo que involucra la palabra `antural` separado por `/` seguido del `ID_MAC` del mismo.

## Comandos Enviados por la Aplicación al ESP32

- `pause` - El ESP32 debe detener la transmisión de datos.
- `resume` - El ESP32 debe reanudar la transmisión de datos.
- `name_sensor` - El ESP32 debe activar el sensor especificado.
- `deselect name_sensor` - El ESP32 debe desactivar el sensor especificado.

## Pruebas - ESP32

- Las pruebas se realizaron enviando datos de cada sensor cada 3 segundos.

## Conclusión

- En conclusión, los datos deben enviarse desde `ESP32/Raspberry Pi`, por sensor, a intervalos regulares para evitar la pérdida de datos. Cuando se envían todos los sensores, el valor de `is_complete` debe establecerse en `true`. La transmisión de datos debe cumplir con el formato mencionado anteriormente.

### la aplicación envía métricas a un broker mediante el protocolo `MQTT` de la siguiente manera:

- Cuando hay acceso a internet, envía métricas cada vez que recibe datos del dispositivo `(ESP32/Raspberry Pi)`.
- En caso de no tener acceso a internet, guarda las métricas y cada `15 minutos` verifica si hay acceso a internet. Si es así, envía todas las métricas almacenadas y luego las borra de la aplicación para evitar el uso innecesario del almacenamiento.

```json
[
  {
    "id": "ID_MAC",
    "is_complete": true,
    "data": [
      {
        "type": "environmental_sensors",
        "sensors": [
          {
            "name": "alcohol",
            "enabled": true,
            "value": 715,
            "unit": "ppm",
            "timestamp": 1701268981
          }
        ]
      }
    ]
  }
]
```
