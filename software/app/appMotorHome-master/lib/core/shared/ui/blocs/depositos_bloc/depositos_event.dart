part of 'depositos_bloc.dart';

sealed class DepositosEvent extends Equatable {
  const DepositosEvent();

  @override
  List<Object> get props => [];
}

class ChangeGreyWaters extends DepositosEvent {
  const ChangeGreyWaters(this.greyWaters);

  final Deposito greyWaters;

  @override
  List<Object> get props => [greyWaters];
}

class ChangeBlackWaters extends DepositosEvent {
  const ChangeBlackWaters(this.blackWaters);

  final Deposito blackWaters;

  @override
  List<Object> get props => [blackWaters];
}

class ChangeCleanWaters extends DepositosEvent {
  const ChangeCleanWaters(this.cleanWaters);

  final Deposito cleanWaters;

  @override
  List<Object> get props => [cleanWaters];
}

class ChangeGasoil extends DepositosEvent {
  const ChangeGasoil(this.gasoil);

  final Deposito gasoil;

  @override
  List<Object> get props => [gasoil];
}

class ChangeAllDepositos extends DepositosEvent {
  const ChangeAllDepositos({
    required this.greyWaters,
    required this.blackWaters,
    required this.cleanWaters,
    required this.gasoil,
  });

  final Deposito greyWaters;
  final Deposito blackWaters;
  final Deposito cleanWaters;
  final Deposito gasoil;

  @override
  List<Object> get props => [
        greyWaters,
        blackWaters,
        cleanWaters,
        gasoil,
      ];
}

class ResetDepositos extends DepositosEvent {}
