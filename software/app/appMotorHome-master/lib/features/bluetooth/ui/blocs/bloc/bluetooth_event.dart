part of 'bluetooth_bloc.dart';

sealed class BluetoothManagerEvent extends Equatable {
  const BluetoothManagerEvent();

  @override
  List<Object> get props => [];
}

class CancelDiscoveryEvent extends BluetoothManagerEvent {}

class CancelListeningEvent extends BluetoothManagerEvent {}

class ConnectToDeviceEvent extends BluetoothManagerEvent {
  const ConnectToDeviceEvent({required this.address});

  final String address;

  @override
  List<Object> get props => [address];
}

class GetPairedDevicesEvent extends BluetoothManagerEvent {}

class ListenToDeviceEvent extends BluetoothManagerEvent {}

class DisconnectFromDeviceEvent extends BluetoothManagerEvent {}

class StartDeviceDiscoveryEvent extends BluetoothManagerEvent {}

class PauseListeningEvent extends BluetoothManagerEvent {}

class ResumeListeningEvent extends BluetoothManagerEvent {}

class IsDisconnectingEvent extends BluetoothManagerEvent {
  const IsDisconnectingEvent({required this.isDisconnecting});

  final bool isDisconnecting;
}

class ChangeSwitchStateEvent extends BluetoothManagerEvent {
  const ChangeSwitchStateEvent({
    required this.state,
    required this.name,
  });

  final String name;
  final bool state;
}
