abstract final class AppRoutes {
  /// Root shell: bottom nav (Cleaner | Contacts | Compress | Vault | More).
  static const main = '/';

  static const settings = '/settings';

  static const appLockSetup = '/app-lock/setup';
  static const appLockVerifyDisable = '/app-lock/verify-disable';

  /// Nested [Navigator] ids ([Get.nestedKey]) per bottom tab.
  static const cleanerNestedNavigatorId = 10;
  static const contactsNestedNavigatorId = 1;
  static const compressNestedNavigatorId = 2;
  static const vaultNestedNavigatorId = 3;
  static const moreNestedNavigatorId = 4;

  // —— Cleaner tab ——
  static const cleanerDashboard = '/cleaner/dashboard';
  static const aiPhotoEditor = '/cleaner/ai-photo-editor';

  // —— Contacts tab ——
  static const contactsHub = '/contacts/hub';
  static const contactsList = '/contacts/list';
  static const contactsBackup = '/contacts/backup';
  static const contactsDuplicates = '/contacts/duplicates';
  static const contactsIncomplete = '/contacts/incomplete';

  // —— Compress tab ——
  static const compressMain = '/compress/main';
  static const compressReview = '/compress/review';

  // —— Private Vault (nested under [privateVaultRoot]) ——
  static const privateVaultRoot = '/private-vault';
  static const privateVaultGate = '/private-vault/gate';
  static const privateVaultSetup = '/private-vault/setup';
  static const privateVaultUnlock = '/private-vault/unlock';
  static const privateVaultHome = '/private-vault/home';
  static const privateVaultAlbums = '/private-vault/albums';
  static const privateVaultPreview = '/private-vault/preview';
  static const privateVaultSettings = '/private-vault/settings';
  static const privateVaultSecurity = '/private-vault/security';
  static const privateVaultChangePin = '/private-vault/change-pin';

  @Deprecated('Use privateVaultSetup')
  static const vaultSetup = privateVaultSetup;
  @Deprecated('Use privateVaultUnlock')
  static const vaultUnlock = privateVaultUnlock;
  @Deprecated('Use privateVaultHome')
  static const vaultHome = privateVaultHome;
  @Deprecated('Use privateVaultPreview')
  static const vaultMediaPreview = privateVaultPreview;

  // —— More tab ——
  static const moreTools = '/more/tools';
  static const cleanupGuide = '/more/cleanup-guide';
  static const cleanupGuideFlow = '/more/cleanup-guide/flow';
  static const chargingHome = '/charging/home';
  static const chargingSelect = '/charging/select';
  static const chargingPreview = '/charging/preview';

  /// Full-screen charging display; stays on root navigator for auto-show overlay.
  static const chargingDisplay = '/charging/display';

  // —— Global (settings, shortcuts) ——
  static const photoWidgetHub = '/photo-widget';
  static const photoWidgetAlbum = '/photo-widget/album';
  static const photoWidgetPicker = '/photo-widget/picker';
  static const photoWidgetStyle = '/photo-widget/style';

  @Deprecated('Use chargingHome')
  static const chargingAnimation = chargingHome;
}
