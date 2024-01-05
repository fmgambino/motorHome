import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motor_home/core/common/helpers/index.dart';
import 'package:motor_home/core/config/index.dart';
import 'package:motor_home/core/shared/ui/blocs/index.dart';
import 'package:motor_home/core/shared/ui/widgets/index.dart';
import 'package:motor_home/features/bluetooth/ui/screens/splash_bluetooth_screen.dart';
import 'package:motor_home/injection_container.dart';
import 'package:motor_home/l10n/l10n.dart';

class SelectProtocolScreen extends StatefulWidget {
  const SelectProtocolScreen({super.key});

  @override
  State<SelectProtocolScreen> createState() => _SelectProtocolScreenState();
}

class _SelectProtocolScreenState extends State<SelectProtocolScreen> {
  late final ConfigCubit configCubit;
  @override
  void initState() {
    configCubit = sl.get<ConfigCubit>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return BlocBuilder<ConfigCubit, ConfigState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: CircleAvatar(
                child: Text(
                  languageCode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: configCubit.changeLanguage,
            ),
            actions: [
              IconButton(
                icon: Icon(
                  icon,
                  color: color,
                ),
                onPressed: configCubit.changeTheme,
              ),
            ],
            backgroundColor: theme.secondaryHeaderColor,
          ),
          persistentFooterAlignment: AlignmentDirectional.center,
          persistentFooterButtons: [
            ElevatedButton(
              onPressed: () {
                configCubit.setFirstTime();
                Navigator.of(context).push(navegarMapaFadeIn(context, const SplashScreenBluetooth(), '/splash_bluetooth'));
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: theme.secondaryHeaderColor,
                minimumSize: Size(double.infinity, context.dp(5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.dp(1)),
                ),
              ),
              child: Text(l10n.continueButton),
            ),
          ],
          body: Padding(
            padding: EdgeInsets.all(context.dp(1)),
            child: Column(
              children: [
                Container(
                  height: context.dp(18),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.secondaryHeaderColor,
                      width: context.dp(0.2),
                    ),
                  ),
                  padding: EdgeInsets.all(context.dp(2)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: context.dp(10),
                        width: context.dp(10),
                        child: FadeInImage(
                          image: Image.asset(
                            'assets/images/png/logo.png',
                            // fit: BoxFit.contain,
                          ).image,
                          placeholder: Image.asset(
                            'assets/images/gif/loading.gif',
                            fit: BoxFit.contain,
                          ).image,
                          placeholderErrorBuilder: (_, __, ___) => const CircularProgressIndicator(),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: context.dp(10),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: KeyedSubtree(
                              key: ValueKey(l10n.welcomme),
                              child: Text(
                                l10n.welcomme,
                                style: TextStyle(
                                  fontSize: context.dp(1.8),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.dp(1)),
                ProtocolCard(title: 'Bluetooth', subtitle: l10n.bluetoothDescription),
                SizedBox(height: context.dp(1)),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/deposits');
                  },
                  child: ProtocolCard(title: l10n.deposits, subtitle: l10n.depositsDescription),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

extension _SelectProtocolScreenStateX on _SelectProtocolScreenState {
  static final cubit = sl.get<ConfigCubit>();
  IconData get icon => cubit.state.isDarkMode! ? FontAwesomeIcons.lightbulb : FontAwesomeIcons.solidLightbulb;
  Color get color => cubit.state.isDarkMode! ? Colors.grey[350]! : Colors.yellow[900]!;
  String get languageCode => cubit.state.locale!.languageCode.toUpperCase();
}
