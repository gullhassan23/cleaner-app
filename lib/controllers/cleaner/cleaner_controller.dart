import 'dart:async';
import 'dart:io';

import 'package:cleaner_app/controllers/bottomnav_controller.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../models/cleaner/cleaner_dashboard_kind.dart';
import '../../models/cleaner/cleaner_dashboard_sort.dart';
import '../../models/cleaner/cleaner_gallery_scan_result.dart';
import '../../models/cleaner/cleaner_media_cluster.dart';
import '../../models/cleaner/cleaner_scan_phase.dart';
import '../../models/cleaner/cleaner_sheet_mode.dart';
import '../../models/photo_library/photo_asset_entity.dart';
import '../../models/photo_library/scan_state_entity.dart';
import '../../services/repositories/photo_library_repository.dart';
import '../../routes/app_routes.dart';
import '../../utils/photo_asset_sort.dart';
import '../../services/cleaner/duplicate_detector_service.dart';
import '../../services/cleaner/gallery_scan_coordinator.dart';
import '../../services/cleaner/similar_detector_service.dart';

import 'cleaner_group_sheet_controller.dart';
import '../../widgets/cleaner/cleaner_flat_media_bottom_sheet.dart';
import '../../widgets/cleaner/cleaner_group_bottom_sheet.dart';

class CleanerController extends GetxController {
  CleanerController({
    required PhotoLibraryRepository repository,
    required GalleryScanCoordinator scanCoordinator,
    required DuplicateDetectorService duplicateDetector,
    required SimilarDetectorService similarDetector,
  }) : _repository = repository,
       _scanCoordinator = scanCoordinator,
       _duplicateDetector = duplicateDetector,
       _similarDetector = similarDetector;

  final PhotoLibraryRepository _repository;
  final GalleryScanCoordinator _scanCoordinator;
  final DuplicateDetectorService _duplicateDetector;
  final SimilarDetectorService _similarDetector;

  final Rx<PermissionStateEntity> permission =
      const PermissionStateEntity(status: MediaPermissionStatus.initial).obs;

  final Rx<CleanerScanPhase> phase = CleanerScanPhase.idle.obs;
  final RxDouble scanProgress = 0.0.obs;
  final RxString scanStageLabel = ''.obs;
  final Rxn<String> lastError = Rxn<String>();

  final Rxn<CleanerGalleryScanResult> galleryResult = Rxn<CleanerGalleryScanResult>();
  final RxList<CleanerMediaCluster> duplicateClusters = <CleanerMediaCluster>[].obs;
  final RxList<CleanerMediaCluster> similarClusters = <CleanerMediaCluster>[].obs;

  final Rx<CleanerDashboardSort> dashboardSort =
      CleanerDashboardSort.largestFirst.obs;

  bool _cancelScan = false;
  bool _scanRunning = false;

  bool get isScanning =>
      phase.value == CleanerScanPhase.loadingLibrary ||
      phase.value == CleanerScanPhase.detectingDuplicates ||
      phase.value == CleanerScanPhase.detectingSimilar;

  bool get hasResults => phase.value == CleanerScanPhase.completed;

  List<CleanerMediaCluster> _sortedClusters(List<CleanerMediaCluster> source) {
    dashboardSort.value;
    final list = List<CleanerMediaCluster>.from(source);
    int compare(CleanerMediaCluster a, CleanerMediaCluster b) {
      switch (dashboardSort.value) {
        case CleanerDashboardSort.largestFirst:
          return b.totalBytes.compareTo(a.totalBytes);
        case CleanerDashboardSort.smallestFirst:
          return a.totalBytes.compareTo(b.totalBytes);
        case CleanerDashboardSort.newestDateFirst:
          return b.keeper.createdAt.compareTo(a.keeper.createdAt);
        case CleanerDashboardSort.oldestDateFirst:
          return a.keeper.createdAt.compareTo(b.keeper.createdAt);
      }
    }

    list.sort(compare);
    return list;
  }

  List<PhotoAssetEntity> _sortedAssets(List<PhotoAssetEntity> source) {
    dashboardSort.value;
    return sortedPhotoAssetsCopy(source, dashboardSort.value);
  }

  int countForKind(CleanerDashboardKind kind) {
    switch (kind) {
      case CleanerDashboardKind.similarPhotos:
        return similarClusters.fold<int>(
          0,
          (s, c) => s + c.memberCount,
        );
      case CleanerDashboardKind.duplicatePhotos:
        return duplicateClusters.fold<int>(
          0,
          (s, c) => s + c.memberCount,
        );
      case CleanerDashboardKind.videos:
        return galleryResult.value?.videoAssets.length ?? 0;
      case CleanerDashboardKind.screenshots:
        return galleryResult.value?.screenshotAssets.length ?? 0;
    }
  }

  int bytesForKind(CleanerDashboardKind kind) {
    final g = galleryResult.value;
    switch (kind) {
      case CleanerDashboardKind.similarPhotos:
        return similarClusters.fold<int>(0, (s, c) => s + c.totalBytes);
      case CleanerDashboardKind.duplicatePhotos:
        return duplicateClusters.fold<int>(0, (s, c) => s + c.totalBytes);
      case CleanerDashboardKind.videos:
        return g?.totalBytesFor(g.videoAssets) ?? 0;
      case CleanerDashboardKind.screenshots:
        return g?.totalBytesFor(g.screenshotAssets) ?? 0;
    }
  }

  PhotoAssetEntity? previewForKind(CleanerDashboardKind kind) {
    final g = galleryResult.value;
    switch (kind) {
      case CleanerDashboardKind.similarPhotos:
        if (similarClusters.isEmpty) {
          return null;
        }
        return _sortedClusters(similarClusters).first.keeper;
      case CleanerDashboardKind.duplicatePhotos:
        if (duplicateClusters.isEmpty) {
          return null;
        }
        return _sortedClusters(duplicateClusters).first.keeper;
      case CleanerDashboardKind.videos:
        if (g == null || g.videoAssets.isEmpty) {
          return null;
        }
        return _sortedAssets(g.videoAssets).first;
      case CleanerDashboardKind.screenshots:
        if (g == null || g.screenshotAssets.isEmpty) {
          return null;
        }
        return _sortedAssets(g.screenshotAssets).first;
    }
  }

  @override
  void onReady() {
    super.onReady();
    unawaited(_bootstrap());
  }

  @override
  void onClose() {
    _cancelScan = true;
    super.onClose();
  }

  Future<void> _bootstrap() async {
    await refreshPermission();
    if (permission.value.canAccess) {
      await startFullScan();
    }
  }

  Future<void> refreshPermission() async {
    try {
      final state = await _repository.getMediaPermissionState();
      permission.value = state;
    } catch (e) {
      lastError.value = e.toString();
      permission.value = const PermissionStateEntity(
        status: MediaPermissionStatus.denied,
      );
    }
  }

  Future<void> requestPermissionAndScan() async {
    try {
      final state = await _repository.requestMediaPermission();
      permission.value = state;
      if (state.canAccess) {
        await startFullScan();
      }
    } catch (e) {
      lastError.value = e.toString();
    }
  }

  Future<void> openAppSettings() => _repository.openAppSettings();

  Future<void> presentLimitedMediaPicker() =>
      _repository.presentLimitedMediaPicker();

  /// Opens the system photo picker when access is limited, then rescans.
  /// For full library access, refreshes permission and rescans the library.
  Future<void> changeGalleryAccess() async {
    if (!permission.value.canAccess || _scanRunning) {
      return;
    }
    try {
      final before = permission.value;
      if (before.isLimited || before.canOpenSystemPicker) {
        await _repository.presentLimitedMediaPicker();
      }
      await refreshPermission();
      if (permission.value.canAccess) {
        await startFullScan();
      }
    } catch (e) {
      lastError.value = e.toString();
    }
  }

  Future<void> startFullScan() async {
    if (_scanRunning || !permission.value.canAccess) {
      return;
    }
    _scanRunning = true;
    _cancelScan = false;
    lastError.value = null;
    scanProgress.value = 0;
    scanStageLabel.value = 'Preparing…';

    try {
      final temp = await getTemporaryDirectory();
      final scratch = Directory(p.join(temp.path, 'cleaner_scratch'));
      if (!await scratch.exists()) {
        await scratch.create(recursive: true);
      }
    } catch (_) {
      // Temp dir is optional; scan continues without scratch.
    }

    try {
      phase.value = CleanerScanPhase.loadingLibrary;
      scanStageLabel.value = 'Loading library…';

      CleanerGalleryScanResult? scanResult;
      await _scanCoordinator.loadFullLibrary(
        onProgress: (loaded, totalHint) {
          if (totalHint != null && totalHint > 0) {
            scanProgress.value = (loaded / totalHint) * 0.2;
          } else {
            scanProgress.value = (scanProgress.value + 0.01).clamp(0.0, 0.19);
          }
        },
      ).then((r) => scanResult = r);

      if (_cancelScan) {
        return;
      }

      galleryResult.value = scanResult;
      scanProgress.value = 0.2;

      phase.value = CleanerScanPhase.detectingDuplicates;
      scanStageLabel.value = 'Finding duplicate files…';

      final dupResult = await _duplicateDetector.findDuplicates(
        scanResult!.imageAssets,
        onProgress: (done, total) {
          if (total > 0) {
            scanProgress.value = 0.2 + (done / total) * 0.5;
          }
        },
        isCancelled: () => _cancelScan,
      );

      if (_cancelScan) {
        return;
      }

      duplicateClusters.assignAll(dupResult.clusters);

      phase.value = CleanerScanPhase.detectingSimilar;
      scanStageLabel.value = 'Finding similar photos…';

      final similar = await _similarDetector.findSimilar(
        scanResult!.imageAssets,
        assetIdToMd5Hex: dupResult.assetIdToMd5Hex,
        onProgress: (done, total) {
          if (total > 0) {
            scanProgress.value = 0.7 + (done / total) * 0.3;
          }
        },
        isCancelled: () => _cancelScan,
      );

      if (_cancelScan) {
        return;
      }

      similarClusters.assignAll(similar);
      scanProgress.value = 1;
      phase.value = CleanerScanPhase.completed;
      scanStageLabel.value = 'Done';
    } catch (e) {
      phase.value = CleanerScanPhase.failed;
      lastError.value = e.toString();
      scanStageLabel.value = 'Something went wrong';
    } finally {
      _scanRunning = false;
    }
  }

  void openCompress() {
    if (Get.isRegistered<BottomNavController>()) {
      Get.find<BottomNavController>().goToCompress();
    } else {
      unawaited(Get.offAllNamed<void>(AppRoutes.main));
    }
  }

  void openDuplicateSheet() {
    if (duplicateClusters.isEmpty) {
      return;
    }
    final tag = 'cleaner_sheet_${CleanerSheetMode.duplicates.name}';
    Get.put(
      CleanerGroupSheetController(
        mode: CleanerSheetMode.duplicates,
        clusters: _sortedClusters(duplicateClusters),
        onDeleted: removeDeletedAssets,
      ),
      tag: tag,
    );
    Get.bottomSheet<void>(
      CleanerGroupBottomSheet(tag: tag),
      isScrollControlled: true,
      enableDrag: true,
    ).whenComplete(() {
      if (Get.isRegistered<CleanerGroupSheetController>(tag: tag)) {
        Get.delete<CleanerGroupSheetController>(tag: tag);
      }
    });
  }

  void openSimilarSheet() {
    if (similarClusters.isEmpty) {
      return;
    }
    final tag = 'cleaner_sheet_${CleanerSheetMode.similar.name}';
    Get.put(
      CleanerGroupSheetController(
        mode: CleanerSheetMode.similar,
        clusters: _sortedClusters(similarClusters),
        onDeleted: removeDeletedAssets,
      ),
      tag: tag,
    );
    Get.bottomSheet<void>(
      CleanerGroupBottomSheet(tag: tag),
      isScrollControlled: true,
      enableDrag: true,
    ).whenComplete(() {
      if (Get.isRegistered<CleanerGroupSheetController>(tag: tag)) {
        Get.delete<CleanerGroupSheetController>(tag: tag);
      }
    });
  }

  void openVideosSheet() {
    final items = galleryResult.value?.videoAssets;
    if (items == null || items.isEmpty) {
      return;
    }
    CleanerFlatMediaBottomSheet.show(
      title: 'Videos',
      assets: _sortedAssets(items),
      onDeleted: removeDeletedAssets,
    );
  }

  void openScreenshotsSheet() {
    final items = galleryResult.value?.screenshotAssets;
    if (items == null || items.isEmpty) {
      return;
    }
    CleanerFlatMediaBottomSheet.show(
      title: 'Screenshots',
      assets: _sortedAssets(items),
      onDeleted: removeDeletedAssets,
    );
  }

  void removeDeletedAssets(Set<String> ids) {
    if (ids.isEmpty) {
      return;
    }
    _rebuildClustersAfterDelete(ids);
  }

  void _rebuildClustersAfterDelete(Set<String> deletedIds) {
    CleanerMediaCluster? rebuildCluster(CleanerMediaCluster c) {
      final kept = c.members.where((m) => !deletedIds.contains(m.id)).toList();
      if (kept.length < 2) {
        return null;
      }
      final keeper = CleanerMediaCluster.pickKeeper(kept);
      return CleanerMediaCluster(
        id: c.id,
        members: List<PhotoAssetEntity>.unmodifiable(kept),
        keeper: keeper,
      );
    }

    final newDupes = duplicateClusters
        .map(rebuildCluster)
        .whereType<CleanerMediaCluster>()
        .toList();
    duplicateClusters.assignAll(newDupes);

    final newSim = similarClusters
        .map(rebuildCluster)
        .whereType<CleanerMediaCluster>()
        .toList();
    similarClusters.assignAll(newSim);

    final g = galleryResult.value;
    if (g != null) {
      final remaining = g.allItems
          .where((a) => !deletedIds.contains(a.id))
          .toList(growable: false);
      galleryResult.value = CleanerGalleryScanResult.fromMediaList(remaining);
    }
  }
}
