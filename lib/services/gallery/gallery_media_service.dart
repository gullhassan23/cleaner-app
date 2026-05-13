import 'dart:io';
import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

class GalleryMediaService {
  static final FilterOptionGroup _filterOption = FilterOptionGroup(
    orders: const <OrderOption>[
      OrderOption(type: OrderOptionType.createDate, asc: false),
    ],
  );

  Future<int> getPhotoCount() {
    return _getAssetCount(type: RequestType.image);
  }

  Future<List<AssetEntity>> getPagedPhotoAssets({
    required int page,
    required int pageSize,
  }) {
    return getPagedAssets(
      page: page,
      pageSize: pageSize,
      type: RequestType.image,
    );
  }

  Future<List<AssetEntity>> getAllPhotoAssets({int pageSize = 250}) async {
    return getAllAssets(pageSize: pageSize, type: RequestType.image);
  }

  Future<int> getMediaCount() {
    return _getAssetCount(type: RequestType.common);
  }

  Future<List<AssetEntity>> getPagedMediaAssets({
    required int page,
    required int pageSize,
  }) {
    return getPagedAssets(
      page: page,
      pageSize: pageSize,
      type: RequestType.common,
    );
  }

  Future<List<AssetEntity>> getAllMediaAssets({int pageSize = 250}) async {
    return getAllAssets(pageSize: pageSize, type: RequestType.common);
  }

  Future<int> _getAssetCount({required RequestType type}) {
    return PhotoManager.getAssetCount(type: type, filterOption: _filterOption);
  }

  Future<List<AssetEntity>> getPagedAssets({
    required int page,
    required int pageSize,
    required RequestType type,
  }) {
    return PhotoManager.getAssetListPaged(
      page: page,
      pageCount: pageSize,
      type: type,
      filterOption: _filterOption,
    );
  }

  Future<List<AssetEntity>> getAllAssets({
    required int pageSize,
    required RequestType type,
  }) async {
    final assets = <AssetEntity>[];
    var page = 0;

    while (true) {
      final pageItems = await getPagedAssets(
        page: page,
        pageSize: pageSize,
        type: type,
      );
      if (pageItems.isEmpty) {
        break;
      }
      assets.addAll(pageItems);
      if (pageItems.length < pageSize) {
        break;
      }
      page++;
    }

    return assets;
  }

  Future<AssetEntity?> getAssetById(String assetId) {
    return AssetEntity.fromId(assetId);
  }

  Future<int> getFileSize(AssetEntity asset) async {
    try {
      final originFile = await asset.originFile;
      if (originFile != null) {
        return originFile.length();
      }

      final compressedFile = await asset.file;
      return compressedFile?.length() ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<Uint8List?> getOriginalBytes(String assetId) async {
    final asset = await getAssetById(assetId);
    if (asset == null) {
      return null;
    }
    return asset.originBytes;
  }

  Future<File?> getOriginalFile(String assetId) async {
    try {
      final asset = await getAssetById(assetId);
      if (asset == null) {
        return null;
      }

      final originFile = await asset.originFile;
      if (originFile != null) {
        return originFile;
      }

      return asset.file;
    } catch (_) {
      return null;
    }
  }

  Future<Uint8List?> getThumbnailBytes(
    String assetId, {
    required int width,
    required int height,
    required int quality,
  }) async {
    try {
      final asset = await getAssetById(assetId);
      if (asset == null) {
        return null;
      }

      return asset.thumbnailDataWithSize(
        ThumbnailSize(width, height),
        quality: quality,
      );
    } catch (_) {
      return null;
    }
  }
}
