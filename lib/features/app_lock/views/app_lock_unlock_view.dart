import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../widgets/vault/vault_numeric_pad.dart';
import '../controllers/app_lock_controller.dart';
import '../widgets/app_lock_pin_dots.dart';

class AppLockUnlockView extends StatefulWidget {
  const AppLockUnlockView({super.key});

  @override
  State<AppLockUnlockView> createState() => _AppLockUnlockViewState();
}

class _AppLockUnlockViewState extends State<AppLockUnlockView> {
  var _bioPrompted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybePromptBiometric());
  }

  Future<void> _maybePromptBiometric() async {
    if (_bioPrompted) return;
    final c = Get.find<AppLockController>();
    if (!c.isEnabled.value || c.isUnlocked.value) return;
    final bioOn = await c.isBiometricEnabled();
    if (!bioOn || !mounted) return;
    _bioPrompted = true;
    await c.unlockWithBiometric();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AppLockController>();
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Icon(Icons.lock_rounded, size: 52, color: cs.primary),
              const SizedBox(height: 16),
              Text(
                'App locked',
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your PIN or use biometrics.',
                textAlign: TextAlign.center,
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
              ),
              const SizedBox(height: 28),
              Obx(() {
                final child = AppLockPinDots(
                  filledCount: c.unlockPinDigits.value.length,
                );
                if (c.errorMessage.value == null) return child;
                return child
                    .animate(key: ValueKey(c.wrongAttempts.value))
                    .shake(duration: 400.ms, hz: 4, curve: Curves.easeOut);
              }),
              const SizedBox(height: 12),
              Obx(() {
                final msg = c.errorMessage.value;
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
              FutureBuilder<bool>(
                future: c.isBiometricEnabled(),
                builder: (context, snap) {
                  final showBio = snap.data == true;
                  return VaultNumericPad(
                    onDigit: c.appendUnlockDigit,
                    onDelete: c.backspaceUnlock,
                    bottomLeft: showBio
                        ? Material(
                            color: cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () => unawaited(c.unlockWithBiometric()),
                              child: Center(
                                child: Icon(
                                  Icons.fingerprint_rounded,
                                  color: cs.primary,
                                  size: 36,
                                ),
                              ),
                            ),
                          )
                        : null,
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
