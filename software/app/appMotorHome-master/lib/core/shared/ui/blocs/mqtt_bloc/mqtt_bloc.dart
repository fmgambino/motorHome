import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:motor_home/core/common/index.dart';
import 'package:motor_home/core/shared/ui/blocs/data_received_bloc/data_received_bloc.dart';
import 'package:motor_home/injection_container.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';

part 'mqtt_event.dart';
part 'mqtt_state.dart';

class MqttBloc extends Bloc<MqttEvent, MqttState> {
  MqttBloc() : super(MqttState.init()) {
    on<MqttEvent>(
      (event, emit) async {
        if (event is ConnetMqtt) await _connectMqtt(event, emit);
        if (event is PublishMessage) _publishMessage(event, emit);
      },
      transformer: sequential(),
    );
  }

  Future<void> _connectMqtt(ConnetMqtt event, Emitter<MqttState> emit) async {
    if (state.client != null && state.client!.connectionStatus!.state == MqttConnectionState.connected) {
      log('client is connected');
      return;
    }

    final client = MqttServerClient(const String.fromEnvironment('BROKER'), '')
      ..logging(on: false)
      ..port = 1883;

    try {
      await client.connect();
    } catch (e) {
      client.disconnect();
      log('Error connecting to the broker: $e');
      // sl.get<ConnectivityBloc>().add(HasInternetAccess());
    }

    emit(state.copyWith(client: client));
  }

  void _publishMessage(PublishMessage event, Emitter<MqttState> emit) {
    final builder = MqttPayloadBuilder();
    // ignore: cascade_invocations
    builder.addWillPayload(event.message);
    if (state.client != null && state.client!.connectionStatus!.state == MqttConnectionState.connected) {
      log('publishMessage ${event.message}');
      state.client!.publishMessage(PreferencesApp.topic, MqttQos.atLeastOnce, builder.payload!);
      state.client!.published!.listen((MqttPublishMessage message) {
        if (message.variableHeader!.topicName == PreferencesApp.topic) {
          log('message received ${PreferencesApp.topic}');
          sl.get<DataReceivedBloc>().add(DeleteMetricsEvent());
        }
      });
    }
  }
}
