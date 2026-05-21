import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../domain/entities/vault_auth_state.dart';

class VaultAuthResult<T> {
  const VaultAuthResult.success(this.value) : error = null, isSuccess = true;
  const VaultAuthResult.failure(this.error) : value = null, isSuccess = false;

  final T? value;
  final String? error;
  final bool isSuccess;
}

/// Independent vault PIN/biometric auth (separate from app lock).
class VaultAuthService extends GetxService {
  VaultAuthService({
    required FlutterSecureStorage storage,
    required LocalAuthentication localAuth,
  }) : _storage = storage,
       _localAuth = localAuth;

  static const _kEnabled = 'vault_enabled';
  static const _kPinSalt = 'vault_pin_salt';
  static const _kPinHash = 'vault_pin_hash';
  static const _kBiometric = 'vault_biometric_enabled';
  static const _kFailedAttempts = 'vault_failed_attempts';
  static const _kLockUntil = 'vault_lock_until';
  static const _kRemoveAfterImport = 'vault_remove_after_import';

  final FlutterSecureStorage _storage;
  final LocalAuthentication _localAuth;

  Future<bool> isEnabled() async {
    final v = await _storage.read(key: _kEnabled);
    return v == 'true';
  }

  Future<bool> isBiometricEnabled() async {
    final v = await _storage.read(key: _kBiometric);
    return v == 'true';
  }

  Future<bool> getRemoveAfterImport() async {
    final v = await _storage.read(key: _kRemoveAfterImport);
    return v == 'true';
  }

  Future<void> setRemoveAfterImport(bool value) async {
    await _storage.write(
      key: _kRemoveAfterImport,
      value: value ? 'true' : 'false',
    );
  }

  Future<bool> canUseBiometrics() async {
    try {
      final supported = await _localAuth.isDeviceSupported();
      final can = await _localAuth.canCheckBiometrics;
      return supported && can;
    } catch (_) {
      return false;
    }
  }

  Future<VaultAuthState> getAuthState() async {
    final lockUntil = await _readLockUntil();
    final now = DateTime.now();
    if (lockUntil != null && lockUntil.isAfter(now)) {
      return VaultAuthState(
        isEnabled: await isEnabled(),
        isBiometricEnabled: await isBiometricEnabled(),
        canUseBiometrics: await canUseBiometrics(),
        isLockedOut: true,
        lockRemainingSeconds: lockUntil.difference(now).inSeconds + 1,
      );
    }
    return VaultAuthState(
      isEnabled: await isEnabled(),
      isBiometricEnabled: await isBiometricEnabled(),
      canUseBiometrics: await canUseBiometrics(),
      isLockedOut: false,
    );
  }

  Future<DateTime?> _readLockUntil() async {
    final raw = await _storage.read(key: _kLockUntil);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  Future<VaultAuthResult<void>> setupPin({
    required String pin,
    required bool enableBiometric,
  }) async {
    if (!_isValidPin(pin)) {
      return const VaultAuthResult.failure('PIN must be exactly 4 digits.');
    }
    try {
      await _clearLockout();
      final salt = _randomSaltB64();
      final hashHex = _hashPin(pin, salt);
      await _storage.write(key: _kPinSalt, value: salt);
      await _storage.write(key: _kPinHash, value: hashHex);
      await _storage.write(key: _kEnabled, value: 'true');
      await _storage.write(
        key: _kBiometric,
        value: enableBiometric ? 'true' : 'false',
      );
      return const VaultAuthResult.success(null);
    } catch (e) {
      return VaultAuthResult.failure('Could not set up vault PIN: $e');
    }
  }

  Future<VaultAuthResult<void>> changePin({
    required String oldPin,
    required String newPin,
  }) async {
    if (!await verifyPin(oldPin)) {
      return const VaultAuthResult.failure('Current PIN is incorrect.');
    }
    if (!_isValidPin(newPin)) {
      return const VaultAuthResult.failure('PIN must be exactly 4 digits.');
    }
    try {
      final salt = _randomSaltB64();
      final hashHex = _hashPin(newPin, salt);
      await _storage.write(key: _kPinSalt, value: salt);
      await _storage.write(key: _kPinHash, value: hashHex);
      return const VaultAuthResult.success(null);
    } catch (e) {
      return VaultAuthResult.failure('Could not change PIN: $e');
    }
  }

  Future<bool> verifyPin(String pin) async {
    final state = await getAuthState();
    if (state.isLockedOut) return false;

    final salt = await _storage.read(key: _kPinSalt);
    final stored = await _storage.read(key: _kPinHash);
    if (salt == null || stored == null) return false;

    final ok = _hashPin(pin, salt) == stored;
    if (ok) {
      await _clearLockout();
      return true;
    }
    await _recordFailedAttempt();
    return false;
  }

  Future<void> _recordFailedAttempt() async {
    final raw = await _storage.read(key: _kFailedAttempts);
    final count = (int.tryParse(raw ?? '') ?? 0) + 1;
    await _storage.write(key: _kFailedAttempts, value: '$count');

    Duration lock = Duration.zero;
    if (count >= 10) {
      lock = const Duration(minutes: 5);
    } else if (count >= 5) {
      lock = const Duration(seconds: 30);
    }

    if (lock > Duration.zero) {
      final until = DateTime.now().add(lock);
      await _storage.write(
        key: _kLockUntil,
        value: until.toIso8601String(),
      );
    }
  }

  Future<void> _clearLockout() async {
    await _storage.delete(key: _kFailedAttempts);
    await _storage.delete(key: _kLockUntil);
  }

  Future<bool> authenticateBiometric() async {
    if (!await isBiometricEnabled()) return false;
    try {
      final can = await _localAuth.canCheckBiometrics;
      final supported = await _localAuth.isDeviceSupported();
      if (!can && !supported) return false;

      final ok = await _localAuth.authenticate(
        localizedReason: 'Unlock your private vault',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (ok) await _clearLockout();
      return ok;
    } catch (_) {
      return false;
    }
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: _kBiometric,
      value: enabled ? 'true' : 'false',
    );
  }

  static bool _isValidPin(String pin) => RegExp(r'^\d{4}$').hasMatch(pin);

  static String _randomSaltB64() {
    final bytes = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    return base64UrlEncode(bytes);
  }

  static String _hashPin(String pin, String salt) {
    return sha256.convert(utf8.encode('$salt|$pin')).toString();
  }
}
