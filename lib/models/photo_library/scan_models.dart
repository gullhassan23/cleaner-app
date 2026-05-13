import 'photo_asset_entity.dart';

class GalleryPageModel extends GalleryPageEntity {
  const GalleryPageModel({
    required super.items,
    required super.page,
    required super.pageSize,
    required super.totalCount,
    required super.hasMore,
  });
}
