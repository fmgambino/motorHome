import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:motor_home/core/shared/domain/entities/deposito/deposito.dart';

part 'depositos_event.dart';
part 'depositos_state.dart';

class DepositosBloc extends HydratedBloc<DepositosEvent, DepositosState> {
  DepositosBloc() : super(DepositosState.initial()) {
    on<DepositosEvent>(
      (event, emit) async {
        if (event is ChangeGreyWaters) _changeGreyWaters(event, emit);
        if (event is ChangeBlackWaters) _changeBlackWaters(event, emit);
        if (event is ChangeCleanWaters) _changeCleanWaters(event, emit);
        if (event is ChangeGasoil) _changeGasoil(event, emit);
        if (event is ChangeAllDepositos) _changeAllDepositos(event, emit);
        if (event is ResetDepositos) emit(DepositosState.initial());
      },
      transformer: concurrent(),
    );
  }

  @override
  DepositosState? fromJson(Map<String, dynamic> json) {
    return DepositosState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(DepositosState state) {
    return state.toJson();
  }

  void _changeGreyWaters(ChangeGreyWaters event, Emitter<DepositosState> emit) {
    emit(state.copyWith(greyWaters: event.greyWaters));
  }

  void _changeBlackWaters(ChangeBlackWaters event, Emitter<DepositosState> emit) {
    emit(state.copyWith(blackWaters: event.blackWaters));
  }

  void _changeCleanWaters(ChangeCleanWaters event, Emitter<DepositosState> emit) {
    emit(state.copyWith(cleanWaters: event.cleanWaters));
  }

  void _changeGasoil(ChangeGasoil event, Emitter<DepositosState> emit) {
    emit(state.copyWith(gasoil: event.gasoil));
  }

  void _changeAllDepositos(ChangeAllDepositos event, Emitter<DepositosState> emit) {
    emit(
      state.copyWith(
        greyWaters: event.greyWaters,
        blackWaters: event.blackWaters,
        cleanWaters: event.cleanWaters,
        gasoil: event.gasoil,
      ),
    );
  }
}
