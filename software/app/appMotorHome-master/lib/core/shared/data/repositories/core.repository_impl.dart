import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:motor_home/core/shared/data/datasources/index.dart';
import 'package:motor_home/core/shared/domain/repositories/core.repository.dart';

class CoreRepositoryImpl extends CoreRepository {
  CoreRepositoryImpl({
    required this.local,
  });

  final CoreLocalDataSource local;

  @override
  Future<ConnectivityResult> checkConnectivity() {
    return local.checkConnectivity();
  }

  @override
  Stream<ConnectivityResult> connectivitySubscription() async* {
    yield* local.connectivitySubscription();
  }

  @override
  void connectivityUnSubscription() {
    local.connectivityUnSubscription();
  }
}
