import 'dart:async';

import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../services/applock/app_lock_service.dart';

/// Global app lock state: bootstrap, lock/unlock, settings toggle flows.
class AppLockController extends GetxController {
  AppLockController({AppLockService? service})
      : _service = service ?? Get.find<AppLockService>();

  final AppLockService _service;

  final isEnabled = false.obs;
  final isUnlocked = true.obs;
  final isLoading = true.obs;
  final isAuthenticating = false.obs;
  final wrongAttempts = 0.obs;
  final errorMessage = RxnString();
  final unlockPinDigits = ''.obs;
  final biometricAvailable = false.obs;

  static const _maxWrongAttempts = 5;

  bool get shouldShowLockOverlay =>
      isEnabled.value && !isUnlocked.value && !isLoading.value;

  @override
  void onInit() {
    super.onInit();
    unawaited(bootstrap());
  }

  Future<void> bootstrap() async {
    isLoading.value = true;
    try {
      final enabled = await _service.isEnabled();
      isEnabled.value = enabled;
      biometricAvailable.value = await _service.canUseBiometrics();
      if (enabled) {
        lock();
      } else {
        isUnlocked.value = true;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void lock() {
    unlockPinDigits.value = '';
    errorMessage.value = null;
    isUnlocked.value = false;
  }

  void appendUnlockDigit(String d) {
    if (unlockPinDigits.value.length >= 4) return;
    unlockPinDigits.value += d;
    if (unlockPinDigits.value.length == 4) {
      unawaited(_submitUnlockPin());
    }
  }

  void backspaceUnlock() {
    final s = unlockPinDigits.value;
    if (s.isEmpty) return;
    unlockPinDigits.value = s.substring(0, s.length - 1);
    errorMessage.value = null;
  }

  Future<void> _submitUnlockPin() async {
    final pin = unlockPinDigits.value;
    await unlockWithPin(pin);
  }

  Future<bool> unlockWithPin(String pin) async {
    final ok = await _service.verifyPin(pin);
    if (ok) {
      wrongAttempts.value = 0;
      errorMessage.value = null;
      unlockPinDigits.value = '';
      isUnlocked.value = true;
      return true;
    }
    wrongAttempts.value++;
    unlockPinDigits.value = '';
    if (wrongAttempts.value >= _maxWrongAttempts) {
      errorMessage.value = 'Too many attempts. Try again or use biometrics.';
    } else {
      errorMessage.value = 'Incorrect PIN. Try again.';
    }
    return false;
  }

  Future<void> unlockWithBiometric() async {
    if (isAuthenticating.value) return;
    isAuthenticating.value = true;
    try {
      final ok = await _service.authenticateBiometric();
      if (ok) {
        wrongAttempts.value = 0;
        errorMessage.value = null;
        unlockPinDigits.value = '';
        isUnlocked.value = true;
      }
    } finally {
      isAuthenticating.value = false;
    }
  }

  Future<bool> requestDisable(String pin) async {
    final ok = await _service.verifyPin(pin);
    if (!ok) return false;

    final result = await _service.disable();
    if (!result.isSuccess) {
      Get.snackbar('App Lock', result.errorMessage ?? 'Could not disable');
      return false;
    }
    isEnabled.value = false;
    isUnlocked.value = true;
    wrongAttempts.value = 0;
    errorMessage.value = null;
    unlockPinDigits.value = '';
    return true;
  }

  Future<void> onSetupCompleted() async {
    isEnabled.value = true;
    isUnlocked.value = true;
    wrongAttempts.value = 0;
    errorMessage.value = null;
    biometricAvailable.value = await _service.canUseBiometrics();
  }

  Future<void> onToggleRequested(bool value) async {
    if (isLoading.value) return;

    if (value) {
      await Get.toNamed(AppRoutes.appLockSetup);
    } else {
      if (!isEnabled.value) return;
      final result = await Get.toNamed(AppRoutes.appLockVerifyDisable);
      if (result != true) return;
    }
  }

  Future<bool> isBiometricEnabled() => _service.isBiometricEnabled();
}
