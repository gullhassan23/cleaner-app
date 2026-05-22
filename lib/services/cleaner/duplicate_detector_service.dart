import 'package:crypto/crypto.dart';

import '../../models/cleaner/cleaner_media_cluster.dart';
import '../../models/photo_library/photo_asset_entity.dart';
import '../repositories/photo_library/photo_library_repository.dart';

typedef DuplicateProgressCallback = void Function(int completed, int total);

/// Exact duplicate detection via streaming MD5 of original files.
class DuplicateDetectorService {
  DuplicateDetectorService({required PhotoLibraryRepository repository})
    : _repository = repository;

  final PhotoLibraryRepository _repository;

  static const int _maxConcurrent = 5;

  /// Returns only groups with more than one member. Also returns [assetIdToMd5Hex] for similar-detector filtering.
  Future<DuplicateDetectorResult> findDuplicates(
    List<PhotoAssetEntity> images, {
    DuplicateProgressCallback? onProgress,
    bool Function()? isCancelled,
  }) async {
    final total = images.length;
    if (total == 0) {
      return DuplicateDetectorResult(
        clusters: const [],
        assetIdToMd5Hex: const {},
      );
    }

    final digestByHex = <String, List<PhotoAssetEntity>>{};
    final idToMd5 = <String, String>{};
    var completed = 0;

    Future<void> hashOne(PhotoAssetEntity asset) async {
      if (isCancelled?.call() ?? false) {
        return;
      }
      final file = await _repository.loadOriginalFile(asset.id);
      if (file == null) {
        completed++;
        onProgress?.call(completed, total);
        return;
      }
      try {
        final digest = await md5.bind(file.openRead()).first;
        final hex = digest.toString();
        idToMd5[asset.id] = hex;
        digestByHex.putIfAbsent(hex, () => <PhotoAssetEntity>[]).add(asset);
      } catch (_) {
        // Skip unreadable files
      } finally {
        completed++;
        onProgress?.call(completed, total);
      }
    }

    // Index-based pool
    var index = 0;
    Future<void> runPool() async {
      while (index < total) {
        if (isCancelled?.call() ?? false) {
          return;
        }
        final batch = <Future<void>>[];
        for (var i = 0; i < _maxConcurrent && index < total; i++) {
          final current = images[index];
          index++;
          batch.add(hashOne(current));
        }
        await Future.wait(batch);
        await Future<void>.delayed(Duration.zero);
      }
    }

    await runPool();

    final clusters = <CleanerMediaCluster>[];
    var clusterIndex = 0;
    for (final entry in digestByHex.entries) {
      final members = entry.value;
      if (members.length < 2) {
        continue;
      }
      final keeper = CleanerMediaCluster.pickKeeper(members);
      clusters.add(
        CleanerMediaCluster(
          id: 'dup_${clusterIndex++}_${entry.key.substring(0, 8)}',
          members: List<PhotoAssetEntity>.unmodifiable(members),
          keeper: keeper,
        ),
      );
    }

    clusters.sort((a, b) => b.totalBytes.compareTo(a.totalBytes));

    return DuplicateDetectorResult(
      clusters: clusters,
      assetIdToMd5Hex: Map<String, String>.unmodifiable(idToMd5),
    );
  }
}

class DuplicateDetectorResult {
  const DuplicateDetectorResult({
    required this.clusters,
    required this.assetIdToMd5Hex,
  });

  final List<CleanerMediaCluster> clusters;
  final Map<String, String> assetIdToMd5Hex;
}
