import 'package:flutter/material.dart';

class SensorInformation {

  SensorInformation({
    required this.sensorName,
    required this.sensorValue,
    required this.sensorIcon,
  });
  final String sensorName;
  final String sensorValue;
  final IconData sensorIcon;
}