import 'dart:async';
import 'dart:io';

import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/charging/charging_controller.dart';
import '../../widgets/charging/battery_status_card.dart';
import '../../widgets/charging/charging_animation_host.dart';
import '../../widgets/charging/charging_backdrop.dart';

class ChargingHomeView extends GetView<ChargingController> {
  const ChargingHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Get.back<void>(),
        ),
        title: Text(
          l10n.chargingAnimationTitle,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ChargingBackdrop(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Obx(() {
                          final config = controller.selectedConfig;
                          final snap = controller.snapshot.value;
                          if (config == null) {
                            return _EmptySelectionHint();
                          }
                          return ChargingAnimationHost(
                            config: config,
                            isActive: controller.isAnimationActive(snap),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  final snap = controller.snapshot.value;
                  return BatteryStatusCard(
                    snapshot: snap,
                    headline: controller.headlineFor(snap.state),
                    subtitle: controller.subtitleFor(snap),
                    lightText: true,
                  );
                }),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Obx(() {
                    final snap = controller.snapshot.value;
                    if (!snap.isPlugged) {
                      return const SizedBox.shrink();
                    }
                    return FilledButton.icon(
                      onPressed: controller.openDisplay,
                      icon: const Icon(Icons.play_circle_outline_rounded),
                      label: Text(l10n.chargingViewAnimation),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: OutlinedButton.icon(
                    onPressed: controller.openSelection,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                    ),
                    icon: const Icon(Icons.grid_view_rounded),
                    label: Text(l10n.chargingBrowseAnimations),
                  ),
                ),
                if (Platform.isAndroid) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: _LockScreenSetupCard(controller: controller),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: FilledButton.tonal(
                      onPressed: () {
                        unawaited(controller.openBatteryOptimizationSettings());
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(l10n.chargingAllowLockScreenOnCharge),
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Text(
                    controller.platformNote(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: Colors.white.withValues(alpha: 0.72),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LockScreenSetupCard extends StatelessWidget {
  const _LockScreenSetupCard({required this.controller});

  final ChargingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = controller.lockScreenSetupSteps();
    return Material(
      color: Colors.black.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.chargingLockScreenSetup,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            for (var i = 0; i < steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${i + 1}.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        steps[i],
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.78),
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptySelectionHint extends StatelessWidget {
  const _EmptySelectionHint();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.battery_charging_full_rounded,
            size: 64,
            color: Colors.white.withValues(alpha: 0.5),
          ),

          Text(
            l10n.chargingChooseAnimation,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
