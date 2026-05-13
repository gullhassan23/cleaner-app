enum GalleryMediaType { image, video, other }

class PhotoAssetEntity {
  const PhotoAssetEntity({
    required this.id,
    required this.width,
    required this.height,
    required this.fileSize,
    required this.createdAt,
    required this.modifiedAt,
    required this.isFavorite,
    required this.title,
    required this.mimeType,
    required this.relativePath,
    this.mediaType = GalleryMediaType.image,
    this.duration = Duration.zero,
  });

  final String id;
  final int width;
  final int height;
  final int fileSize;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final bool isFavorite;
  final String? title;
  final String? mimeType;
  final String? relativePath;
  final GalleryMediaType mediaType;
  final Duration duration;

  int get pixelCount => width * height;
  bool get isVideo => mediaType == GalleryMediaType.video;
  bool get isImage => mediaType == GalleryMediaType.image;

  double get aspectRatio {
    if (height == 0) {
      return 1;
    }

    return width / height;
  }

  PhotoAssetEntity copyWith({
    String? id,
    int? width,
    int? height,
    int? fileSize,
    DateTime? createdAt,
    DateTime? modifiedAt,
    bool? isFavorite,
    String? title,
    String? mimeType,
    String? relativePath,
    GalleryMediaType? mediaType,
    Duration? duration,
  }) {
    return PhotoAssetEntity(
      id: id ?? this.id,
      width: width ?? this.width,
      height: height ?? this.height,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      title: title ?? this.title,
      mimeType: mimeType ?? this.mimeType,
      relativePath: relativePath ?? this.relativePath,
      mediaType: mediaType ?? this.mediaType,
      duration: duration ?? this.duration,
    );
  }
}

class GalleryPageEntity {
  const GalleryPageEntity({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.hasMore,
  });

  final List<PhotoAssetEntity> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool hasMore;
}
