import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor_home/core/app/view/app.dart';
import 'package:motor_home/core/common/index.dart';
import 'package:motor_home/core/config/index.dart';
import 'package:motor_home/features/bluetooth/index.dart';
import 'package:motor_home/features/home/index.dart';
import 'package:motor_home/injection_container.dart';
import 'package:motor_home/l10n/l10n.dart';

final snackBarKeyB = GlobalKey<ScaffoldMessengerState>();

class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({super.key});

  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  late final BluetoothManagerBloc bluetoothManagerBloc;
  @override
  void initState() {
    bluetoothManagerBloc = sl.get<BluetoothManagerBloc>()
      ..add(GetPairedDevicesEvent())
      ..add(StartDeviceDiscoveryEvent());

    super.initState();
  }

  @override
  void activate() {
    super.activate();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    bluetoothManagerBloc.add(CancelDiscoveryEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<BluetoothManagerBloc, BluetoothManagerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            if (state.connecting != null && state.connecting!) {
              return false;
            }
            bluetoothManagerBloc.add(CancelDiscoveryEvent());
            return true;
          },
          child: ScaffoldMessenger(
            key: snackBarKeyB,
            child: Scaffold(
              appBar: AppBar(
                title: Text(l10n.findDevices, style: TextStyle(fontSize: context.dp(2.6))),
                backgroundColor: Theme.of(context).secondaryHeaderColor,
              ),
              body: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(const Duration(milliseconds: 500)); // show refresh icon breifly
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              l10n.linkedDevices,
                              style: TextStyle(
                                fontSize: context.dp(2),
                              ),
                            ),
                            SizedBox(width: context.dp(1)),
                            if (!state.isDiscoveryComplete!)
                              SizedBox(
                                height: context.dp(2),
                                width: context.dp(2),
                                child: CircularProgressIndicator(
                                  strokeWidth: context.dp(0.3),
                                ),
                              )
                            else
                              IconButton(
                                icon: Icon(
                                  Icons.replay,
                                  size: context.dp(3),
                                ),
                                onPressed: () {
                                  if (state.connecting != null && state.connecting!) return;
                                  bluetoothManagerBloc.add(StartDeviceDiscoveryEvent());
                                },
                              ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        itemCount: state.pairedDevices.isEmpty ? 1 : state.pairedDevices.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final device = state.pairedDevices.isEmpty ? null : state.pairedDevices[index];

                          if (state.isDiscoveryComplete! && state.pairedDevices.isEmpty) {
                            return const NoDeviceFoundWidget();
                          } else if (state.isDiscoveryComplete! && state.pairedDevices.isNotEmpty) {
                            return DeviceListWidget(device: device!);
                          }
                          return const SearchingDevicesWidget();
                        },
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              l10n.availableDevices,
                              style: TextStyle(
                                fontSize: context.dp(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        itemCount: state.unPairedDevices.isEmpty ? 1 : state.unPairedDevices.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final device = state.unPairedDevices.isEmpty ? null : state.unPairedDevices[index];

                          if (state.isDiscoveryComplete! && state.unPairedDevices.isEmpty) {
                            return const NoDeviceFoundWidget();
                          } else if (state.isDiscoveryComplete! && state.unPairedDevices.isNotEmpty) {
                            return DeviceListWidget(device: device!);
                          }
                          return const SearchingDevicesWidget();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NoDeviceFoundWidget extends StatelessWidget {
  const NoDeviceFoundWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      title: Text(
        l10n.noDevicesFound,
        style: TextStyle(
          fontSize: context.dp(1.6),
        ),
      ),
    );
  }
}

class SearchingDevicesWidget extends StatelessWidget {
  const SearchingDevicesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      title: Text(
        l10n.searchingDevices,
        style: TextStyle(
          fontSize: context.dp(1.6),
        ),
      ),
    );
  }
}

class DeviceListWidget extends StatefulWidget {
  const DeviceListWidget({
    required this.device,
    super.key,
  });

  final DeviceWithAvailability device;

  @override
  State<DeviceListWidget> createState() => _DeviceListWidgetState();
}

class _DeviceListWidgetState extends State<DeviceListWidget> {
  late final BluetoothManagerBloc bluetoothManagerBloc;
  final bluetoothAdapterStateObserver = BluetoothAdapterStateObserver();
  @override
  void initState() {
    bluetoothManagerBloc = sl.get<BluetoothManagerBloc>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<BluetoothManagerBloc, BluetoothManagerState>(
      listener: (context, state) {
        Future<dynamic>.delayed(const Duration(milliseconds: 2000)).then((value) => null);
        log('listener 1 ${state.connection != null && state.connection!.isConnected}');
        if (state.connection != null && state.connection!.isConnected) {
          Navigator.of(context).push(navegarMapaFadeIn(context, const HomeScreen(), '/home'));
        }
        log('listener 2 ${state.connecting != null && state.connecting!}');
        if (state.connecting != null && state.connecting!) {
          snackBarKeyB.currentState!.showSnackBar(
            SnackBar(
              content: Text('${l10n.connectedTo} ${widget.device.device.name}'),
            ),
          );
        }
        log('listener 3 ${state.connection == null && state.error != null && state.error!}');
        if (state.connection == null && state.error != null && state.error!) {
          snackBarKeyB.currentState!.showSnackBar(
            SnackBar(
              content: Text('${l10n.errorConnectingTo} ${widget.device.device.name}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        return ListTile(
          leading: (widget.device.device.isBonded
              ? Icon(
                  Icons.devices_other,
                  size: context.dp(3),
                )
              : Icon(
                  Icons.devices_other_outlined,
                  size: context.dp(3),
                )),
          title: Text(
            widget.device.device.name ?? 'Unknown',
            style: TextStyle(
              fontSize: context.dp(1.8),
              color: widget.device.availability == DeviceAvailability.yes ? Colors.green : null,
            ),
          ),
          subtitle: Text(
            widget.device.device.address,
            style: TextStyle(
              fontSize: context.dp(1.6),
            ),
          ),
          trailing: Text('${widget.device.rssi ?? '-'}', style: widget.computeTextStyle(widget.device.rssi ?? -100, context)),
          enabled: !state.connecting!,
          onTap: () async {
            bluetoothManagerBloc.add(ConnectToDeviceEvent(address: widget.device.device.address));
          },
        );
      },
    );
  }
}

extension Style on DeviceListWidget {
  TextStyle computeTextStyle(int rssi, BuildContext context) {
    if (rssi >= -35) {
      return TextStyle(color: Colors.greenAccent[700], fontSize: context.dp(1.6));
    } else if (rssi >= -45) {
      return TextStyle(
        color: Color.lerp(
          Colors.greenAccent[700],
          Colors.lightGreen,
          -(rssi + 35) / 10,
        ),
        fontSize: context.dp(1.6),
      );
    } else if (rssi >= -55) {
      return TextStyle(
        color: Color.lerp(
          Colors.lightGreen,
          Colors.lime[600],
          -(rssi + 45) / 10,
        ),
        fontSize: context.dp(1.6),
      );
    } else if (rssi >= -65) {
      return TextStyle(
        color: Color.lerp(
          Colors.lime[600],
          Colors.amber,
          -(rssi + 55) / 10,
        ),
        fontSize: context.dp(1.6),
      );
    } else if (rssi >= -75) {
      return TextStyle(
        color: Color.lerp(
          Colors.amber,
          Colors.deepOrangeAccent,
          -(rssi + 65) / 10,
        ),
        fontSize: context.dp(1.6),
      );
    } else if (rssi >= -85) {
      return TextStyle(
        color: Color.lerp(
          Colors.deepOrangeAccent,
          Colors.redAccent,
          -(rssi + 75) / 10,
        ),
        fontSize: context.dp(1.6),
      );
    } else {
      return TextStyle(
        color: Colors.redAccent,
        fontSize: context.dp(1.6),
      );
    }
  }
}
