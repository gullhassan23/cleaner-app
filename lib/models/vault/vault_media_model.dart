import 'package:flutter/foundation.dart';

@immutable
class VaultMediaModel {
  const VaultMediaModel({
    required this.id,
    required this.storedFileName,
    required this.isVideo,
    required this.byteSize,
    required this.createdAtMillis,
    this.width,
    this.height,
    this.sourceAssetId,
  });

  final String id;
  final String storedFileName;
  final bool isVideo;
  final int? width;
  final int? height;
  final int byteSize;
  final int createdAtMillis;
  final String? sourceAssetId;

  Map<String, dynamic> toJson() => {
    'id': id,
    'storedFileName': storedFileName,
    'isVideo': isVideo,
    'width': width,
    'height': height,
    'byteSize': byteSize,
    'createdAtMillis': createdAtMillis,
    'sourceAssetId': sourceAssetId,
  };

  factory VaultMediaModel.fromJson(Map<String, dynamic> json) {
    return VaultMediaModel(
      id: json['id'] as String,
      storedFileName: json['storedFileName'] as String,
      isVideo: json['isVideo'] as bool,
      width: json['width'] as int?,
      height: json['height'] as int?,
      byteSize: json['byteSize'] as int,
      createdAtMillis: json['createdAtMillis'] as int,
      sourceAssetId: json['sourceAssetId'] as String?,
    );
  }

  VaultMediaModel copyWith({
    String? id,
    String? storedFileName,
    bool? isVideo,
    int? width,
    int? height,
    int? byteSize,
    int? createdAtMillis,
    String? sourceAssetId,
  }) {
    return VaultMediaModel(
      id: id ?? this.id,
      storedFileName: storedFileName ?? this.storedFileName,
      isVideo: isVideo ?? this.isVideo,
      width: width ?? this.width,
      height: height ?? this.height,
      byteSize: byteSize ?? this.byteSize,
      createdAtMillis: createdAtMillis ?? this.createdAtMillis,
      sourceAssetId: sourceAssetId ?? this.sourceAssetId,
    );
  }
}
