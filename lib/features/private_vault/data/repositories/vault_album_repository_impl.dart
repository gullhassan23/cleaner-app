import '../../domain/entities/vault_album.dart';
import '../../domain/repositories/vault_album_repository.dart';
import '../../domain/vault_constants.dart';
import '../datasources/vault_database.dart';
import '../mappers/vault_mappers.dart';

class VaultAlbumRepositoryImpl implements VaultAlbumRepository {
  VaultAlbumRepositoryImpl(this._database);

  final VaultDatabase _database;

  @override
  Future<List<VaultAlbum>> getAlbums() async {
    final db = await _database.db;
    final rows = await db.query(
      'vault_albums',
      orderBy: 'created_at DESC',
    );
    return rows.map(vaultAlbumFromRow).toList();
  }

  @override
  Future<VaultAlbum> ensureDefaultAlbum() async {
    final db = await _database.db;
    final rows = await db.query(
      'vault_albums',
      where: 'id = ?',
      whereArgs: [VaultConstants.defaultAlbumId],
      limit: 1,
    );
    if (rows.isNotEmpty) return vaultAlbumFromRow(rows.first);

    final album = VaultAlbum(
      id: VaultConstants.defaultAlbumId,
      name: VaultConstants.defaultAlbumName,
      createdAt: DateTime.now(),
    );
    await db.insert('vault_albums', vaultAlbumToRow(album));
    return album;
  }

  @override
  Future<VaultAlbum> createAlbum(String name) async {
    final db = await _database.db;
    final album = VaultAlbum(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim().isEmpty ? 'Album' : name.trim(),
      createdAt: DateTime.now(),
    );
    await db.insert('vault_albums', vaultAlbumToRow(album));
    return album;
  }
}
