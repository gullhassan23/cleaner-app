import 'dart:async';

import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/charging/charging_controller.dart';
import '../../widgets/charging/charging_animation_host.dart';
import '../../widgets/charging/charging_backdrop.dart';

/// Immersive charging display (auto-show on plug or manual open).
class ChargingDisplayView extends GetView<ChargingController> {
  const ChargingDisplayView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canPopRoute = Get.key.currentState?.canPop() ?? false;
    return PopScope(
      canPop: canPopRoute,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          unawaited(controller.closeDisplay());
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Obx(() {
                final model = controller.selected.value;
                if (model == null) {
                  return const ChargingBackdrop();
                }
                return ChargingBackdrop(colors: model.previewColors);
              }),
              SafeArea(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () => unawaited(controller.closeDisplay()),
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Obx(() {
                        final config = controller.selectedConfig;
                        final snap = controller.snapshot.value;
                        if (config == null) {
                          return Center(
                            child: Text(
                              l10n.chargingNoAnimationSelected,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: ChargingAnimationHost(
                            config: config,
                            isActive: controller.isAnimationActive(snap),
                          ),
                        );
                      }),
                    ),
                    Obx(() {
                      final snap = controller.snapshot.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Text(
                          l10n.chargingBatteryPercent(snap.level),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1.5,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
