import 'dart:io';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:motor_home/core/common/index.dart';
import 'package:motor_home/core/shared/domain/usecases/index.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends HydratedBloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc({
    required this.checkConnectivity,
    required this.connectivitySubscription,
    required this.connectivityUnsubscription,
  }) : super(ConnectivityState.initial()) {
    on<ConnectivityEvent>(
      (event, emit) async {
        if (event is CheckConnectivity) await _checkConnectivity(event, emit);
        if (event is ConnectivitySubscription) _connectivitySubscription(event, emit);
        if (event is ConnectivityUnsubscription) _connectivityUnsubscription(event, emit);
        if (event is HasInternetAccess) await _hasInternetAccess(event, emit);
      },
      transformer: concurrent(),
    );

    add(ConnectivitySubscription());
  }
  final CheckConnectivityUsecase checkConnectivity;
  final ConnectivitySubscriptionUsecase connectivitySubscription;
  final ConnectivityUnsubscriptionUsecase connectivityUnsubscription;

  Future<void> _checkConnectivity(ConnectivityEvent event, Emitter<ConnectivityState> emit) async {
    final value = await checkConnectivity();
    emit(state.copyWith(connectivityResult: value));
    add(HasInternetAccess());
  }

  void _connectivitySubscription(ConnectivityEvent event, Emitter<ConnectivityState> emit) {
    connectivitySubscription().listen((event) {
      add(CheckConnectivity());
    });
  }

  void _connectivityUnsubscription(ConnectivityEvent event, Emitter<ConnectivityState> emit) {
    connectivityUnsubscription();
  }

  @override
  Future<void> close() {
    connectivityUnsubscription();
    return super.close();
  }

  Future<void> _hasInternetAccess(HasInternetAccess event, Emitter<ConnectivityState> emit) async {
    var res = <InternetAddress>[];
    if (![ConnectivityResult.mobile, ConnectivityResult.wifi].contains(state.connectivityResult)) {
      addError(HasInternetAccessEnum.noInternetAccess);
      emit(state.copyWith(hasInternetAccessEnum: HasInternetAccessEnum.noInternetAccess));
      return;
    }
    try {
      res = await InternetAddress.lookup('google.com', type: InternetAddressType.IPv4);
    } catch (e) {
      res = [];
    }

    if (res.isEmpty) {
      addError(HasInternetAccessEnum.noInternetAccess);
      emit(state.copyWith(hasInternetAccessEnum: HasInternetAccessEnum.noInternetAccess));
      return;
    }
    if (state.hasInternetAccessEnum == HasInternetAccessEnum.noInternetAccess) {
      addError(HasInternetAccessEnum.hasInternetAccess);
      emit(state.copyWith(hasInternetAccessEnum: HasInternetAccessEnum.hasInternetAccess));
    }
  }

  @override
  ConnectivityState? fromJson(Map<String, dynamic> json) {
    return ConnectivityState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ConnectivityState state) {
    return state.toJson();
  }
}
