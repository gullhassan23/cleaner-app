import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cleaner_app/controllers/private_vault/vault_change_pin_controller.dart';
import 'package:cleaner_app/widgets/private_vault/vault_pin_scaffold.dart';

class VaultChangePinPage extends GetView<VaultChangePinController> {
  const VaultChangePinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Obx(() {
      final titles = [
        l10n.vaultEnterCurrentPin,
        l10n.vaultEnterNewPin,
        l10n.vaultConfirmNewPin,
      ];
      return VaultPinScaffold(
        title: titles[controller.step.value.clamp(0, 2)],
        subtitle: l10n.vaultPinMustBeFourDigits,
        filledCount: controller.buffer.value.length,
        onDigit: controller.onDigit,
        onDelete: controller.deleteDigit,
        error: controller.errorMessage.value,
      );
    });
  }
}
