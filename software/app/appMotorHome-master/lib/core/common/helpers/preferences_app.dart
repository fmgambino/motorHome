import 'package:shared_preferences/shared_preferences.dart';

class PreferencesApp {
  static late SharedPreferences _prefs;
  static Future<SharedPreferences> init() async => _prefs = await SharedPreferences.getInstance();

  static String _token = '';

  static String get token => _prefs.getString('token') ?? _token;

  static set token(String value) {
    _token = value;
    _prefs.setString('token', value);
  }

  static String _topic = '';

  static String get topic => _prefs.getString('topic') ?? _topic;

  static set topic(String value) {
    _topic = value;
    _prefs.setString('topic', value);
  }

  static String _localeName = 'en';

  static String get localeName => _prefs.getString('localeName') ?? _localeName;

  static set localeName(String value) {
    _localeName = value;
    _prefs.setString('localeName', value);
  }

  static bool _isDarkMode = false;

  static bool get isDarkMode => _prefs.getBool('isDarkMode') ?? _isDarkMode;

  static set isDarkMode(bool value) {
    _isDarkMode = value;
    _prefs.setBool('isDarkMode', value);
  }
}
