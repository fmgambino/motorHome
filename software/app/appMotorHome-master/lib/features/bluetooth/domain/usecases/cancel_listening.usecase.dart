import 'package:motor_home/features/bluetooth/domain/repositories/bluetooth.repository.dart';

class CancelListeningUsecase {
	const CancelListeningUsecase(this.repository);

	final BluetoothRepository repository;

	void call() => repository.cancelListening();

}