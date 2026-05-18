import 'photo_widget_style.dart';

class PhotoWidgetManifestEntry {
  const PhotoWidgetManifestEntry({
    required this.fileName,
    required this.order,
  });

  final String fileName;
  final int order;

  Map<String, dynamic> toJson() => {
        'fileName': fileName,
        'order': order,
      };

  factory PhotoWidgetManifestEntry.fromJson(Map<String, dynamic> json) {
    return PhotoWidgetManifestEntry(
      fileName: json['fileName'] as String,
      order: json['order'] as int? ?? 0,
    );
  }
}

class PhotoWidgetManifest {
  const PhotoWidgetManifest({
    this.version = 1,
    required this.enabled,
    required this.style,
    required this.slideshowIntervalSec,
    required this.cacheDirectory,
    required this.photos,
    required this.updatedAt,
  });

  final int version;
  final bool enabled;
  final PhotoWidgetStyle style;
  final int slideshowIntervalSec;
  final String cacheDirectory;
  final List<PhotoWidgetManifestEntry> photos;
  final int updatedAt;

  Map<String, dynamic> toJson() => {
        'version': version,
        'enabled': enabled,
        'style': style.storageValue,
        'slideshowIntervalSec': slideshowIntervalSec,
        'cacheDirectory': cacheDirectory,
        'photos': photos.map((p) => p.toJson()).toList(),
        'updatedAt': updatedAt,
      };

  factory PhotoWidgetManifest.fromJson(Map<String, dynamic> json) {
    final rawPhotos = json['photos'] as List<dynamic>? ?? [];
    return PhotoWidgetManifest(
      version: json['version'] as int? ?? 1,
      enabled: json['enabled'] as bool? ?? false,
      style: PhotoWidgetStyle.fromStorage(json['style'] as String?),
      slideshowIntervalSec: json['slideshowIntervalSec'] as int? ?? 30,
      cacheDirectory: json['cacheDirectory'] as String? ?? '',
      photos: rawPhotos
          .map(
            (e) => PhotoWidgetManifestEntry.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
      updatedAt: json['updatedAt'] as int? ?? 0,
    );
  }
}
