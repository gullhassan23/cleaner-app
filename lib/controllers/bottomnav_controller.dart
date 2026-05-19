import 'package:get/get.dart';

import 'package:cleaner_app/bindings/contacts_binding.dart';
import 'package:cleaner_app/bindings/vault_binding.dart';

/// Drives bottom navigation: Clean, Contacts, Compress, Vault, More.
class BottomNavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  /// First time the Contacts tab is selected we register contacts bindings and
  /// mount the nested navigator (avoids contacts permission work at cold start).
  final RxBool contactsNavigatorReady = false.obs;

  /// First time the Vault tab is selected we register vault bindings.
  final RxBool vaultTabReady = false.obs;

  void goToCleaner() => currentIndex.value = 0;

  void goToCompress() => currentIndex.value = 2;

  void goToContacts() {
    prepareContactsTab();
    currentIndex.value = 1;
  }

  void selectTab(int index) {
    if (index == 1) {
      prepareContactsTab();
    }
    if (index == 3) {
      prepareVaultTab();
    }
    currentIndex.value = index;
  }

  void prepareContactsTab() {
    if (!contactsNavigatorReady.value) {
      ContactsBinding().dependencies();
      contactsNavigatorReady.value = true;
    }
  }

  void prepareVaultTab() {
    if (!vaultTabReady.value) {
      VaultBinding().dependencies();
      vaultTabReady.value = true;
    }
  }
}
