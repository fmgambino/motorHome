import 'package:dartz/dartz.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:motor_home/features/bluetooth/data/datasources/local/bluetooth_local_datasource.dart';
import 'package:motor_home/features/bluetooth/domain/index.dart';

class BluetoothRepositoryImpl extends BluetoothRepository {
  BluetoothRepositoryImpl({required this.localSource});

  final BluetoothLocalDatasource localSource;

  @override
  Stream<T> startDeviceDiscovery<T>() async* {
    yield* localSource.startDeviceDiscovery<T>();
  }

  @override
  Future<T> getPairedDevices<T>() async {
    return localSource.getPairedDevices<T>();
  }

  @override
  Future<Either<L,R>> connectToDevice<L,R>({required String address}) async {
    return localSource.connectToDevice<L,R>(address: address);
  }

  @override
  Stream<T> listenToDevice<T>({required BluetoothConnection connection}) async* {
    yield* localSource.listenToDevice<T>(connection: connection);
  }

	@override
	void cancelDiscovery() => localSource.cancelDiscovery();

	@override
	void cancelListening() => localSource.cancelListening();
  
   @override
   Future<void> disconnectFromDevice() async {
     await localSource.disconnectFromDevice();
   }
}