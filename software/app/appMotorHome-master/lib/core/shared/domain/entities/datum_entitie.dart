// import 'package:equatable/equatable.dart';
// import 'package:motor_home/core/shared/domain/entities/sensor_entitie.dart';

// class Datum extends Equatable {

//   const Datum({
//     required this.type,
//     required this.sensors,
//   });
//   final String type;
//   final List<Sensor> sensors;

//   Datum copyWith({
//     String? type,
//     List<Sensor>? sensors,
//   }) =>
//       Datum(
//         type: type ?? this.type,
//         sensors: sensors ?? this.sensors,
//       );

//   @override
//   String toString() {
//     return 'Datum(type: $type, sensors: $sensors)';
//   }

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) || other is Datum && runtimeType == other.runtimeType && type == other.type && sensors == other.sensors;

//   @override
//   int get hashCode => type.hashCode ^ sensors.hashCode;

//   @override
//   List<Object?> get props => [
//         type,
//         sensors,
//       ];
// }
