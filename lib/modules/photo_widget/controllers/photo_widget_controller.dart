import 'dart:async';

import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../models/photo_widget_album.dart';
import '../models/photo_widget_config.dart';
import '../models/photo_widget_style.dart';
import '../platform/photo_widget_native_bridge.dart';
import '../services/photo_widget_repository.dart';

class PhotoWidgetController extends GetxController {
  PhotoWidgetController({PhotoWidgetRepository? repository})
      : _repository = repository ?? Get.find<PhotoWidgetRepository>();

  final PhotoWidgetRepository _repository;

  final albums = <PhotoWidgetAlbum>[].obs;
  final config = const PhotoWidgetConfig().obs;
  final isLoading = true.obs;
  final isSyncing = false.obs;

  bool get isEnabled => config.value.enabled;
  PhotoWidgetStyle get style => config.value.style;

  @override
  void onInit() {
    super.onInit();
    PhotoWidgetNativeBridge.installNavigationHandler();
    unawaited(bootstrap());
  }

  Future<void> bootstrap() async {
    isLoading.value = true;
    try {
      final data = await _repository.loadAll();
      albums.assignAll(data.albums);
      config.value = data.config;
      await _repository.syncToNative();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reload() async {
    final data = await _repository.loadAll();
    albums.assignAll(data.albums);
    config.value = data.config;
  }

  bool get hasWidgetContent =>
      _repository.hasWidgetContent(albums, config.value);

  PhotoWidgetAlbum? albumById(String id) {
    for (final a in albums) {
      if (a.id == id) return a;
    }
    return null;
  }

  Future<bool> setEnabled(bool enabled) async {
    if (enabled && !hasWidgetContent) {
      return false;
    }
    isSyncing.value = true;
    try {
      await _repository.setEnabled(enabled);
      config.value = config.value.copyWith(enabled: enabled);
      return true;
    } finally {
      isSyncing.value = false;
    }
  }

  Future<PhotoWidgetAlbum?> createAlbum(String name) async {
    isSyncing.value = true;
    try {
      final album = await _repository.createAlbum(name);
      await reload();
      return album;
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> renameAlbum(String albumId, String name) async {
    isSyncing.value = true;
    try {
      await _repository.renameAlbum(albumId, name);
      await reload();
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> deleteAlbum(String albumId) async {
    isSyncing.value = true;
    try {
      await _repository.deleteAlbum(albumId);
      await reload();
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> setWidgetSourceAlbum(String albumId) async {
    isSyncing.value = true;
    try {
      await _repository.setWidgetSourceAlbum(albumId);
      await reload();
    } finally {
      isSyncing.value = false;
    }
  }

  Future<int> importPhotos(String albumId, List<AssetEntity> assets) async {
    isSyncing.value = true;
    try {
      final count = await _repository.importPhotos(
        albumId: albumId,
        assets: assets,
      );
      await reload();
      if (count > 0) {
        await PhotoWidgetNativeBridge.refreshWidget();
      }
      return count;
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> removePhoto(String albumId, String photoId) async {
    isSyncing.value = true;
    try {
      await _repository.removePhoto(albumId, photoId);
      await reload();
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> setStyle(PhotoWidgetStyle style) async {
    isSyncing.value = true;
    try {
      await _repository.setStyle(style);
      config.value = config.value.copyWith(style: style);
    } finally {
      isSyncing.value = false;
    }
  }

  /// Uses PhotoManager only (avoids permission_handler manifest noise on Android).
  Future<bool> ensurePhotoPermission() async {
    var state = await PhotoManager.getPermissionState(
      requestOption: _photoPermissionOption,
    );
    if (state.hasAccess) return true;

    state = await PhotoManager.requestPermissionExtend(
      requestOption: _photoPermissionOption,
    );
    return state.hasAccess;
  }

  static final _photoPermissionOption = PermissionRequestOption(
    iosAccessLevel: IosAccessLevel.readWrite,
    androidPermission: AndroidPermission(
      type: RequestType.image,
      mediaLocation: false,
    ),
  );
}
