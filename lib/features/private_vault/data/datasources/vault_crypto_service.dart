import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

/// AES-256-GCM encryption for vault files (unique nonce per file).
class VaultCryptoService extends GetxService {
  VaultCryptoService({required FlutterSecureStorage storage})
    : _storage = storage;

  static const _kMasterKey = 'vault_master_key_v1';
  static const _fileVersion = 1;
  static const _nonceLength = 12;
  static const _macLength = 16;
  static const _maxFileBytes = 250 * 1024 * 1024;

  final FlutterSecureStorage _storage;
  final AesGcm _algorithm = AesGcm.with256bits();

  SecretKey? _cachedKey;

  Future<SecretKey> getMasterKey() async {
    if (_cachedKey != null) return _cachedKey!;
    var raw = await _storage.read(key: _kMasterKey);
    if (raw == null || raw.isEmpty) {
      final key = await _algorithm.newSecretKey();
      final bytes = await key.extractBytes();
      raw = base64UrlEncode(bytes);
      await _storage.write(key: _kMasterKey, value: raw);
      _cachedKey = key;
      return key;
    }
    final decoded = base64Url.decode(raw);
    _cachedKey = SecretKeyData(decoded);
    return _cachedKey!;
  }

  Future<void> ensureMasterKey() => getMasterKey();

  Future<void> encryptFile(File source, File dest) async {
    final len = await source.length();
    if (len > _maxFileBytes) {
      throw StateError('File exceeds vault size limit');
    }
    final plain = await source.readAsBytes();
    await encryptBytes(plain, dest);
  }

  Future<void> encryptBytes(Uint8List plain, File dest) async {
    final key = await getMasterKey();
    final nonce = _algorithm.newNonce();
    final box = await _algorithm.encrypt(plain, secretKey: key, nonce: nonce);

    final out = dest.openWrite();
    try {
      out.add([_fileVersion]);
      out.add(nonce);
      out.add(box.cipherText);
      out.add(box.mac.bytes);
    } finally {
      await out.close();
    }
  }

  Future<void> decryptFile(File encrypted, File dest) async {
    final bytes = await encrypted.readAsBytes();
    final plain = await decryptBytes(bytes);
    await dest.writeAsBytes(plain, flush: true);
  }

  Future<Uint8List> decryptBytes(Uint8List bytes) async {
    if (bytes.length < 1 + _nonceLength + _macLength + 1) {
      throw StateError('Invalid encrypted vault file');
    }

    final version = bytes[0];
    if (version != _fileVersion) {
      throw StateError('Unsupported vault file version: $version');
    }

    final nonce = bytes.sublist(1, 1 + _nonceLength);
    final cipherWithMac = bytes.sublist(1 + _nonceLength);
    if (cipherWithMac.length < _macLength) {
      throw StateError('Truncated vault ciphertext');
    }

    final cipherText = cipherWithMac.sublist(
      0,
      cipherWithMac.length - _macLength,
    );
    final mac = Mac(cipherWithMac.sublist(cipherWithMac.length - _macLength));

    final key = await getMasterKey();
    return Uint8List.fromList(
      await _algorithm.decrypt(
        SecretBox(cipherText, nonce: nonce, mac: mac),
        secretKey: key,
      ),
    );
  }

  Future<bool> verifyEncryptedFile(File encrypted) async {
    try {
      if (!await encrypted.exists()) return false;
      final len = await encrypted.length();
      if (len < 1 + _nonceLength + _macLength + 1) return false;
      final raf = await encrypted.open();
      try {
        final version = await raf.readByte();
        return version == _fileVersion;
      } finally {
        await raf.close();
      }
    } catch (_) {
      return false;
    }
  }
}
