import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists app [Locale] via SharedPreferences.
class LocalePreferencesService extends GetxService {
  static const _prefsKey = 'app_locale';

  Future<Locale> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return _parse(prefs.getString(_prefsKey)) ?? const Locale('en');
  }

  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _serialize(locale));
  }

  static Locale? _parse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final parts = raw.split('_');
    if (parts.length == 1) return Locale(parts[0]);
    return Locale(parts[0], parts[1]);
  }

  static String _serialize(Locale locale) {
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }
}
