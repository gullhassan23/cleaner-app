import '../photo_library/photo_asset_entity.dart';

/// Heuristic: screenshots are identified by path/title patterns only (not 100% on all devices).
bool isLikelyScreenshot(PhotoAssetEntity asset) {
  final path = asset.relativePath?.toLowerCase() ?? '';
  final title = asset.title?.toLowerCase() ?? '';
  if (path.contains('screenshot') || title.contains('screenshot')) {
    return true;
  }
  if (path.contains('pictures/screenshots') ||
      path.contains('dcim/screenshots')) {
    return true;
  }
  if (title.contains('screen shot')) {
    return true;
  }
  if (title == 'screenshot') {
    return true;
  }
  return false;
}

class CleanerGalleryScanResult {
  const CleanerGalleryScanResult({
    required this.allItems,
    required this.imageAssets,
    required this.videoAssets,
    required this.screenshotAssets,
  });

  final List<PhotoAssetEntity> allItems;
  final List<PhotoAssetEntity> imageAssets;
  final List<PhotoAssetEntity> videoAssets;
  final List<PhotoAssetEntity> screenshotAssets;

  static CleanerGalleryScanResult fromMediaList(List<PhotoAssetEntity> media) {
    final videos = <PhotoAssetEntity>[];
    final images = <PhotoAssetEntity>[];
    final screenshots = <PhotoAssetEntity>[];

    for (final asset in media) {
      if (asset.isVideo) {
        videos.add(asset);
        continue;
      }
      if (!asset.isImage) {
        continue;
      }
      images.add(asset);
      if (isLikelyScreenshot(asset)) {
        screenshots.add(asset);
      }
    }

    return CleanerGalleryScanResult(
      allItems: List<PhotoAssetEntity>.unmodifiable(media),
      imageAssets: List<PhotoAssetEntity>.unmodifiable(images),
      videoAssets: List<PhotoAssetEntity>.unmodifiable(videos),
      screenshotAssets: List<PhotoAssetEntity>.unmodifiable(screenshots),
    );
  }

  int totalBytesFor(Iterable<PhotoAssetEntity> items) =>
      items.fold<int>(0, (s, a) => s + a.fileSize);
}
