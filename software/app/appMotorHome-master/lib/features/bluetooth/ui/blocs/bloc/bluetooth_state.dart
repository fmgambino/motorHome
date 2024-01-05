part of 'bluetooth_bloc.dart';

class BluetoothManagerState extends Equatable {
  const BluetoothManagerState({
    required this.pairedDevices,
    required this.unPairedDevices,
    this.isDiscoveryComplete = false,
    this.connection,
    this.connecting = false,
    this.isDisconnecting = true,
    this.permissionGranted,
    this.error,
    this.address,
  });

  factory BluetoothManagerState.fromJson(Map<String, dynamic> json) => BluetoothManagerState(
        pairedDevices: (json['pairedDevices'] as List<dynamic>).map((e) {
          final aux = e as Map<String, dynamic>;
          return DeviceWithAvailabilityModel.fromJson(aux);
        }).toList(),
        unPairedDevices: (json['unPairedDevices'] as List<dynamic>).map((e) {
          final aux = e as Map<String, dynamic>;
          return DeviceWithAvailabilityModel.fromJson(aux);
        }).toList(),
        address: json['address'] as String?,
      );

  factory BluetoothManagerState.initial() => const BluetoothManagerState(
        pairedDevices: [],
        unPairedDevices: [],
        address: '',
      );

  BluetoothManagerState copyWith({
    List<DeviceWithAvailability>? pairedDevices,
    List<DeviceWithAvailability>? unPairedDevices,
    bool? isDiscoveryComplete,
    BluetoothConnection? connection,
    bool? connecting,
    bool? isDisconnecting,
    bool? permissionGranted,
    bool? error,
    String? address,
  }) {
    return BluetoothManagerState(
      pairedDevices: pairedDevices ?? this.pairedDevices,
      unPairedDevices: unPairedDevices ?? this.unPairedDevices,
      isDiscoveryComplete: isDiscoveryComplete ?? this.isDiscoveryComplete,
      connection: connection ?? this.connection,
      connecting: connecting ?? this.connecting,
      isDisconnecting: isDisconnecting ?? this.isDisconnecting,
      permissionGranted: permissionGranted ?? this.permissionGranted,
      error: error ?? this.error,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toJson() => {
        'pairedDevices': pairedDevices.map((e) {
          final aux = DeviceWithAvailabilityModel(
            e.device,
            e.availability,
            e.rssi,
          );
          return aux.toJson();
        }).toList(),
        'unPairedDevices': unPairedDevices.map((e) {
          final aux = DeviceWithAvailabilityModel(
            e.device,
            e.availability,
            e.rssi,
          );
          return aux.toJson();
        }).toList(),
        'address': address,
      };

  @override
  String toString() {
    return '''
    BluetoothManagerState(
      pairedDevices: $pairedDevices, 
      unPairedDevices: $unPairedDevices, 
      isDiscoveryComplete: $isDiscoveryComplete,
      connection: $connection, 
      connecting: $connecting, 
      isDisconnecting: $isDisconnecting, 
      permissionGranted: $permissionGranted,
      error: $error,
      address: $address,
    )
    ''';
  }

  final List<DeviceWithAvailability> pairedDevices;
  final List<DeviceWithAvailability> unPairedDevices;
  final bool? isDiscoveryComplete;
  final BluetoothConnection? connection;
  final bool? connecting;
  final bool? isDisconnecting;
  final bool? permissionGranted;
  final bool? error;
  final String? address;

  @override
  List<Object?> get props => [
        pairedDevices,
        unPairedDevices,
        isDiscoveryComplete,
        connection,
        connecting,
        isDisconnecting,
        permissionGranted,
        error,
        address,
      ];
}
