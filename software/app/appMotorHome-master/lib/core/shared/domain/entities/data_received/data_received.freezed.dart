// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_received.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DataReceived _$DataReceivedFromJson(Map<String, dynamic> json) {
  return _DataReceived.fromJson(json);
}

/// @nodoc
mixin _$DataReceived {
  List<Datum> get data => throw _privateConstructorUsedError;
  bool? get isComplete => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DataReceivedCopyWith<DataReceived> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataReceivedCopyWith<$Res> {
  factory $DataReceivedCopyWith(
          DataReceived value, $Res Function(DataReceived) then) =
      _$DataReceivedCopyWithImpl<$Res, DataReceived>;
  @useResult
  $Res call({List<Datum> data, bool? isComplete, String? id});
}

/// @nodoc
class _$DataReceivedCopyWithImpl<$Res, $Val extends DataReceived>
    implements $DataReceivedCopyWith<$Res> {
  _$DataReceivedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? isComplete = freezed,
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Datum>,
      isComplete: freezed == isComplete
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DataReceivedImplCopyWith<$Res>
    implements $DataReceivedCopyWith<$Res> {
  factory _$$DataReceivedImplCopyWith(
          _$DataReceivedImpl value, $Res Function(_$DataReceivedImpl) then) =
      __$$DataReceivedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Datum> data, bool? isComplete, String? id});
}

/// @nodoc
class __$$DataReceivedImplCopyWithImpl<$Res>
    extends _$DataReceivedCopyWithImpl<$Res, _$DataReceivedImpl>
    implements _$$DataReceivedImplCopyWith<$Res> {
  __$$DataReceivedImplCopyWithImpl(
      _$DataReceivedImpl _value, $Res Function(_$DataReceivedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? isComplete = freezed,
    Object? id = freezed,
  }) {
    return _then(_$DataReceivedImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Datum>,
      isComplete: freezed == isComplete
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DataReceivedImpl implements _DataReceived {
  _$DataReceivedImpl(
      {required final List<Datum> data,
      required this.isComplete,
      required this.id})
      : _data = data;

  factory _$DataReceivedImpl.fromJson(Map<String, dynamic> json) =>
      _$$DataReceivedImplFromJson(json);

  final List<Datum> _data;
  @override
  List<Datum> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final bool? isComplete;
  @override
  final String? id;

  @override
  String toString() {
    return 'DataReceived(data: $data, isComplete: $isComplete, id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataReceivedImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.isComplete, isComplete) ||
                other.isComplete == isComplete) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), isComplete, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DataReceivedImplCopyWith<_$DataReceivedImpl> get copyWith =>
      __$$DataReceivedImplCopyWithImpl<_$DataReceivedImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DataReceivedImplToJson(
      this,
    );
  }
}

abstract class _DataReceived implements DataReceived {
  factory _DataReceived(
      {required final List<Datum> data,
      required final bool? isComplete,
      required final String? id}) = _$DataReceivedImpl;

  factory _DataReceived.fromJson(Map<String, dynamic> json) =
      _$DataReceivedImpl.fromJson;

  @override
  List<Datum> get data;
  @override
  bool? get isComplete;
  @override
  String? get id;
  @override
  @JsonKey(ignore: true)
  _$$DataReceivedImplCopyWith<_$DataReceivedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
