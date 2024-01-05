import 'package:motor_home/features/bluetooth/domain/repositories/bluetooth.repository.dart';

class GetPairedDevicesUsecase {
  const GetPairedDevicesUsecase(this.repository);

  final BluetoothRepository repository;

  Future<T> call<T>() async {
    return repository.getPairedDevices();
  }
}
