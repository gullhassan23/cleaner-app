import 'dart:async';

import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/app_lock/pin_numeric_pad.dart';
import '../../controllers/applock/app_lock_setup_controller.dart';
import '../../widgets/appLock/app_lock_pin_dots.dart';

class AppLockSetupView extends GetView<AppLockSetupController> {
  const AppLockSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appLockSetupTitle),
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
                      ? l10n.appLockCreatePin
                      : l10n.appLockConfirmPin,
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
                      ? l10n.appLockCreatePinHint
                      : l10n.appLockConfirmPinHint,
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
                        l10n.appLockEnableBiometric,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        l10n.appLockBiometricSubtitle,
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
              PinNumericPad(
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
                          step == 0 ? l10n.appLockContinue : l10n.appLockFinishSetup,
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
