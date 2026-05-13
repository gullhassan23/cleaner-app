import '../photo_library/photo_asset_entity.dart';

/// A cluster of related images (duplicates or visually similar), with a chosen keeper.
class CleanerMediaCluster {
  const CleanerMediaCluster({
    required this.id,
    required this.members,
    required this.keeper,
  }) : assert(members.length > 1, 'Cluster must have at least two members');

  final String id;
  final List<PhotoAssetEntity> members;
  final PhotoAssetEntity keeper;

  int get memberCount => members.length;

  int get totalBytes =>
      members.fold<int>(0, (sum, a) => sum + a.fileSize);

  int get reclaimableBytes => totalBytes - keeper.fileSize;

  /// Prefer highest resolution, then file size, then newest.
  static PhotoAssetEntity pickKeeper(Iterable<PhotoAssetEntity> items) {
    final list = items.toList(growable: false);
    if (list.length == 1) {
      return list.first;
    }
    list.sort((a, b) {
      final px = b.pixelCount.compareTo(a.pixelCount);
      if (px != 0) {
        return px;
      }
      final sz = b.fileSize.compareTo(a.fileSize);
      if (sz != 0) {
        return sz;
      }
      return b.createdAt.compareTo(a.createdAt);
    });
    return list.first;
  }

  static String clusterIdFromMemberIds(Iterable<String> ids) {
    final sorted = ids.toList()..sort();
    return sorted.join('|');
  }
}
