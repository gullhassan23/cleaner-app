import 'package:flutter/widgets.dart';

import 'app_localizations.dart';
import 'charging_l10n.dart';

export 'charging_l10n.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension L10nAppLocalizations on AppLocalizations {
  String chargingAnimationTitleFor(String id) => chargingTitleFor(this, id);
}
