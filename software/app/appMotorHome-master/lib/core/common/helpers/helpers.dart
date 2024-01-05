import 'package:flutter/material.dart';
import 'package:motor_home/l10n/l10n.dart';

String toSensorTitle(String code, BuildContext context) {
  final sensorTitles = {
    'white_water': AppLocalizations.of(context).white_water,
    'gray_water': AppLocalizations.of(context).gray_water,
    'black_water': AppLocalizations.of(context).black_water,
    'boiler_diesel': AppLocalizations.of(context).boiler_diesel,
    'outdoor_temperature': AppLocalizations.of(context).outdoor_temperature,
    'indoor_temperature': AppLocalizations.of(context).indoor_temperature,
    'refrigerator_temperature': AppLocalizations.of(context).refrigerator_temperature,
    'atmospheric_pressure': AppLocalizations.of(context).atmospheric_pressure,
    'altitude': AppLocalizations.of(context).altitude,
    'ppm': AppLocalizations.of(context).ppm,
    'butane': AppLocalizations.of(context).butane,
    'propane': AppLocalizations.of(context).propane,
    'methane': AppLocalizations.of(context).methane,
    'alcohol': AppLocalizations.of(context).alcohol,
    'hall': AppLocalizations.of(context).hall,
    'starter': AppLocalizations.of(context).starter,
    'bomb': AppLocalizations.of(context).bomb,
    'refrigerator': AppLocalizations.of(context).refrigerator,
    'lights': AppLocalizations.of(context).lights,
    'boiler': AppLocalizations.of(context).boiler,
    'indoor_hum': AppLocalizations.of(context).indoor_hum,
  };
  return sensorTitles.putIfAbsent(code, () => 'none');
}

Map<String, String> toSensorType(String code, BuildContext context) {
  return {
    'level': AppLocalizations.of(context).level,
    'meteorology': AppLocalizations.of(context).meteorology,
    'environmental_sensors': AppLocalizations.of(context).environmental_sensors,
    'battery': AppLocalizations.of(context).battery,
    'switches': AppLocalizations.of(context).switches,
  };
}

IconData toSensorIcon(String code) {
  final icon = {
    'white_water': Icons.water,
    'gray_water': Icons.water,
    'black_water': Icons.water_damage,
    'boiler_diesel': Icons.local_fire_department,
    'outdoor_temperature': Icons.thermostat,
    'indoor_temperature': Icons.ac_unit,
    'refrigerator_temperature': Icons.kitchen,
    'atmospheric_pressure': Icons.speed,
    'altitude': Icons.height,
    'ppm': Icons.analytics,
    'butane': Icons.local_gas_station,
    'propane': Icons.local_gas_station_outlined,
    'methane': Icons.local_gas_station_sharp,
    'alcohol': Icons.local_bar,
    'hall': Icons.house_siding,
    'starter': Icons.star,
    'bomb': Icons.military_tech,
    'refrigerator': Icons.icecream,
    'lights': Icons.lightbulb_outline_rounded,
    'boiler': Icons.fire_extinguisher,
  };
  return icon.putIfAbsent(code, () => Icons.error);
}

Map<String, String> toImage(String code) {
  return {
    'white_water': 'assets/images/png/nivel-de-agua.png',
    'gray_water': 'assets/images/png/nivel-de-agua.png',
    'black_water': 'assets/images/png/nivel-de-agua.png',
    'boiler_diesel': 'assets/images/png/combustible-de-gas.png',
    'outdoor_temperature': 'assets/images/png/termometro.png',
    'indoor_temperature': 'assets/images/png/termometro.png',
    'refrigerator_temperature': 'assets/images/png/nevera.png',
    'atmospheric_pressure': 'assets/images/png/atmosferico.png',
    'altitude': 'assets/images/png/altitud.png',
    'ppm': 'assets/images/png/ppm.png',
    'butane': 'assets/images/png/butano.png',
    'propane': 'assets/images/png/propano.png',
    'methane': 'assets/images/png/metano.png',
    'alcohol': 'assets/images/png/alcohol.png',
    'hall': 'assets/images/png/salon.png',
    'starter': 'assets/images/png/bateria.png',
    'bomb': 'assets/images/png/bomba.png',
    'refrigerator': 'assets/images/png/heladera.png',
    'lights': 'assets/images/svg/tanque.svg',
    'boiler': 'assets/images/svg/caldera.svg',
    'indoor_hum': 'assets/images/png/humidity.png'
  };
}

enum ProtocolType { bluetooth, mqtt }
