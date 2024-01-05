// import 'package:equatable/equatable.dart';

// class Sensor extends Equatable {
//   const Sensor({
//     required this.name,
//     required this.enabled,
//     required this.value,
//     required this.timestamp,
//     this.unit,
//   });

//   double convertUnit() {
//     if (unit == 'C') {
//       return (value * 9 / 5) + 32;
//     } else if (unit == 'F') {
//       return (value - 32) * 5 / 9;
//     } else if (unit == 'L') {
//       return value * 1000;
//     } else if (unit == 'mL') {
//       return value / 1000;
//     } else if (unit == 'hPa' || unit == 'mbar') {
//       return value;
//     } else if (unit == 'V') {
//       return value * 1000;
//     } else if (unit == 'mV') {
//       return value / 1000;
//     }
//     return value;
//   }

//   String convert() {
//     if (unit == 'C') {
//       return 'F';
//     } else if (unit == 'F') {
//       return 'C';
//     } else if (unit == 'L') {
//       return 'mL';
//     } else if (unit == 'mL') {
//       return 'L';
//     } else if (unit == 'hPa') {
//       return 'mbar';
//     } else if (unit == 'mbar') {
//       return 'hPa';
//     } else if (unit == 'V') {
//       return 'mV';
//     } else if (unit == 'mV') {
//       return 'V';
//     }
//     return unit!;
//   }

//   final String name;
//   final bool enabled;
//   final double value;
//   final String? unit;
//   final int? timestamp;

//   Sensor copyWith({
//     String? name,
//     bool? enabled,
//     double? value,
//     String? unit,
//     int? timestamp,
//   }) =>
//       Sensor(
//         name: name ?? this.name,
//         enabled: enabled ?? this.enabled,
//         value: value ?? this.value,
//         unit: unit ?? this.unit,
//         timestamp: timestamp ?? this.timestamp,
//       );

//   @override
//   List<Object?> get props => [
//         name,
//         enabled,
//         value,
//         unit,
//         timestamp,
//       ];

//   @override
//   String toString() {
//     return 'Sensor(name: $name, enabled: $enabled, value: $value, unit: $unit, timestamp: $timestamp)';
//   }

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Sensor &&
//           runtimeType == other.runtimeType &&
//           name == other.name &&
//           enabled == other.enabled &&
//           value == other.value &&
//           timestamp == other.timestamp;

//   @override
//   int get hashCode => name.hashCode ^ enabled.hashCode ^ value.hashCode ^ timestamp.hashCode;
// }
