import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/vault/vault_numeric_pad.dart';
import '../../controllers/applock/app_lock_setup_controller.dart';
import '../../widgets/appLock/app_lock_pin_dots.dart';

class AppLockSetupView extends GetView<AppLockSetupController> {
  const AppLockSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set up App Lock'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Obx(
                () => Text(
                  controller.setupStep.value == 0
                      ? 'Create a 4-digit PIN'
                      : 'Confirm your PIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Text(
                  controller.setupStep.value == 0
                      ? 'You will use this PIN to unlock the app.'
                      : 'Enter the same PIN again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                ),
              ),
              const SizedBox(height: 28),
              Obx(
                () => AppLockPinDots(filledCount: controller.buffer.length),
              ),
              const SizedBox(height: 28),
              Obx(() {
                if (controller.setupStep.value != 1) {
                  return const SizedBox.shrink();
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Enable Face ID / fingerprint',
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Unlock the app without typing your PIN.',
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                      value: controller.bioEnabled.value,
                      onChanged: controller.setBio,
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              }),
              const Spacer(),
              VaultNumericPad(
                onDigit: controller.appendDigit,
                onDelete: controller.backspace,
              ),
              const SizedBox(height: 16),
              Obx(() {
                final busy = controller.setupBusy.value;
                final bufLen = controller.buffer.length;
                final step = controller.setupStep.value;
                return FilledButton(
                  onPressed: busy || bufLen != 4
                      ? null
                      : () {
                          if (step == 0) {
                            controller.goToConfirmStep();
                          } else {
                            unawaited(controller.finishSetup());
                          }
                        },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: busy
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          step == 0 ? 'Continue' : 'Finish setup',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
