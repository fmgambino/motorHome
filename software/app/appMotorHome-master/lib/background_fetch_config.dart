import 'dart:developer';

import 'package:background_fetch/background_fetch.dart';
import 'package:motor_home/core/shared/index.dart';
import 'package:motor_home/injection_container.dart';

@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(String taskId) {
  // final hasInternetAccess = sl.get<GlobalBloc>().state.hasInternetAccess;
  // if (hasInternetAccess != HasInternetAccessEnum.hasInternetAccess) {
  sl.get<DataReceivedBloc>().add(SaveMetricEvent());
  // }
  log('[BackgroundFetch] Headless event received.');
  BackgroundFetch.finish(taskId);
}

void configureBackgroundFetch() {
  // Configura la tarea de fondo.
  log('configureBackgroundFetch');
  BackgroundFetch.configure(
    BackgroundFetchConfig(
      minimumFetchInterval: 15, // Ejecuta cada 30 minutos.
      stopOnTerminate: false,
      enableHeadless: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
    ),
    (String taskId) async {
      backgroundFetchHeadlessTask(taskId);
    },
  );

  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}
