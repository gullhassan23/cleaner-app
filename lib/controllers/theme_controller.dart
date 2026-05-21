import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../services/theme/theme_preferences_service.dart';
import '../utils/app_theme.dart';

/// Single source of truth for [ThemeMode].
///
/// Drives [AppThemeAnimatedBuilder] via [activeTheme]. [GetMaterialApp] is kept
/// stable (fixed baseline [themeMode]); do not call [Get.changeThemeMode].
class ThemeController extends GetxController {
  ThemeController({
    required ThemePreferencesService prefs,
    required ThemeMode initial,
  })  : _prefs = prefs,
        themeMode = initial.obs;

  final ThemePreferencesService _prefs;

  final Rx<ThemeMode> themeMode;

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  /// Cached [AppTheme.light] / [AppTheme.dark] — safe for [AnimatedTheme].
  ThemeData get activeTheme =>
      isDarkMode ? AppTheme.dark : AppTheme.light;

  Brightness get activeBrightness =>
      isDarkMode ? Brightness.dark : Brightness.light;

  @override
  void onInit() {
    super.onInit();
    _syncSystemChrome();
    ever(themeMode, (_) => _syncSystemChrome());
  }

  void setDarkModeEnabled(bool enabled) {
    setThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }

  /// Updates [themeMode] and persists in the background.
  void setThemeMode(ThemeMode mode) {
    if (mode == ThemeMode.system) {
      mode = ThemeMode.light;
    }
    if (themeMode.value == mode) return;
    themeMode.value = mode;
    unawaited(_prefs.saveThemeMode(mode));
  }

  void _syncSystemChrome() {
    final overlay = activeBrightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    SystemChrome.setSystemUIOverlayStyle(
      overlay.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
  }
}
