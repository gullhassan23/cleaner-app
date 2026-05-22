import 'package:cleaner_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import 'package:cleaner_app/routes/app_routes.dart';
import 'package:cleaner_app/services/permissions/photo_permission_service.dart';
import 'package:cleaner_app/services/private_vault/vault_auth_service.dart';
import 'package:cleaner_app/models/private_vault/vault_media.dart';
import 'package:cleaner_app/services/private_vault/vault_album_repository.dart';
import 'package:cleaner_app/services/private_vault/vault_media_repository.dart';
import 'package:cleaner_app/models/private_vault/vault_constants.dart';
import 'package:cleaner_app/widgets/private_vault/vault_import_bottom_sheet.dart';

class VaultHomeController extends GetxController {
  final VaultMediaRepository _media = Get.find();
  final VaultAlbumRepository _albums = Get.find();
  final VaultAuthService _auth = Get.find();
  final PhotoPermissionService _permissions = Get.find();

  final items = <VaultMedia>[].obs;
  final photoCount = 0.obs;
  final videoCount = 0.obs;
  final isLoading = true.obs;
  final isImporting = false.obs;
  final importProgress = 0.0.obs;
  final selectionMode = false.obs;
  final selectedIds = <String>{}.obs;
  final hasMore = true.obs;

  var _offset = 0;
  final String _albumId = VaultConstants.defaultAlbumId;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  Future<void> loadInitial() async {
    isLoading.value = true;
    _offset = 0;
    items.clear();
    try {
      await _albums.ensureDefaultAlbum();
      await _refreshCounts();
      await _loadPage();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _refreshCounts() async {
    final c = await _media.countByAlbum(_albumId);
    photoCount.value = c.photos;
    videoCount.value = c.videos;
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;
    await _loadPage();
  }

  Future<void> _loadPage() async {
    final page = await _media.getPage(
      albumId: _albumId,
      offset: _offset,
      limit: VaultConstants.mediaPageSize,
    );
    items.addAll(page.items);
    _offset += page.items.length;
    hasMore.value = page.hasMore;
  }

  void toggleSelectionMode() {
    selectionMode.value = !selectionMode.value;
    if (!selectionMode.value) selectedIds.clear();
  }

  void toggleSelect(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    selectedIds.refresh();
  }

  void selectAll() {
    selectedIds
      ..clear()
      ..addAll(items.map((e) => e.id));
    selectedIds.refresh();
  }

  Future<void> deleteSelected() async {
    if (selectedIds.isEmpty) return;
    await _media.deleteMedia(selectedIds.toList());
    selectedIds.clear();
    selectionMode.value = false;
    await loadInitial();
  }

  void openPreview(int index) {
    if (index < 0 || index >= items.length) return;
    final media = items[index];
    Get.toNamed(
      AppRoutes.privateVaultPreview,
      id: AppRoutes.vaultNestedNavigatorId,
      arguments: {
        'albumId': _albumId,
        'mediaId': media.id,
        'index': index,
        'items': items.toList(),
      },
    )?.then((_) => loadInitial());
  }

  Future<void> showImportSheet() async {
    await Get.bottomSheet(
      VaultImportBottomSheet(
        onCamera: _importFromCamera,
        onGallery: _importFromGallery,
      ),
      isScrollControlled: true,
    );
  }

  Future<void> _importFromGallery() async {
    Get.back();
    final state = await _permissions.requestMediaPermission();
    if (!state.canAccess) {
      final l10n = AppLocalizations.of(Get.context!);
      Get.snackbar(l10n.vaultPermissionTitle, l10n.vaultPhotoLibraryRequired);
      return;
    }

    final ctx = Get.context!;
    final theme = Theme.of(ctx);
    final picked = await AssetPicker.pickAssets(
      ctx,
      pickerConfig: AssetPickerConfig(
        maxAssets: VaultConstants.maxImportBatch,
        requestType: RequestType.common,
        pickerTheme: AssetPicker.themeData(
          theme.colorScheme.primary,
          light: theme.brightness == Brightness.light,
        ),
      ),
    );
    if (picked == null || picked.isEmpty) return;
    await _runImport(picked);
  }

  Future<void> _importFromCamera() async {
    Get.back();
    final entity = await CameraPicker.pickFromCamera(
      Get.context!,
      pickerConfig: const CameraPickerConfig(enableRecording: true),
    );
    if (entity == null) return;
    await _runImport([entity]);
  }

  Future<void> _runImport(List<AssetEntity> assets) async {
    isImporting.value = true;
    importProgress.value = 0;
    try {
      final remove = await _auth.getRemoveAfterImport();
      final summary = await _media.importFromGalleryAssets(
        assets: assets,
        albumId: _albumId,
        removeAfterImport: remove,
        onProgress: (done, total) {
          importProgress.value = done / total;
        },
      );
      await loadInitial();
      final l10n = AppLocalizations.of(Get.context!);
      Get.snackbar(
        l10n.vaultImportTitle,
        l10n.vaultImportedCount(summary.importedCount),
      );
    } finally {
      isImporting.value = false;
      importProgress.value = 0;
    }
  }
}
