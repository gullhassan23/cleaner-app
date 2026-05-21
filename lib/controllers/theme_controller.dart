import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/theme/theme_preferences_service.dart';
import '../utils/app_theme.dart';

/// Single source of truth for [ThemeMode]; drives [GetMaterialApp.themeMode]
/// via the root [Obx] in [MyApp].
class ThemeController extends GetxController {
  ThemeController({
    required ThemePreferencesService prefs,
    required ThemeMode initial,
  })  : _prefs = prefs,
        themeMode = initial.obs;

  final ThemePreferencesService _prefs;

  final Rx<ThemeMode> themeMode;

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  ThemeData get activeTheme =>
      AppTheme.resolve(isDarkMode ? AppThemeVariant.dark : AppThemeVariant.light);

  Brightness get activeBrightness =>
      isDarkMode ? Brightness.dark : Brightness.light;

  void setDarkModeEnabled(bool enabled) {
    setThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }

  /// Updates [themeMode] and persists in the background. Root [Obx] applies
  /// the change to [GetMaterialApp]; do not call [Get.changeThemeMode].
  void setThemeMode(ThemeMode mode) {
    if (mode == ThemeMode.system) {
      mode = ThemeMode.light;
    }
    if (themeMode.value == mode) return;
    themeMode.value = mode;
    unawaited(_prefs.saveThemeMode(mode));
  }
}
