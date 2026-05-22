import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// SQLite metadata store for the private vault (replaces Isar).
class VaultDatabase extends GetxService {
  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    final base = await getDatabasesPath();
    final path = p.join(base, 'private_vault.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE vault_albums (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            cover_media_id TEXT,
            created_at INTEGER NOT NULL
          )
        ''');
        await database.execute('''
          CREATE TABLE vault_media (
            id TEXT PRIMARY KEY,
            album_id TEXT NOT NULL,
            encrypted_path TEXT NOT NULL,
            thumbnail_path TEXT NOT NULL,
            media_type_index INTEGER NOT NULL,
            size_bytes INTEGER NOT NULL,
            duration_ms INTEGER NOT NULL,
            is_favorite INTEGER NOT NULL DEFAULT 0,
            is_deleted INTEGER NOT NULL DEFAULT 0,
            created_at INTEGER NOT NULL
          )
        ''');
        await database.execute(
          'CREATE INDEX idx_vault_media_album ON vault_media(album_id)',
        );
        await database.execute(
          'CREATE INDEX idx_vault_media_deleted_created ON vault_media(is_deleted, created_at DESC)',
        );
      },
    );
    return _db!;
  }

  @override
  void onClose() {
    _db?.close();
    super.onClose();
  }
}
