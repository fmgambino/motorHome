// import 'package:motor_home/core/shared/domain/entities/sensor_entitie.dart';

// class SensorModel extends Sensor {
//   const SensorModel({
//     required super.name,
//     required super.enabled,
//     required super.value,
//     required super.timestamp,
//     super.unit,
//   });

//   factory SensorModel.fromJson(Map<String, dynamic> json) {
//     return SensorModel(
//       name: json['name'] != null ? json['name'] as String : '',
//       enabled: json['enabled'] != null && json['enabled'] as bool,
//       value: json['value'] != null ? double.tryParse(json['value'].toString()) ?? 0 : 0,
//       unit: json['unit'] != null ? json['unit'] as String : null,
//       timestamp: json['timestamp'] as int?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'enabled': enabled,
//       'value': value,
//       'unit': unit,
//       'timestamp': timestamp,
//     };
//   }
// }
