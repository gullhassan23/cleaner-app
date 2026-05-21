import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/vault_gate_controller.dart';

class VaultGatePage extends GetView<VaultGateController> {
  const VaultGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Obx(() {
      if (controller.routeFailed.value) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.vaultCouldNotOpen,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: controller.retry,
                    child: Text(l10n.commonTryAgain),
                  ),
                  TextButton(
                    onPressed: Get.back,
                    child: Text(l10n.vaultGoBack),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    });
  }
}
