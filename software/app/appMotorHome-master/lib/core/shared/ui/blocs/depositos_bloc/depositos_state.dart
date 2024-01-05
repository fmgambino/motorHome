part of 'depositos_bloc.dart';

class DepositosState extends Equatable {
  const DepositosState({
    required this.greyWaters,
    required this.blackWaters,
    required this.cleanWaters,
    required this.gasoil,
    required this.updatedAt,
  });

  factory DepositosState.initial() {
    return DepositosState(
      greyWaters: Deposito(
        alturaMaxima: 25,
        alturaMinima: 5,
        volumen: 100,
      ),
      blackWaters: Deposito(
        alturaMaxima: 35,
        alturaMinima: 5,
        volumen: 55,
      ),
      cleanWaters: Deposito(
        alturaMaxima: 35,
        alturaMinima: 5,
        volumen: 150,
      ),
      gasoil: Deposito(
        alturaMaxima: 35,
        alturaMinima: 5,
        volumen: 10,
      ),
      updatedAt: DateTime.now(),
    );
  }

  factory DepositosState.fromJson(Map<String, dynamic> json) {
    return DepositosState(
      greyWaters: Deposito.fromJson(json['greyWaters'] as Map<String, dynamic>),
      blackWaters: Deposito.fromJson(json['blackWaters'] as Map<String, dynamic>),
      cleanWaters: Deposito.fromJson(json['cleanWaters'] as Map<String, dynamic>),
      gasoil: Deposito.fromJson(json['gasoil'] as Map<String, dynamic>),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'greyWaters': greyWaters.toJson(),
      'blackWaters': blackWaters.toJson(),
      'cleanWaters': cleanWaters.toJson(),
      'gasoil': gasoil.toJson(),
      'updatedAt': updatedAt.toString(),
    };
  }

  DepositosState copyWith({
    Deposito? greyWaters,
    Deposito? blackWaters,
    Deposito? cleanWaters,
    Deposito? gasoil,
  }) {
    return DepositosState(
      greyWaters: greyWaters ?? this.greyWaters,
      blackWaters: blackWaters ?? this.blackWaters,
      cleanWaters: cleanWaters ?? this.cleanWaters,
      gasoil: gasoil ?? this.gasoil,
      updatedAt: DateTime.now(),
    );
  }

  final Deposito greyWaters;
  final Deposito blackWaters;
  final Deposito cleanWaters;
  final Deposito gasoil;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        greyWaters,
        blackWaters,
        cleanWaters,
        gasoil,
        updatedAt,
      ];
}
