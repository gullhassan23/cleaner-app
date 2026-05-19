import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../../models/cleaner/cleaner_media_cluster.dart';
import '../../models/photo_library/photo_asset_entity.dart';
import '../repositories/photo_library_repository.dart';

typedef SimilarProgressCallback = void Function(int completed, int total);

/// Visually similar images via dHash on thumbnails + BK-tree + union-find.
class SimilarDetectorService {
  SimilarDetectorService({required PhotoLibraryRepository repository})
    : _repository = repository;

  final PhotoLibraryRepository _repository;

  static const int _thumbSize = 160;
  static const int _thumbQuality = 70;
  static const int _hammingThreshold = 12;
  static const int _thumbConcurrency = 6;

  /// [assetIdToMd5Hex] skips pairing assets with identical MD5 (handled by duplicate flow).
  Future<List<CleanerMediaCluster>> findSimilar(
    List<PhotoAssetEntity> images, {
    required Map<String, String> assetIdToMd5Hex,
    SimilarProgressCallback? onProgress,
    bool Function()? isCancelled,
  }) async {
    final total = images.length;
    if (total < 2) {
      return [];
    }

    final hashes = <int?>[]; // parallel to images, null if failed
    hashes.length = total;
    var completed = 0;

    Future<void> loadOne(int i) async {
      if (isCancelled?.call() ?? false) {
        return;
      }
      final asset = images[i];
      final bytes = await _repository.loadPreviewBytes(
        asset.id,
        width: _thumbSize,
        height: _thumbSize,
        quality: _thumbQuality,
      );
      hashes[i] = _computeDHash56(bytes);
      completed++;
      onProgress?.call(completed, total);
    }

    var idx = 0;
    while (idx < total) {
      if (isCancelled?.call() ?? false) {
        return [];
      }
      final batch = <Future<void>>[];
      for (var b = 0; b < _thumbConcurrency && idx < total; b++) {
        batch.add(loadOne(idx));
        idx++;
      }
      await Future.wait(batch);
      await Future<void>.delayed(Duration.zero);
    }

    // Aspect buckets: quantize ratio to reduce false positives
    final buckets = <int, List<int>>{};
    for (var i = 0; i < total; i++) {
      final h = hashes[i];
      if (h == null) {
        continue;
      }
      final asset = images[i];
      final ratio = asset.height == 0 ? 1.0 : asset.width / asset.height;
      final key = (ratio * 20).round().clamp(0, 2000);
      buckets.putIfAbsent(key, () => <int>[]).add(i);
    }

    final uf = _UnionFind(total);

    for (final entry in buckets.entries) {
      final indices = entry.value;
      if (indices.length < 2) {
        continue;
      }
      _BKNode? root;
      for (final i in indices) {
        if (isCancelled?.call() ?? false) {
          return [];
        }
        final hi = hashes[i]!;
        final neighbors = <int>[];
        _searchBK(root, hi, _hammingThreshold, neighbors);
        for (final j in neighbors) {
          if (_skipPair(
            images[i],
            images[j],
            assetIdToMd5Hex,
          )) {
            continue;
          }
          uf.union(i, j);
        }
        root = _insertBK(root, hi, i);
      }
    }

    final clustersByRoot = <int, List<int>>{};
    for (var i = 0; i < total; i++) {
      if (hashes[i] == null) {
        continue;
      }
      final r = uf.find(i);
      clustersByRoot.putIfAbsent(r, () => <int>[]).add(i);
    }

    final out = <CleanerMediaCluster>[];
    var clusterSeq = 0;
    for (final group in clustersByRoot.values) {
      if (group.length < 2) {
        continue;
      }
      final members = group.map((i) => images[i]).toList(growable: false);
      final keeper = CleanerMediaCluster.pickKeeper(members);
      out.add(
        CleanerMediaCluster(
          id: 'sim_${clusterSeq++}',
          members: List<PhotoAssetEntity>.unmodifiable(members),
          keeper: keeper,
        ),
      );
    }

    out.sort((a, b) => b.totalBytes.compareTo(a.totalBytes));
    return out;
  }

  static bool _skipPair(
    PhotoAssetEntity a,
    PhotoAssetEntity b,
    Map<String, String> md5ById,
  ) {
    final ma = md5ById[a.id];
    final mb = md5ById[b.id];
    return ma != null && ma == mb;
  }

  /// 56-bit dHash from 9×8 grayscale (8×7 horizontal comparisons).
  static int? _computeDHash56(Uint8List? bytes) {
    if (bytes == null) {
      return null;
    }
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return null;
    }
    final resized = img.copyResize(
      decoded,
      width: 9,
      height: 8,
      interpolation: img.Interpolation.linear,
    );
    final gray = img.grayscale(resized);
    var hash = 0;
    var bit = 0;
    for (var y = 0; y < 8; y++) {
      for (var x = 0; x < 7; x++) {
        final left = gray.getPixel(x, y).r;
        final right = gray.getPixel(x + 1, y).r;
        if (left > right) {
          hash |= 1 << bit;
        }
        bit++;
      }
    }
    return hash & ((1 << 56) - 1);
  }

  static int _hamming56(int a, int b) {
    var x = (a ^ b) & ((1 << 56) - 1);
    var c = 0;
    while (x != 0) {
      c += x & 1;
      x >>= 1;
    }
    return c;
  }

  static void _searchBK(
    _BKNode? node,
    int hash,
    int maxDist,
    List<int> out,
  ) {
    if (node == null) {
      return;
    }
    final d = _hamming56(hash, node.hash);
    if (d <= maxDist) {
      out.add(node.index);
    }
    for (final entry in node.children.entries) {
      final k = entry.key;
      if ((k - d).abs() <= maxDist) {
        _searchBK(entry.value, hash, maxDist, out);
      }
    }
  }

  static _BKNode? _insertBK(_BKNode? node, int hash, int index) {
    if (node == null) {
      return _BKNode(hash, index);
    }
    final d = _hamming56(hash, node.hash);
    node.children[d] = _insertBK(node.children[d], hash, index);
    return node;
  }
}

class _BKNode {
  _BKNode(this.hash, this.index);

  final int hash;
  final int index;
  final Map<int, _BKNode?> children = {};
}

class _UnionFind {
  _UnionFind(int n) : _parent = List<int>.generate(n, (i) => i), _rank = List<int>.filled(n, 0);

  final List<int> _parent;
  final List<int> _rank;

  int find(int x) {
    if (_parent[x] != x) {
      _parent[x] = find(_parent[x]);
    }
    return _parent[x];
  }

  void union(int a, int b) {
    var ra = find(a);
    var rb = find(b);
    if (ra == rb) {
      return;
    }
    if (_rank[ra] < _rank[rb]) {
      final t = ra;
      ra = rb;
      rb = t;
    }
    _parent[rb] = ra;
    if (_rank[ra] == _rank[rb]) {
      _rank[ra]++;
    }
  }
}
