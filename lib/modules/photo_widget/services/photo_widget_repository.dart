import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/photo_widget_album.dart';
import '../models/photo_widget_config.dart';
import '../models/photo_widget_style.dart';
import '../platform/photo_widget_native_bridge.dart';
import 'photo_widget_prefs_keys.dart';
import 'photo_widget_storage_service.dart';

class PhotoWidgetRepository extends GetxService {
  PhotoWidgetRepository({PhotoWidgetStorageService? storage})
      : _storage = storage ?? Get.find<PhotoWidgetStorageService>();

  final PhotoWidgetStorageService _storage;

  Future<List<PhotoWidgetAlbum>> loadAlbums() => _storage.readAlbums();

  Future<PhotoWidgetConfig> loadConfig() => _storage.readConfig();

  Future<({List<PhotoWidgetAlbum> albums, PhotoWidgetConfig config})> loadAll() async {
    final albums = await loadAlbums();
    final config = await loadConfig();
    return (albums: albums, config: config);
  }

  Future<void> saveAlbums(List<PhotoWidgetAlbum> albums) =>
      _storage.writeAlbums(albums);

  Future<void> saveConfig(PhotoWidgetConfig config) =>
      _storage.writeConfig(config);

  Future<PhotoWidgetAlbum> createAlbum(String name) async {
    final albums = await loadAlbums();
    final album = PhotoWidgetAlbum(
      id: PhotoWidgetStorageService.newId(),
      name: name.trim().isEmpty ? 'Album ${albums.length + 1}' : name.trim(),
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
      photos: const [],
      isWidgetSource: albums.isEmpty,
    );
    albums.add(album);
    await saveAlbums(albums);
    if (albums.length == 1) {
      final config = await loadConfig();
      await saveConfig(
        config.copyWith(activeAlbumId: album.id),
      );
    }
    return album;
  }

  Future<void> renameAlbum(String albumId, String name) async {
    final albums = await loadAlbums();
    final i = albums.indexWhere((a) => a.id == albumId);
    if (i < 0) return;
    albums[i] = albums[i].copyWith(name: name.trim());
    await saveAlbums(albums);
    await syncToNative();
  }

  Future<void> deleteAlbum(String albumId) async {
    final albums = await loadAlbums();
    final albumIndex = albums.indexWhere((a) => a.id == albumId);
    if (albumIndex < 0) return;
    final album = albums[albumIndex];
    await _storage.deleteAlbumCache(album);
    albums.removeWhere((a) => a.id == albumId);
    await saveAlbums(albums);

    final config = await loadConfig();
    if (config.activeAlbumId == albumId) {
      final nextId = albums.isNotEmpty ? albums.first.id : null;
      await saveConfig(
        config.copyWith(
          activeAlbumId: nextId,
          clearActiveAlbumId: nextId == null,
        ),
      );
    }
    await syncToNative();
  }

  Future<void> setWidgetSourceAlbum(String albumId) async {
    final albums = await loadAlbums();
    for (var i = 0; i < albums.length; i++) {
      albums[i] = albums[i].copyWith(isWidgetSource: albums[i].id == albumId);
    }
    await saveAlbums(albums);
    final config = await loadConfig();
    await saveConfig(config.copyWith(activeAlbumId: albumId));
    await syncToNative();
  }

  Future<int> importPhotos({
    required String albumId,
    required List<AssetEntity> assets,
  }) async {
    if (assets.isEmpty) return 0;

    final albums = await loadAlbums();
    final i = albums.indexWhere((a) => a.id == albumId);
    if (i < 0) return 0;

    final album = albums[i];
    final total = _storage.totalPhotoCount(albums);
    final remainingAlbum =
        PhotoWidgetStorageService.maxPhotosPerAlbum - album.photos.length;
    final remainingTotal =
        PhotoWidgetStorageService.maxTotalPhotos - total;
    final cap = remainingAlbum < remainingTotal
        ? remainingAlbum
        : remainingTotal;
    if (cap <= 0) return 0;

    final batch = assets.take(cap).toList();
    final startOrder = album.photos.isEmpty
        ? 0
        : album.photos.map((p) => p.order).reduce((a, b) => a > b ? a : b) + 1;

    final imported = await _storage.importAssets(
      albumId: albumId,
      assets: batch,
      startOrder: startOrder,
    );

    if (imported.isEmpty) return 0;

    albums[i] = album.copyWith(
      photos: [...album.photos, ...imported],
    );
    await saveAlbums(albums);

    // Imported album becomes the home-screen source; enable widget when we have photos.
    await setWidgetSourceAlbum(albumId);
    final updatedConfig = await loadConfig();
    if (!updatedConfig.enabled && hasWidgetContent(await loadAlbums(), updatedConfig)) {
      await setEnabled(true);
    }

    return imported.length;
  }

  Future<void> removePhoto(String albumId, String photoId) async {
    final albums = await loadAlbums();
    final i = albums.indexWhere((a) => a.id == albumId);
    if (i < 0) return;

    final album = albums[i];
    final photoIndex = album.photos.indexWhere((p) => p.id == photoId);
    if (photoIndex < 0) return;
    final photo = album.photos[photoIndex];

    await _storage.deleteCachedFile(photo.fileName);
    albums[i] = album.copyWith(
      photos: album.photos.where((p) => p.id != photoId).toList(),
    );
    await saveAlbums(albums);
    await syncToNative();
  }

  Future<void> setEnabled(bool enabled) async {
    final config = await loadConfig();
    await saveConfig(
      config.copyWith(
        enabled: enabled,
        lastUpdatedMs: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    await syncToNative();
  }

  Future<void> setStyle(PhotoWidgetStyle style) async {
    final config = await loadConfig();
    await saveConfig(
      config.copyWith(
        style: style,
        lastUpdatedMs: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    await syncToNative();
  }

  Future<void> setSlideshowInterval(int seconds) async {
    final config = await loadConfig();
    await saveConfig(
      config.copyWith(
        slideshowIntervalSec: seconds.clamp(15, 300),
        lastUpdatedMs: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    await syncToNative();
  }

  bool hasWidgetContent(List<PhotoWidgetAlbum> albums, PhotoWidgetConfig config) {
    return _storage.resolveWidgetPhotos(albums: albums, config: config).isNotEmpty;
  }

  Future<void> syncToNative() async {
    final albums = await loadAlbums();
    var config = await loadConfig();
    config = config.copyWith(
      lastUpdatedMs: DateTime.now().millisecondsSinceEpoch,
    );
    await saveConfig(config);

    final manifest = await _storage.buildManifest(
      config: config,
      albums: albums,
    );
    final manifestFile = await _storage.writeManifest(manifest);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PhotoWidgetPrefsKeys.enabled, config.enabled);
    await prefs.setString(
      PhotoWidgetPrefsKeys.style,
      config.style.storageValue,
    );
    await prefs.setInt(
      PhotoWidgetPrefsKeys.slideshowInterval,
      config.slideshowIntervalSec,
    );
    await prefs.setString(
      PhotoWidgetPrefsKeys.manifestPath,
      manifestFile.path,
    );

    await PhotoWidgetNativeBridge.saveWidgetConfig();
    await PhotoWidgetNativeBridge.refreshWidget();
  }
}
