import 'package:dartz/dartz.dart';
import 'package:motor_home/features/bluetooth/domain/repositories/bluetooth.repository.dart';

class ConnectToDeviceUsecase {
	const ConnectToDeviceUsecase(this.repository);

	final BluetoothRepository repository;

	Future<Either<L,R>> call<L,R>({required String address}) async => repository.connectToDevice(address: address);

}