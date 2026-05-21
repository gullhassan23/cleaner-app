import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/vault_unlock_controller.dart';
import '../widgets/vault_pin_scaffold.dart';

class VaultUnlockPage extends GetView<VaultUnlockController> {
  const VaultUnlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Obx(() {
      final state = controller.authState.value;
      final locked = state?.isLockedOut == true;
      return VaultPinScaffold(
        title: l10n.vaultUnlockTitle,
        subtitle: locked
            ? l10n.vaultUnlockLocked(controller.lockCountdown.value)
            : l10n.vaultUnlockSubtitle,
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
