import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path/path.dart' as p;
import 'package:photo_manager/photo_manager.dart';

import '../../features/vault/models/vault_media_model.dart';
import '../../features/vault/models/vault_result.dart';
import '../../repositories/vault_repository.dart';
import '../permissions/photo_permission_service.dart';
import 'vault_crypto.dart';
import 'vault_service.dart';

class VaultRepositoryImpl extends GetxService implements VaultRepository {
  VaultRepositoryImpl({
    required FlutterSecureStorage secureStorage,
    required LocalAuthentication localAuth,
    required VaultService vaultService,
    required PhotoPermissionService permissionService,
  }) : _storage = secureStorage,
       _localAuth = localAuth,
       _vaultService = vaultService,
       _permissionService = permissionService;

  static const _kPinSalt = 'vault_pin_salt_b64';
  static const _kPinHash = 'vault_pin_hash_hex';
  static const _kAesKey = 'vault_aes_key_b64';
  static const _kSetup = 'vault_setup_done';
  static const _kBio = 'vault_biometric_enabled';

  final FlutterSecureStorage _storage;
  final LocalAuthentication _localAuth;
  final VaultService _vaultService;
  final PhotoPermissionService _permissionService;

  enc.Key? _sessionKey;

  @override
  final RxBool sessionUnlocked = false.obs;

  bool get _hasSession => _sessionKey != null;

  @override
  Future<bool> isSetupComplete() async {
    final v = await _storage.read(key: _kSetup);
    return v == 'true';
  }

  @override
  Future<VaultResult<void>> completeSetup({
    required String pin,
    required bool enableBiometric,
  }) async {
    if (!_isValidPin(pin)) {
      return VaultResult.failure('PIN must be exactly 4 digits.');
    }
    try {
      final salt = _randomSaltB64();
      final hashHex = _hashPin(pin, salt);
      final aesKey = VaultCrypto.newAesKey();
      await _storage.write(key: _kPinSalt, value: salt);
      await _storage.write(key: _kPinHash, value: hashHex);
      await _storage.write(key: _kAesKey, value: VaultCrypto.keyToBase64(aesKey));
      await _storage.write(key: _kSetup, value: 'true');
      await _storage.write(
        key: _kBio,
        value: enableBiometric ? 'true' : 'false',
      );
      await _vaultService.writeIndex(aesKey, []);
      _sessionKey = aesKey;
      sessionUnlocked.value = true;
      return const VaultResult.success(null);
    } catch (e) {
      return VaultResult.failure('Setup failed: $e');
    }
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final v = await _storage.read(key: _kBio);
    return v == 'true';
  }

  @override
  Future<VaultResult<void>> setBiometricEnabled(bool enabled) async {
    try {
      await _storage.write(key: _kBio, value: enabled ? 'true' : 'false');
      return const VaultResult.success(null);
    } catch (e) {
      return VaultResult.failure('Could not update biometric setting: $e');
    }
  }

  @override
  Future<bool> pinMatches(String pin) async {
    final salt = await _storage.read(key: _kPinSalt);
    final stored = await _storage.read(key: _kPinHash);
    if (salt == null || stored == null) return false;
    return _hashPin(pin, salt) == stored;
  }

  @override
  Future<bool> unlockWithPin(String pin) async {
    final ok = await pinMatches(pin);
    if (!ok) return false;
    final key = await _loadAesKey();
    if (key == null) return false;
    _sessionKey = key;
    sessionUnlocked.value = true;
    return true;
  }

  @override
  Future<bool> unlockWithBiometrics() async {
    if (!await isBiometricEnabled()) return false;
    final can = await _localAuth.canCheckBiometrics;
    final supported = await _localAuth.isDeviceSupported();
    if (!can && !supported) return false;
    final authed = await _localAuth.authenticate(
      localizedReason: 'Unlock your private vault',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );
    if (!authed) return false;
    final key = await _loadAesKey();
    if (key == null) return false;
    _sessionKey = key;
    sessionUnlocked.value = true;
    return true;
  }

  @override
  void lockSession() {
    _sessionKey = null;
    sessionUnlocked.value = false;
  }

  @override
  Future<VaultResult<List<VaultMediaModel>>> loadMediaIndex() async {
    if (!_hasSession) {
      return VaultResult.failure('Vault is locked.');
    }
    try {
      final list = await _vaultService.readIndex(_sessionKey!);
      return VaultResult.success(list);
    } catch (e) {
      return VaultResult.failure('Could not read vault: $e');
    }
  }

  @override
  Future<VaultResult<VaultImportSummary>> importAssets(
    List<AssetEntity> assets, {
    required bool removeFromGalleryAfterImport,
    void Function(int completed, int total)? onProgress,
  }) async {
    if (!_hasSession) {
      return VaultResult.failure('Vault is locked.');
    }
    final perm = await _permissionService.getMediaPermissionState();
    if (!perm.canAccess) {
      return VaultResult.failure(
        'Photos access is required. Grant access in Settings.',
      );
    }

    final failed = <String>[];
    final galleryDeleteFailed = <String>[];
    final key = _sessionKey!;
    var index = await _vaultService.readIndex(key);
    final total = assets.length;
    var done = 0;

    for (final asset in assets) {
      try {
        final file = await _resolveAssetFile(asset);
        if (file == null || !await file.exists()) {
          failed.add('Could not read file for ${asset.title}');
          done++;
          onProgress?.call(done, total);
          continue;
        }

        final id = _newVaultId();
        final ext = _extensionFor(asset, file.path);
        final storedName = '$id$ext';
        final size = await _vaultService.copyIntoVault(
          source: file,
          destFileName: storedName,
        );

        final model = VaultMediaModel(
          id: id,
          storedFileName: storedName,
          isVideo: asset.type == AssetType.video,
          width: asset.width,
          height: asset.height,
          byteSize: size,
          createdAtMillis: DateTime.now().millisecondsSinceEpoch,
          sourceAssetId: asset.id,
        );
        index = [...index, model];
        await _vaultService.writeIndex(key, index);

        if (removeFromGalleryAfterImport) {
          try {
            final deleted = await PhotoManager.editor.deleteWithIds([asset.id]);
            if (deleted.isEmpty) {
              galleryDeleteFailed.add(asset.id);
            }
          } catch (_) {
            galleryDeleteFailed.add(asset.id);
          }
        }
      } catch (e) {
        failed.add('${asset.title}: $e');
      }
      done++;
      onProgress?.call(done, total);
    }

    final importedCount = assets.length - failed.length;
    return VaultResult.success(
      VaultImportSummary(
        importedCount: importedCount,
        failedItems: failed,
        galleryDeleteFailedIds: galleryDeleteFailed,
      ),
    );
  }

  @override
  Future<VaultResult<void>> deleteFromVault(List<String> ids) async {
    if (!_hasSession) {
      return VaultResult.failure('Vault is locked.');
    }
    try {
      final key = _sessionKey!;
      var index = await _vaultService.readIndex(key);
      final idSet = ids.toSet();
      final toRemove = index.where((m) => idSet.contains(m.id)).toList();
      index = index.where((m) => !idSet.contains(m.id)).toList(growable: false);
      for (final m in toRemove) {
        await _vaultService.deleteStoredFile(m.storedFileName);
      }
      await _vaultService.writeIndex(key, index);
      return const VaultResult.success(null);
    } catch (e) {
      return VaultResult.failure('Delete failed: $e');
    }
  }

  @override
  Future<VaultResult<void>> restoreToGallery(VaultMediaModel item) async {
    if (!_hasSession) {
      return VaultResult.failure('Vault is locked.');
    }
    try {
      final file = await _vaultService.resolvedMediaFileAsync(item.storedFileName);
      if (!await file.exists()) {
        return VaultResult.failure('File is missing from vault storage.');
      }
      if (item.isVideo) {
        await PhotoManager.editor.saveVideo(
          file,
          title: p.basenameWithoutExtension(item.storedFileName),
          creationDate: DateTime.now(),
        );
      } else {
        await PhotoManager.editor.saveImageWithPath(
          file.path,
          title: p.basenameWithoutExtension(item.storedFileName),
          creationDate: DateTime.now(),
        );
      }
      return const VaultResult.success(null);
    } catch (e) {
      return VaultResult.failure('Could not restore to library: $e');
    }
  }

  @override
  Future<File?> fileFor(VaultMediaModel item) async {
    final f = await _vaultService.resolvedMediaFileAsync(item.storedFileName);
    if (await f.exists()) return f;
    return null;
  }

  Future<enc.Key?> _loadAesKey() async {
    final b64 = await _storage.read(key: _kAesKey);
    if (b64 == null || b64.isEmpty) return null;
    try {
      return VaultCrypto.keyFromBase64(b64);
    } catch (_) {
      return null;
    }
  }

  Future<File?> _resolveAssetFile(AssetEntity asset) async {
    try {
      final f = await asset.originFile;
      if (f != null && await f.exists()) return f;
    } catch (_) {}
    try {
      final f = await asset.file;
      if (f != null && await f.exists()) return f;
    } catch (_) {}
    return null;
  }

  static bool _isValidPin(String pin) => RegExp(r'^\d{4}$').hasMatch(pin);

  static String _randomSaltB64() {
    final bytes = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    return base64UrlEncode(bytes);
  }

  static String _hashPin(String pin, String salt) {
    return sha256.convert(utf8.encode('$salt|$pin')).toString();
  }

  static String _newVaultId() {
    final r = Random.secure();
    return List.generate(32, (_) => r.nextInt(16).toRadixString(16)).join();
  }

  static String _extensionFor(AssetEntity asset, String path) {
    var ext = p.extension(path).toLowerCase();
    if (ext.isEmpty) {
      ext = asset.type == AssetType.video ? '.mp4' : '.jpg';
    }
    if (ext.length > 8) ext = ext.substring(0, 8);
    return ext;
  }
}
