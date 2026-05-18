import 'photo_widget_photo.dart';

class PhotoWidgetAlbum {
  const PhotoWidgetAlbum({
    required this.id,
    required this.name,
    required this.createdAtMs,
    required this.photos,
    this.isWidgetSource = false,
  });

  final String id;
  final String name;
  final int createdAtMs;
  final List<PhotoWidgetPhoto> photos;
  final bool isWidgetSource;

  PhotoWidgetAlbum copyWith({
    String? id,
    String? name,
    int? createdAtMs,
    List<PhotoWidgetPhoto>? photos,
    bool? isWidgetSource,
  }) {
    return PhotoWidgetAlbum(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      photos: photos ?? this.photos,
      isWidgetSource: isWidgetSource ?? this.isWidgetSource,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAtMs': createdAtMs,
        'isWidgetSource': isWidgetSource,
        'photos': photos.map((p) => p.toJson()).toList(),
      };

  factory PhotoWidgetAlbum.fromJson(Map<String, dynamic> json) {
    final rawPhotos = json['photos'] as List<dynamic>? ?? [];
    return PhotoWidgetAlbum(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAtMs: json['createdAtMs'] as int? ??
          DateTime.now().millisecondsSinceEpoch,
      isWidgetSource: json['isWidgetSource'] as bool? ?? false,
      photos: rawPhotos
          .map(
            (e) => PhotoWidgetPhoto.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
    );
  }
}
