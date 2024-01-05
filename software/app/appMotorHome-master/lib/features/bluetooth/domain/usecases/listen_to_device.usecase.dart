import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:motor_home/features/bluetooth/domain/repositories/bluetooth.repository.dart';

class ListenToDeviceUsecase {
  const ListenToDeviceUsecase(this.repository);

  final BluetoothRepository repository;

  Stream<T> call<T>({required BluetoothConnection connection}) async* {
    yield* repository.listenToDevice(connection: connection);
  }
}
