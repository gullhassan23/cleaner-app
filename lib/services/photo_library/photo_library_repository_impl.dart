import 'dart:io';
import 'dart:typed_data';

import 'photo_library_data_source.dart';
import '../../models/photo_library/photo_asset_entity.dart';
import '../../models/photo_library/scan_state_entity.dart';
import '../../repositories/photo_library_repository.dart';

class PhotoLibraryRepositoryImpl implements PhotoLibraryRepository {
  PhotoLibraryRepositoryImpl({required PhotoLibraryDataSource dataSource})
    : _dataSource = dataSource;

  final PhotoLibraryDataSource _dataSource;

  @override
  Future<PermissionStateEntity> getPermissionState() {
    return _dataSource.getPermissionState();
  }

  @override
  Future<PermissionStateEntity> requestPermission() {
    return _dataSource.requestPermission();
  }

  @override
  Future<PermissionStateEntity> getMediaPermissionState() {
    return _dataSource.getMediaPermissionState();
  }

  @override
  Future<PermissionStateEntity> requestMediaPermission() {
    return _dataSource.requestMediaPermission();
  }

  @override
  Future<void> openAppSettings() {
    return _dataSource.openAppSettings();
  }

  @override
  Future<void> presentLimitedLibraryPicker() {
    return _dataSource.presentLimitedLibraryPicker();
  }

  @override
  Future<void> presentLimitedMediaPicker() {
    return _dataSource.presentLimitedMediaPicker();
  }

  @override
  Future<GalleryPageEntity> fetchGalleryPage({
    required int page,
    required int pageSize,
  }) {
    return _dataSource.fetchGalleryPage(page: page, pageSize: pageSize);
  }

  @override
  Future<List<PhotoAssetEntity>> fetchAllPhotos() {
    return _dataSource.fetchAllPhotos();
  }

  @override
  Future<GalleryPageEntity> fetchMediaPage({
    required int page,
    required int pageSize,
    bool videosOnly = false,
  }) {
    return _dataSource.fetchMediaPage(
      page: page,
      pageSize: pageSize,
      videosOnly: videosOnly,
    );
  }

  @override
  Future<List<PhotoAssetEntity>> fetchAllMedia() {
    return _dataSource.fetchAllMedia();
  }

  @override
  Future<Uint8List?> loadPreviewBytes(
    String assetId, {
    required int width,
    required int height,
    required int quality,
  }) {
    return _dataSource.loadPreviewBytes(
      assetId,
      width: width,
      height: height,
      quality: quality,
    );
  }

  @override
  Future<File?> loadOriginalFile(String assetId) {
    return _dataSource.loadOriginalFileById(assetId);
  }

  @override
  Future<DeletionResultEntity> deleteAssets(List<PhotoAssetEntity> assets) {
    return _dataSource.deleteAssets(assets);
  }
}
