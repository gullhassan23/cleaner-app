import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../controllers/applock/app_lock_controller.dart';

/// Locks the app when it leaves the foreground (if app lock is enabled).
class AppLockLifecycleCoordinator extends GetxService with WidgetsBindingObserver {
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
    if (!Get.isRegistered<AppLockController>()) return;
    final c = Get.find<AppLockController>();
    if (c.isAuthenticating.value || !c.isEnabled.value) return;

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
        c.lock();
        break;
      case AppLifecycleState.resumed:
      case AppLifecycleState.detached:
        break;
    }
  }
}
