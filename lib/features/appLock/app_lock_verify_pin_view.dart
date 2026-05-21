import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/app_lock/pin_numeric_pad.dart';
import '../../controllers/applock/app_lock_verify_controller.dart';
import '../../widgets/appLock/app_lock_pin_dots.dart';

class AppLockVerifyPinView extends GetView<AppLockVerifyController> {
  const AppLockVerifyPinView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appLockTurnOffTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                l10n.appLockEnterPinToTurnOff,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.appLockVerifyPinToDisable,
                textAlign: TextAlign.center,
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
              ),
              const SizedBox(height: 28),
              Obx(
                () => AppLockPinDots(filledCount: controller.pinDigits.value.length),
              ),
              const SizedBox(height: 12),
              Obx(() {
                final msg = controller.errorMessage.value;
                if (msg == null) return const SizedBox(height: 20);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: cs.error,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }),
              const Spacer(),
              Obx(() {
                final busy = controller.busy.value;
                return IgnorePointer(
                  ignoring: busy,
                  child: PinNumericPad(
                    onDigit: controller.appendDigit,
                    onDelete: controller.backspace,
                  ),
                );
              }),
              Obx(() {
                if (!controller.busy.value) {
                  return const SizedBox(height: 24);
                }
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
