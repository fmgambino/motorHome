import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:motor_home/core/common/index.dart';
import 'package:motor_home/core/config/index.dart';

part 'global_event.dart';
part 'global_state.dart';

class GlobalBloc extends HydratedBloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(GlobalState.initial()) {
    on<GlobalEvent>(
      (event, emit) async {
        if (event is AddRequestError) _addRequestError(event, emit);
        if (event is RemoveRequestError) _removeRequestError(event, emit);
        if (event is ChangeHasInternetAccess) _changeHasInternetAccess(event, emit);
      },
    );
  }

  void _addRequestError(AddRequestError event, Emitter<GlobalState> emit) {
    emit(
      state.copyWith(
        requestError: event.requestError,
      ),
    );
  }

  void _removeRequestError(RemoveRequestError event, Emitter<GlobalState> emit) {
    emit(GlobalState.initial());
  }

  void _changeHasInternetAccess(ChangeHasInternetAccess event, Emitter<GlobalState> emit) {
    log('ChangeHasInternetAccess: ${event.hasInternetAccess}');
    emit(
      state.copyWith(
        hasInternetAccess: event.hasInternetAccess,
      ),
    );
  }

  @override
  GlobalState? fromJson(Map<String, dynamic> json) {
    return GlobalState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(GlobalState state) {
    return state.toJson();
  }
}
