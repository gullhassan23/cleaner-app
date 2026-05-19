import 'dart:io';

import '../../models/photo_library/photo_asset_entity.dart';
import '../../models/photo_library/scan_state_entity.dart';
import '../repositories/photo_library_repository.dart';

class GetPhotoPermissionStateUseCase {
  const GetPhotoPermissionStateUseCase(this._repository);

  final PhotoLibraryRepository _repository;

  Future<PermissionStateEntity> call() => _repository.getPermissionState();
}

class RequestPhotoPermissionUseCase {
  const RequestPhotoPermissionUseCase(this._repository);

  final PhotoLibraryRepository _repository;

  Future<PermissionStateEntity> call() => _repository.requestPermission();
}

class GetMediaPermissionStateUseCase {
  const GetMediaPermissionStateUseCase(this._repository);

  final PhotoLibraryRepository _repository;

  Future<PermissionStateEntity> call() => _repository.getMediaPermissionState();
}

class RequestMediaPermissionUseCase {
  const RequestMediaPermissionUseCase(this._repository);

  final PhotoLibraryRepository _repository;

  Future<PermissionStateEntity> call() => _repository.requestMediaPermission();
}

class FetchGalleryPageUseCase {
  const FetchGalleryPageUseCase(this._repository);

  final PhotoLibraryRepository _repository;

  Future<GalleryPageEntity> call({required int page, required int pageSize}) {
    return _repository.fetchGalleryPage(page: page, pageSize: pageSize);
  }
}

class FetchAllPhotosUseCase {
  const FetchAllPhotosUseCase(this._repository);

  final PhotoLibraryRepository _repository;

  Future<List<PhotoAssetEntity>> call() => _repository.fetchAllPhotos();
}

class FetchMediaGalleryPageUseCase {
  const FetchMediaGalleryPageUseCase(this._repository);

  final PhotoLibraryRepository _repository;

  Future<GalleryPageEntity> call({
    required int page,
    required int pageSize,
    bool videosOnly = false,
  }) {
    return _repository.fetchMediaPage(
      page: page,
      pageSize: pageSize,
      videosOnly: videosOnly,
    );
  }
}

class FetchAllMediaUseCase {
  const FetchAllMediaUseCase(this._repository);

  final PhotoLibraryRepository _repository;

  Future<List<PhotoAssetEntity>> call() => _repository.fetchAllMedia();
}

class DeleteSelectedPhotosUseCase {
  const DeleteSelectedPhotosUseCase(this._repository);

  final PhotoLibraryRepository _repository;

  Future<DeletionResultEntity> call(List<PhotoAssetEntity> assets) {
    return _repository.deleteAssets(assets);
  }
}

class OpenPhotoSettingsUseCase {
  const OpenPhotoSettingsUseCase(this._repository);

  final PhotoLibraryRepository _repository;

  Future<void> call() => _repository.openAppSettings();
}

class PresentLimitedLibraryPickerUseCase {
  const PresentLimitedLibraryPickerUseCase(this._repository);

  final PhotoLibraryRepository _repository;

  Future<void> call() => _repository.presentLimitedLibraryPicker();
}

class PresentLimitedMediaPickerUseCase {
  const PresentLimitedMediaPickerUseCase(this._repository);

  final PhotoLibraryRepository _repository;

  Future<void> call() => _repository.presentLimitedMediaPicker();
}

class LoadOriginalFileUseCase {
  const LoadOriginalFileUseCase(this._repository);

  final PhotoLibraryRepository _repository;

  Future<File?> call(String assetId) => _repository.loadOriginalFile(assetId);
}
