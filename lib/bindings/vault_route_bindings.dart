import 'package:get/get.dart';

import 'package:cleaner_app/controllers/private_vault/vault_albums_controller.dart';
import 'package:cleaner_app/controllers/private_vault/vault_change_pin_controller.dart';
import 'package:cleaner_app/controllers/private_vault/vault_gate_controller.dart';
import 'package:cleaner_app/controllers/private_vault/vault_home_controller.dart';
import 'package:cleaner_app/controllers/private_vault/vault_pin_setup_controller.dart';
import 'package:cleaner_app/controllers/private_vault/vault_preview_controller.dart';
import 'package:cleaner_app/controllers/private_vault/vault_settings_controller.dart';
import 'package:cleaner_app/controllers/private_vault/vault_unlock_controller.dart';
import 'private_vault_binding.dart';

class VaultAuthSetupBinding extends Bindings {
  @override
  void dependencies() {
    PrivateVaultBinding().dependencies();
    Get.lazyPut(VaultPinSetupController.new);
  }
}

class VaultAuthUnlockBinding extends Bindings {
  @override
  void dependencies() {
    PrivateVaultBinding().dependencies();
    Get.lazyPut(VaultUnlockController.new);
  }
}

class VaultHomeBinding extends Bindings {
  @override
  void dependencies() {
    PrivateVaultBinding().dependencies();
    Get.lazyPut(VaultHomeController.new);
  }
}

class VaultAlbumsBinding extends Bindings {
  @override
  void dependencies() {
    PrivateVaultBinding().dependencies();
    Get.lazyPut(VaultAlbumsController.new);
  }
}

class VaultPreviewBinding extends Bindings {
  @override
  void dependencies() {
    PrivateVaultBinding().dependencies();
    Get.lazyPut(VaultPreviewController.new, fenix: true);
  }
}

class VaultSettingsBinding extends Bindings {
  @override
  void dependencies() {
    PrivateVaultBinding().dependencies();
    Get.lazyPut(VaultSettingsController.new);
  }
}

class VaultChangePinBinding extends Bindings {
  @override
  void dependencies() {
    PrivateVaultBinding().dependencies();
    Get.lazyPut(VaultChangePinController.new);
  }
}

class VaultGateBinding extends Bindings {
  @override
  void dependencies() {
    PrivateVaultBinding().dependencies();
    Get.lazyPut(VaultGateController.new);
  }
}
