import 'package:motor_home/features/bluetooth/domain/repositories/bluetooth.repository.dart';

class DisconnectFromDeviceUsecase {
	const DisconnectFromDeviceUsecase(this.repository);

	final BluetoothRepository repository;

	Future<void> call<T>() async  { await repository.disconnectFromDevice(); }

}