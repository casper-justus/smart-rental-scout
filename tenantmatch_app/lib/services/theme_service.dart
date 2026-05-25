import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static final ValueNotifier<ThemeMode> modeNotifier =
      ValueNotifier(ThemeMode.light);

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('tm-dark-mode') ?? false;
    modeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static void toggle() {
    final newMode = modeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    modeNotifier.value = newMode;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('tm-dark-mode', newMode == ThemeMode.dark);
    });
  }

  static bool get isDark => modeNotifier.value == ThemeMode.dark;
}
