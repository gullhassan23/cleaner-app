import 'dart:async';

import 'package:get/get.dart';

import '../utils/bytes_formatter.dart';
import '../models/compress/compress_entities.dart';
import '../models/photo_library/photo_asset_entity.dart';
import '../models/photo_library/scan_state_entity.dart';
import '../services/photo_library/photo_library_use_cases.dart';
import '../services/compression/media_compression_service.dart';
import '../models/compress/compress_session_state.dart';

class CompressSessionController extends GetxController {
  static const String permissionUpdateId = 'compress_permission';
  static const String contentUpdateId = 'compress_content';
  static const String selectionUpdateId = 'compress_selection';
  static const String qualityUpdateId = 'compress_quality';
  static const String progressUpdateId = 'compress_progress';

  CompressSessionController({
    required GetMediaPermissionStateUseCase getMediaPermissionStateUseCase,
    required RequestMediaPermissionUseCase requestMediaPermissionUseCase,
    required FetchMediaGalleryPageUseCase fetchMediaGalleryPageUseCase,
    required OpenPhotoSettingsUseCase openPhotoSettingsUseCase,
    required PresentLimitedMediaPickerUseCase presentLimitedMediaPickerUseCase,
    required MediaCompressionService mediaCompressionService,
  }) : _getMediaPermissionStateUseCase = getMediaPermissionStateUseCase,
       _requestMediaPermissionUseCase = requestMediaPermissionUseCase,
       _fetchMediaGalleryPageUseCase = fetchMediaGalleryPageUseCase,
       _openPhotoSettingsUseCase = openPhotoSettingsUseCase,
       _presentLimitedMediaPickerUseCase = presentLimitedMediaPickerUseCase,
       _mediaCompressionService = mediaCompressionService;

  final GetMediaPermissionStateUseCase _getMediaPermissionStateUseCase;
  final RequestMediaPermissionUseCase _requestMediaPermissionUseCase;
  final FetchMediaGalleryPageUseCase _fetchMediaGalleryPageUseCase;
  final OpenPhotoSettingsUseCase _openPhotoSettingsUseCase;
  final PresentLimitedMediaPickerUseCase _presentLimitedMediaPickerUseCase;
  final MediaCompressionService _mediaCompressionService;

  final Rx<CompressSessionState> state = CompressSessionState.initial().obs;

  PermissionStateEntity get permissionState => state.value.permissionState;
  List<PhotoAssetEntity> get mediaItems => state.value.mediaItems;
  Set<String> get selectedAssetIds => state.value.selectedAssetIds;
  CompressionQualityPreset get quality => state.value.quality;
  CompressionProgressEntity get progress => state.value.progress;
  List<CompressedMediaResultEntity> get results => state.value.results;
  String? get errorMessage => state.value.errorMessage;
  String? get successMessage => state.value.successMessage;
  bool get isCompressing => state.value.isCompressing;
  bool get hasSelection => state.value.hasSelection;

  List<PhotoAssetEntity> get selectedAssets => mediaItems
      .where((asset) => selectedAssetIds.contains(asset.id))
      .toList(growable: false);

  int get selectedOriginalBytes => selectedAssets.fold<int>(
    0,
    (sum, asset) => sum + asset.fileSize,
  );

  int get estimatedCompressedBytes =>
      (selectedOriginalBytes * quality.estimatedOutputRatio).round();

  int get estimatedSavedBytes =>
      selectedOriginalBytes > estimatedCompressedBytes
          ? selectedOriginalBytes - estimatedCompressedBytes
          : 0;

  Future<void> initialize() async {
    if (permissionState.status == MediaPermissionStatus.initial) {
      await loadPermissionState();
      return;
    }

    if (permissionState.canAccess && mediaItems.isEmpty) {
      await loadInitialMedia(force: true);
    }
  }

  Future<void> loadPermissionState() async {
    _applySession(
      (current) => current.copyWith(
        permissionState: const PermissionStateEntity(
          status: MediaPermissionStatus.loading,
        ),
        clearErrorMessage: true,
      ),
    );

    try {
      final permission = await _getMediaPermissionStateUseCase();
      _applySession((current) => current.copyWith(permissionState: permission));
      if (permission.canAccess && mediaItems.isEmpty) {
        await loadInitialMedia(force: true);
      }
    } catch (_) {
      _applySession(
        (current) => current.copyWith(
          permissionState: const PermissionStateEntity(
            status: MediaPermissionStatus.denied,
          ),
          errorMessage: 'Unable to check media permission state.',
        ),
      );
    }
  }

  Future<PermissionStateEntity> requestPermission() async {
    _applySession(
      (current) => current.copyWith(
        permissionState: const PermissionStateEntity(
          status: MediaPermissionStatus.loading,
        ),
        clearErrorMessage: true,
      ),
    );

    try {
      final permission = await _requestMediaPermissionUseCase();
      _applySession((current) => current.copyWith(permissionState: permission));
      if (permission.canAccess) {
        await loadInitialMedia(force: true);
      }
      return permission;
    } catch (_) {
      const denied = PermissionStateEntity(
        status: MediaPermissionStatus.denied,
      );
      _applySession(
        (current) => current.copyWith(
          permissionState: denied,
          errorMessage: 'Unable to request media permission.',
        ),
      );
      return denied;
    }
  }

  Future<void> openAppSettings() {
    return _openPhotoSettingsUseCase();
  }

  Future<void> manageLimitedLibrary() async {
    await _presentLimitedMediaPickerUseCase();
    await loadPermissionState();
  }

  Future<void> loadInitialMedia({bool force = false}) async {
    if (!permissionState.canAccess) {
      return;
    }
    if (state.value.isLoadingInitial) {
      return;
    }
    if (!force && mediaItems.isNotEmpty) {
      return;
    }

    _applySession(
      (current) => current.copyWith(
        isLoadingInitial: true,
        isLoadingMore: false,
        page: 0,
        hasMore: false,
        mediaItems: const <PhotoAssetEntity>[],
        selectedAssetIds: <String>{},
        results: const <CompressedMediaResultEntity>[],
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      final galleryPage = await _fetchMediaGalleryPageUseCase(
        page: 0,
        pageSize: state.value.pageSize,
      );
      _applySession(
        (current) => current.copyWith(
          mediaItems: galleryPage.items,
          page: galleryPage.page,
          totalCount: galleryPage.totalCount,
          hasMore: galleryPage.hasMore,
          isLoadingInitial: false,
        ),
      );
    } catch (_) {
      _applySession(
        (current) => current.copyWith(
          isLoadingInitial: false,
          errorMessage: 'Unable to load gallery media.',
        ),
      );
    }
  }

  Future<void> loadMoreMedia() async {
    if (!state.value.canLoadMore) {
      return;
    }

    _applySession((current) => current.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.value.page + 1;
      final galleryPage = await _fetchMediaGalleryPageUseCase(
        page: nextPage,
        pageSize: state.value.pageSize,
      );
      final mergedItems = <PhotoAssetEntity>[
        ...mediaItems,
        ...galleryPage.items,
      ];
      _applySession(
        (current) => current.copyWith(
          mediaItems: mergedItems,
          page: galleryPage.page,
          totalCount: galleryPage.totalCount,
          hasMore: galleryPage.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      _applySession(
        (current) => current.copyWith(
          isLoadingMore: false,
          errorMessage: 'Unable to load more media.',
        ),
      );
    }
  }

  bool isSelected(String assetId) => selectedAssetIds.contains(assetId);

  void toggleSelection(String assetId) {
    final nextSelection = Set<String>.from(selectedAssetIds);
    if (!nextSelection.add(assetId)) {
      nextSelection.remove(assetId);
    }

    _applySession(
      (current) => current.copyWith(
        selectedAssetIds: nextSelection,
        clearSuccessMessage: true,
      ),
    );
  }

  void clearSelection() {
    _applySession(
      (current) => current.copyWith(
        selectedAssetIds: <String>{},
        clearSuccessMessage: true,
      ),
    );
  }

  void updateQuality(CompressionQualityPreset preset) {
    if (preset == quality) {
      return;
    }
    _applySession((current) => current.copyWith(quality: preset));
  }

  void clearMessages() {
    _applySession(
      (current) => current.copyWith(
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );
  }

  Future<List<CompressedMediaResultEntity>> compressSelectedAssets() async {
    final assets = selectedAssets;
    if (assets.isEmpty || isCompressing) {
      return results;
    }

    _applySession(
      (current) => current.copyWith(
        isCompressing: true,
        results: const <CompressedMediaResultEntity>[],
        progress: CompressionProgressEntity(
          phase: CompressionPhase.running,
          processedCount: 0,
          totalCount: assets.length,
          label: 'Preparing compression',
          currentFileProgress: 0,
        ),
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final output = <CompressedMediaResultEntity>[];
    for (var index = 0; index < assets.length; index++) {
      final asset = assets[index];
      _applySession(
        (current) => current.copyWith(
          progress: CompressionProgressEntity(
            phase: CompressionPhase.running,
            processedCount: index,
            totalCount: assets.length,
            label: 'Compressing ${asset.title ?? 'item ${index + 1}'}',
            currentFileLabel: asset.title ?? 'Item ${index + 1}',
            currentFileProgress: 0,
          ),
        ),
      );

      final result = await _mediaCompressionService.compressAsset(
        asset,
        quality: quality,
        onProgress: (progress) {
          _applySession(
            (current) => current.copyWith(
              progress: CompressionProgressEntity(
                phase: CompressionPhase.running,
                processedCount: index,
                totalCount: assets.length,
                label:
                    'Compressing ${asset.title ?? 'item ${index + 1}'} • ${(progress * 100).round()}%',
                currentFileLabel: asset.title ?? 'Item ${index + 1}',
                currentFileProgress: progress,
              ),
            ),
          );
        },
      );
      output.add(result);

      _applySession(
        (current) => current.copyWith(
          results: List<CompressedMediaResultEntity>.from(output),
          progress: CompressionProgressEntity(
            phase: CompressionPhase.running,
            processedCount: index + 1,
            totalCount: assets.length,
            label:
                index + 1 == assets.length
                    ? 'Finalizing compression'
                    : 'Compressed ${index + 1} of ${assets.length}',
            currentFileLabel: asset.title ?? 'Item ${index + 1}',
            currentFileProgress: 1,
          ),
        ),
      );
    }

    final successCount = output.where((result) => result.isSuccess).length;
    final savedBytes = output.fold<int>(
      0,
      (sum, result) => sum + result.savedBytes,
    );
    final failedCount = output.length - successCount;
    final phase =
        successCount == 0
            ? CompressionPhase.failed
            : CompressionPhase.completed;

    if (successCount > 0) {
      await _refreshVisibleMediaAfterCompression(preserveAssets: assets);
    }

    _applySession(
      (current) => current.copyWith(
        isCompressing: false,
        results: List<CompressedMediaResultEntity>.unmodifiable(output),
        progress: CompressionProgressEntity(
          phase: phase,
          processedCount: output.length,
          totalCount: assets.length,
          label:
              successCount == output.length
                  ? 'Compression complete'
                  : 'Compressed $successCount of ${output.length} items',
          currentFileProgress: 1,
        ),
        errorMessage:
            successCount == 0
                ? 'Unable to compress the selected media.'
                : (failedCount > 0
                    ? '$failedCount item(s) could not be compressed.'
                    : null),
        successMessage:
            successCount > 0
                ? 'Saved compressed copies to gallery. Total saved: ${BytesFormatter.humanize(savedBytes)} across $successCount item(s).'
                : null,
      ),
    );

    return output;
  }

  Future<void> _refreshVisibleMediaAfterCompression({
    required List<PhotoAssetEntity> preserveAssets,
  }) async {
    try {
      final galleryPage = await _fetchMediaGalleryPageUseCase(
        page: 0,
        pageSize: state.value.pageSize,
      );
      final mergedItems = <PhotoAssetEntity>[];
      final seenIds = <String>{};

      for (final asset in [...galleryPage.items, ...preserveAssets]) {
        if (seenIds.add(asset.id)) {
          mergedItems.add(asset);
        }
      }

      _applySession(
        (current) => current.copyWith(
          mediaItems: mergedItems,
          page: galleryPage.page,
          totalCount: galleryPage.totalCount,
          hasMore: galleryPage.hasMore,
        ),
      );
    } catch (_) {
      // Ignore refresh errors so successful compression results are still shown.
    }
  }

  void _applySession(
    CompressSessionState Function(CompressSessionState current) transform,
  ) {
    state.value = transform(state.value);
    update([
      permissionUpdateId,
      contentUpdateId,
      selectionUpdateId,
      qualityUpdateId,
      progressUpdateId,
    ]);
  }
}
