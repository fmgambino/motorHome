// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SensorImpl _$$SensorImplFromJson(Map<String, dynamic> json) => _$SensorImpl(
      name: json['name'] as String,
      enabled: json['enabled'] as bool,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String?,
      timestamp: json['timestamp'] as int?,
    );

Map<String, dynamic> _$$SensorImplToJson(_$SensorImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'enabled': instance.enabled,
      'value': instance.value,
      'unit': instance.unit,
      'timestamp': instance.timestamp,
    };
