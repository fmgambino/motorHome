import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:motor_home/core/app/view/global_bloc.dart';
import 'package:motor_home/core/config/index.dart';
import 'package:motor_home/core/shared/index.dart';
import 'package:motor_home/features/bluetooth/index.dart';

GetIt sl = GetIt.instance;

Future<void> setup() async {
  sl
    ..registerLazySingleton(Dio.new)
    ..registerLazySingleton(DioAdapter.new)
    ..registerLazySingleton(
      GlobalBloc.new,
    )
    ..registerLazySingleton<ConfigCubit>(ConfigCubit.new)
    ..registerLazySingleton<BluetoothLocalDatasource>(BluetoothLocalDatasourceImpl.new)
    ..registerLazySingleton<BluetoothRepository>(() => BluetoothRepositoryImpl(localSource: sl()))
    ..registerLazySingleton<CancelListeningUsecase>(() => CancelListeningUsecase(sl()))
    ..registerLazySingleton<CancelDiscoveryUsecase>(() => CancelDiscoveryUsecase(sl()))
    ..registerLazySingleton<ConnectToDeviceUsecase>(() => ConnectToDeviceUsecase(sl()))
    ..registerLazySingleton<GetPairedDevicesUsecase>(() => GetPairedDevicesUsecase(sl()))
    ..registerLazySingleton<ListenToDeviceUsecase>(() => ListenToDeviceUsecase(sl()))
    ..registerLazySingleton<StartDeviceDiscoveryUsecase>(() => StartDeviceDiscoveryUsecase(sl()))
    ..registerLazySingleton<DisconnectFromDeviceUsecase>(() => DisconnectFromDeviceUsecase(sl()))
    ..registerLazySingleton(DataReceivedBloc.new)
    ..registerLazySingleton(PermissionBloc.new)
    ..registerLazySingleton<BluetoothManagerBloc>(
      () => BluetoothManagerBloc(
        cancelDiscoveryUsecase: sl(),
        cancelListeningUsecase: sl(),
        connectToDeviceUsecase: sl(),
        getPairedDevicesUsecase: sl(),
        listenToDeviceUsecase: sl(),
        startDeviceDiscoveryUsecase: sl(),
        disconnectFromDeviceUsecase: sl(),
        dataReceivedBloc: sl(),
      ),
    )
    ..registerLazySingleton<CoreLocalDataSource>(
      CoreLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<CoreRepository>(
      () => CoreRepositoryImpl(local: sl()),
    )
    ..registerLazySingleton(() => ConnectivitySubscriptionUsecase(sl()))
    ..registerLazySingleton(() => ConnectivityUnsubscriptionUsecase(sl()))
    ..registerLazySingleton(() => CheckConnectivityUsecase(sl()))
    ..registerLazySingleton(
      () => ConnectivityBloc(
        checkConnectivity: sl(),
        connectivitySubscription: sl(),
        connectivityUnsubscription: sl(),
      ),
    )
    ..registerLazySingleton(
      MqttBloc.new,
    )
    ..registerLazySingleton(
      DepositosBloc.new,
    );
}
