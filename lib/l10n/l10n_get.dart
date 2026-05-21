import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'app_localizations.dart';

/// Resolves [AppLocalizations] from the active GetX route, or English fallback.
AppLocalizations getL10n() {
  final ctx = Get.context;
  if (ctx != null) {
    return AppLocalizations.of(ctx);
  }
  return lookupAppLocalizations(const Locale('en'));
}
