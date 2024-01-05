import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

abstract class CoreLocalDataSource {
  Future<ConnectivityResult> checkConnectivity();
  void connectivityUnSubscription();
  Stream<ConnectivityResult> connectivitySubscription();
}

class CoreLocalDataSourceImpl implements CoreLocalDataSource {
  late final StreamSubscription<ConnectivityResult>? connSubscription;
  final StreamController<ConnectivityResult> connectivityResult = StreamController<ConnectivityResult>.broadcast();

  @override
  Future<ConnectivityResult> checkConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result;
    } on PlatformException catch (_) {
      return ConnectivityResult.none;
    }
  }

  @override
  void connectivityUnSubscription() {
    connSubscription?.cancel();
  }

  @override
  Stream<ConnectivityResult> connectivitySubscription() async* {
    connSubscription = Connectivity().onConnectivityChanged.listen(connectivityResult.add);
    yield* connectivityResult.stream;
  }
}
