import 'dart:io';
import 'dart:typed_data';

import '../models/photo_library/photo_asset_entity.dart';
import '../models/photo_library/scan_state_entity.dart';

abstract class PhotoLibraryRepository {
  Future<PermissionStateEntity> getPermissionState();

  Future<PermissionStateEntity> requestPermission();

  Future<PermissionStateEntity> getMediaPermissionState();

  Future<PermissionStateEntity> requestMediaPermission();

  Future<void> openAppSettings();

  Future<void> presentLimitedLibraryPicker();

  Future<void> presentLimitedMediaPicker();

  Future<GalleryPageEntity> fetchGalleryPage({
    required int page,
    required int pageSize,
  });

  Future<List<PhotoAssetEntity>> fetchAllPhotos();

  Future<GalleryPageEntity> fetchMediaPage({
    required int page,
    required int pageSize,
    bool videosOnly = false,
  });

  Future<List<PhotoAssetEntity>> fetchAllMedia();

  Future<Uint8List?> loadPreviewBytes(
    String assetId, {
    required int width,
    required int height,
    required int quality,
  });

  Future<File?> loadOriginalFile(String assetId);

  Future<DeletionResultEntity> deleteAssets(List<PhotoAssetEntity> assets);
}
