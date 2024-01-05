import 'package:connectivity_plus/connectivity_plus.dart' show ConnectivityResult;
import 'package:motor_home/core/shared/domain/repositories/core.repository.dart';

class CheckConnectivityUsecase {
  CheckConnectivityUsecase(this.coreRepository);
  final CoreRepository coreRepository;

  Future<ConnectivityResult> call() async => coreRepository.checkConnectivity();
}
