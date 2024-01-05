import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:motor_home/core/shared/index.dart';
import 'package:motor_home/features/bluetooth/ui/screens/bluetooth_screen.dart';
import 'package:motor_home/features/bluetooth/ui/screens/find_devices_screen.dart';
// import 'package:motor_home/injection_container.dart';

class SplashScreenBluetooth extends StatefulWidget {
  const SplashScreenBluetooth({super.key});

  @override
  State<SplashScreenBluetooth> createState() => _SplashScreenBluetoothState();
}

class _SplashScreenBluetoothState extends State<SplashScreenBluetooth> {
  late final PermissionBloc permissionBloc;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    permissionBloc = PermissionBloc()
      ..add(UpdatePermissionEvent())
      ..add(RequestPermissionEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PermissionBloc, PermissionState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: StreamBuilder<BluetoothAdapterState>(
            stream: FlutterBluePlus.adapterState,
            initialData: BluetoothAdapterState.unknown,
            builder: (BuildContext context, AsyncSnapshot<BluetoothAdapterState?> snapshot) {
              final adapterState = snapshot.data;
              if (adapterState == BluetoothAdapterState.on && state.requiredPermissionGranted != null && state.requiredPermissionGranted!) {
                return const FindDevicesScreen();
              } else {
                FlutterBluePlus.stopScan();
                return BluetoothScreen(adapterState: adapterState);
              }
            },
          ),
        );
      },
    );
  }
}
