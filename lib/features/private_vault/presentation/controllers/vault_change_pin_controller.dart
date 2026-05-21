import 'package:get/get.dart';

import '../../domain/usecases/vault_auth_usecases.dart';
import '../../data/datasources/vault_auth_service.dart';

class VaultChangePinController extends GetxController {
  final ChangeVaultPin _change = ChangeVaultPin(Get.find<VaultAuthService>());

  final step = 0.obs;
  final buffer = ''.obs;
  final isBusy = false.obs;
  final errorMessage = RxnString();

  String? _oldPin;
  String? _newPin;

  void onDigit(String d) {
    if (isBusy.value || buffer.value.length >= 4) return;
    errorMessage.value = null;
    buffer.value += d;
    if (buffer.value.length == 4) {
      Future<void>.delayed(const Duration(milliseconds: 120), _advance);
    }
  }

  void deleteDigit() {
    if (isBusy.value || buffer.value.isEmpty) return;
    buffer.value = buffer.value.substring(0, buffer.value.length - 1);
  }

  Future<void> _advance() async {
    final pin = buffer.value;
    buffer.value = '';

    if (step.value == 0) {
      final ok = await Get.find<VaultAuthService>().verifyPin(pin);
      if (!ok) {
        errorMessage.value = 'Current PIN is incorrect';
        return;
      }
      _oldPin = pin;
      step.value = 1;
      return;
    }

    if (step.value == 1) {
      _newPin = pin;
      step.value = 2;
      return;
    }

    if (pin != _newPin) {
      errorMessage.value = 'PINs do not match';
      step.value = 1;
      _newPin = null;
      return;
    }

    isBusy.value = true;
    try {
      final result = await _change(oldPin: _oldPin!, newPin: pin);
      if (!result.isSuccess) {
        errorMessage.value = result.error;
        return;
      }
      Get.back();
      Get.snackbar('Vault', 'PIN changed successfully');
    } finally {
      isBusy.value = false;
    }
  }
}
