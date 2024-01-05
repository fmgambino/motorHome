import 'package:motor_home/features/bluetooth/domain/repositories/bluetooth.repository.dart';

class CancelDiscoveryUsecase {
	const CancelDiscoveryUsecase(this.repository);

	final BluetoothRepository repository;

	void call() => repository.cancelDiscovery();

}