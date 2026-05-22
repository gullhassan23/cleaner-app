import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'vault_session_service.dart';

/// Locks vault session when app leaves foreground.
class VaultLifecycleCoordinator extends GetxService with WidgetsBindingObserver {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!Get.isRegistered<VaultSessionService>()) return;
    final session = Get.find<VaultSessionService>();
    if (!session.isUnlocked.value) return;

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
        session.lock();
        break;
      case AppLifecycleState.resumed:
      case AppLifecycleState.detached:
        break;
    }
  }
}
