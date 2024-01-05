import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:motor_home/core/shared/domain/repositories/core.repository.dart';

class ConnectivitySubscriptionUsecase {
  ConnectivitySubscriptionUsecase(this.coreRepository);
  final CoreRepository coreRepository;

  Stream<ConnectivityResult> call() async* {
    yield* coreRepository.connectivitySubscription();
  }
}
