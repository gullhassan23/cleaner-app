import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../models/appLock/app_lock_result.dart';

/// Persists app lock settings and handles PIN/biometric verification.
class AppLockService extends GetxService {
  AppLockService({
    required FlutterSecureStorage storage,
    required LocalAuthentication localAuth,
  })  : _storage = storage,
        _localAuth = localAuth;

  static const _kEnabled = 'app_lock_enabled';
  static const _kPinSalt = 'app_lock_pin_salt';
  static const _kPinHash = 'app_lock_pin_hash';
  static const _kBiometric = 'app_lock_biometric_enabled';

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

  Future<bool> canUseBiometrics() async {
    try {
      final supported = await _localAuth.isDeviceSupported();
      final can = await _localAuth.canCheckBiometrics;
      return supported && can;
    } catch (_) {
      return false;
    }
  }

  Future<AppLockResult<void>> enable({
    required String pin,
    required bool enableBiometric,
  }) async {
    if (!_isValidPin(pin)) {
      return const AppLockResult.failure('PIN must be exactly 4 digits.');
    }
    try {
      final salt = _randomSaltB64();
      final hashHex = _hashPin(pin, salt);
      await _storage.write(key: _kPinSalt, value: salt);
      await _storage.write(key: _kPinHash, value: hashHex);
      await _storage.write(key: _kEnabled, value: 'true');
      await _storage.write(
        key: _kBiometric,
        value: enableBiometric ? 'true' : 'false',
      );
      return const AppLockResult.success(null);
    } catch (e) {
      return AppLockResult.failure('Could not enable app lock: $e');
    }
  }

  Future<bool> verifyPin(String pin) async {
    final salt = await _storage.read(key: _kPinSalt);
    final stored = await _storage.read(key: _kPinHash);
    if (salt == null || stored == null) return false;
    return _hashPin(pin, salt) == stored;
  }

  Future<bool> authenticateBiometric() async {
    if (!await isBiometricEnabled()) return false;
    try {
      final can = await _localAuth.canCheckBiometrics;
      final supported = await _localAuth.isDeviceSupported();
      if (!can && !supported) return false;

      return await _localAuth.authenticate(
        localizedReason: 'Unlock Cleaner App',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  Future<AppLockResult<void>> disable() async {
    try {
      await _storage.delete(key: _kEnabled);
      await _storage.delete(key: _kPinSalt);
      await _storage.delete(key: _kPinHash);
      await _storage.delete(key: _kBiometric);
      return const AppLockResult.success(null);
    } catch (e) {
      return AppLockResult.failure('Could not disable app lock: $e');
    }
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
