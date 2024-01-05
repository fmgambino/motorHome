import 'package:freezed_annotation/freezed_annotation.dart';

part 'deposito.freezed.dart';
part 'deposito.g.dart';

@freezed
class Deposito with _$Deposito {
  factory Deposito({
    required int volumen,
    required int alturaMaxima,
    required int alturaMinima,
  }) = _Deposito;

  const Deposito._();

  factory Deposito.fromJson(Map<String, dynamic> json) => _$DepositoFromJson(json);

  double calcularNivel(int alturaActual) {
    return (alturaActual * volumen) / (alturaMaxima - alturaMinima) * 100;
  }
}
