import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:motor_home/features/bluetooth/domain/entities/device_with_availability_entitie.dart';

class DeviceWithAvailabilityModel extends DeviceWithAvailability {
  const DeviceWithAvailabilityModel(
    super.device,
    super.availability,
    super.rssi,
  );

  factory DeviceWithAvailabilityModel.fromJson(Map<String, dynamic> json) => DeviceWithAvailabilityModel(
        BluetoothDevice.fromMap(json['device'] as Map<String, dynamic>),
        DeviceAvailability.values[json['availability'] as int],
        json['rssi'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'device': device.toMap(),
        'availability': availability.index,
        'rssi': rssi,
      };
}
