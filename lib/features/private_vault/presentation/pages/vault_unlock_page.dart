import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/vault_unlock_controller.dart';
import '../widgets/vault_pin_scaffold.dart';

class VaultUnlockPage extends GetView<VaultUnlockController> {
  const VaultUnlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.authState.value;
      final locked = state?.isLockedOut == true;
      return VaultPinScaffold(
        title: 'Enter Passcode to unlock',
        subtitle: locked
            ? 'Try again in ${controller.lockCountdown.value}s'
            : 'Enter your 4-digit vault PIN',
        filledCount: controller.buffer.value.length,
        onDigit: controller.onDigit,
        onDelete: controller.deleteDigit,
        error: controller.errorMessage.value,
        bottomLeft: state?.canUseBiometrics == true &&
                state?.isBiometricEnabled == true
            ? IconButton(
                icon: const Icon(Icons.fingerprint, size: 32),
                onPressed: locked ? null : controller.tryBiometric,
              )
            : null,
      );
    });
  }
}
