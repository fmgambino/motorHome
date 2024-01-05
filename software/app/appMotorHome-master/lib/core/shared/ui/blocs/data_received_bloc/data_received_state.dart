part of 'data_received_bloc.dart';

class DataReceivedState extends Equatable {
  const DataReceivedState({
    this.dataReceived,
    this.selectSensor,
    this.indexSensor,
    this.type,
    this.metrics = const [],
  });

  factory DataReceivedState.fromJson(Map<String, dynamic> json) {
    return DataReceivedState(
      dataReceived: DataReceived.fromJson(json),
      selectSensor: Sensor.fromJson(json),
      metrics: (json['metrics'] as List<dynamic>).map((item) => DataReceived.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  factory DataReceivedState.init() => DataReceivedState(
        dataReceived: _initialDataReceived,
      );

  final DataReceived? dataReceived;
  final List<DataReceived>? metrics;
  final Sensor? selectSensor;
  final int? indexSensor;
  final String? type;

  @override
  List<Object?> get props => [
        dataReceived,
        selectSensor,
        indexSensor,
        type,
        metrics,
      ];

  DataReceivedState copyWith({
    DataReceived? dataReceived,
    Sensor? selectSensor,
    int? indexSensor,
    String? type,
    List<DataReceived>? metrics,
  }) {
    return DataReceivedState(
      dataReceived: dataReceived ?? this.dataReceived,
      selectSensor: selectSensor ?? this.selectSensor,
      indexSensor: indexSensor ?? this.indexSensor,
      type: type ?? this.type,
      metrics: metrics ?? this.metrics,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dataReceived': dataReceived != null ? dataReceived!.toJson() : null,
      'metrics': metrics?.map((item) => item.toJson()).toList(),
      'selectSensor': selectSensor != null ? selectSensor!.toJson() : null,
    };
  }
}

final _initialDataReceived = DataReceived(
  data: [
    Datum(
      type: 'switches',
      sensors: [
        Sensor(
          name: 'bomb',
          value: 0,
          unit: '',
          enabled: false,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'refrigerator',
          value: 0,
          unit: '',
          enabled: false,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'lights',
          value: 0,
          unit: '',
          enabled: false,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'boiler',
          value: 0,
          unit: '',
          enabled: false,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ],
    ),
    Datum(
      type: 'environmental_sensors',
      sensors: [
        Sensor(
          name: 'ppm',
          value: 0,
          unit: 'ppm',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'butane',
          value: 0,
          unit: 'ppm',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'propane',
          value: 0,
          unit: 'ppm',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'methane',
          value: 0,
          unit: 'ppm',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'alcohol',
          value: 0,
          unit: 'ppm',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ],
    ),
    Datum(
      type: 'level',
      sensors: [
        Sensor(
          name: 'white_water',
          value: 0,
          unit: 'L',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'gray_water',
          value: 0,
          unit: 'L',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'black_water',
          value: 0,
          unit: 'L',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'boiler_diesel',
          value: 0,
          unit: 'L',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ],
    ),
    Datum(
      type: 'meteorology',
      sensors: [
        Sensor(
          name: 'outdoor_temperature',
          value: 0,
          unit: 'C',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'indoor_temperature',
          value: 0,
          unit: 'C',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'refrigerator_temperature',
          value: 0,
          unit: 'C',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'atmospheric_pressure',
          value: 0,
          unit: 'hPa',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'altitude',
          value: 0,
          unit: 'msnm',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'indoor_hum',
          value: 0,
          unit: '%',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ],
    ),
    Datum(
      type: 'battery',
      sensors: [
        Sensor(
          name: 'hall',
          value: 0,
          unit: 'V',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        Sensor(
          name: 'starter',
          value: 0,
          unit: 'V',
          enabled: true,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ],
    ),
  ],
  isComplete: false,
  id: '',
);
