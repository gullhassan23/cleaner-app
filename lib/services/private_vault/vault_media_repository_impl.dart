import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:photo_manager/photo_manager.dart';
import 'package:sqflite/sqflite.dart';

import 'package:cleaner_app/models/private_vault/vault_import_summary.dart';
import 'package:cleaner_app/models/private_vault/vault_media.dart';
import 'package:cleaner_app/models/private_vault/vault_media_page.dart';
import 'package:cleaner_app/models/private_vault/vault_media_type.dart';
import 'package:cleaner_app/services/private_vault/vault_media_repository.dart';
import 'package:cleaner_app/services/private_vault/vault_crypto_service.dart';
import 'package:cleaner_app/services/private_vault/vault_database.dart';
import 'package:cleaner_app/services/private_vault/vault_file_store.dart';
import 'package:cleaner_app/services/private_vault/vault_mappers.dart';

class VaultMediaRepositoryImpl implements VaultMediaRepository {
  VaultMediaRepositoryImpl({
    required VaultDatabase database,
    required VaultCryptoService crypto,
    required VaultFileStore fileStore,
  }) : _database = database,
       _crypto = crypto,
       _fileStore = fileStore;

  final VaultDatabase _database;
  final VaultCryptoService _crypto;
  final VaultFileStore _fileStore;

  String _newId() {
    final bytes = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  @override
  Future<VaultMediaPage> getPage({
    required String albumId,
    required int offset,
    required int limit,
  }) async {
    final db = await _database.db;
    final total = Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM vault_media WHERE album_id = ? AND is_deleted = 0',
            [albumId],
          ),
        ) ??
        0;
    final rows = await db.query(
      'vault_media',
      where: 'album_id = ? AND is_deleted = 0',
      whereArgs: [albumId],
      orderBy: 'created_at DESC',
      limit: limit,
      offset: offset,
    );
    return VaultMediaPage(
      items: rows.map(vaultMediaFromRow).toList(),
      totalCount: total,
      hasMore: offset + rows.length < total,
    );
  }

  @override
  Future<VaultMedia?> getById(String id) async {
    final db = await _database.db;
    final rows = await db.query(
      'vault_media',
      where: 'id = ? AND is_deleted = 0',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return vaultMediaFromRow(rows.first);
  }

  @override
  Future<({int photos, int videos})> countByAlbum(String albumId) async {
    final db = await _database.db;
    final photos = Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM vault_media WHERE album_id = ? AND is_deleted = 0 AND media_type_index = ?',
            [albumId, VaultMediaType.image.index],
          ),
        ) ??
        0;
    final videos = Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM vault_media WHERE album_id = ? AND is_deleted = 0 AND media_type_index = ?',
            [albumId, VaultMediaType.video.index],
          ),
        ) ??
        0;
    return (photos: photos, videos: videos);
  }

  @override
  Future<VaultImportSummary> importFromGalleryAssets({
    required List<dynamic> assets,
    required String albumId,
    required bool removeAfterImport,
    void Function(int done, int total)? onProgress,
  }) async {
    final list = assets.cast<AssetEntity>();
    var imported = 0;
    final failed = <String>[];
    final deleteFailed = <String>[];

    for (var i = 0; i < list.length; i++) {
      final asset = list[i];
      try {
        final deleteFailedId = await _importAsset(
          asset: asset,
          albumId: albumId,
          removeAfterImport: removeAfterImport,
        );
        imported++;
        if (deleteFailedId != null) deleteFailed.add(deleteFailedId);
      } catch (e) {
        failed.add('${asset.id}: $e');
      }
      onProgress?.call(i + 1, list.length);
    }

    return VaultImportSummary(
      importedCount: imported,
      failedItems: failed,
      galleryDeleteFailedIds: deleteFailed,
    );
  }

  @override
  Future<VaultImportSummary> importFromFile({
    required String filePath,
    required String albumId,
    required bool isVideo,
    required bool removeAfterImport,
  }) async {
    try {
      await _importPlainFile(
        source: File(filePath),
        albumId: albumId,
        isVideo: isVideo,
      );
      if (removeAfterImport) {
        try {
          await File(filePath).delete();
        } catch (_) {}
      }
      return const VaultImportSummary(
        importedCount: 1,
        failedItems: [],
        galleryDeleteFailedIds: [],
      );
    } catch (e) {
      return VaultImportSummary(
        importedCount: 0,
        failedItems: [e.toString()],
        galleryDeleteFailedIds: [],
      );
    }
  }

  Future<String?> _importAsset({
    required AssetEntity asset,
    required String albumId,
    required bool removeAfterImport,
  }) async {
    final file = await asset.file;
    if (file == null) throw StateError('Could not read asset file');
    final isVideo = asset.type == AssetType.video;
    await _importPlainFile(
      source: file,
      albumId: albumId,
      isVideo: isVideo,
      durationMs: isVideo ? asset.videoDuration.inMilliseconds : 0,
    );

    if (removeAfterImport) {
      try {
        final failed = await PhotoManager.editor.deleteWithIds([asset.id]);
        if (failed.isNotEmpty) return asset.id;
      } catch (_) {
        return asset.id;
      }
    }
    return null;
  }

  Future<void> _importPlainFile({
    required File source,
    required String albumId,
    required bool isVideo,
    int durationMs = 0,
  }) async {
    await _crypto.ensureMasterKey();
    final mediaId = _newId();
    final encPath = await _fileStore.newEncryptedOriginalPath(isVideo: isVideo);
    final thumbPath = await _fileStore.newEncryptedThumbnailPath();

    final encFile = File(encPath);
    await _crypto.encryptFile(source, encFile);
    if (!await _crypto.verifyEncryptedFile(encFile)) {
      await encFile.delete();
      throw StateError('Encryption verification failed');
    }

    await _writeThumbnail(source, isVideo, File(thumbPath));

    final media = VaultMedia(
      id: mediaId,
      albumId: albumId,
      encryptedPath: encPath,
      thumbnailPath: thumbPath,
      mediaType: isVideo ? VaultMediaType.video : VaultMediaType.image,
      sizeBytes: await encFile.length(),
      durationMs: durationMs,
      isFavorite: false,
      isDeleted: false,
      createdAt: DateTime.now(),
    );

    final db = await _database.db;
    await db.insert(
      'vault_media',
      vaultMediaToRow(media),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _writeThumbnail(File source, bool isVideo, File dest) async {
    Uint8List? thumbBytes;
    if (isVideo) {
      thumbBytes = await _videoThumbnailPlaceholder();
    } else {
      final bytes = await source.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded != null) {
        final resized = img.copyResize(decoded, width: 256);
        thumbBytes = Uint8List.fromList(img.encodeJpg(resized, quality: 75));
      }
    }
    thumbBytes ??= await _videoThumbnailPlaceholder();
    await _crypto.encryptBytes(thumbBytes, dest);
  }

  Future<Uint8List> _videoThumbnailPlaceholder() async {
    final placeholder = img.Image(width: 256, height: 256);
    img.fill(placeholder, color: img.ColorRgb8(37, 99, 235));
    return Uint8List.fromList(img.encodeJpg(placeholder, quality: 70));
  }

  @override
  Future<String> decryptToTemp(VaultMedia media) async {
    await _fileStore.purgeTemp();
    final destPath = await _fileStore.tempPathFor(
      media.id,
      isVideo: media.isVideo,
    );
    final dest = File(destPath);
    await _crypto.decryptFile(File(media.encryptedPath), dest);
    return destPath;
  }

  @override
  Future<String> decryptThumbnailToMemoryPath(VaultMedia media) async {
    final destPath = await _fileStore.tempPathFor(
      '${media.id}_thumb',
      isVideo: false,
    );
    await _crypto.decryptFile(File(media.thumbnailPath), File(destPath));
    return destPath;
  }

  @override
  Future<String> exportForShare(VaultMedia media) async {
    final path = await _fileStore.exportPathFor(
      media.id,
      isVideo: media.isVideo,
    );
    await _crypto.decryptFile(File(media.encryptedPath), File(path));
    return path;
  }

  @override
  Future<void> deleteMedia(List<String> ids) async {
    final db = await _database.db;
    for (final id in ids) {
      final rows = await db.query(
        'vault_media',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (rows.isEmpty) continue;
      final row = rows.first;
      await _fileStore.deleteIfExists(row['encrypted_path']! as String);
      await _fileStore.deleteIfExists(row['thumbnail_path']! as String);
      await db.update(
        'vault_media',
        {'is_deleted': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  @override
  Future<void> purgeScratch() async {
    await _fileStore.purgeTemp();
    await _fileStore.purgeExports();
  }
}
