import 'app_localizations.dart';

/// Localized charging animation titles by catalog [id].
String chargingTitleFor(AppLocalizations l10n, String id) {
  switch (id) {
    case 'neon_battery':
      return l10n.chargingAnimNeonBattery;
    case 'circular_charge':
      return l10n.chargingAnimCircularCharge;
    case 'cyberpunk':
      return l10n.chargingAnimCyberpunk;
    case 'glowing_energy':
      return l10n.chargingAnimGlowingEnergy;
    case 'minimal_battery':
      return l10n.chargingAnimMinimalBattery;
    case 'futuristic_pulse':
      return l10n.chargingAnimFuturisticPulse;
    case 'liquid_wave':
      return l10n.chargingAnimLiquidWave;
    case 'aurora_ring':
      return l10n.chargingAnimAuroraRing;
    default:
      return id;
  }
}
