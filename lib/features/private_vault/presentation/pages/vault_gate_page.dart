import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/vault_gate_controller.dart';

class VaultGatePage extends GetView<VaultGateController> {
  const VaultGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.routeFailed.value) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Could not open Private Photos',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: controller.retry,
                    child: const Text('Try again'),
                  ),
                  TextButton(
                    onPressed: Get.back,
                    child: const Text('Go back'),
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
