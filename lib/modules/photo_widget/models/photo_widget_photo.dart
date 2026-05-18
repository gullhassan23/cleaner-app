class PhotoWidgetPhoto {
  const PhotoWidgetPhoto({
    required this.id,
    required this.fileName,
    required this.order,
    this.sourceAssetId,
  });

  final String id;
  final String fileName;
  final int order;
  final String? sourceAssetId;

  PhotoWidgetPhoto copyWith({
    String? id,
    String? fileName,
    int? order,
    String? sourceAssetId,
  }) {
    return PhotoWidgetPhoto(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      order: order ?? this.order,
      sourceAssetId: sourceAssetId ?? this.sourceAssetId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileName': fileName,
        'order': order,
        if (sourceAssetId != null) 'sourceAssetId': sourceAssetId,
      };

  factory PhotoWidgetPhoto.fromJson(Map<String, dynamic> json) {
    return PhotoWidgetPhoto(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      order: json['order'] as int? ?? 0,
      sourceAssetId: json['sourceAssetId'] as String?,
    );
  }
}
