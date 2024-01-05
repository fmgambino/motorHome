import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:motor_home/features/bluetooth/domain/entities/index.dart';

abstract class BluetoothLocalDatasource {
  Stream<T> startDeviceDiscovery<T>();
  Future<T> getPairedDevices<T>();
  Future<Either<L, R>> connectToDevice<L, R>({required String address});
  Stream<T> listenToDevice<T>({required BluetoothConnection connection});

  Future<void> disconnectFromDevice();
  void cancelDiscovery();
  void cancelListening();
}

class BluetoothLocalDatasourceImpl implements BluetoothLocalDatasource {
  BluetoothLocalDatasourceImpl();

  StreamSubscription<BluetoothDiscoveryResult>? streamSubscription;
  StreamController<DeviceWithAvailability?> devices = StreamController<DeviceWithAvailability?>.broadcast();

  StreamSubscription<Uint8List>? streamSubscription2;
  StreamController<Uint8List?> data = StreamController<Uint8List?>.broadcast();

  @override
  Stream<T> startDeviceDiscovery<T>() async* {
    if (devices.isClosed) {
      devices = StreamController<DeviceWithAvailability?>.broadcast();
    }
    streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen(
      (r) {
        devices.add(
          DeviceWithAvailability(
            r.device,
            r.device.isBonded ? DeviceAvailability.yes : DeviceAvailability.maybe,
            r.rssi,
          ),
        );
      },
    )..onDone(() {
        devices
          ..add(null)
          ..close();
      });
    yield* devices.stream as Stream<T>;
  }

  @override
  void cancelDiscovery() {
    streamSubscription?.cancel();
  }

  @override
  Future<T> getPairedDevices<T>() async {
    return FlutterBluetoothSerial.instance.getBondedDevices().then(
          (List<BluetoothDevice> bondedDevices) => bondedDevices
              .map(
                (e) => DeviceWithAvailability(
                  e,
                  DeviceAvailability.yes,
                ),
              )
              .toList() as T,
        );
  }

  @override
  Future<Either<L, R>> connectToDevice<L, R>({required String address}) async {
    try {
      final connection = await BluetoothConnection.toAddress(address);
      log('connection: $connection');
      return Right(connection as R);
    } on PlatformException catch (e) {
      return Left(e as L);
    }

    // try {
    //   final connection = await BluetoothConnection.toAddress(address);
    //   return connection as T;
    // } catch (e) {
    //   return -1 as T;
    // }

    // final connection = await BluetoothConnection.toAddress(address);
    // return connection as T;
  }

  @override
  Stream<T> listenToDevice<T>({required BluetoothConnection connection}) async* {
    if (data.isClosed) {
      data = StreamController<Uint8List?>.broadcast();
    }
    streamSubscription2 = connection.input!.listen(
      (data) {
        if (!this.data.isClosed) {
          this.data.add(data);
        }
      },
    )
      ..onDone(() {
        log('listenToDevice - onDone');
        if (!data.isClosed) {
          data
            ..add(null)
            ..close();
        }
      })
      ..onError((e) {
        log('listenToDevice - onError: $e');
        if (!data.isClosed) {
          data
            ..add(null)
            ..close();
        }
      });
    yield* data.stream as Stream<T>;
  }

  @override
  void cancelListening() {
    streamSubscription2?.cancel();
  }

  @override
  Future<void> disconnectFromDevice() async {
    log('disconnectFromDevice - closing streams');
    // await streamSubscription2?.cancel();
    await data.close();
  }
}
