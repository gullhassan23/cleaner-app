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
import '../repositories/photo_library/photo_library_repository.dart';

class PhotoLibraryDataSource implements PhotoLibraryRepository {
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
    bool videosOnly = false,
  }) async {
    if (videosOnly) {
      await _galleryService.refreshLibraryCache();
      if (page == 0) {
        return _fetchFirstVideoPage(pageSize: pageSize);
      }
    }

    final totalCount =
        videosOnly
            ? await _galleryService.getVideoCount()
            : await _galleryService.getMediaCount();
    final assets =
        videosOnly
            ? await _galleryService.getPagedVideoAssets(
              page: page,
              pageSize: pageSize,
            )
            : await _galleryService.getPagedMediaAssets(
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

  static bool _isGalleryVideo(AssetEntity asset) {
    if (asset.type == AssetType.video) {
      return true;
    }
    final mime = asset.mimeType?.toLowerCase() ?? '';
    if (mime.startsWith('video/')) {
      return true;
    }
    return asset.duration > 0;
  }

  /// Merges video-only, mixed-media, and Recent-album queries so brand-new
  /// camera recordings appear after refresh.
  Future<GalleryPageEntity> _fetchFirstVideoPage({required int pageSize}) async {
    final totalCount = await _galleryService.getVideoCount();
    final videoAssets = await _galleryService.getPagedVideoAssets(
      page: 0,
      pageSize: pageSize,
    );
    final recentScanSize = pageSize < 80 ? 80 : pageSize;
    final recentCommon = await _galleryService.getPagedMediaAssets(
      page: 0,
      pageSize: recentScanSize,
    );
    final recentAlbum = await _galleryService.getRecentAlbumAssets(
      limit: recentScanSize,
    );

    final merged = <AssetEntity>[];
    final seenIds = <String>{};
    for (final asset in [
      ...recentAlbum,
      ...recentCommon,
      ...videoAssets,
    ]) {
      if (!_isGalleryVideo(asset)) {
        continue;
      }
      if (seenIds.add(asset.id)) {
        merged.add(asset);
      }
    }
    merged.sort(
      (a, b) => b.createDateTime.compareTo(a.createDateTime),
    );

    final pageAssets = merged.take(pageSize).toList(growable: false);
    final models = await _hydrateAssets(pageAssets);

    return GalleryPageModel(
      items: models,
      page: 0,
      pageSize: pageSize,
      totalCount: totalCount,
      hasMore: pageSize < totalCount || merged.length > pageSize,
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

  @override
  Future<File?> loadOriginalFile(String assetId) {
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
            return PhotoAssetModel.fromAssetEntity(asset, fileSize: 0);
          }
        }),
      );
      hydrated.addAll(models.whereType<PhotoAssetEntity>());
    }

    return List<PhotoAssetEntity>.unmodifiable(hydrated);
  }
}
