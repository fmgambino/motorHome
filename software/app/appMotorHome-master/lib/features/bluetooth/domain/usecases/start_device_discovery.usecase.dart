import 'package:motor_home/features/bluetooth/domain/repositories/bluetooth.repository.dart';

class StartDeviceDiscoveryUsecase {
	const StartDeviceDiscoveryUsecase(this.repository);

	final BluetoothRepository repository;

	Stream<T> call<T>() async* {
    yield* repository.startDeviceDiscovery<T>();
  }

}