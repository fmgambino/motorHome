part of 'mqtt_bloc.dart';

class MqttState extends Equatable {
  const MqttState({
    required this.client,
  });

  factory MqttState.init() {
    return const MqttState(
      client: null,
    );
  }

  MqttState copyWith({
    MqttServerClient? client,
  }) {
    return MqttState(
      client: client ?? this.client,
    );
  }

  final MqttServerClient? client;

  @override
  List<Object?> get props => [
        client,
      ];
}
