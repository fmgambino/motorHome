// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_received.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DataReceivedImpl _$$DataReceivedImplFromJson(Map<String, dynamic> json) => _$DataReceivedImpl(
      data: json['data'] != null ? (json['data'] as List<dynamic>).map((e) => Datum.fromJson(e as Map<String, dynamic>)).toList() : [],
      isComplete: json['isComplete'] as bool?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$$DataReceivedImplToJson(_$DataReceivedImpl instance) => <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'isComplete': instance.isComplete,
      'id': instance.id,
    };
