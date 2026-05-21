import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/app_lock/pin_numeric_pad.dart';
import '../../../../widgets/appLock/app_lock_pin_dots.dart';

class VaultPinScaffold extends StatelessWidget {
  const VaultPinScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.filledCount,
    required this.onDigit,
    required this.onDelete,
    this.error,
    this.bottomLeft,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final int filledCount;
  final void Function(String) onDigit;
  final VoidCallback onDelete;
  final String? error;
  final Widget? bottomLeft;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.shield_outlined,
                size: 180,
                color: cs.primary.withValues(alpha: 0.08),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 32),
                  AppLockPinDots(filledCount: filledCount),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      error!,
                      style: TextStyle(color: cs.error, fontSize: 13),
                    ),
                  ],
                  if (trailing != null) ...[
                    const SizedBox(height: 16),
                    trailing!,
                  ],
                  const Spacer(),
                  PinNumericPad(
                    onDigit: onDigit,
                    onDelete: onDelete,
                    bottomLeft: bottomLeft,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
