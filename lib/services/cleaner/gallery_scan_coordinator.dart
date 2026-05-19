import '../../models/cleaner/cleaner_gallery_scan_result.dart';
import '../../models/photo_library/photo_asset_entity.dart';
import '../repositories/photo_library_repository.dart';

/// Loads and classifies all gallery media for the cleaner pipeline.
class GalleryScanCoordinator {
  GalleryScanCoordinator({required PhotoLibraryRepository repository})
    : _repository = repository;

  final PhotoLibraryRepository _repository;

  static const int _pageSize = 120;

  /// Fetches every page until exhausted, then returns classified buckets.
  Future<CleanerGalleryScanResult> loadFullLibrary({
    void Function(int loadedCount, int? totalHint)? onProgress,
  }) async {
    final all = <PhotoAssetEntity>[];
    var page = 0;

    while (true) {
      final galleryPage = await _repository.fetchMediaPage(
        page: page,
        pageSize: _pageSize,
      );
      if (galleryPage.items.isEmpty) {
        break;
      }
      all.addAll(galleryPage.items);
      onProgress?.call(all.length, galleryPage.totalCount);
      if (!galleryPage.hasMore) {
        break;
      }
      page += 1;
    }

    return CleanerGalleryScanResult.fromMediaList(
      List<PhotoAssetEntity>.unmodifiable(all),
    );
  }
}
