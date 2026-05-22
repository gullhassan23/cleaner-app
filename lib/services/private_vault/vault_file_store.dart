import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:cleaner_app/models/private_vault/vault_constants.dart';

/// Manages sandbox paths for encrypted vault storage.
class VaultFileStore extends GetxService {
  static const _root = 'private_vault';

  Directory? _rootDir;

  String _newId() {
    final bytes = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  Future<Directory> get root async {
    if (_rootDir != null) return _rootDir!;
    final base = await getApplicationSupportDirectory();
    _rootDir = Directory(p.join(base.path, _root));
    await _ensureTree();
    return _rootDir!;
  }

  Future<void> _ensureTree() async {
    final r = await root;
    for (final sub in ['originals', 'thumbnails', 'temp', 'exports']) {
      final d = Directory(p.join(r.path, sub));
      if (!await d.exists()) await d.create(recursive: true);
    }
  }

  Future<String> newEncryptedOriginalPath({required bool isVideo}) async {
    final r = await root;
    final ext = isVideo ? '.encv' : '.enci';
    return p.join(r.path, 'originals', '${_newId()}$ext');
  }

  Future<String> newEncryptedThumbnailPath() async {
    final r = await root;
    return p.join(r.path, 'thumbnails', '${_newId()}.thm');
  }

  Future<String> tempPathFor(String mediaId, {required bool isVideo}) async {
    final r = await root;
    final ext = isVideo ? '.mp4' : '.jpg';
    return p.join(r.path, 'temp', '$mediaId$ext');
  }

  Future<String> exportPathFor(String mediaId, {required bool isVideo}) async {
    final r = await root;
    final ext = isVideo ? '.mp4' : '.jpg';
    return p.join(r.path, 'exports', '${_newId()}_$mediaId$ext');
  }

  Future<void> deleteIfExists(String path) async {
    final f = File(path);
    if (await f.exists()) await f.delete();
  }

  Future<void> purgeTemp({int maxAgeMinutes = VaultConstants.tempMaxAgeMinutes}) async {
    await _purgeDir('temp', maxAgeMinutes);
  }

  Future<void> purgeExports({
    int maxAgeMinutes = VaultConstants.exportMaxAgeMinutes,
  }) async {
    await _purgeDir('exports', maxAgeMinutes);
  }

  Future<void> purgeAllScratch() async {
    final r = await root;
    for (final sub in ['temp', 'exports']) {
      final d = Directory(p.join(r.path, sub));
      if (await d.exists()) {
        await for (final e in d.list()) {
          await e.delete(recursive: true);
        }
      }
    }
  }

  Future<void> _purgeDir(String sub, int maxAgeMinutes) async {
    final r = await root;
    final d = Directory(p.join(r.path, sub));
    if (!await d.exists()) return;
    final cutoff = DateTime.now().subtract(Duration(minutes: maxAgeMinutes));
    await for (final e in d.list()) {
      final stat = await e.stat();
      if (stat.modified.isBefore(cutoff)) {
        await e.delete(recursive: true);
      }
    }
  }
}
