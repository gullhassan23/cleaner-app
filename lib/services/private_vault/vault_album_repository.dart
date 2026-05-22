import 'package:cleaner_app/models/private_vault/vault_album.dart';

abstract class VaultAlbumRepository {
  Future<List<VaultAlbum>> getAlbums();

  Future<VaultAlbum> ensureDefaultAlbum();

  Future<VaultAlbum> createAlbum(String name);
}
