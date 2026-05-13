import 'package:photo_manager/photo_manager.dart';

import 'photo_asset_entity.dart';

class PhotoAssetModel extends PhotoAssetEntity {
  const PhotoAssetModel({
    required super.id,
    required super.width,
    required super.height,
    required super.fileSize,
    required super.createdAt,
    required super.modifiedAt,
    required super.isFavorite,
    required super.title,
    required super.mimeType,
    required super.relativePath,
    required super.mediaType,
    required super.duration,
  });

  factory PhotoAssetModel.fromAssetEntity(
    AssetEntity asset, {
    required int fileSize,
  }) {
    return PhotoAssetModel(
      id: asset.id,
      width: asset.width,
      height: asset.height,
      fileSize: fileSize,
      createdAt: asset.createDateTime,
      modifiedAt: asset.modifiedDateTime,
      isFavorite: asset.isFavorite,
      title: asset.title,
      mimeType: asset.mimeType,
      relativePath: asset.relativePath,
      mediaType: _mapMediaType(asset.type),
      duration: Duration(seconds: asset.duration),
    );
  }

  static GalleryMediaType _mapMediaType(AssetType type) {
    switch (type) {
      case AssetType.image:
        return GalleryMediaType.image;
      case AssetType.video:
        return GalleryMediaType.video;
      case AssetType.audio:
      case AssetType.other:
        return GalleryMediaType.other;
    }
  }
}
