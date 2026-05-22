import 'package:cleaner_app/models/private_vault/vault_album.dart';
import 'package:cleaner_app/models/private_vault/vault_media.dart';
import 'package:cleaner_app/models/private_vault/vault_media_type.dart';

VaultMedia vaultMediaFromRow(Map<String, Object?> row) {
  return VaultMedia(
    id: row['id']! as String,
    albumId: row['album_id']! as String,
    encryptedPath: row['encrypted_path']! as String,
    thumbnailPath: row['thumbnail_path']! as String,
    mediaType:
        VaultMediaType.values[(row['media_type_index']! as int).clamp(0, 1)],
    sizeBytes: row['size_bytes']! as int,
    durationMs: row['duration_ms']! as int,
    isFavorite: (row['is_favorite']! as int) == 1,
    isDeleted: (row['is_deleted']! as int) == 1,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at']! as int),
  );
}

Map<String, Object?> vaultMediaToRow(VaultMedia m) {
  return {
    'id': m.id,
    'album_id': m.albumId,
    'encrypted_path': m.encryptedPath,
    'thumbnail_path': m.thumbnailPath,
    'media_type_index': m.mediaType.index,
    'size_bytes': m.sizeBytes,
    'duration_ms': m.durationMs,
    'is_favorite': m.isFavorite ? 1 : 0,
    'is_deleted': m.isDeleted ? 1 : 0,
    'created_at': m.createdAt.millisecondsSinceEpoch,
  };
}

VaultAlbum vaultAlbumFromRow(Map<String, Object?> row) {
  return VaultAlbum(
    id: row['id']! as String,
    name: row['name']! as String,
    coverMediaId: row['cover_media_id'] as String?,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at']! as int),
  );
}

Map<String, Object?> vaultAlbumToRow(VaultAlbum a) {
  return {
    'id': a.id,
    'name': a.name,
    'cover_media_id': a.coverMediaId,
    'created_at': a.createdAt.millisecondsSinceEpoch,
  };
}
