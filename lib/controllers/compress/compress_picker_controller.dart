import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../models/cleaner/cleaner_dashboard_sort.dart';
import '../../models/photo_library/photo_asset_entity.dart';
import '../../models/photo_library/scan_state_entity.dart';
import '../../utils/photo_asset_sort.dart';
import '../../routes/app_routes.dart';
import 'compress_session_controller.dart';

class CompressPickerController extends GetxController with WidgetsBindingObserver {
  CompressPickerController(this.session);

  final CompressSessionController session;

  final Rx<CleanerDashboardSort> pickerSort =
      CleanerDashboardSort.newestDateFirst.obs;

  /// Visible grid order; reads [pickerSort] for [Obx] reactivity.
  List<PhotoAssetEntity> get sortedDisplayMedia {
    pickerSort.value;
    return sortedPhotoAssetsCopy(session.mediaItems, pickerSort.value);
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(session.loadInitialMedia(force: true));
    }
  }

  @override
  void onReady() {
    super.onReady();
    unawaited(session.initialize());
  }

  Future<void> requestAccess() async {
    final permission = await session.requestPermission();
    if (permission.canAccess && session.mediaItems.isEmpty) {
      await session.loadInitialMedia(force: true);
    }
  }

  Future<void> openSettings() {
    return session.openAppSettings();
  }

  Future<void> manageLimitedLibrary() {
    return session.manageLimitedLibrary();
  }

  Future<void> refreshMedia() {
    return session.loadInitialMedia(force: true);
  }

  Future<void> loadMoreIfNeeded() {
    return session.loadMoreMedia();
  }

  void toggleSelection(String assetId) {
    session.toggleSelection(assetId);
  }

  void clearSelection() {
    session.clearSelection();
  }

  Future<void> openReview() async {
    if (!session.hasSelection) {
      return;
    }
    await Get.toNamed<void>(
      AppRoutes.compressReview,
      id: AppRoutes.compressNestedNavigatorId,
    );
  }

  PermissionStateEntity get permissionState => session.permissionState;
}
