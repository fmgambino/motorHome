// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deposito.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Deposito _$DepositoFromJson(Map<String, dynamic> json) {
  return _Deposito.fromJson(json);
}

/// @nodoc
mixin _$Deposito {
  int get volumen => throw _privateConstructorUsedError;
  int get alturaMaxima => throw _privateConstructorUsedError;
  int get alturaMinima => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DepositoCopyWith<Deposito> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DepositoCopyWith<$Res> {
  factory $DepositoCopyWith(Deposito value, $Res Function(Deposito) then) =
      _$DepositoCopyWithImpl<$Res, Deposito>;
  @useResult
  $Res call({int volumen, int alturaMaxima, int alturaMinima});
}

/// @nodoc
class _$DepositoCopyWithImpl<$Res, $Val extends Deposito>
    implements $DepositoCopyWith<$Res> {
  _$DepositoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? volumen = null,
    Object? alturaMaxima = null,
    Object? alturaMinima = null,
  }) {
    return _then(_value.copyWith(
      volumen: null == volumen
          ? _value.volumen
          : volumen // ignore: cast_nullable_to_non_nullable
              as int,
      alturaMaxima: null == alturaMaxima
          ? _value.alturaMaxima
          : alturaMaxima // ignore: cast_nullable_to_non_nullable
              as int,
      alturaMinima: null == alturaMinima
          ? _value.alturaMinima
          : alturaMinima // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DepositoImplCopyWith<$Res>
    implements $DepositoCopyWith<$Res> {
  factory _$$DepositoImplCopyWith(
          _$DepositoImpl value, $Res Function(_$DepositoImpl) then) =
      __$$DepositoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int volumen, int alturaMaxima, int alturaMinima});
}

/// @nodoc
class __$$DepositoImplCopyWithImpl<$Res>
    extends _$DepositoCopyWithImpl<$Res, _$DepositoImpl>
    implements _$$DepositoImplCopyWith<$Res> {
  __$$DepositoImplCopyWithImpl(
      _$DepositoImpl _value, $Res Function(_$DepositoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? volumen = null,
    Object? alturaMaxima = null,
    Object? alturaMinima = null,
  }) {
    return _then(_$DepositoImpl(
      volumen: null == volumen
          ? _value.volumen
          : volumen // ignore: cast_nullable_to_non_nullable
              as int,
      alturaMaxima: null == alturaMaxima
          ? _value.alturaMaxima
          : alturaMaxima // ignore: cast_nullable_to_non_nullable
              as int,
      alturaMinima: null == alturaMinima
          ? _value.alturaMinima
          : alturaMinima // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DepositoImpl extends _Deposito {
  _$DepositoImpl(
      {required this.volumen,
      required this.alturaMaxima,
      required this.alturaMinima})
      : super._();

  factory _$DepositoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DepositoImplFromJson(json);

  @override
  final int volumen;
  @override
  final int alturaMaxima;
  @override
  final int alturaMinima;

  @override
  String toString() {
    return 'Deposito(volumen: $volumen, alturaMaxima: $alturaMaxima, alturaMinima: $alturaMinima)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DepositoImpl &&
            (identical(other.volumen, volumen) || other.volumen == volumen) &&
            (identical(other.alturaMaxima, alturaMaxima) ||
                other.alturaMaxima == alturaMaxima) &&
            (identical(other.alturaMinima, alturaMinima) ||
                other.alturaMinima == alturaMinima));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, volumen, alturaMaxima, alturaMinima);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DepositoImplCopyWith<_$DepositoImpl> get copyWith =>
      __$$DepositoImplCopyWithImpl<_$DepositoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DepositoImplToJson(
      this,
    );
  }
}

abstract class _Deposito extends Deposito {
  factory _Deposito(
      {required final int volumen,
      required final int alturaMaxima,
      required final int alturaMinima}) = _$DepositoImpl;
  _Deposito._() : super._();

  factory _Deposito.fromJson(Map<String, dynamic> json) =
      _$DepositoImpl.fromJson;

  @override
  int get volumen;
  @override
  int get alturaMaxima;
  @override
  int get alturaMinima;
  @override
  @JsonKey(ignore: true)
  _$$DepositoImplCopyWith<_$DepositoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
