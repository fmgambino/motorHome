import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:motor_home/core/app/view/global_bloc.dart';
import 'package:motor_home/core/common/index.dart';
import 'package:motor_home/core/config/index.dart';
import 'package:motor_home/core/shared/index.dart';
import 'package:motor_home/features/bluetooth/index.dart';
import 'package:motor_home/injection_container.dart';
import 'package:path_provider/path_provider.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
    if (error is DioErrorAdapter) {
      sl<GlobalBloc>().add(AddRequestError(error));
    }
    if (error is HasInternetAccessEnum) {
      log('Error is a HasInternetAccessEnum: $error');
      sl<GlobalBloc>().add(ChangeHasInternetAccess(error));
    }
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here

  // runApp(await builder());
  await runZonedGuarded(
    () async {
      await dotenv.load();
      WidgetsFlutterBinding.ensureInitialized();
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getTemporaryDirectory(),
      );
      await PreferencesApp.init();
      await setup();

      return runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<ConfigCubit>(
              create: (context) => sl.get<ConfigCubit>(),
            ),
            BlocProvider<BluetoothManagerBloc>(
              create: (context) => sl.get<BluetoothManagerBloc>(),
            ),
            BlocProvider<DataReceivedBloc>(
              create: (context) => sl.get<DataReceivedBloc>(),
            ),
            BlocProvider<PermissionBloc>(
              create: (context) => sl.get<PermissionBloc>(),
            ),
            BlocProvider.value(
              value: sl<ConnectivityBloc>(),
            ),
            BlocProvider(
              create: (_) => sl<GlobalBloc>(),
            ),
            BlocProvider(
              create: (_) => sl<MqttBloc>(),
            ),
            BlocProvider(
              create: (_) => sl<DepositosBloc>(),
            ),
          ],
          child: await builder(),
        ),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
