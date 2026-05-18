import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

import '../models/photo_widget_album.dart';
import '../models/photo_widget_config.dart';
import '../models/photo_widget_manifest.dart';
import '../models/photo_widget_photo.dart';
import '../models/photo_widget_source_mode.dart';
import '../../../services/gallery/gallery_media_service.dart';

/// Local persistence for photo widget albums, config, and native-facing cache.
class PhotoWidgetStorageService extends GetxService {
  PhotoWidgetStorageService({GalleryMediaService? gallery})
      : _gallery = gallery ?? Get.find<GalleryMediaService>();

  static const maxPhotosPerAlbum = 30;
  static const maxTotalPhotos = 120;
  static const maxImageEdge = 512;

  static const _rootSubdir = 'photo_widget';
  static const _albumsFileName = 'albums.json';
  static const _configFileName = 'config.json';
  static const _manifestFileName = 'widget_manifest.json';
  static const _cacheSubdir = 'cache';

  final GalleryMediaService _gallery;
  Directory? _root;

  Future<Directory> rootDirectory() async {
    if (_root != null) return _root!;
    final support = await getApplicationSupportDirectory();
    _root = Directory(p.join(support.path, _rootSubdir));
    if (!await _root!.exists()) {
      await _root!.create(recursive: true);
    }
    return _root!;
  }

  Future<Directory> cacheDirectory() async {
    final root = await rootDirectory();
    final dir = Directory(p.join(root.path, _cacheSubdir));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<File> _albumsFile() async {
    final root = await rootDirectory();
    return File(p.join(root.path, _albumsFileName));
  }

  Future<File> _configFile() async {
    final root = await rootDirectory();
    return File(p.join(root.path, _configFileName));
  }

  Future<File> manifestFile() async {
    final root = await rootDirectory();
    return File(p.join(root.path, _manifestFileName));
  }

  static String newId() {
    final r = Random();
    return '${DateTime.now().millisecondsSinceEpoch}_${r.nextInt(999999)}';
  }

  Future<List<PhotoWidgetAlbum>> readAlbums() async {
    final file = await _albumsFile();
    if (!await file.exists()) return [];
    final raw = await file.readAsString();
    if (raw.trim().isEmpty) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (e) => PhotoWidgetAlbum.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }

  Future<void> writeAlbums(List<PhotoWidgetAlbum> albums) async {
    final file = await _albumsFile();
    final jsonStr = jsonEncode(albums.map((a) => a.toJson()).toList());
    await file.writeAsString(jsonStr, flush: true);
  }

  Future<PhotoWidgetConfig> readConfig() async {
    final file = await _configFile();
    if (!await file.exists()) {
      return const PhotoWidgetConfig();
    }
    final raw = await file.readAsString();
    if (raw.trim().isEmpty) {
      return const PhotoWidgetConfig();
    }
    return PhotoWidgetConfig.fromJson(
      Map<String, dynamic>.from(jsonDecode(raw) as Map),
    );
  }

  Future<void> writeConfig(PhotoWidgetConfig config) async {
    final file = await _configFile();
    await file.writeAsString(
      jsonEncode(config.toJson()),
      flush: true,
    );
  }

  int totalPhotoCount(List<PhotoWidgetAlbum> albums) {
    return albums.fold<int>(0, (sum, a) => sum + a.photos.length);
  }

  /// Imports gallery assets into widget cache; returns new photo entries.
  Future<List<PhotoWidgetPhoto>> importAssets({
    required String albumId,
    required List<AssetEntity> assets,
    required int startOrder,
  }) async {
    final cache = await cacheDirectory();
    final entries = <PhotoWidgetPhoto>[];
    var order = startOrder;

    for (final asset in assets) {
      final photoId = newId();
      final fileName = '${albumId}_$photoId.jpg';
      final destPath = p.join(cache.path, fileName);

      final ok = await _compressAssetToFile(asset, destPath);
      if (!ok) continue;

      entries.add(
        PhotoWidgetPhoto(
          id: photoId,
          fileName: fileName,
          order: order,
          sourceAssetId: asset.id,
        ),
      );
      order++;
    }

    return entries;
  }

  Future<bool> _compressAssetToFile(AssetEntity asset, String destPath) async {
    try {
      final sourceFile = await _gallery.getOriginalFile(asset.id);
      if (sourceFile == null) return false;

      final result = await FlutterImageCompress.compressAndGetFile(
        sourceFile.absolute.path,
        destPath,
        minWidth: maxImageEdge,
        minHeight: maxImageEdge,
        quality: 85,
        format: CompressFormat.jpeg,
        keepExif: false,
      );
      return result != null && await File(destPath).exists();
    } catch (_) {
      return false;
    }
  }

  Future<void> deleteCachedFile(String fileName) async {
    final cache = await cacheDirectory();
    final file = File(p.join(cache.path, fileName));
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> deleteAlbumCache(PhotoWidgetAlbum album) async {
    for (final photo in album.photos) {
      await deleteCachedFile(photo.fileName);
    }
  }

  Future<File> cachedFileAsync(String fileName) async {
    final cache = await cacheDirectory();
    return File(p.join(cache.path, fileName));
  }

  List<PhotoWidgetPhoto> resolveWidgetPhotos({
    required List<PhotoWidgetAlbum> albums,
    required PhotoWidgetConfig config,
  }) {
    switch (config.sourceMode) {
      case PhotoWidgetSourceMode.allAlbums:
        final all = <PhotoWidgetPhoto>[];
        for (final album in albums) {
          all.addAll(album.photos);
        }
        all.sort((a, b) => a.order.compareTo(b.order));
        return all;
      case PhotoWidgetSourceMode.activeAlbum:
        for (final album in albums) {
          if (album.isWidgetSource && album.photos.isNotEmpty) {
            return List<PhotoWidgetPhoto>.from(album.photos)
              ..sort((a, b) => a.order.compareTo(b.order));
          }
        }
        final activeId = config.activeAlbumId;
        if (activeId != null) {
          for (final album in albums) {
            if (album.id == activeId) {
              return List<PhotoWidgetPhoto>.from(album.photos)
                ..sort((a, b) => a.order.compareTo(b.order));
            }
          }
        }
        return [];
    }
  }

  Future<PhotoWidgetManifest> buildManifest({
    required PhotoWidgetConfig config,
    required List<PhotoWidgetAlbum> albums,
  }) async {
    final cache = await cacheDirectory();
    final photos = resolveWidgetPhotos(albums: albums, config: config);
    final entries = <PhotoWidgetManifestEntry>[];
    for (var i = 0; i < photos.length; i++) {
      entries.add(
        PhotoWidgetManifestEntry(
          fileName: photos[i].fileName,
          order: i,
        ),
      );
    }

    return PhotoWidgetManifest(
      enabled: config.enabled,
      style: config.style,
      slideshowIntervalSec: config.slideshowIntervalSec,
      cacheDirectory: cache.path,
      photos: entries,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<File> writeManifest(PhotoWidgetManifest manifest) async {
    final file = await manifestFile();
    await file.writeAsString(
      jsonEncode(manifest.toJson()),
      flush: true,
    );
    return file;
  }
}
