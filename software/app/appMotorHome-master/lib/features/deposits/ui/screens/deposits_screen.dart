import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motor_home/core/config/index.dart';
import 'package:motor_home/core/shared/ui/blocs/depositos_bloc/depositos_bloc.dart';
import 'package:motor_home/l10n/l10n.dart';

class DepositsScreen extends StatefulWidget {
  const DepositsScreen({super.key});

  @override
  State<DepositsScreen> createState() => DdepositsScreenState();
}

class DdepositsScreenState extends State<DepositsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return BlocBuilder<DepositosBloc, DepositosState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.homeDrawerHeader),
            actions: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.arrowRotateLeft),
                onPressed: () {
                  context.read<DepositosBloc>().add(
                        ResetDepositos(),
                      );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: context.dp(1), horizontal: context.dp(2)),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.primaryColorLight),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Padding(
                      padding: EdgeInsets.symmetric(vertical: context.dp(1)),
                      child: Text(l10n.white_water, style: TextStyle(fontSize: context.dp(1.6), fontWeight: FontWeight.w500)),
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.maxHeight, style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                            Text('${state.cleanWaters.alturaMaxima} cm', style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Slider(
                          value: state.cleanWaters.alturaMaxima.toDouble(),
                          min: 1,
                          max: 200,
                          onChanged: (value) {
                            context.read<DepositosBloc>().add(
                                  ChangeCleanWaters(
                                    state.cleanWaters.copyWith(
                                      alturaMaxima: value.toInt(),
                                    ),
                                  ),
                                );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.minHeight, style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                            Text('${state.cleanWaters.alturaMinima} cm', style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Slider(
                          value: state.cleanWaters.alturaMinima.toDouble(),
                          min: 1,
                          max: 200,
                          onChanged: (value) {
                            context.read<DepositosBloc>().add(
                                  ChangeCleanWaters(
                                    state.cleanWaters.copyWith(
                                      alturaMinima: value.toInt(),
                                    ),
                                  ),
                                );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.volume, style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                            Text('${state.cleanWaters.volumen} L   ', style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Slider(
                          value: state.cleanWaters.volumen.toDouble(),
                          min: 1,
                          max: 200,
                          onChanged: (value) {
                            context.read<DepositosBloc>().add(
                                  ChangeCleanWaters(
                                    state.cleanWaters.copyWith(
                                      volumen: value.toInt(),
                                    ),
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: context.dp(1), horizontal: context.dp(2)),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.primaryColorLight),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Padding(
                      padding: EdgeInsets.symmetric(vertical: context.dp(1)),
                      child: Text(l10n.gray_water, style: TextStyle(fontSize: context.dp(1.6), fontWeight: FontWeight.w500)),
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.maxHeight, style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                            Text('${state.greyWaters.alturaMaxima} cm', style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Slider(
                          value: state.greyWaters.alturaMaxima.toDouble(),
                          min: 1,
                          max: 200,
                          onChanged: (value) {
                            context.read<DepositosBloc>().add(
                                  ChangeGreyWaters(
                                    state.greyWaters.copyWith(
                                      alturaMaxima: value.toInt(),
                                    ),
                                  ),
                                );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.minHeight, style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                            Text('${state.greyWaters.alturaMinima} cm', style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Slider(
                          value: state.greyWaters.alturaMinima.toDouble(),
                          min: 1,
                          max: 200,
                          onChanged: (value) {
                            context.read<DepositosBloc>().add(
                                  ChangeGreyWaters(
                                    state.greyWaters.copyWith(
                                      alturaMinima: value.toInt(),
                                    ),
                                  ),
                                );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.volume, style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                            Text('${state.greyWaters.volumen} L   ', style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Slider(
                          value: state.greyWaters.volumen.toDouble(),
                          min: 1,
                          max: 200,
                          onChanged: (value) {
                            context.read<DepositosBloc>().add(
                                  ChangeGreyWaters(
                                    state.greyWaters.copyWith(
                                      volumen: value.toInt(),
                                    ),
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: context.dp(1), horizontal: context.dp(2)),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.primaryColorLight),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Padding(
                      padding: EdgeInsets.symmetric(vertical: context.dp(1)),
                      child: Text(l10n.black_water, style: TextStyle(fontSize: context.dp(1.6), fontWeight: FontWeight.w500)),
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.maxHeight, style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                            Text('${state.blackWaters.alturaMaxima} cm', style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Slider(
                          value: state.blackWaters.alturaMaxima.toDouble(),
                          min: 1,
                          max: 200,
                          onChanged: (value) {
                            context.read<DepositosBloc>().add(
                                  ChangeBlackWaters(
                                    state.blackWaters.copyWith(
                                      alturaMaxima: value.toInt(),
                                    ),
                                  ),
                                );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.minHeight, style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                            Text('${state.blackWaters.alturaMinima} cm', style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Slider(
                          value: state.blackWaters.alturaMinima.toDouble(),
                          min: 1,
                          max: 200,
                          onChanged: (value) {
                            context.read<DepositosBloc>().add(
                                  ChangeBlackWaters(
                                    state.blackWaters.copyWith(
                                      alturaMinima: value.toInt(),
                                    ),
                                  ),
                                );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.volume, style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                            Text('${state.blackWaters.volumen} L   ', style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Slider(
                          value: state.blackWaters.volumen.toDouble(),
                          min: 1,
                          max: 200,
                          onChanged: (value) {
                            context.read<DepositosBloc>().add(
                                  ChangeBlackWaters(
                                    state.blackWaters.copyWith(
                                      volumen: value.toInt(),
                                    ),
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: context.dp(1), horizontal: context.dp(2)),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.primaryColorLight),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Padding(
                      padding: EdgeInsets.symmetric(vertical: context.dp(1)),
                      child: Text(l10n.boiler_diesel, style: TextStyle(fontSize: context.dp(1.6), fontWeight: FontWeight.w500)),
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.maxHeight, style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                            Text('${state.gasoil.alturaMaxima} cm', style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Slider(
                          value: state.gasoil.alturaMaxima.toDouble(),
                          min: 1,
                          max: 200,
                          onChanged: (value) {
                            context.read<DepositosBloc>().add(
                                  ChangeGasoil(
                                    state.gasoil.copyWith(
                                      alturaMaxima: value.toInt(),
                                    ),
                                  ),
                                );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.minHeight, style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                            Text('${state.gasoil.alturaMinima} cm', style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Slider(
                          value: state.gasoil.alturaMinima.toDouble(),
                          min: 1,
                          max: 200,
                          onChanged: (value) {
                            context.read<DepositosBloc>().add(
                                  ChangeGasoil(
                                    state.gasoil.copyWith(
                                      alturaMinima: value.toInt(),
                                    ),
                                  ),
                                );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.volume, style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                            Text('${state.gasoil.volumen} L   ', style: TextStyle(fontSize: context.dp(1.4), fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Slider(
                          value: state.gasoil.volumen.toDouble(),
                          min: 1,
                          max: 200,
                          onChanged: (value) {
                            context.read<DepositosBloc>().add(
                                  ChangeGasoil(
                                    state.gasoil.copyWith(
                                      volumen: value.toInt(),
                                    ),
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
