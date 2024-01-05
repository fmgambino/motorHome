import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:motor_home/core/shared/index.dart';
import 'package:motor_home/features/bluetooth/data/models/index.dart';
import 'package:motor_home/features/bluetooth/domain/index.dart';

part 'bluetooth_event.dart';
part 'bluetooth_state.dart';

class BluetoothManagerBloc extends HydratedBloc<BluetoothManagerEvent, BluetoothManagerState> {
  BluetoothManagerBloc({
    required this.cancelDiscoveryUsecase,
    required this.cancelListeningUsecase,
    required this.connectToDeviceUsecase,
    required this.getPairedDevicesUsecase,
    required this.listenToDeviceUsecase,
    required this.startDeviceDiscoveryUsecase,
    required this.disconnectFromDeviceUsecase,
    required this.dataReceivedBloc,
  }) : super(BluetoothManagerState.initial()) {
    on<BluetoothManagerEvent>(
      (event, emit) async {
        if (event is CancelDiscoveryEvent) _cancelDiscovery(event, emit);
        if (event is CancelListeningEvent) _cancelListening(event, emit);
        if (event is ConnectToDeviceEvent) await _connectToDevice(event, emit);
        if (event is GetPairedDevicesEvent) await _getPairedDevices(event, emit);
        if (event is ListenToDeviceEvent) await _listenToDevice(event, emit);
        if (event is DisconnectFromDeviceEvent) await _disconnectFromDevice(event, emit);
        if (event is StartDeviceDiscoveryEvent) await _startDeviceDiscovery(event, emit);
        if (event is PauseListeningEvent) _pauseListening(event, emit);
        if (event is ResumeListeningEvent) _resumeListening(event, emit);
        if (event is ChangeSwitchStateEvent) _changeSwitchState(event, emit);
        if (event is IsDisconnectingEvent) _isDisconnecting(event, emit);
      },
      transformer: concurrent(),
    );
  }

  final CancelDiscoveryUsecase cancelDiscoveryUsecase;
  final CancelListeningUsecase cancelListeningUsecase;
  final ConnectToDeviceUsecase connectToDeviceUsecase;
  final GetPairedDevicesUsecase getPairedDevicesUsecase;
  final ListenToDeviceUsecase listenToDeviceUsecase;
  final StartDeviceDiscoveryUsecase startDeviceDiscoveryUsecase;
  final DisconnectFromDeviceUsecase disconnectFromDeviceUsecase;
  final DataReceivedBloc dataReceivedBloc;

  StreamSubscription<Uint8List?>? listenSubscription;

  @override
  BluetoothManagerState? fromJson(Map<String, dynamic> json) => BluetoothManagerState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(BluetoothManagerState state) => state.toJson();

  void _cancelDiscovery(CancelDiscoveryEvent event, Emitter<BluetoothManagerState> emit) {
    cancelDiscoveryUsecase();
  }

  void _cancelListening(CancelListeningEvent event, Emitter<BluetoothManagerState> emit) {}

  Future<void> _connectToDevice(ConnectToDeviceEvent event, Emitter<BluetoothManagerState> emit) async {
    emit(state.copyWith(connecting: true, address: event.address));
    final res = await connectToDeviceUsecase<dynamic, BluetoothConnection?>(address: event.address);

    res.fold(
      (l) {
        emit(state.copyWith(connecting: false, error: true));
        return;
      },
      (r) {
        if (r is BluetoothConnection) {
          emit(state.copyWith(connecting: false, connection: r, isDisconnecting: false));
          return;
        }
      },
    );
  }

  Future<void> _getPairedDevices(GetPairedDevicesEvent event, Emitter<BluetoothManagerState> emit) async {
    final pairedDevices = await getPairedDevicesUsecase<List<DeviceWithAvailability>>();
    if (pairedDevices.isEmpty) return;
    final filter = pairedDevices.where((e) => e.device.name != null && e.device.name!.contains(const String.fromEnvironment('BLUETOOTH'))).toList();
    emit(state.copyWith(pairedDevices: filter));
  }

  Future<void> _listenToDevice(
    ListenToDeviceEvent event,
    Emitter<BluetoothManagerState> emit,
  ) async {
    if (state.connection == null) return;
    if (!state.connection!.isConnected) return;

    listenSubscription = listenToDeviceUsecase<Uint8List?>(connection: state.connection!).listen((data) {
      log('data: $data');
      if (data == null) {
        // if (!emit.isDone) {
        //   emit(state.copyWith(isDisconnecting: true));
        // }
        add(const IsDisconnectingEvent(isDisconnecting: true));
        return;
      }
      dataReceivedBloc.add(GetDataReceivedEvent(data));
    });
  }

  Future<void> _startDeviceDiscovery(StartDeviceDiscoveryEvent event, Emitter<BluetoothManagerState> emit) async {
    emit(state.copyWith(unPairedDevices: [], isDiscoveryComplete: false));
    final unPairedDevices = List<DeviceWithAvailability>.empty(growable: true);
    final pairedDevices = List<DeviceWithAvailability>.empty(growable: true);

    var isDiscoveryComplete = false;

    await for (final event in startDeviceDiscoveryUsecase<DeviceWithAvailability?>()) {
      if (event == null) {
        isDiscoveryComplete = true;
      }

      if (!state.pairedDevices.contains(event) && !isDiscoveryComplete) {
        unPairedDevices.add(event!);
      } else if (state.pairedDevices.contains(event)) {
        final index = state.pairedDevices.indexWhere((element) => element.device.address == event!.device.address);
        state.pairedDevices.removeAt(index);
        pairedDevices.add(event!);
      }
    }

    final deviceESP32 = unPairedDevices.where((e) => e.device.name != null && e.device.name!.startsWith(const String.fromEnvironment('BLUETOOTH'))).toList();
    final filter = deviceESP32
        .where(
          (e) => state.pairedDevices.where((element) => element.device.address == e.device.address).isEmpty,
        )
        .toList();
    emit(state.copyWith(unPairedDevices: filter, isDiscoveryComplete: isDiscoveryComplete, pairedDevices: [...pairedDevices, ...state.pairedDevices]));
  }

  Future<void> _disconnectFromDevice(DisconnectFromDeviceEvent event, Emitter<BluetoothManagerState> emit) async {
    // verify if is connected
    await listenSubscription?.cancel();
    if (state.connection == null || !state.connection!.isConnected) return;

    state.connection?.dispose();
    emit(BluetoothManagerState.initial());
    await disconnectFromDeviceUsecase<void>();
  }

  void _pauseListening(PauseListeningEvent event, Emitter<BluetoothManagerState> emit) {
    if (state.connection == null || !state.connection!.isConnected) return;
    state.connection!.output.add(ascii.encode('pause'));
  }

  void _resumeListening(ResumeListeningEvent event, Emitter<BluetoothManagerState> emit) {
    if (state.connection == null || !state.connection!.isConnected) return;
    state.connection!.output.add(ascii.encode('resume'));
  }

  void _changeSwitchState(ChangeSwitchStateEvent event, Emitter<BluetoothManagerState> emit) {
    if (state.connection == null || !state.connection!.isConnected) return;
    final output = event.state ? event.name : 'deselect ${event.name}';
    state.connection!.output.add(ascii.encode('pause'));
    Future<void>.delayed(const Duration(milliseconds: 500));
    state.connection!.output.add(ascii.encode(output));
    Future<void>.delayed(const Duration(milliseconds: 3000));
    state.connection!.output.add(ascii.encode('resume'));
  }

  void _isDisconnecting(
    IsDisconnectingEvent event,
    Emitter<BluetoothManagerState> emit,
  ) {
    emit(state.copyWith(isDisconnecting: event.isDisconnecting));
  }
}
