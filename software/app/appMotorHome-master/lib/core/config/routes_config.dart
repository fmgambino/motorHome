import 'package:flutter/widgets.dart' show WidgetBuilder;
import 'package:motor_home/core/shared/ui/screens/index.dart';
import 'package:motor_home/features/bluetooth/ui/screens/index.dart';
import 'package:motor_home/features/deposits/ui/screens/deposits_screen.dart';
import 'package:motor_home/features/home/ui/screens/index.dart';

final Map<String, WidgetBuilder> routes = {
  '/find_devices': (_) => const FindDevicesScreen(),
  '/home': (_) => const HomeScreen(),
  '/bluetooth': (_) => const BluetoothScreen(),
  '/splash_bluetooth': (_) => const SplashScreenBluetooth(),
  '/sensor_configuration': (_) => const SensorConfigurationScreen(),
  '/select_protocol': (_) => const SelectProtocolScreen(),
  '/deposits': (_) => const DepositsScreen(),
};
