import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/shared_pref_services.dart';

/// Persists and exposes the chosen [ThemeMode] (light / dark / system).
class ThemeCubit extends Cubit<ThemeMode> {
  static const String _key = 'kThemeMode';

  ThemeCubit() : super(_load());

  static ThemeMode _load() {
    final stored = SharedPreferencesServices.getData(key: _key);
    switch (stored) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    emit(mode);
    await SharedPreferencesServices.setData(key: _key, value: mode.name);
  }

  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setMode(next);
  }
}
