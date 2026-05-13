import 'package:get/get.dart';

import 'package:cleaner_app/bindings/contacts_binding.dart';

/// Drives bottom navigation: Clean, Contacts, Compress, Private, More.
class MainShellController extends GetxController {
  final RxInt currentIndex = 0.obs;

  /// First time the Contacts tab is selected we register contacts bindings and
  /// mount the nested navigator (avoids contacts permission work at cold start).
  final RxBool contactsNavigatorReady = false.obs;

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
    currentIndex.value = index;
  }

  void prepareContactsTab() {
    if (!contactsNavigatorReady.value) {
      ContactsBinding().dependencies();
      contactsNavigatorReady.value = true;
    }
  }
}
