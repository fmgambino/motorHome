import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:motor_home/core/shared/domain/entities/datum/datum.dart';

part 'data_received.freezed.dart';
part 'data_received.g.dart';

@freezed
class DataReceived with _$DataReceived {
  factory DataReceived({
    required List<Datum> data,
    required bool? isComplete,
    required String? id,
  }) = _DataReceived;

  factory DataReceived.fromJson(Map<String, dynamic> json) => _$DataReceivedFromJson(json);
}
