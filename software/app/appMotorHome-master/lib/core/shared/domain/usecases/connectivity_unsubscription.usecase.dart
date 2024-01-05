import 'package:motor_home/core/shared/domain/repositories/core.repository.dart';

class ConnectivityUnsubscriptionUsecase {
  ConnectivityUnsubscriptionUsecase(this.coreRepository);
  final CoreRepository coreRepository;

  void call() => coreRepository.connectivityUnSubscription();
}
