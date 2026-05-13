import '../../models/photo_library/photo_asset_entity.dart';
import '../../models/photo_library/scan_state_entity.dart';

import 'package:photo_manager/photo_manager.dart';

class PhotoDeleteService {
  Future<DeletionResultEntity> deleteAssets(
    List<PhotoAssetEntity> assets,
  ) async {
    final deletedIds = await PhotoManager.editor.deleteWithIds(
      assets.map((asset) => asset.id).toList(growable: false),
    );

    final deletedIdSet = deletedIds.toSet();
    final reclaimedBytes = assets
        .where((asset) => deletedIdSet.contains(asset.id))
        .fold<int>(0, (total, asset) => total + asset.fileSize);

    return DeletionResultEntity(
      deletedCount: deletedIds.length,
      failedIds: assets
          .where((asset) => !deletedIdSet.contains(asset.id))
          .map((asset) => asset.id)
          .toList(growable: false),
      reclaimedBytes: reclaimedBytes,
    );
  }
}
