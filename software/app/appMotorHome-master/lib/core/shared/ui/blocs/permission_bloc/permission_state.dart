part of 'permission_bloc.dart';

class PermissionState extends Equatable {
  const PermissionState({required this.requiredPermissionGranted, required this.location, required this.bluetoothScan, required this.bluetoothConnect});

  factory PermissionState.fromMap(Map<String, dynamic> map) {
    return PermissionState(
      requiredPermissionGranted: map['requiredPermissionGranted'] as bool?,
      location: map['location'] as bool?,
      bluetoothScan: map['bluetoothScan'] as bool?,
      bluetoothConnect: map['bluetoothConnect'] as bool?,
    );
  }

  factory PermissionState.initial() => const PermissionState(
        requiredPermissionGranted: null,
        location: null,
        bluetoothScan: null,
        bluetoothConnect: null,
      );

  final bool? requiredPermissionGranted;
  final bool? location;
  final bool? bluetoothScan;
  final bool? bluetoothConnect;

  @override
  List<Object?> get props => [
        requiredPermissionGranted,
        location,
        bluetoothScan,
        bluetoothConnect,
      ];

  PermissionState copyWith({
    bool? requiredPermissionGranted,
    bool? location,
    bool? bluetoothScan,
    bool? bluetoothConnect,
  }) {
    return PermissionState(
      requiredPermissionGranted: requiredPermissionGranted ?? this.requiredPermissionGranted,
      location: location ?? this.location,
      bluetoothScan: bluetoothScan ?? this.bluetoothScan,
      bluetoothConnect: bluetoothConnect ?? this.bluetoothConnect,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requiredPermissionGranted': requiredPermissionGranted,
      'location': location,
      'bluetoothScan': bluetoothScan,
      'bluetoothConnect': bluetoothConnect,
    };
  }
}
