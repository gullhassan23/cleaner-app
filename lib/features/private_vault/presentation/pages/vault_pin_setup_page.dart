import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/vault_pin_setup_controller.dart';
import '../widgets/vault_pin_scaffold.dart';

class VaultPinSetupPage extends GetView<VaultPinSetupController> {
  const VaultPinSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VaultPinScaffold(
        title: controller.setupStep.value == 0
            ? 'Create Vault PIN'
            : 'Confirm Vault PIN',
        subtitle: controller.setupStep.value == 0
            ? 'Choose a 4-digit PIN to protect your private photos'
            : 'Enter the same PIN again',
        filledCount: controller.buffer.value.length,
        onDigit: controller.onDigit,
        onDelete: controller.deleteDigit,
        error: controller.errorMessage.value,
        trailing: controller.setupStep.value == 1
            ? SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Enable Face ID / fingerprint'),
                value: controller.enableBiometric.value,
                onChanged: (v) => controller.enableBiometric.value = v,
              )
            : null,
      ),
    );
  }
}
