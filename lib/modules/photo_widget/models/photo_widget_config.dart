import 'photo_widget_source_mode.dart';
import 'photo_widget_style.dart';

class PhotoWidgetConfig {
  const PhotoWidgetConfig({
    this.enabled = false,
    this.style = PhotoWidgetStyle.grid,
    this.sourceMode = PhotoWidgetSourceMode.activeAlbum,
    this.activeAlbumId,
    this.slideshowIntervalSec = 30,
    this.lastUpdatedMs = 0,
  });

  final bool enabled;
  final PhotoWidgetStyle style;
  final PhotoWidgetSourceMode sourceMode;
  final String? activeAlbumId;
  final int slideshowIntervalSec;
  final int lastUpdatedMs;

  PhotoWidgetConfig copyWith({
    bool? enabled,
    PhotoWidgetStyle? style,
    PhotoWidgetSourceMode? sourceMode,
    String? activeAlbumId,
    int? slideshowIntervalSec,
    int? lastUpdatedMs,
    bool clearActiveAlbumId = false,
  }) {
    return PhotoWidgetConfig(
      enabled: enabled ?? this.enabled,
      style: style ?? this.style,
      sourceMode: sourceMode ?? this.sourceMode,
      activeAlbumId:
          clearActiveAlbumId ? null : (activeAlbumId ?? this.activeAlbumId),
      slideshowIntervalSec:
          slideshowIntervalSec ?? this.slideshowIntervalSec,
      lastUpdatedMs: lastUpdatedMs ?? this.lastUpdatedMs,
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'style': style.storageValue,
        'sourceMode': sourceMode.storageValue,
        'activeAlbumId': activeAlbumId,
        'slideshowIntervalSec': slideshowIntervalSec,
        'lastUpdatedMs': lastUpdatedMs,
      };

  factory PhotoWidgetConfig.fromJson(Map<String, dynamic> json) {
    return PhotoWidgetConfig(
      enabled: json['enabled'] as bool? ?? false,
      style: PhotoWidgetStyle.fromStorage(json['style'] as String?),
      sourceMode:
          PhotoWidgetSourceMode.fromStorage(json['sourceMode'] as String?),
      activeAlbumId: json['activeAlbumId'] as String?,
      slideshowIntervalSec: json['slideshowIntervalSec'] as int? ?? 30,
      lastUpdatedMs: json['lastUpdatedMs'] as int? ?? 0,
    );
  }
}
