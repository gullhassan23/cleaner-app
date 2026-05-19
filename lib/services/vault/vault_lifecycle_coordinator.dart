import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../repositories/vault_repository.dart';

/// Locks the vault crypto session when the app leaves the foreground.
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
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      _lockVaultSession();
    }
  }

  void _lockVaultSession() {
    if (Get.isRegistered<VaultRepository>()) {
      Get.find<VaultRepository>().lockSession();
    }
  }
}
