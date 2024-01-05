// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DatumImpl _$$DatumImplFromJson(Map<String, dynamic> json) => _$DatumImpl(
      type: json['type'] as String,
      sensors: (json['sensors'] as List<dynamic>).map((e) => Sensor.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$$DatumImplToJson(_$DatumImpl instance) => <String, dynamic>{
      'type': instance.type,
      'sensors': instance.sensors.map((e) => e.toJson()).toList(),
    };
