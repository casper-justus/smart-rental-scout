import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static final ValueNotifier<ThemeMode> modeNotifier =
      ValueNotifier(ThemeMode.system);

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('tm-theme-mode') ?? 'system';
    modeNotifier.value = _fromString(stored);
  }

  static void cycleMode() {
    final order = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
    final idx = order.indexOf(modeNotifier.value);
    final next = order[(idx + 1) % order.length];
    modeNotifier.value = next;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('tm-theme-mode', _toString(next));
    });
  }

  static String get label {
    switch (modeNotifier.value) {
      case ThemeMode.system:
        return 'Auto';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  static ThemeMode _fromString(String s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _toString(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}
