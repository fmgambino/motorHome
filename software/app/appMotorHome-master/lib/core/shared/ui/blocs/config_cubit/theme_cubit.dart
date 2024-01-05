import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:motor_home/core/common/index.dart';

part 'theme_state.dart';

class ConfigCubit extends HydratedCubit<ConfigState> {
  ConfigCubit() : super(ConfigState.initial());

  void setFirstTime() {
    emit(
      state.copyWith(
        firstTime: false,
      ),
    );
  }

  void changeTheme() {
    emit(
      state.copyWith(
        isDarkMode: !state.isDarkMode!,
        themeMode: state.isDarkMode! ? ThemeMode.light : ThemeMode.dark,
      ),
    );
  }

  void changeLanguage() {
    emit(
      state.copyWith(
        locale: state.locale == const Locale('en') ? const Locale('es') : const Locale('en'),
      ),
    );
  }

  void changeProtocolType(ProtocolType protocolType) {
    emit(
      state.copyWith(
        protocolType: protocolType,
      ),
    );
  }

  @override
  ConfigState? fromJson(Map<String, dynamic> json) {
    return ConfigState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ConfigState state) {
    return state.toJson();
  }
}
