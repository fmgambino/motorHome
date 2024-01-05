import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor_home/core/common/helpers/index.dart';
import 'package:motor_home/core/config/index.dart';
import 'package:motor_home/core/shared/index.dart';
import 'package:motor_home/features/bluetooth/index.dart';
import 'package:motor_home/injection_container.dart';

class SensorConfigurationScreen extends StatefulWidget {
  const SensorConfigurationScreen({
    super.key,
  });

  @override
  State<SensorConfigurationScreen> createState() => _SensorConfigurationScreenState();
}

class _SensorConfigurationScreenState extends State<SensorConfigurationScreen> {
  late final DataReceivedBloc dataReceivedBloc;

  @override
  void initState() {
    dataReceivedBloc = sl.get<DataReceivedBloc>();
    super.initState();
  }

  @override
  void activate() {
    super.activate();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    sl.get<BluetoothManagerBloc>().add(ResumeListeningEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataReceivedBloc, DataReceivedState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sensor Configuration'),
          ),
          body: Padding(
            padding: EdgeInsets.all(context.dp(0.6)),
            child: Align(
              child: Column(
                children: [
                  Text(
                    toSensorTitle(state.selectSensor!.name, context),
                    style: TextStyle(fontSize: context.dp(3), fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: context.dp(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: state.selectSensor!.name,
                          child: SizedBox(
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: context.dp(0.2),
                              surfaceTintColor: Theme.of(context).hintColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  context.dp(1),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(context.dp(1)),
                                // child: Image.asset(
                                //   toImage(state.selectSensor!.name)[state.selectSensor!.name]!,
                                //   color: Theme.of(context).hintColor,
                                // ),
                                child: Image(
                                  color: Theme.of(context).hintColor,
                                  image: ResizeImage(
                                    AssetImage(toImage(state.selectSensor!.name)[state.selectSensor!.name]!),
                                    width: context.dp(20).toInt(),
                                    height: context.dp(20).toInt(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(context.dp(0.6)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'Nombre: ',
                                        style: TextStyle(color: Theme.of(context).hintColor, fontSize: context.dp(2)),
                                        children: [
                                          TextSpan(
                                            text: toSensorTitle(state.selectSensor!.name, context),
                                            style: TextStyle(color: Theme.of(context).hintColor, fontSize: context.dp(2)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: context.dp(0.6)),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Unidad: ',
                                        style: TextStyle(color: Theme.of(context).hintColor, fontSize: context.dp(2)),
                                        children: [
                                          TextSpan(
                                            text: state.selectSensor!.unit ?? 'No tiene',
                                            style: TextStyle(color: Theme.of(context).hintColor, fontSize: context.dp(2)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: context.dp(0.6)),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Habilitado: ',
                                        style: TextStyle(color: Theme.of(context).hintColor, fontSize: context.dp(2)),
                                        children: [
                                          TextSpan(
                                            text: state.selectSensor!.enabled ? 'Si' : 'No',
                                            style: TextStyle(color: Theme.of(context).hintColor, fontSize: context.dp(2)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: context.dp(0.6)),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(context.dp(1)),
                                  border: Border.all(color: Theme.of(context).hintColor),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text: '${state.selectSensor!.value}',
                                    style: TextStyle(color: Theme.of(context).hintColor, fontSize: context.dp(4)),
                                    children: [
                                      TextSpan(
                                        text: ' ${state.selectSensor!.unit}',
                                        style: TextStyle(color: Theme.of(context).hintColor, fontSize: context.dp(2)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.dp(2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          dataReceivedBloc.add(ChangeUnitEvent());
                        },
                        child: const Text('Cambiar Unidad'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // dataReceivedBloc.add(ChangeEnabledEvent(sensor: state.selectSensor!));
                        },
                        child: const Text('Habilitar/Desabilitar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
