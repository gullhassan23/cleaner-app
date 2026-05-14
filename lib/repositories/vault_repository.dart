import 'dart:io';

import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../models/vault/vault_media_model.dart';
import '../models/vault/vault_result.dart';

/// High-level vault API (PIN, biometrics, media, encrypted index).
abstract class VaultRepository {
  RxBool get sessionUnlocked;

  Future<bool> isSetupComplete();

  /// Persists PIN hash, AES index key, optional biometric preference, writes empty index.
  Future<VaultResult<void>> completeSetup({
    required String pin,
    required bool enableBiometric,
  });

  Future<bool> isBiometricEnabled();

  Future<VaultResult<void>> setBiometricEnabled(bool enabled);

  /// Returns true if PIN matches stored hash (does not unlock).
  Future<bool> pinMatches(String pin);

  Future<bool> unlockWithPin(String pin);

  Future<bool> unlockWithBiometrics();

  void lockSession();

  Future<VaultResult<List<VaultMediaModel>>> loadMediaIndex();

  Future<VaultResult<VaultImportSummary>> importAssets(
    List<AssetEntity> assets, {
    required bool removeFromGalleryAfterImport,
    void Function(int completed, int total)? onProgress,
  });

  Future<VaultResult<void>> deleteFromVault(List<String> ids);

  Future<VaultResult<void>> restoreToGallery(VaultMediaModel item);

  Future<File?> fileFor(VaultMediaModel item);
}

class VaultImportSummary {
  const VaultImportSummary({
    required this.importedCount,
    required this.failedItems,
    required this.galleryDeleteFailedIds,
  });

  final int importedCount;
  final List<String> failedItems;
  final List<String> galleryDeleteFailedIds;
}
