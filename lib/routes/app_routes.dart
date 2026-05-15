abstract final class AppRoutes {
  /// Root shell: bottom nav (Cleaner | Contacts | Compress | Vault | More).
  static const main = '/';

  static const compressReview = '/compress/review';

  static const aiPhotoEditor = '/cleaner/ai-photo-editor';

  /// Nested [Navigator] under the Contacts tab ([Get.nestedKey] id).
  static const contactsNestedNavigatorId = 1;

  static const contactsHub = '/contacts/hub';
  static const contactsList = '/contacts/list';
  static const contactsBackup = '/contacts/backup';
  static const contactsDuplicates = '/contacts/duplicates';
  static const contactsIncomplete = '/contacts/incomplete';

  static const vaultMediaPicker = '/vault/media/picker';
  static const vaultMediaPreview = '/vault/media/preview';

  static const settings = '/settings';

  static const appLockSetup = '/app-lock/setup';
  static const appLockVerifyDisable = '/app-lock/verify-disable';

  static const chargingHome = '/charging/home';
  static const chargingSelect = '/charging/select';
  static const chargingPreview = '/charging/preview';
  static const chargingDisplay = '/charging/display';

  @Deprecated('Use chargingHome')
  static const chargingAnimation = chargingHome;
}
