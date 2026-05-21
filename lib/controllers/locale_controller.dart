import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../l10n/app_localizations.dart';
import '../services/locale/locale_preferences_service.dart';

/// Single source of truth for app [Locale].
class LocaleController extends GetxController {
  LocaleController({
    required LocalePreferencesService prefs,
    required Locale initial,
  })  : _prefs = prefs,
        locale = initial.obs;

  final LocalePreferencesService _prefs;

  final Rx<Locale> locale;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
    Locale('zh'),
    Locale('ar'),
    Locale('es'),
  ];

  static const languageOptions = <_LanguageOption>[
    _LanguageOption(Locale('en'), 'languageEnglish'),
    _LanguageOption(Locale('ur'), 'languageUrdu'),
    _LanguageOption(Locale('zh'), 'languageChinese'),
    _LanguageOption(Locale('ar'), 'languageArabic'),
    _LanguageOption(Locale('es'), 'languageSpanish'),
  ];

  bool get isRtl {
    final code = locale.value.languageCode;
    return code == 'ar' || code == 'ur';
  }

  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  String labelFor(AppLocalizations l10n, Locale loc) {
    switch (loc.languageCode) {
      case 'en':
        return l10n.languageEnglish;
      case 'ur':
        return l10n.languageUrdu;
      case 'zh':
        return l10n.languageChinese;
      case 'ar':
        return l10n.languageArabic;
      case 'es':
        return l10n.languageSpanish;
      default:
        return l10n.languageEnglish;
    }
  }

  void setLocale(Locale value) {
    final normalized = _normalize(value);
    if (locale.value == normalized) return;
    locale.value = normalized;
    Get.updateLocale(normalized);
    unawaited(_prefs.saveLocale(normalized));
  }

  static Locale _normalize(Locale value) {
    for (final supported in supportedLocales) {
      if (supported.languageCode == value.languageCode) {
        return supported;
      }
    }
    return const Locale('en');
  }
}

class _LanguageOption {
  const _LanguageOption(this.locale, this.labelKey);
  final Locale locale;
  final String labelKey;
}
