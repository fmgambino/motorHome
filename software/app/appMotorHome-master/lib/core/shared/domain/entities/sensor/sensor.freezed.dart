// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sensor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Sensor _$SensorFromJson(Map<String, dynamic> json) {
  return _Sensor.fromJson(json);
}

/// @nodoc
mixin _$Sensor {
  String get name => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  int? get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SensorCopyWith<Sensor> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SensorCopyWith<$Res> {
  factory $SensorCopyWith(Sensor value, $Res Function(Sensor) then) =
      _$SensorCopyWithImpl<$Res, Sensor>;
  @useResult
  $Res call(
      {String name, bool enabled, double value, String? unit, int? timestamp});
}

/// @nodoc
class _$SensorCopyWithImpl<$Res, $Val extends Sensor>
    implements $SensorCopyWith<$Res> {
  _$SensorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? enabled = null,
    Object? value = null,
    Object? unit = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SensorImplCopyWith<$Res> implements $SensorCopyWith<$Res> {
  factory _$$SensorImplCopyWith(
          _$SensorImpl value, $Res Function(_$SensorImpl) then) =
      __$$SensorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, bool enabled, double value, String? unit, int? timestamp});
}

/// @nodoc
class __$$SensorImplCopyWithImpl<$Res>
    extends _$SensorCopyWithImpl<$Res, _$SensorImpl>
    implements _$$SensorImplCopyWith<$Res> {
  __$$SensorImplCopyWithImpl(
      _$SensorImpl _value, $Res Function(_$SensorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? enabled = null,
    Object? value = null,
    Object? unit = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_$SensorImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SensorImpl implements _Sensor {
  _$SensorImpl(
      {required this.name,
      required this.enabled,
      required this.value,
      required this.unit,
      required this.timestamp});

  factory _$SensorImpl.fromJson(Map<String, dynamic> json) =>
      _$$SensorImplFromJson(json);

  @override
  final String name;
  @override
  final bool enabled;
  @override
  final double value;
  @override
  final String? unit;
  @override
  final int? timestamp;

  @override
  String toString() {
    return 'Sensor(name: $name, enabled: $enabled, value: $value, unit: $unit, timestamp: $timestamp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SensorImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, enabled, value, unit, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SensorImplCopyWith<_$SensorImpl> get copyWith =>
      __$$SensorImplCopyWithImpl<_$SensorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SensorImplToJson(
      this,
    );
  }
}

abstract class _Sensor implements Sensor {
  factory _Sensor(
      {required final String name,
      required final bool enabled,
      required final double value,
      required final String? unit,
      required final int? timestamp}) = _$SensorImpl;

  factory _Sensor.fromJson(Map<String, dynamic> json) = _$SensorImpl.fromJson;

  @override
  String get name;
  @override
  bool get enabled;
  @override
  double get value;
  @override
  String? get unit;
  @override
  int? get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$SensorImplCopyWith<_$SensorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
