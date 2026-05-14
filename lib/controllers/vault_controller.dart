import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../models/photo_library/scan_state_entity.dart';
import '../repositories/vault_repository.dart';
import '../routes/app_routes.dart';
import '../services/permissions/photo_permission_service.dart';
import '../models/vault/vault_media_model.dart';
import '../models/vault/vault_result.dart';

enum VaultShellState { setup, unlock, home }

class VaultController extends GetxController {
  VaultRepository get _repo => Get.find<VaultRepository>();
  PhotoPermissionService get _perm => Get.find<PhotoPermissionService>();

  final shell = VaultShellState.setup.obs;
  final mediaItems = <VaultMediaModel>[].obs;
  final isImporting = false.obs;
  final importDone = 0.obs;
  final importTotal = 0.obs;
  final selectionMode = false.obs;
  final selectedIds = <String>{}.obs;
  final unlockPinDigits = ''.obs;
  final isLimitedLibrary = false.obs;

  int _failedPinAttempts = 0;
  DateTime? _pinBackoffUntil;

  Worker? _sessionWorker;

  @override
  void onInit() {
    super.onInit();
    _sessionWorker = ever<bool>(_repo.sessionUnlocked, _onSessionChanged);
    unawaited(_bootstrap());
  }

  @override
  void onClose() {
    _sessionWorker?.dispose();
    super.onClose();
  }

  void _onSessionChanged(bool unlocked) {
    if (!unlocked) {
      unawaited(_handleLocked());
    } else {
      shell.value = VaultShellState.home;
      unawaited(refreshMedia());
    }
  }

  Future<void> _handleLocked() async {
    unlockPinDigits.value = '';
    if (await _repo.isSetupComplete()) {
      shell.value = VaultShellState.unlock;
    }
  }

  Future<void> _bootstrap() async {
    final limited =
        (await _perm.getMediaPermissionState()).status ==
        MediaPermissionStatus.limited;
    isLimitedLibrary.value = limited;

    if (!await _repo.isSetupComplete()) {
      shell.value = VaultShellState.setup;
      return;
    }
    if (_repo.sessionUnlocked.value) {
      shell.value = VaultShellState.home;
      await refreshMedia();
    } else {
      shell.value = VaultShellState.unlock;
    }
  }

  Future<void> refreshMedia() async {
    final res = await _repo.loadMediaIndex();
    if (res.isSuccess && res.data != null) {
      mediaItems.assignAll(res.data!);
    }
  }

  Future<void> refreshLibraryBanner() async {
    final limited =
        (await _perm.getMediaPermissionState()).status ==
        MediaPermissionStatus.limited;
    isLimitedLibrary.value = limited;
  }

  Future<void> requestGalleryAccess() async {
    await _perm.requestMediaPermission();
    await refreshLibraryBanner();
  }

  Future<void> openSystemPhotoSettings() => _perm.openAppSettings();

  Future<void> presentManageLibraryAccess() async {
    await _perm.presentLimitedMediaPicker();
    await refreshLibraryBanner();
  }

  Future<VaultResult<void>> completeSetup({
    required String pin,
    required bool enableBiometric,
  }) async {
    final r = await _repo.completeSetup(
      pin: pin,
      enableBiometric: enableBiometric,
    );
    if (r.isSuccess) {
      shell.value = VaultShellState.home;
      await refreshMedia();
    }
    return r;
  }

  bool get _inPinBackoff {
    final until = _pinBackoffUntil;
    return until != null && DateTime.now().isBefore(until);
  }

  Future<void> submitUnlockPin() async {
    if (_inPinBackoff) {
      Get.snackbar(
        'Vault',
        'Too many attempts. Try again in a few seconds.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final pin = unlockPinDigits.value;
    if (pin.length != 4) return;
    final ok = await _repo.unlockWithPin(pin);
    if (!ok) {
      _failedPinAttempts++;
      unlockPinDigits.value = '';
      if (_failedPinAttempts >= 5) {
        _pinBackoffUntil = DateTime.now().add(const Duration(seconds: 5));
        _failedPinAttempts = 0;
        Get.snackbar(
          'Vault',
          'Too many incorrect PIN attempts. Wait 5 seconds.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Vault',
          'Incorrect PIN.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    }
    _failedPinAttempts = 0;
    _pinBackoffUntil = null;
    unlockPinDigits.value = '';
  }

  Future<void> submitBiometricUnlock() async {
    final ok = await _repo.unlockWithBiometrics();
    if (!ok) {
      Get.snackbar(
        'Vault',
        'Biometric authentication failed or is unavailable.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void appendUnlockDigit(String d) {
    if (unlockPinDigits.value.length >= 4) return;
    unlockPinDigits.value += d;
    if (unlockPinDigits.value.length == 4) {
      unawaited(submitUnlockPin());
    }
  }

  void backspaceUnlock() {
    final s = unlockPinDigits.value;
    if (s.isEmpty) return;
    unlockPinDigits.value = s.substring(0, s.length - 1);
  }

  void lockVault() {
    _repo.lockSession();
  }

  void toggleSelectionMode() {
    selectionMode.toggle();
    selectedIds.clear();
  }

  void toggleSelect(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  void clearSelection() => selectedIds.clear();

  Future<void> deleteSelected() async {
    if (selectedIds.isEmpty) return;
    final ids = selectedIds.toList(growable: false);
    final r = await _repo.deleteFromVault(ids);
    if (r.isSuccess) {
      selectedIds.clear();
      selectionMode.value = false;
      await refreshMedia();
    } else {
      Get.snackbar('Vault', r.errorMessage ?? 'Delete failed');
    }
  }

  Future<void> importFromPicker() async {
    final perm = await _perm.getMediaPermissionState();
    if (!perm.canAccess) {
      await requestGalleryAccess();
      final after = await _perm.getMediaPermissionState();
      if (!after.canAccess) {
        Get.snackbar(
          'Vault',
          'Photo library access is required to import media.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    final pickedRaw = await Get.toNamed<dynamic>(AppRoutes.vaultMediaPicker);
    if (pickedRaw is! List<AssetEntity> || pickedRaw.isEmpty) return;
    final picked = pickedRaw;

    final removeOriginal = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Remove from Photos?'),
        content: const Text(
          'Choose whether to keep a copy in your library after import.\n\n'
          'Removing originals sends items to Recently Deleted on iOS (until purged). '
          'On Android they may be removed from the gallery depending on your device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Keep in library'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Remove from library'),
          ),
        ],
      ),
    );
    if (removeOriginal == null) return;

    isImporting.value = true;
    importDone.value = 0;
    importTotal.value = picked.length;
    try {
      final res = await _repo.importAssets(
        picked,
        removeFromGalleryAfterImport: removeOriginal,
        onProgress: (done, total) {
          importDone.value = done;
          importTotal.value = total;
        },
      );
      if (!res.isSuccess) {
        Get.snackbar('Vault', res.errorMessage ?? 'Import failed');
        return;
      }
      final summary = res.data!;
      if (summary.failedItems.isNotEmpty) {
        Get.snackbar(
          'Vault',
          'Imported ${summary.importedCount}. ${summary.failedItems.length} failed.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          'Vault',
          'Imported ${summary.importedCount} item(s).',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      if (summary.galleryDeleteFailedIds.isNotEmpty) {
        Get.snackbar(
          'Vault',
          'Some items could not be removed from the library.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      await refreshMedia();
    } finally {
      isImporting.value = false;
    }
  }
}
