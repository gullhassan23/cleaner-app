import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cleaner_app/controllers/private_vault/vault_pin_setup_controller.dart';
import 'package:cleaner_app/widgets/private_vault/vault_pin_scaffold.dart';

class VaultPinSetupPage extends GetView<VaultPinSetupController> {
  const VaultPinSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Obx(
      () => VaultPinScaffold(
        title: controller.setupStep.value == 0
            ? l10n.vaultCreatePin
            : l10n.vaultConfirmPin,
        subtitle: controller.setupStep.value == 0
            ? l10n.vaultCreatePinSubtitle
            : l10n.vaultConfirmPinSubtitle,
        filledCount: controller.buffer.value.length,
        onDigit: controller.onDigit,
        onDelete: controller.deleteDigit,
        error: controller.errorMessage.value,
        trailing: controller.setupStep.value == 1
            ? SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.vaultEnableBiometric),
                value: controller.enableBiometric.value,
                onChanged: (v) => controller.enableBiometric.value = v,
              )
            : null,
      ),
    );
  }
}
