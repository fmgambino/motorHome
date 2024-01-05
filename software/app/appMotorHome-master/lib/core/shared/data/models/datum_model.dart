// import 'package:motor_home/core/shared/data/models/sensor_model.dart';
// import 'package:motor_home/core/shared/domain/entities/datum_entitie.dart';

// class DatumModel extends Datum {
//   const DatumModel({
//     required super.type,
//     required super.sensors,
//   });

//   factory DatumModel.fromJson(Map<String, dynamic> json) {
//     return DatumModel(
//       type: json['type'] as String,
//       sensors: (json['sensors'] as List<dynamic>)
//           .map(
//             (e) => SensorModel.fromJson(e as Map<String, dynamic>),
//           )
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'type': type,
//       'sensors': sensors
//           .map(
//             (e) => SensorModel(
//               name: e.name,
//               enabled: e.enabled,
//               value: e.value,
//               unit: e.unit,
//               timestamp: e.timestamp,
//             ).toJson(),
//           )
//           .toList(),
//     };
//   }
// }
