import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/vault_change_pin_controller.dart';
import '../widgets/vault_pin_scaffold.dart';

class VaultChangePinPage extends GetView<VaultChangePinController> {
  const VaultChangePinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final titles = ['Enter current PIN', 'Enter new PIN', 'Confirm new PIN'];
      return VaultPinScaffold(
        title: titles[controller.step.value.clamp(0, 2)],
        subtitle: 'Vault PIN must be 4 digits',
        filledCount: controller.buffer.value.length,
        onDigit: controller.onDigit,
        onDelete: controller.deleteDigit,
        error: controller.errorMessage.value,
      );
    });
  }
}
