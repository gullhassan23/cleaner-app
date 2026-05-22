import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import 'package:cleaner_app/services/private_vault/vault_auth_service.dart';
import 'package:cleaner_app/services/private_vault/vault_crypto_service.dart';
import 'package:cleaner_app/services/private_vault/vault_file_store.dart';
import 'package:cleaner_app/services/private_vault/vault_database.dart';
import 'package:cleaner_app/services/private_vault/vault_album_repository_impl.dart';
import 'package:cleaner_app/services/private_vault/vault_media_repository_impl.dart';
import 'package:cleaner_app/services/private_vault/vault_album_repository.dart';
import 'package:cleaner_app/services/private_vault/vault_media_repository.dart';
import 'package:cleaner_app/services/private_vault/vault_lifecycle_coordinator.dart';
import 'package:cleaner_app/services/private_vault/vault_session_service.dart';

class PrivateVaultBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<VaultCryptoService>()) {
      Get.put(
        VaultCryptoService(storage: Get.find<FlutterSecureStorage>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<VaultFileStore>()) {
      Get.put(VaultFileStore(), permanent: true);
    }
    if (!Get.isRegistered<VaultDatabase>()) {
      Get.put(VaultDatabase(), permanent: true);
    }
    if (!Get.isRegistered<VaultAuthService>()) {
      Get.put(
        VaultAuthService(
          storage: Get.find<FlutterSecureStorage>(),
          localAuth: Get.find<LocalAuthentication>(),
        ),
        permanent: true,
      );
    }
    if (!Get.isRegistered<VaultAlbumRepository>()) {
      Get.put<VaultAlbumRepository>(
        VaultAlbumRepositoryImpl(Get.find<VaultDatabase>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<VaultMediaRepository>()) {
      Get.put<VaultMediaRepository>(
        VaultMediaRepositoryImpl(
          database: Get.find<VaultDatabase>(),
          crypto: Get.find<VaultCryptoService>(),
          fileStore: Get.find<VaultFileStore>(),
        ),
        permanent: true,
      );
    }
    if (!Get.isRegistered<VaultSessionService>()) {
      Get.put(VaultSessionService(), permanent: true);
    }
    if (!Get.isRegistered<VaultLifecycleCoordinator>()) {
      Get.put(VaultLifecycleCoordinator(), permanent: true);
    }

    Get.find<VaultMediaRepository>().purgeScratch();
  }
}
