import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends HydratedBloc<PermissionEvent, PermissionState> {
  PermissionBloc() : super(PermissionState.initial()) {
    on<PermissionEvent>((event, emit) async {
      if (event is RequestPermissionEvent) await _requestPermission(event, emit);
      if (event is UpdatePermissionEvent) await _updatePermission(event, emit);
    });
  }

  @override
  PermissionState? fromJson(Map<String, dynamic> json) {
    return PermissionState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(PermissionState state) {
    return state.toMap();
  }

  Future<void> _requestPermission(RequestPermissionEvent event, Emitter<PermissionState> emit) async {
    if (state.requiredPermissionGranted != null && state.requiredPermissionGranted!) return;
    final res = await [
      Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();
    emit(
      state.copyWith(
        requiredPermissionGranted: res[Permission.location] == PermissionStatus.granted &&
            res[Permission.bluetoothConnect] == PermissionStatus.granted &&
            res[Permission.bluetoothScan] == PermissionStatus.granted,
        location: res[Permission.location] == PermissionStatus.granted,
        bluetoothConnect: res[Permission.bluetoothConnect] == PermissionStatus.granted,
        bluetoothScan: res[Permission.bluetoothScan] == PermissionStatus.granted,
      ),
    );
  }

  Future<void> _updatePermission(UpdatePermissionEvent event, Emitter<PermissionState> emit) async {
    final locationStatus = await Permission.location.status;
    final bluetoothConnectStatus = await Permission.bluetoothConnect.status;
    final bluetoothScanStatus = await Permission.bluetoothScan.status;

    emit(
      state.copyWith(
        requiredPermissionGranted:
            locationStatus == PermissionStatus.granted && bluetoothConnectStatus == PermissionStatus.granted && bluetoothScanStatus == PermissionStatus.granted,
        location: locationStatus == PermissionStatus.granted,
        bluetoothConnect: bluetoothConnectStatus == PermissionStatus.granted,
        bluetoothScan: bluetoothScanStatus == PermissionStatus.granted,
      ),
    );
  }
}
