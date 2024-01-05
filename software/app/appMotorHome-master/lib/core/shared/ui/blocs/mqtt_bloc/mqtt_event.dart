part of 'mqtt_bloc.dart';

sealed class MqttEvent extends Equatable {
  const MqttEvent();

  @override
  List<Object> get props => [];
}

class ConnetMqtt extends MqttEvent {}

class PublishMessage extends MqttEvent {
  const PublishMessage({
    required this.topic,
    required this.message,
  });

  final String topic;
  final String message;

  @override
  List<Object> get props => [
        topic,
        message,
      ];
}
