import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../data/datasources/vault_auth_service.dart';
import '../../data/datasources/vault_crypto_service.dart';
import '../../data/datasources/vault_file_store.dart';
import '../../data/datasources/vault_database.dart';
import '../../data/repositories/vault_album_repository_impl.dart';
import '../../data/repositories/vault_media_repository_impl.dart';
import '../../domain/repositories/vault_album_repository.dart';
import '../../domain/repositories/vault_media_repository.dart';
import '../services/vault_lifecycle_coordinator.dart';
import '../services/vault_session_service.dart';

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
