import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motor_home/core/config/index.dart';
import 'package:motor_home/core/shared/ui/blocs/index.dart';
import 'package:motor_home/injection_container.dart';

class ProtocolCard extends StatelessWidget {
  const ProtocolCard({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: context.dp(18),
      child: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.secondaryHeaderColor,
            width: context.dp(0.2),
          ),
        ),
        child: ListTile(
          style: ListTileStyle.drawer,
          leading: Icon(
            icon,
            color: color,
            size: context.dp(8),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          subtitle: SizedBox(
            height: context.dp(12),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: KeyedSubtree(
                key: ValueKey(subtitle),
                child: Text(
                  subtitle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension ProtocolCardX on ProtocolCard {
  static final cubit = sl.get<ConfigCubit>();
  Color get color => title == 'Bluetooth' ? Colors.blue : Colors.grey;
  IconData get icon => title == 'Bluetooth' ? FontAwesomeIcons.bluetooth : FontAwesomeIcons.sliders;
}
