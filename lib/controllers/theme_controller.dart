import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists and exposes [ThemeMode] for [GetMaterialApp.themeMode].
class ThemeController extends GetxController {
  ThemeController(ThemeMode initial) : themeMode = initial.obs;

  static const _prefsKey = 'app_theme_mode';

  final Rx<ThemeMode> themeMode;

  static Future<ThemeMode> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    return _parse(prefs.getString(_prefsKey)) ?? ThemeMode.system;
  }

  static ThemeMode? _parse(String? raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return null;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _serialize(mode));
  }

  static String _serialize(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
