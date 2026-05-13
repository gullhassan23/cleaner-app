import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/vault/models/vault_media_model.dart';
import 'vault_crypto.dart';

/// File IO and encrypted vault index under app support directory.
class VaultService extends GetxService {
  static const _vaultSubdir = 'private_vault';
  static const _mediaSubdir = 'media';
  static const _indexFileName = 'vault_index.enc';

  Directory? _root;

  Future<Directory> _vaultRoot() async {
    if (_root != null) return _root!;
    final support = await getApplicationSupportDirectory();
    _root = Directory(p.join(support.path, _vaultSubdir));
    if (!await _root!.exists()) {
      await _root!.create(recursive: true);
    }
    return _root!;
  }

  Future<Directory> mediaDirectory() async {
    final root = await _vaultRoot();
    final dir = Directory(p.join(root.path, _mediaSubdir));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<File> indexFile() async {
    final root = await _vaultRoot();
    return File(p.join(root.path, _indexFileName));
  }

  Future<List<VaultMediaModel>> readIndex(enc.Key aesKey) async {
    final file = await indexFile();
    if (!await file.exists() || await file.length() == 0) {
      return [];
    }
    final raw = await file.readAsBytes();
    final jsonStr = VaultCrypto.decryptToUtf8(raw, aesKey);
    final decoded = jsonDecode(jsonStr) as List<dynamic>;
    return decoded
        .map((e) => VaultMediaModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(growable: false);
  }

  Future<void> writeIndex(enc.Key aesKey, List<VaultMediaModel> items) async {
    final file = await indexFile();
    final jsonStr = jsonEncode(items.map((e) => e.toJson()).toList(growable: false));
    final encrypted = VaultCrypto.encryptUtf8(jsonStr, aesKey);
    await file.writeAsBytes(encrypted, flush: true);
  }

  /// Streams bytes from [source] into a new vault file; returns size written.
  Future<int> copyIntoVault({
    required File source,
    required String destFileName,
    void Function(int received, int total)? onProgress,
  }) async {
    final dir = await mediaDirectory();
    final dest = File(p.join(dir.path, destFileName));
    final total = await source.length();
    var received = 0;
    final sink = dest.openWrite();
    try {
      await for (final chunk in source.openRead()) {
        sink.add(chunk);
        received += chunk.length;
        onProgress?.call(received, total);
      }
      await sink.flush();
      await sink.close();
    } catch (_) {
      await sink.close();
      if (await dest.exists()) {
        await dest.delete();
      }
      rethrow;
    }
    return received;
  }

  Future<File> resolvedMediaFileAsync(String storedFileName) async {
    final dir = await mediaDirectory();
    return File(p.join(dir.path, storedFileName));
  }

  Future<void> deleteStoredFile(String storedFileName) async {
    final f = await resolvedMediaFileAsync(storedFileName);
    if (await f.exists()) {
      await f.delete();
    }
  }

  @override
  void onInit() {
    super.onInit();
    unawaited(_vaultRoot());
  }
}
