import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:motor_home/core/config/index.dart';
import 'package:motor_home/core/shared/index.dart';
import 'package:motor_home/injection_container.dart';
import 'package:permission_handler/permission_handler.dart';

final snackBarKeyA = GlobalKey<ScaffoldMessengerState>();

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key, this.adapterState});
  final BluetoothAdapterState? adapterState;

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> with WidgetsBindingObserver {
  late final PermissionBloc permissionBloc;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    permissionBloc = sl.get<PermissionBloc>();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print('state: $state');
    if (state == AppLifecycleState.resumed) {
      permissionBloc.add(UpdatePermissionEvent());
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionBloc, PermissionState>(
      builder: (context, state) {
        return ScaffoldMessenger(
          key: snackBarKeyA,
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.bluetooth_disabled,
                    size: context.dp(25),
                    color: Theme.of(context).hintColor,
                  ),
                  Text(
                    'Bluetooth Adapter is ${widget.adapterState != null ? widget.adapterState.toString().split(".").last : 'not available'}.',
                    style: Theme.of(context).primaryTextTheme.titleMedium,
                  ),
                  if (Platform.isAndroid && state.requiredPermissionGranted != null && state.requiredPermissionGranted!)
                    ElevatedButton(
                      child: const Text('TURN ON'),
                      onPressed: () async {
                        try {
                          if (Platform.isAndroid) {
                            await FlutterBluePlus.turnOn();
                          }
                        } catch (e) {
                          final snackBar = SnackBar(
                            content: Text('Error Turning On: $e'),
                            backgroundColor: Colors.red,
                          );
                          snackBarKeyA.currentState?.removeCurrentSnackBar();
                          snackBarKeyA.currentState?.showSnackBar(snackBar);
                        }
                      },
                    ),
                  if (state.requiredPermissionGranted != true)
                    ElevatedButton(
                      child: const Text('REQUEST PERMISSION'),
                      onPressed: () async {
                        await openAppSettings();
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
