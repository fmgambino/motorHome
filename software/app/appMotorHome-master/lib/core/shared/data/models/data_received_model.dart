// import 'package:motor_home/core/shared/data/models/datum_model.dart';
// import 'package:motor_home/core/shared/domain/entities/data_received_entitie.dart';

// class DataReceivedModel extends DataReceived {
//   const DataReceivedModel({
//     required super.data,
//     required super.id,
//     super.isComplete,
//   });

//   factory DataReceivedModel.fromJson(Map<String, dynamic> json) {
//     final dataList =
//         json['data'] != null ? (json['data'] as List<dynamic>).map((e) => DatumModel.fromJson(e as Map<String, dynamic>)).toList() : List<DatumModel>.empty()
//           ..sort(
//             (a, b) => (b.type == 'switches' ? 1 : 0)..compareTo(a.type == 'switches' ? 1 : 0),
//           );

//     return DataReceivedModel(
//       data: dataList,
//       isComplete: json['is_complete'] as bool?,
//       id: json['id'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'data': data
//           .map(
//             (e) => DatumModel(
//               type: e.type,
//               sensors: e.sensors,
//             ).toJson(),
//           )
//           .toList(),
//       'is_complete': isComplete,
//       'id': id,
//     };
//   }
// }
