import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/vault/vault_setup_pin_controller.dart';
import '../../widgets/vault/vault_numeric_pad.dart';

class VaultSetupPinPage extends GetView<VaultSetupPinController> {
  const VaultSetupPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
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
                    ? 'You will use this PIN to unlock the vault.'
                    : 'Enter the same PIN again.',
                textAlign: TextAlign.center,
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
              ),
            ),
            const SizedBox(height: 28),
            Obx(() {
              final len = controller.buffer.length;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final filled = i < len;
                  return Container(
                    width: 14,
                    height: 14,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? cs.primary : cs.outline.withValues(alpha: 0.45),
                    ),
                  );
                }),
              );
            }),
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
                      style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Unlock the vault without typing your PIN.',
                      style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
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
                onPressed:
                    busy || bufLen != 4
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
                child:
                    busy
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
    );
  }
}
