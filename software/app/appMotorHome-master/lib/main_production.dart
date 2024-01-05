import 'package:motor_home/background_fetch_config.dart';
import 'package:motor_home/bootstrap.dart';
import 'package:motor_home/core/app/app.dart';

void main() {
  bootstrap(() => const App());
  configureBackgroundFetch();
}
