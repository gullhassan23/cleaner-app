import '../entities/vault_import_summary.dart';
import '../entities/vault_media.dart';
import '../entities/vault_media_page.dart';

abstract class VaultMediaRepository {
  Future<VaultMediaPage> getPage({
    required String albumId,
    required int offset,
    required int limit,
  });

  Future<VaultMedia?> getById(String id);

  Future<({int photos, int videos})> countByAlbum(String albumId);

  Future<VaultImportSummary> importFromGalleryAssets({
    required List<dynamic> assets,
    required String albumId,
    required bool removeAfterImport,
    void Function(int done, int total)? onProgress,
  });

  Future<VaultImportSummary> importFromFile({
    required String filePath,
    required String albumId,
    required bool isVideo,
    required bool removeAfterImport,
  });

  Future<String> decryptToTemp(VaultMedia media);

  Future<String> decryptThumbnailToMemoryPath(VaultMedia media);

  Future<String> exportForShare(VaultMedia media);

  Future<void> deleteMedia(List<String> ids);

  Future<void> purgeScratch();
}
