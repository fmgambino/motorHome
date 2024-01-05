import 'package:equatable/equatable.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DeviceWithAvailability extends Equatable {
  const DeviceWithAvailability(this.device, this.availability, [this.rssi]);

  final BluetoothDevice device;
  final DeviceAvailability availability;
  final int? rssi;

  @override
  List<Object?> get props => [device, availability, rssi];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeviceWithAvailability && other.device == device;
  }

  @override
  int get hashCode => device.hashCode;
}

enum DeviceAvailability {
  no,
  maybe,
  yes,
}
