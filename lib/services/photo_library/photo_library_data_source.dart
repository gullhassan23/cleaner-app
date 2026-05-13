import 'dart:io';
import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

import '../../models/photo_library/photo_asset_model.dart';
import '../../models/photo_library/scan_models.dart';
import '../../models/photo_library/photo_asset_entity.dart';
import '../../models/photo_library/scan_state_entity.dart';
import '../cache/thumbnail_cache_service.dart';
import '../deletion/photo_delete_service.dart';
import '../gallery/gallery_media_service.dart';
import '../permissions/photo_permission_service.dart';

class PhotoLibraryDataSource {
  static const int _metadataConcurrency = 8;

  PhotoLibraryDataSource({
    required PhotoPermissionService permissionService,
    required GalleryMediaService galleryService,
    required PhotoDeleteService deleteService,
    required ThumbnailCacheService thumbnailCacheService,
  }) : _permissionService = permissionService,
       _galleryService = galleryService,
       _deleteService = deleteService,
       _thumbnailCacheService = thumbnailCacheService;

  final PhotoPermissionService _permissionService;
  final GalleryMediaService _galleryService;
  final PhotoDeleteService _deleteService;
  final ThumbnailCacheService _thumbnailCacheService;

  Future<PermissionStateEntity> getPermissionState() {
    return _permissionService.getPermissionState();
  }

  Future<PermissionStateEntity> requestPermission() {
    return _permissionService.requestPermission();
  }

  Future<void> openAppSettings() {
    return _permissionService.openAppSettings();
  }

  Future<void> presentLimitedLibraryPicker() {
    return _permissionService.presentLimitedPicker();
  }

  Future<PermissionStateEntity> getMediaPermissionState() {
    return _permissionService.getMediaPermissionState();
  }

  Future<PermissionStateEntity> requestMediaPermission() {
    return _permissionService.requestMediaPermission();
  }

  Future<void> presentLimitedMediaPicker() {
    return _permissionService.presentLimitedMediaPicker();
  }

  Future<GalleryPageEntity> fetchGalleryPage({
    required int page,
    required int pageSize,
  }) async {
    final totalCount = await _galleryService.getPhotoCount();
    final assets = await _galleryService.getPagedPhotoAssets(
      page: page,
      pageSize: pageSize,
    );
    final models = await _hydrateAssets(assets);

    return GalleryPageModel(
      items: models,
      page: page,
      pageSize: pageSize,
      totalCount: totalCount,
      hasMore: (page + 1) * pageSize < totalCount,
    );
  }

  Future<List<PhotoAssetEntity>> fetchAllPhotos({int pageSize = 120}) async {
    final allPhotos = <PhotoAssetEntity>[];
    var page = 0;

    while (true) {
      final galleryPage = await fetchGalleryPage(page: page, pageSize: pageSize);
      allPhotos.addAll(galleryPage.items);
      if (!galleryPage.hasMore || galleryPage.items.isEmpty) {
        break;
      }
      page += 1;
    }

    return List<PhotoAssetEntity>.unmodifiable(allPhotos);
  }

  Future<GalleryPageEntity> fetchMediaPage({
    required int page,
    required int pageSize,
  }) async {
    final totalCount = await _galleryService.getMediaCount();
    final assets = await _galleryService.getPagedMediaAssets(
      page: page,
      pageSize: pageSize,
    );
    final models = await _hydrateAssets(assets);

    return GalleryPageModel(
      items: models,
      page: page,
      pageSize: pageSize,
      totalCount: totalCount,
      hasMore: (page + 1) * pageSize < totalCount,
    );
  }

  Future<List<PhotoAssetEntity>> fetchAllMedia({int pageSize = 120}) async {
    final allMedia = <PhotoAssetEntity>[];
    var page = 0;

    while (true) {
      final galleryPage = await fetchMediaPage(page: page, pageSize: pageSize);
      allMedia.addAll(galleryPage.items);
      if (!galleryPage.hasMore || galleryPage.items.isEmpty) {
        break;
      }
      page += 1;
    }

    return List<PhotoAssetEntity>.unmodifiable(allMedia);
  }

  Future<File?> loadOriginalFile(PhotoAssetEntity asset) {
    return _galleryService.getOriginalFile(asset.id);
  }

  Future<File?> loadOriginalFileById(String assetId) {
    return _galleryService.getOriginalFile(assetId);
  }

  Future<Uint8List?> loadPreviewBytes(
    String assetId, {
    required int width,
    required int height,
    required int quality,
  }) {
    final cacheKey = '$assetId-$width-$height-$quality';
    return _thumbnailCacheService.getOrLoad(
      cacheKey,
      () => _galleryService.getThumbnailBytes(
        assetId,
        width: width,
        height: height,
        quality: quality,
      ),
    );
  }

  Future<DeletionResultEntity> deleteAssets(List<PhotoAssetEntity> assets) {
    return _deleteService.deleteAssets(assets);
  }

  Future<List<PhotoAssetEntity>> _hydrateAssets(List<AssetEntity> assets) async {
    final hydrated = <PhotoAssetEntity>[];
    for (var start = 0; start < assets.length; start += _metadataConcurrency) {
      final batch = assets.skip(start).take(_metadataConcurrency);
      final models = await Future.wait(
        batch.map((asset) async {
          try {
            final fileSize = await _galleryService.getFileSize(asset);
            return PhotoAssetModel.fromAssetEntity(asset, fileSize: fileSize);
          } catch (_) {
            return null;
          }
        }),
      );
      hydrated.addAll(models.whereType<PhotoAssetEntity>());
    }

    return List<PhotoAssetEntity>.unmodifiable(hydrated);
  }
}
