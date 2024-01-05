import 'package:flutter/material.dart';
import 'package:motor_home/core/config/index.dart';
import 'package:motor_home/core/shared/ui/widgets/protocols_widget.dart';
import 'package:motor_home/l10n/l10n.dart';

class WelcomeHeaderWidget extends StatelessWidget {
  const WelcomeHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: context.dp(7),
            left: 0,
            right: 0,
            bottom: 0,
            child: Card(
              color: theme.colorScheme.surface,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.dp(1)),
              ),
              child: Padding(
                padding: EdgeInsets.all(context.dp(2)).copyWith(
                  top: context.dp(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.welcomme,
                      style: TextStyle(
                        fontSize: context.dp(1.8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: context.dp(2)),
                    ProtocolCard(
                      title: 'Bluetooth',
                      subtitle: l10n.bluetoothDescription,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -context.dp(3),
            left: context.width / 2 - context.dp(12),
            child: Container(
              height: context.dp(20),
              width: context.dp(20),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset(
                'assets/images/png/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
