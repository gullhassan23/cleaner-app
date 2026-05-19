import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/repositories/vault_repository.dart';
import '../../controllers/vault/vault_controller.dart';
import '../../widgets/vault/vault_numeric_pad.dart';

class VaultUnlockPage extends StatefulWidget {
  const VaultUnlockPage({super.key});

  @override
  State<VaultUnlockPage> createState() => _VaultUnlockPageState();
}

class _VaultUnlockPageState extends State<VaultUnlockPage> {
  late final Future<bool> _bioFuture;

  @override
  void initState() {
    super.initState();
    _bioFuture = Get.find<VaultRepository>().isBiometricEnabled();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<VaultController>();
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Icon(Icons.lock_rounded, size: 52, color: cs.primary),
            const SizedBox(height: 16),
            Text(
              'Private vault',
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
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final filled = i < c.unlockPinDigits.value.length;
                  return Container(
                    width: 14,
                    height: 14,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          filled
                              ? cs.primary
                              : cs.outline.withValues(alpha: 0.45),
                    ),
                  );
                }),
              ),
            ),
            const Spacer(),
            FutureBuilder<bool>(
              future: _bioFuture,
              builder: (context, snap) {
                final showBio = snap.data == true;
                return VaultNumericPad(
                  onDigit: c.appendUnlockDigit,
                  onDelete: c.backspaceUnlock,
                  bottomLeft:
                      showBio
                          ? Material(
                            color: cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: c.submitBiometricUnlock,
                              child: Center(
                                child: Icon(
                                  Icons.fingerprint_rounded,
                                  color: cs.primary,
                                  size: 30,
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
    );
  }
}
