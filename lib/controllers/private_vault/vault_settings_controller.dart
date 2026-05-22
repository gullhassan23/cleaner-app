import 'package:get/get.dart';

import 'package:cleaner_app/services/private_vault/vault_auth_service.dart';
import 'package:cleaner_app/services/private_vault/vault_session_service.dart';
import 'package:cleaner_app/routes/app_routes.dart';

class VaultSettingsController extends GetxController {
  final VaultAuthService _auth = Get.find();
  final VaultSessionService _session = Get.find();

  final removeAfterImport = false.obs;
  final biometricEnabled = false.obs;
  final canUseBiometrics = false.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    try {
      removeAfterImport.value = await _auth.getRemoveAfterImport();
      biometricEnabled.value = await _auth.isBiometricEnabled();
      canUseBiometrics.value = await _auth.canUseBiometrics();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setRemoveAfterImport(bool v) async {
    removeAfterImport.value = v;
    await _auth.setRemoveAfterImport(v);
  }

  Future<void> setBiometric(bool v) async {
    biometricEnabled.value = v;
    await _auth.setBiometricEnabled(v);
  }

  void lockNow() {
    _session.lock();
    Get.offNamed(
      AppRoutes.privateVaultUnlock,
      id: AppRoutes.vaultNestedNavigatorId,
    );
  }

  void openSecurity() {
    Get.toNamed(
      AppRoutes.privateVaultSecurity,
      id: AppRoutes.vaultNestedNavigatorId,
    );
  }
}
