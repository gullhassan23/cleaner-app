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

  // —— Vault tab ——
  static const vaultSetup = '/vault/setup';
  static const vaultUnlock = '/vault/unlock';
  static const vaultHome = '/vault/home';
  static const vaultMediaPicker = '/vault/media/picker';
  static const vaultMediaPreview = '/vault/media/preview';

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
