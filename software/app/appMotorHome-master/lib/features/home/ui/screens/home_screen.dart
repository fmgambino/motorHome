import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motor_home/core/app/view/global_bloc.dart';
import 'package:motor_home/core/index.dart';
import 'package:motor_home/features/bluetooth/index.dart';
import 'package:motor_home/features/home/ui/screens/sensor_configuration_screen.dart';
import 'package:motor_home/injection_container.dart';
import 'package:motor_home/l10n/l10n.dart';

// final snackBarKey = GlobalKey<ScaffoldMessengerState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late final BluetoothManagerBloc bluetoothManagerBloc;
  late final DataReceivedBloc dataReceivedBloc;
  late final GlobalBloc globalBloc;
  late final MqttBloc mqttBloc;

  late final StreamSubscription<GlobalState>? _globalBlocSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    bluetoothManagerBloc = sl<BluetoothManagerBloc>()..add(ListenToDeviceEvent());
    globalBloc = sl.get<GlobalBloc>();
    mqttBloc = sl.get<MqttBloc>();
    dataReceivedBloc = sl.get<DataReceivedBloc>();
    _globalBlocSubscription = globalBloc.stream.listen(_sendMetric);

    super.initState();
  }

  void _sendMetric(GlobalState state) {
    log('GlobalState: ${state.hasInternetAccess}');
    if (state.hasInternetAccess == HasInternetAccessEnum.hasInternetAccess && dataReceivedBloc.state.metrics!.isNotEmpty) {
      dataReceivedBloc.add(SendMetricEvent());
    }
  }

  @override
  void activate() {
    super.activate();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    log('AppLifecycleState: $state');
    if (state == AppLifecycleState.resumed) {
      bluetoothManagerBloc.add(ResumeListeningEvent());
    } else if (state == AppLifecycleState.paused) {
      bluetoothManagerBloc.add(PauseListeningEvent());
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    bluetoothManagerBloc.add(DisconnectFromDeviceEvent());
    _globalBlocSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<DataReceivedBloc, DataReceivedState>(
      listener: (context, state) {
        // log('HomeScreen: listener ${globalBloc.state.hasInternetAccess} ${state.dataReceived?.isComplete}');
        // // TODO: si hay internet enviar los datos
        // if (state.dataReceived != null && state.dataReceived!.isComplete != null && state.dataReceived!.isComplete!) {
        //   log('HomeScreen: listener ${state.dataReceived!.toJson()}');
        //   mqttBloc.add(PublishMessage(topic: '', message: state.dataReceived!.toJson().toString()));
        // }
      },
      listenWhen: (previous, current) {
        return previous.dataReceived?.data != current.dataReceived?.data;
      },
      builder: (context, state) {
        // log('HomeScreen: ${state.dataReceived!.id}');
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                l10n.homeAppBarTitle,
                style: TextStyle(fontSize: context.dp(2.6)),
              ),
              centerTitle: true,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              actions: [
                BlocBuilder<BluetoothManagerBloc, BluetoothManagerState>(
                  builder: (context, state) {
                    return IconButton(
                      icon: (state.connection == null || state.isDisconnecting!)
                          ? Icon(Icons.bluetooth_disabled, color: Colors.red, size: context.dp(3))
                          : Icon(Icons.bluetooth_connected, color: Colors.blue, size: context.dp(3)),
                      onPressed: () {
                        log('ESTA DESCONECTADO: ${state.isDisconnecting}');
                      },
                    );
                  },
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    child: Text(
                      l10n.homeDrawerHeader,
                      style: TextStyle(
                        fontSize: context.dp(2.6),
                      ),
                    ),
                  ),
                  _SwitchWidget(
                    title: l10n.homeDrawerItem1,
                    value: widget.isDarkMode,
                    onChanged: widget.changeTheme,
                  ),
                  _SwitchWidget(
                    title: l10n.homeDrawerItem2,
                    value: widget.isEnglish,
                    onChanged: widget.changeLanguage,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.dp(1)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.dp(1))),
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        l10n.configuration_of_tank_dimensions,
                        style: TextStyle(
                          fontSize: context.dp(1.6),
                        ),
                      ),
                      onPressed: () {
                        bluetoothManagerBloc.add(PauseListeningEvent());
                        Navigator.pushNamed(context, '/deposits');
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.dp(1)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.dataReceived != null)
                          if (state.dataReceived!.data.isEmpty)
                            Center(
                              child: Text(
                                l10n.homeEmptyData,
                                style: TextStyle(
                                  fontSize: context.dp(2),
                                  letterSpacing: context.dp(0.2),
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          else
                            ...state.dataReceived!.data.map(
                              (e) {
                                if (e.type == 'switches') {
                                  return _SensorHorizontal(data: e);
                                }
                                return _SensoresVertical(data: e);
                              },
                            ),
                      ],
                    ),
                  ),
                ),
                if (state.dataReceived != null && state.dataReceived!.data.map((e) => e.sensors.length).reduce((a, b) => a + b) < 21)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                      height: context.hp(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: context.dp(1)),
                              const Icon(FontAwesomeIcons.searchengin),
                              SizedBox(width: context.dp(1)),
                              const Text('Cargando sensores...'),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: context.dp(1)),
                            child: SizedBox(
                              width: context.dp(2),
                              height: context.dp(2),
                              child: CircularProgressIndicator(
                                strokeWidth: context.dp(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).hintColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SensorHorizontal extends StatelessWidget {
  const _SensorHorizontal({
    required this.data,
  });

  final Datum data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              toSensorType(data.type, context)['switches']!,
              style: TextStyle(
                fontSize: context.dp(2),
                letterSpacing: context.dp(0.2),
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: context.dp(0.5)),
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
          spacing: context.dp(1),
          runSpacing: context.dp(1),
          children: data.sensors
              .asMap()
              .entries
              .map(
                (entry) => SwitchesCardWidget(
                  sensor: data.sensors[entry.key],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _SensoresVertical extends StatelessWidget {
  const _SensoresVertical({
    required this.data,
  });

  final Datum data;

  @override
  Widget build(BuildContext context) {
    final title = toSensorType(data.type, context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.dp(1)),
        Row(
          children: [
            Text(
              title[data.type]!,
              style: TextStyle(
                fontSize: context.dp(2),
                letterSpacing: context.dp(0.2),
                color: Theme.of(context).hintColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: context.dp(0.5)),
        Wrap(
          spacing: context.dp(0.5),
          runSpacing: context.dp(1),
          children: data.sensors
              .asMap()
              .entries
              .map(
                (sensor) => CardWidget(
                  sensor: data.sensors[sensor.key],
                  index: sensor.key,
                  type: data.type,
                ),
              )
              .toList(),
        ),
        SizedBox(height: context.dp(1)),
      ],
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    required this.sensor,
    required this.index,
    required this.type,
    super.key,
  });
  final Sensor sensor;
  final int index;
  final String type;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        sl<DataReceivedBloc>().add(SelectSensorEvent(sensor: sensor, index: index, type: type));
        sl<BluetoothManagerBloc>().add(PauseListeningEvent());
        Navigator.of(context).push(navegarMapaFadeIn(context, const SensorConfigurationScreen(), '/sensor_configuration'));
      },
      child: SizedBox(
        width: context.width / 4 - context.dp(1),
        height: context.dp(16),
        child: Card(
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(),
          child: Padding(
            padding: EdgeInsets.all(context.dp(1)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FittedBox(
                  child: Text(
                    toSensorTitle(sensor.name, context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.dp(1.4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: context.dp(0.6)),
                Center(
                  child: Hero(
                    tag: sensor.name,
                    child: Image(
                      color: Theme.of(context).hintColor,
                      image: ResizeImage(
                        AssetImage(toImage(sensor.name)[sensor.name]!),
                        width: context.dp(4).toInt(),
                        height: context.dp(4).toInt(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.dp(0.8)),
                Text(
                  "${sensor.value} ${sensor.unit ?? ''}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.dp(1.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget that displays a card with a title and a lightbulb icon button.
///
/// The widget has a state that toggles the lightbulb icon button when pressed.
/// The title and the initial state of the lightbulb icon button are passed as parameters.
///
/// Example usage:
///
/// ```dart
/// SwitchesCardWidget(
///   title: 'Living Room',
///   value: true,
/// )
/// ```
class SwitchesCardWidget extends StatefulWidget {
  const SwitchesCardWidget({
    required this.sensor,
    super.key,
  });
  final Sensor sensor;

  @override
  State<SwitchesCardWidget> createState() => SwitchesCardWidgetState();
}

class SwitchesCardWidgetState extends State<SwitchesCardWidget> {
  @override
  Widget build(BuildContext context) {
    final title = toSensorTitle(widget.sensor.name, context);
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(context.dp(2)),
      decoration: BoxDecoration(
        color: widget.sensor.enabled ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).disabledColor,
        borderRadius: BorderRadius.circular(context.dp(2)),
      ),
      width: context.width / 2 - context.dp(2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).highlightColor,
                radius: context.dp(2),
                child: Icon(
                  widget.sensor.enabled ? FontAwesomeIcons.solidLightbulb : FontAwesomeIcons.lightbulb,
                  size: context.dp(2),
                  color: widget.sensor.enabled ? Colors.amber[400] : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  sl.get<BluetoothManagerBloc>().add(ChangeSwitchStateEvent(state: !widget.sensor.enabled, name: widget.sensor.name));
                  sl.get<DataReceivedBloc>().add(StatusChangeEvent(enabled: !widget.sensor.enabled, name: widget.sensor.name));
                },
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).cardColor,
                  radius: context.dp(2),
                  child: Icon(
                    FontAwesomeIcons.powerOff,
                    size: context.dp(2),
                    color: widget.sensor.enabled ? Theme.of(context).hintColor : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.dp(2)),
          Text(
            'Dispositivo',
            style: TextStyle(
              fontSize: context.dp(1.4),
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: context.dp(2),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// A private stateless widget that represents a switch widget with a title and
/// a switch button.
///
/// This widget is used in the [HomeScreen] to display a switch button
/// with a title.
///
/// Required parameters:
/// * [title]: A string that represents the title of the switch widget.
/// * [value]: A boolean that represents the value of the switch button.
/// * [onChanged]: A function that is called when the switch button is toggled.
class _SwitchWidget extends StatelessWidget {
  const _SwitchWidget({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: context.dp(1.6),
        ),
      ),
      trailing: Switch(
        value: value,
        // ignore: avoid_dynamic_calls
        onChanged: (_) => onChanged(),
      ),
    );
  }
}

/// Extension that provides additional functionalities to the [HomeScreen] class.
extension Functionalities on HomeScreen {
  /// Returns a boolean indicating whether the current locale is English or not.
  bool get isEnglish => sl<ConfigCubit>().state.locale?.languageCode == 'en';

  /// Returns a boolean indicating whether the current theme is dark mode or not.
  bool get isDarkMode => sl<ConfigCubit>().state.isDarkMode ?? false;

  /// Changes the current theme to the opposite of the current one.
  void changeTheme() => sl<ConfigCubit>().changeTheme();

  /// Changes the current language to the opposite of the current one.
  void changeLanguage() => sl<ConfigCubit>().changeLanguage();
}
