import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:motor_home/core/app/view/global_bloc.dart';
import 'package:motor_home/core/common/index.dart';
import 'package:motor_home/core/shared/domain/index.dart';
import 'package:motor_home/core/shared/ui/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:motor_home/core/shared/ui/blocs/depositos_bloc/depositos_bloc.dart';
import 'package:motor_home/core/shared/ui/blocs/mqtt_bloc/mqtt_bloc.dart';
import 'package:motor_home/injection_container.dart';

part 'data_received_event.dart';
part 'data_received_state.dart';

class DataReceivedBloc extends HydratedBloc<DataReceivedEvent, DataReceivedState> {
  DataReceivedBloc() : super(DataReceivedState.init()) {
    on<DataReceivedEvent>((event, emit) async {
      if (event is GetDataReceivedEvent) await _getDataReceived(event, emit);
      if (event is SelectSensorEvent) _selectSensor(event, emit);
      if (event is ChangeUnitEvent) _changeUnit(event, emit);
      if (event is StatusChangeEvent) _statusChange(event, emit);
      if (event is SaveMetricEvent) _saveMetric(event, emit);
      if (event is SendMetricEvent) _sendMetric(event, emit);
      if (event is DeleteMetricsEvent) _deleteMetrics(event, emit);
    });
  }

  @override
  DataReceivedState? fromJson(Map<String, dynamic> json) {
    return DataReceivedState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(DataReceivedState state) {
    return state.toJson();
  }

  Future<void> _getDataReceived(GetDataReceivedEvent event, Emitter<DataReceivedState> emit) async {
    if (event.dataReceived == null) return;
    final data = ascii.decode(event.dataReceived!);
    final depositoBloc = sl.get<DepositosBloc>().state;

    if (data.trim().isEmpty) return;
    log('data received: $data');
    final json = jsonDecode(data) as Map<String, dynamic>;

    final filterData = json['data'] as Map<String, dynamic>;
    final isComplete = (json['is_complete'] ?? false) as bool;
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final id = json['topic'].toString().split('/').last;

    if (PreferencesApp.topic.isEmpty) {
      PreferencesApp.topic = json['topic'] as String;
    }
    log('filterData: $filterData');

    var setValue = filterData['valor'] as int;

    if (filterData['sensor'] == 'white_water') {
      setValue = depositoBloc.cleanWaters.calcularNivel(filterData['valor'] as int).toInt();
    }
    if (filterData['sensor'] == 'black_water') {
      setValue = depositoBloc.blackWaters.calcularNivel(filterData['valor'] as int).toInt();
    }
    if (filterData['sensor'] == 'gray_water') {
      setValue = depositoBloc.greyWaters.calcularNivel(filterData['valor'] as int).toInt();
    }
    if (filterData['sensor'] == 'boiler_diesel') {
      setValue = depositoBloc.gasoil.calcularNivel(filterData['valor'] as int).toInt();
    }

    final newJsonData = {
      'id': id,
      'is_complete': isComplete,
      'data': [
        {
          'type': filterData['type'],
          'sensors': [
            {
              'name': filterData['sensor'],
              'enabled': filterData['enabled'] ?? false,
              'value': setValue,
              // 'value': filterData['valor'],
              'unit': filterData['unit'] ?? '',
              'timestamp': timestamp,
            }
          ],
        }
      ],
    };
    // log('newJsonData: $newJsonData');
    final inputData = DataReceived.fromJson(newJsonData);

    if (state.dataReceived == null) {
      emit(state.copyWith(dataReceived: inputData));
      return;
    }

    final indexType = state.dataReceived!.data.indexWhere((element) => element.type == inputData.data.first.type);
    if (indexType != -1) {
      final index = state.dataReceived!.data[indexType].sensors.indexWhere((element) => element.name == inputData.data.first.sensors.first.name);
      if (index != -1) {
        final updatedSensors = List<Sensor>.from(state.dataReceived!.data[indexType].sensors);

        updatedSensors[index] = inputData.data.first.sensors.first.copyWith(unit: updatedSensors[index].unit ?? inputData.data.first.sensors.first.unit);

        log('encontro el sensor, actualizo el valor ${inputData.data.first.sensors.first.value} - ${inputData.data.first.sensors.first.name} ${state.metrics!.length}');

        final updatedData = List<Datum>.from(state.dataReceived!.data);
        updatedData[indexType] = Datum(type: inputData.data.first.type, sensors: updatedSensors);
        final aux = DataReceived(id: id, data: updatedData, isComplete: isComplete);
        emit(state.copyWith(dataReceived: aux));
        sl.get<MqttBloc>()
          ..add(ConnetMqtt())
          ..add(PublishMessage(topic: '', message: aux.toJson().toString()));
      } else {
        log('no encontro el sensor, agrego el sensor');
        final updatedData = List<Datum>.from(state.dataReceived!.data);
        updatedData[indexType] =
            Datum(type: inputData.data.first.type, sensors: [...state.dataReceived!.data[indexType].sensors, inputData.data.first.sensors.first]);
        final aux2 = DataReceived(id: id, data: updatedData, isComplete: isComplete);
        emit(state.copyWith(dataReceived: aux2));
      }
    } else {
      log('no encontro el tipo, agrego el tipo');
      var updatedData = List<Datum>.from(
        state.dataReceived!.data,
      );
      updatedData = [...updatedData, Datum(type: inputData.data.first.type, sensors: inputData.data.first.sensors)]..sort((a, b) {
          if (a.type == 'switches' && b.type != 'switches') {
            return -1;
          } else if (b.type == 'switches' && a.type != 'switches') {
            return 1;
          } else {
            return a.type.compareTo(b.type);
          }
        });

      final aux3 = DataReceived(id: id, data: updatedData, isComplete: isComplete);
      emit(state.copyWith(dataReceived: aux3));
    }
  }

  void _selectSensor(SelectSensorEvent event, Emitter<DataReceivedState> emit) {
    emit(state.copyWith(selectSensor: event.sensor, indexSensor: event.index, type: event.type));
  }

  void _changeUnit(ChangeUnitEvent event, Emitter<DataReceivedState> emit) {
    final indexType = state.dataReceived!.data.indexWhere((element) => element.type == state.type);
    if (indexType != -1) {
      final index = state.dataReceived!.data[indexType].sensors.indexWhere((element) => element.name == state.selectSensor!.name);
      if (index != -1) {
        final updatedSensors = List<Sensor>.from(state.dataReceived!.data[indexType].sensors);
        // final newUnit = updatedSensors[index].convert();
        final newUnit = updatedSensors[index].copyWith(unit: _convert(updatedSensors[index].unit!)).unit;
        // final newValue = updatedSensors[index].convertUnit().toStringAsFixed(2);
        final newValue = _convertUnit(updatedSensors[index].unit!, updatedSensors[index].value).toStringAsFixed(2);
        final filter = double.tryParse(newValue);
        updatedSensors[index] = updatedSensors[index].copyWith(unit: newUnit, value: filter!);

        final updatedData = List<Datum>.from(state.dataReceived!.data);
        updatedData[indexType] = Datum(type: state.type!, sensors: updatedSensors);
        final aux = DataReceived(id: id, data: updatedData, isComplete: true);
        emit(state.copyWith(dataReceived: aux, selectSensor: updatedSensors[index]));
      }
    }
  }

  void _statusChange(StatusChangeEvent event, Emitter<DataReceivedState> emit) {
    final name = event.name;
    final enabled = event.enabled;

    final indexType = state.dataReceived!.data.indexWhere((element) => element.type == 'switches');

    if (indexType != -1) {
      final index = state.dataReceived!.data[indexType].sensors.indexWhere((element) => element.name == name);
      if (index != -1) {
        final updatedSensors = List<Sensor>.from(state.dataReceived!.data[indexType].sensors);
        updatedSensors[index] = updatedSensors[index].copyWith(enabled: enabled);

        final updatedData = List<Datum>.from(state.dataReceived!.data);
        updatedData[indexType] = Datum(type: 'switches', sensors: updatedSensors);
        final aux = DataReceived(id: id, data: updatedData, isComplete: true);
        emit(state.copyWith(dataReceived: aux));
      }
    }
  }

  void _saveMetric(SaveMetricEvent event, Emitter<DataReceivedState> emit) {
    sl.get<ConnectivityBloc>().add(HasInternetAccess());
    if (sl.get<GlobalBloc>().state.hasInternetAccess == HasInternetAccessEnum.hasInternetAccess) return;
    final hashMap = state.dataReceived!.data.map((e) => e.toJson()).toList();
    final metric = DataReceived.fromJson({'data': hashMap, 'is_complete': true, 'id': state.dataReceived!.id});
    if (state.metrics!.contains(metric)) return;
    emit(state.copyWith(metrics: [...state.metrics!, metric]));
  }

  void _sendMetric(SendMetricEvent event, Emitter<DataReceivedState> emit) {
    final metrics = state.metrics!.map((e) => e.toJson()).toList();
    final json = jsonEncode(metrics);
    sl.get<MqttBloc>().add(PublishMessage(topic: PreferencesApp.topic, message: json));
  }

  void _deleteMetrics(DeleteMetricsEvent event, Emitter<DataReceivedState> emit) {
    emit(state.copyWith(metrics: []));
  }

  double _convertUnit(String unit, double value) {
    if (unit == 'C') {
      return (value * 9 / 5) + 32;
    } else if (unit == 'F') {
      return (value - 32) * 5 / 9;
    } else if (unit == 'L') {
      return value * 1000;
    } else if (unit == 'mL') {
      return value / 1000;
    } else if (unit == 'hPa' || unit == 'mbar') {
      return value;
    } else if (unit == 'V') {
      return value * 1000;
    } else if (unit == 'mV') {
      return value / 1000;
    }
    return value;
  }

  String _convert(String unit) {
    if (unit == 'C') {
      return 'F';
    } else if (unit == 'F') {
      return 'C';
    } else if (unit == 'L') {
      return 'mL';
    } else if (unit == 'mL') {
      return 'L';
    } else if (unit == 'hPa') {
      return 'mbar';
    } else if (unit == 'mbar') {
      return 'hPa';
    } else if (unit == 'V') {
      return 'mV';
    } else if (unit == 'mV') {
      return 'V';
    }
    return unit;
  }
}
