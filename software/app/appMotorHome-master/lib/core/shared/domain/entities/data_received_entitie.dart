// import 'package:equatable/equatable.dart';
// import 'package:motor_home/core/shared/domain/entities/datum_entitie.dart';

// class DataReceived extends Equatable {
//   const DataReceived({
//     required this.data,
//     this.isComplete,
//     required this.id,
//   });
//   final List<Datum> data;
//   final bool? isComplete;
//   final String id;

//   DataReceived copyWith({
//     List<Datum>? data,
//     bool? isComplete,
//     String? id,
//   }) =>
//       DataReceived(
//         data: data ?? this.data,
//         isComplete: isComplete ?? this.isComplete,
//         id: id ?? this.id,
//       );

//   @override
//   List<Object?> get props => [
//         data,
//         isComplete,
//         id,
//       ];

//   @override
//   String toString() {
//     return 'DataReceived(data: $data, isComplete: $isComplete, id: $id)';
//   }

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is DataReceived && runtimeType == other.runtimeType && data == other.data && isComplete == other.isComplete && id == other.id;

//   @override
//   int get hashCode => data.hashCode ^ isComplete.hashCode ^ id.hashCode;
// }
