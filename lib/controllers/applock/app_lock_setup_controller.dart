import 'dart:async';

import 'package:cleaner_app/l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../services/applock/app_lock_service.dart';
import 'app_lock_controller.dart';

class AppLockSetupController extends GetxController {
  final setupStep = 0.obs;
  final firstPin = ''.obs;
  final secondPin = ''.obs;
  final bioEnabled = true.obs;
  final setupBusy = false.obs;

  AppLockService get _service => Get.find<AppLockService>();

  String get buffer => setupStep.value == 0 ? firstPin.value : secondPin.value;

  @override
  void onInit() {
    super.onInit();
    unawaited(_checkBioDefault());
  }

  Future<void> _checkBioDefault() async {
    bioEnabled.value = await _service.canUseBiometrics();
  }

  void appendDigit(String d) {
    if (buffer.length >= 4) return;
    if (setupStep.value == 0) {
      firstPin.value += d;
    } else {
      secondPin.value += d;
    }
  }

  void backspace() {
    if (setupStep.value == 0) {
      final s = firstPin.value;
      if (s.isEmpty) return;
      firstPin.value = s.substring(0, s.length - 1);
    } else {
      final s = secondPin.value;
      if (s.isEmpty) return;
      secondPin.value = s.substring(0, s.length - 1);
    }
  }

  void goToConfirmStep() {
    if (buffer.length != 4 || setupStep.value != 0) return;
    setupStep.value = 1;
  }

  Future<void> finishSetup() async {
    if (setupStep.value != 1 || buffer.length != 4) return;
    if (firstPin.value != secondPin.value) {
      final l10n = AppLocalizations.of(Get.context!);
      Get.snackbar(l10n.appLockSnackbarTitle, l10n.appLockPinsDoNotMatch);
      setupStep.value = 0;
      firstPin.value = '';
      secondPin.value = '';
      return;
    }

    setupBusy.value = true;
    try {
      final useBio = bioEnabled.value && await _service.canUseBiometrics();
      final res = await _service.enable(
        pin: firstPin.value,
        enableBiometric: useBio,
      );
      if (!res.isSuccess) {
        final l10n = AppLocalizations.of(Get.context!);
        Get.snackbar(
          l10n.appLockSnackbarTitle,
          res.errorMessage ?? l10n.appLockSetupFailed,
        );
        return;
      }
      await Get.find<AppLockController>().onSetupCompleted();
      Get.back(result: true);
    } finally {
      setupBusy.value = false;
    }
  }

  void setBio(bool v) => bioEnabled.value = v;
}
