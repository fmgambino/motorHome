part of 'theme_cubit.dart';

class ConfigState extends Equatable {
  const ConfigState({
    required this.isDarkMode,
    required this.themeMode,
    required this.locale,
    required this.protocolType,
    required this.firstTime,
  });

  factory ConfigState.fromJson(Map<String, dynamic> json) {
    return ConfigState(
      isDarkMode: json['isDarkMode'] as bool?,
      themeMode: json['themeMode'] == 'dark' ? ThemeMode.dark : ThemeMode.light,
      locale: Locale(json['locale'] as String),
      protocolType: ProtocolType.values[json['protocolType'] as int],
      firstTime: json['firstTime'] as bool?,
    );
  }

  factory ConfigState.initial() {
    return const ConfigState(
      isDarkMode: false,
      themeMode: ThemeMode.light,
      locale: Locale('en'),
      protocolType: ProtocolType.bluetooth,
      firstTime: true,
    );
  }

  final bool? isDarkMode;
  final ThemeMode? themeMode;
  final Locale? locale;
  final ProtocolType? protocolType;
  final bool? firstTime;

  Map<String, dynamic> toJson() => {
        'isDarkMode': isDarkMode,
        'themeMode': themeMode == ThemeMode.dark ? 'dark' : 'light',
        'locale': locale.toString(),
        'protocolType': protocolType?.index,
        'firstTime': firstTime,
      };

  ConfigState copyWith({
    bool? isDarkMode,
    ThemeMode? themeMode,
    Locale? locale,
    ProtocolType? protocolType,
    bool? firstTime,
  }) {
    return ConfigState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      protocolType: protocolType ?? this.protocolType,
      firstTime: firstTime ?? this.firstTime,
    );
  }

  @override
  List<Object?> get props => [
        isDarkMode,
        locale,
        protocolType,
        themeMode,
        firstTime,
      ];
}
