import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:cleaner_app/l10n/l10n_get.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../utils/bytes_formatter.dart';
import '../../models/compress/compress_entities.dart';
import '../../models/photo_library/photo_asset_entity.dart';
import '../../models/photo_library/scan_state_entity.dart';
import '../../services/photo_library/photo_library_use_cases.dart';
import '../../services/compression/media_compression_service.dart';
import '../../models/compress/compress_session_state.dart';

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
  bool _cancelRequested = false;
  Timer? _galleryChangeDebounce;

  final Rx<CompressSessionState> state = CompressSessionState.initial().obs;

  @override
  void onInit() {
    super.onInit();
    PhotoManager.addChangeCallback(_onGalleryChanged);
    unawaited(PhotoManager.startChangeNotify());
  }

  @override
  void onClose() {
    _galleryChangeDebounce?.cancel();
    PhotoManager.removeChangeCallback(_onGalleryChanged);
    unawaited(PhotoManager.stopChangeNotify());
    super.onClose();
  }

  void _onGalleryChanged(MethodCall call) {
    _galleryChangeDebounce?.cancel();
    _galleryChangeDebounce = Timer(const Duration(milliseconds: 500), () {
      if (!permissionState.canAccess || isCompressing) {
        return;
      }
      // Saving compressed media updates the gallery. A full reload wipes the
      // active review selection and completed results on the review screen.
      unawaited(_mergeGalleryRefresh());
    });
  }

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

  int get selectedOriginalBytes =>
      selectedAssets.fold<int>(0, (sum, asset) => sum + asset.fileSize);

  int get estimatedCompressedBytes =>
      (selectedOriginalBytes * quality.estimatedOutputRatio).round();

  int get estimatedSavedBytes =>
      selectedOriginalBytes > estimatedCompressedBytes
          ? selectedOriginalBytes - estimatedCompressedBytes
          : 0;

  bool get hasActualCompressionResults =>
      results.isNotEmpty && results.every((result) => result.isSuccess);

  int get actualOriginalBytes =>
      results.fold<int>(0, (sum, result) => sum + result.originalBytes);

  int get actualCompressedBytes =>
      results.fold<int>(0, (sum, result) => sum + result.compressedBytes);

  int get actualSavedBytes =>
      results.fold<int>(0, (sum, result) => sum + result.savedBytes);

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
          errorMessage: getL10n().compressUnableCheckPermission,
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
          errorMessage: getL10n().compressUnableRequestPermission,
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
    if (state.value.isLoadingInitial && !force) {
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
        videosOnly: true,
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
          errorMessage: getL10n().compressUnableLoadGallery,
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
        videosOnly: true,
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
          errorMessage: getL10n().compressUnableLoadMore,
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
    _applySession(
      (current) => current.copyWith(
        quality: preset,
        results: const <CompressedMediaResultEntity>[],
        progress: const CompressionProgressEntity(
          phase: CompressionPhase.idle,
          processedCount: 0,
          totalCount: 0,
          label: '',
        ),
        clearSuccessMessage: true,
        clearErrorMessage: true,
      ),
    );
  }

  void clearMessages() {
    _applySession(
      (current) =>
          current.copyWith(clearErrorMessage: true, clearSuccessMessage: true),
    );
  }

  Future<List<CompressedMediaResultEntity>> compressSelectedAssets() async {
    final assets = selectedAssets;
    if (assets.isEmpty || isCompressing) {
      developer.log(
        'compressSelectedAssets skipped '
        'empty=${assets.isEmpty} isCompressing=$isCompressing',
        name: 'CompressSession',
      );
      return results;
    }
    developer.log(
      'compressSelectedAssets started assets=${assets.length} '
      'quality=${quality.label} targetCompressionPercent=${quality.compressionPercent}%',
      name: 'CompressSession',
    );
    _cancelRequested = false;

    final l10n = getL10n();
    _applySession(
      (current) => current.copyWith(
        isCompressing: true,
        results: const <CompressedMediaResultEntity>[],
        progress: CompressionProgressEntity(
          phase: CompressionPhase.running,
          processedCount: 0,
          totalCount: assets.length,
          label: l10n.compressPreparingCompression,
          currentFileProgress: 0,
        ),
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    final output = List<CompressedMediaResultEntity?>.filled(
      assets.length,
      null,
    );
    final perAssetProgress = <String, double>{};
    final activeIndexes = <int>{};
    var completedCount = 0;
    var nextIndex = 0;
    // `video_compress` is not safe to run concurrently and exposes a
    // single-listener progress stream, so process selected videos sequentially.
    final hasVideoAsset = assets.any((asset) => asset.isVideo);
    final workerCount = hasVideoAsset ? 1 : math.min(assets.length, 2);

    void publishProgress({String? activeLabel}) {
      final runningProgress = activeIndexes.fold<double>(
        0,
        (sum, index) => sum + (perAssetProgress[assets[index].id] ?? 0),
      );
      final aggregate =
          assets.isEmpty
              ? 0.0
              : ((completedCount + runningProgress) / assets.length);
      final scaled = (aggregate * assets.length).clamp(
        0.0,
        assets.length.toDouble(),
      );
      final processedCount = scaled.floor();
      final currentProgress = (scaled - processedCount).clamp(0.0, 1.0);
      _applySession(
        (current) => current.copyWith(
          progress: CompressionProgressEntity(
            phase: CompressionPhase.running,
            processedCount: processedCount,
            totalCount: assets.length,
            label:
                activeLabel == null
                    ? getL10n().compressPreparingCompression
                    : getL10n().compressCompressingItem(activeLabel),
            currentFileLabel: activeLabel,
            currentFileProgress: currentProgress,
          ),
        ),
      );
    }

    Future<void> worker() async {
      while (!_cancelRequested) {
        if (nextIndex >= assets.length) {
          return;
        }
        final index = nextIndex;
        nextIndex += 1;
        final asset = assets[index];
        final fileLabel = asset.title ?? '${index + 1}';
        perAssetProgress[asset.id] = 0;
        activeIndexes.add(index);
        publishProgress(activeLabel: fileLabel);

        developer.log(
          'Compressing asset index=$index id=${asset.id} title=$fileLabel',
          name: 'CompressSession',
        );

        final result = await _mediaCompressionService.compressAsset(
          asset,
          quality: quality,
          onProgress: (progress) {
            if (_cancelRequested) {
              return;
            }
            perAssetProgress[asset.id] = progress.clamp(0.0, 1.0);
            publishProgress(activeLabel: fileLabel);
          },
        );

        activeIndexes.remove(index);
        perAssetProgress.remove(asset.id);
        if (_cancelRequested) {
          return;
        }

        output[index] = result;
        completedCount += 1;
        if (result.isSuccess) {
          final savedBytes = result.savedBytes;
          final actualCompressionPercent = result.originalBytes > 0
              ? ((savedBytes / result.originalBytes) * 100).round()
              : 0;
          final summary =
              '[Compress Session] File: $fileLabel | '
              'User selected: ${quality.label.toUpperCase()} '
              '(target ${quality.targetKeepPercent}% of original size) | '
              'Original: ${BytesFormatter.humanize(result.originalBytes)} → '
              'Compressed: ${BytesFormatter.humanize(result.compressedBytes)} | '
              'Saved: ${BytesFormatter.humanize(savedBytes)} | '
              'Actual compression: $actualCompressionPercent%';
          // ignore: avoid_print
          print(summary);
          developer.log(summary, name: 'CompressSession');
        } else {
          developer.log(
            'Asset compression failed index=$index id=${asset.id} '
            'userSelected=${quality.label} error=${result.errorMessage}',
            name: 'CompressSession',
          );
        }
        _applySession(
          (current) => current.copyWith(
            results: output.whereType<CompressedMediaResultEntity>().toList(
              growable: false,
            ),
            progress: CompressionProgressEntity(
              phase: CompressionPhase.running,
              processedCount: completedCount,
              totalCount: assets.length,
              label:
                  completedCount == assets.length
                      ? getL10n().compressFinalizingCompression
                      : getL10n().compressCompressedCount(
                        completedCount,
                        assets.length,
                      ),
              currentFileLabel: fileLabel,
              currentFileProgress: 1,
            ),
          ),
        );
      }
    }

    await Future.wait(
      List<Future<void>>.generate(workerCount, (_) => worker()),
      eagerError: false,
    );
    final completedOutput = output
        .whereType<CompressedMediaResultEntity>()
        .toList(growable: false);

    final successCount =
        completedOutput.where((result) => result.isSuccess).length;
    final savedBytes = completedOutput.fold<int>(
      0,
      (sum, result) => sum + result.savedBytes,
    );
    final failedCount = completedOutput.length - successCount;
    final phase =
        _cancelRequested
            ? CompressionPhase.idle
            : (successCount == 0
                ? CompressionPhase.failed
                : CompressionPhase.completed);

    if (successCount > 0) {
      await _mergeGalleryRefresh(extraAssets: assets);
    }

    if (!_cancelRequested && successCount > 0) {
      final totalOriginal = completedOutput.fold<int>(
        0,
        (sum, r) => sum + r.originalBytes,
      );
      final totalCompressed = completedOutput.fold<int>(
        0,
        (sum, r) => sum + r.compressedBytes,
      );
      final outputPercent = totalOriginal > 0
          ? ((totalCompressed / totalOriginal) * 100).round()
          : 0;
      final targetKeepPercent =
          (quality.estimatedOutputRatio * 100).round();
      final batchSummary =
          '[Compress Batch Done] User selected: ${quality.label.toUpperCase()} '
          '(compress to ~$targetKeepPercent% of original) | '
          'Files: $successCount | '
          'Total original: ${BytesFormatter.humanize(totalOriginal)} → '
          'Total after compress: ${BytesFormatter.humanize(totalCompressed)} | '
          'Total saved: ${BytesFormatter.humanize(savedBytes)} | '
          'Output is $outputPercent% of original (target $targetKeepPercent%)';
      // ignore: avoid_print
      print(batchSummary);
      developer.log(batchSummary, name: 'CompressSession');
    }

    final doneL10n = getL10n();
    _applySession(
      (current) => current.copyWith(
        isCompressing: false,
        results: List<CompressedMediaResultEntity>.unmodifiable(
          completedOutput,
        ),
        progress: CompressionProgressEntity(
          phase: phase,
          processedCount: completedOutput.length,
          totalCount: assets.length,
          label:
              _cancelRequested
                  ? ''
                  : (successCount == completedOutput.length
                      ? doneL10n.compressCompressionComplete
                      : doneL10n.compressCompressedSummary(
                        successCount,
                        completedOutput.length,
                      )),
          currentFileProgress: _cancelRequested ? 0 : 1,
        ),
        errorMessage:
            _cancelRequested
                ? null
                : (successCount == 0
                    ? doneL10n.compressUnableCompressSelected
                    : (failedCount > 0
                        ? doneL10n.compressFailedCount(failedCount)
                        : null)),
        successMessage:
            _cancelRequested
                ? '${doneL10n.commonCancel}.'
                : (successCount > 0
                    ? doneL10n.compressSuccessMessage(
                      BytesFormatter.humanize(savedBytes),
                      successCount,
                    )
                    : null),
      ),
    );
    final wasCancelled = _cancelRequested;
    _cancelRequested = false;

    developer.log(
      'compressSelectedAssets finished '
      'successCount=$successCount total=${completedOutput.length} '
      'cancelled=$wasCancelled',
      name: 'CompressSession',
    );

    return completedOutput;
  }

  Future<void> cancelCompression() async {
    if (!isCompressing) {
      return;
    }
    _cancelRequested = true;
    await _mediaCompressionService.cancelOngoingCompression();
  }

  Future<void> _mergeGalleryRefresh({
    List<PhotoAssetEntity> extraAssets = const <PhotoAssetEntity>[],
  }) async {
    try {
      final galleryPage = await _fetchMediaGalleryPageUseCase(
        page: 0,
        pageSize: state.value.pageSize,
        videosOnly: true,
      );
      final mergedItems = <PhotoAssetEntity>[];
      final seenIds = <String>{};

      for (final asset in [
        ...galleryPage.items,
        ...extraAssets,
        ...selectedAssets,
      ]) {
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
