import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../features/vault/controllers/vault_controller.dart';
import '../repositories/vault_repository.dart';
import '../services/permissions/photo_permission_service.dart';
import '../services/vault/vault_repository_impl.dart';
import '../services/vault/vault_service.dart';

class VaultBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<VaultService>()) {
      Get.put(VaultService(), permanent: true);
    }
    if (!Get.isRegistered<VaultRepository>()) {
      Get.put<VaultRepository>(
        VaultRepositoryImpl(
          secureStorage: Get.find<FlutterSecureStorage>(),
          localAuth: Get.find<LocalAuthentication>(),
          vaultService: Get.find<VaultService>(),
          permissionService: Get.find<PhotoPermissionService>(),
        ),
        permanent: true,
      );
    }
    if (!Get.isRegistered<VaultController>()) {
      Get.put(VaultController(), permanent: true);
    }
  }
}
