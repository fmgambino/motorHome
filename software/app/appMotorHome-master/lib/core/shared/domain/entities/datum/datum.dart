import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:motor_home/core/shared/domain/entities/sensor/sensor.dart';

part 'datum.freezed.dart';
part 'datum.g.dart';

@freezed
class Datum with _$Datum {
  factory Datum({
    required String type,
    required List<Sensor> sensors,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}
