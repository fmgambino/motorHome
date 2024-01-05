import 'package:dartz/dartz.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract class BluetoothRepository {
  Stream<T> startDeviceDiscovery<T>();
  Future<T> getPairedDevices<T>();
  Future<Either<L,R>> connectToDevice<L,R>({required String address});
  Stream<T> listenToDevice<T>({required BluetoothConnection connection});
  Future<void> disconnectFromDevice();
  void cancelDiscovery();
  void cancelListening();
}