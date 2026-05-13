import '../models/cleaner/cleaner_dashboard_sort.dart';
import '../models/photo_library/photo_asset_entity.dart';

/// Returns a new list sorted by [sort]; does not mutate [source].
List<PhotoAssetEntity> sortedPhotoAssetsCopy(
  Iterable<PhotoAssetEntity> source,
  CleanerDashboardSort sort,
) {
  final list = List<PhotoAssetEntity>.from(source);
  int compare(PhotoAssetEntity a, PhotoAssetEntity b) {
    switch (sort) {
      case CleanerDashboardSort.largestFirst:
        return b.fileSize.compareTo(a.fileSize);
      case CleanerDashboardSort.smallestFirst:
        return a.fileSize.compareTo(b.fileSize);
      case CleanerDashboardSort.newestDateFirst:
        return b.createdAt.compareTo(a.createdAt);
      case CleanerDashboardSort.oldestDateFirst:
        return a.createdAt.compareTo(b.createdAt);
    }
  }

  list.sort(compare);
  return list;
}
