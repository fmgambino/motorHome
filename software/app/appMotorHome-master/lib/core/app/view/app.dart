import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor_home/core/config/index.dart';
import 'package:motor_home/core/shared/index.dart';
import 'package:motor_home/features/bluetooth/index.dart';
import 'package:motor_home/injection_container.dart';
import 'package:motor_home/l10n/l10n.dart';

/// NavigatorObserver that observes the state of the Bluetooth adapter.
/// Overrides the didPush and didPop methods to handle the BluetoothManagerBloc events.
class BluetoothAdapterStateObserver extends NavigatorObserver {
  factory BluetoothAdapterStateObserver() {
    return _singleton;
  }

  BluetoothAdapterStateObserver._internal();

  static final BluetoothAdapterStateObserver _singleton = BluetoothAdapterStateObserver._internal();

  String? currentRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('didPush ${route.settings.name} - ${previousRoute?.settings.name}');
    currentRoute = route.settings.name;
    log('currentRoute $currentRoute');
    super.didPush(route, previousRoute);
    if (route.settings.name == '/') {}
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('didPop ${route.settings.name} - ${previousRoute?.settings.name}');
    super.didPop(route, previousRoute);
    currentRoute = previousRoute?.settings.name;
    if (previousRoute!.settings.name == '/splash_bluetooth') {
      Future.delayed(const Duration(seconds: 2), () {
        sl.get<BluetoothManagerBloc>()
          ..add(GetPairedDevicesEvent())
          ..add(StartDeviceDiscoveryEvent());
      });
    }
    if (route.settings.name == '/deposits' && previousRoute.settings.name == '/home') {
      Future.delayed(const Duration(seconds: 2), () {
        sl.get<BluetoothManagerBloc>().add(ResumeListeningEvent());
      });
    }
  }
}

/// A widget that represents the main application.
///
/// This widget is responsible for building the MaterialApp widget with the appropriate theme and localization.
/// It uses the ConfigCubit to get the current state of the application configuration, such as the current locale and theme mode.
/// The widget also sets the initial route to '/splash_bluetooth' and adds a navigator observer for BluetoothAdapterState changes.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigCubit, ConfigState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData.dark(
            useMaterial3: true,
          ),
          theme: ThemeData.light(
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: state.locale,
          routes: routes,
          navigatorObservers: [BluetoothAdapterStateObserver()],
          themeMode: state.themeMode,
          onGenerateInitialRoutes: (initialRoute) {
            return state.firstTime!
                ? [MaterialPageRoute(builder: (context) => routes['/select_protocol']!(context))]
                : [MaterialPageRoute(builder: (context) => routes['/splash_bluetooth']!(context))];
          },
        );
      },
    );
  }
}
