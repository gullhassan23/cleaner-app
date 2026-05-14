import 'dart:async';

import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import 'vault_controller.dart';

class VaultSetupPinController extends GetxController {
  final setupStep = 0.obs;
  final firstPin = ''.obs;
  final secondPin = ''.obs;
  final bioEnabled = true.obs;
  final setupBusy = false.obs;

  VaultController get _vault => Get.find<VaultController>();

  String get buffer => setupStep.value == 0 ? firstPin.value : secondPin.value;

  @override
  void onInit() {
    super.onInit();
    unawaited(_checkBioDefault());
  }

  Future<void> _checkBioDefault() async {
    final la = LocalAuthentication();
    final supported = await la.isDeviceSupported();
    final can = await la.canCheckBiometrics;
    bioEnabled.value = supported && can;
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
    if (buffer.length != 4) return;
    if (setupStep.value == 0) {
      setupStep.value = 1;
    }
  }

  Future<void> finishSetup() async {
    if (setupStep.value != 1 || buffer.length != 4) return;
    if (firstPin.value != secondPin.value) {
      Get.snackbar('Vault', 'PINs do not match. Start again.');
      setupStep.value = 0;
      firstPin.value = '';
      secondPin.value = '';
      return;
    }
    setupBusy.value = true;
    final res = await _vault.completeSetup(
      pin: firstPin.value,
      enableBiometric: bioEnabled.value,
    );
    setupBusy.value = false;
    if (!res.isSuccess) {
      Get.snackbar('Vault', res.errorMessage ?? 'Setup failed');
    }
  }

  void setBio(bool v) => bioEnabled.value = v;
}
