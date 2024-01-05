part of 'data_received_bloc.dart';

sealed class DataReceivedEvent extends Equatable {
  const DataReceivedEvent();

  @override
  List<Object> get props => [];
}

class GetDataReceivedEvent extends DataReceivedEvent {
  const GetDataReceivedEvent(this.dataReceived);

  final Uint8List? dataReceived;
}

class SelectSensorEvent extends DataReceivedEvent {
  const SelectSensorEvent({
    required this.sensor,
    required this.index,
    required this.type,
  });

  final Sensor sensor;
  final int index;
  final String type;

  @override
  List<Object> get props => [
        sensor,
        index,
        type,
      ];
}

class ChangeUnitEvent extends DataReceivedEvent {}

class StatusChangeEvent extends DataReceivedEvent {
  const StatusChangeEvent({
    required this.enabled,
    required this.name,
  });

  final String name;
  final bool enabled;
}

class SaveMetricEvent extends DataReceivedEvent {}

class SendMetricEvent extends DataReceivedEvent {}

class DeleteMetricsEvent extends DataReceivedEvent {}
