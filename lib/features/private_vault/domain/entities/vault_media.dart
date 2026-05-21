import 'vault_media_type.dart';

class VaultMedia {
  const VaultMedia({
    required this.id,
    required this.albumId,
    required this.encryptedPath,
    required this.thumbnailPath,
    required this.mediaType,
    required this.sizeBytes,
    required this.durationMs,
    required this.isFavorite,
    required this.isDeleted,
    required this.createdAt,
  });

  final String id;
  final String albumId;
  final String encryptedPath;
  final String thumbnailPath;
  final VaultMediaType mediaType;
  final int sizeBytes;
  final int durationMs;
  final bool isFavorite;
  final bool isDeleted;
  final DateTime createdAt;

  bool get isVideo => mediaType == VaultMediaType.video;
  bool get isImage => mediaType == VaultMediaType.image;
}
