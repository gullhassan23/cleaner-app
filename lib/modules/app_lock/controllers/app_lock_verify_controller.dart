import 'dart:async';

import 'package:get/get.dart';

import 'app_lock_controller.dart';

class AppLockVerifyController extends GetxController {
  final pinDigits = ''.obs;
  final busy = false.obs;
  final errorMessage = RxnString();

  AppLockController get _appLock => Get.find<AppLockController>();

  void appendDigit(String d) {
    if (pinDigits.value.length >= 4 || busy.value) return;
    pinDigits.value += d;
    if (pinDigits.value.length == 4) {
      unawaited(_submit());
    }
  }

  void backspace() {
    if (busy.value) return;
    final s = pinDigits.value;
    if (s.isEmpty) return;
    pinDigits.value = s.substring(0, s.length - 1);
    errorMessage.value = null;
  }

  Future<void> _submit() async {
    busy.value = true;
    try {
      final ok = await _appLock.requestDisable(pinDigits.value);
      if (ok) {
        Get.back(result: true);
      } else {
        pinDigits.value = '';
        errorMessage.value = 'Incorrect PIN. Try again.';
      }
    } finally {
      busy.value = false;
    }
  }
}
