import 'dart:async';

import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/charging/charging_controller.dart';
import '../../models/charging/charging_animation_model.dart';
import '../../widgets/charging/battery_status_card.dart';
import '../../widgets/charging/charging_animation_host.dart';
import '../../widgets/charging/charging_backdrop.dart';

class ChargingPreviewView extends GetView<ChargingController> {
  const ChargingPreviewView({super.key});

  ChargingAnimationModel get _model {
    final args = Get.arguments;
    if (args is ChargingAnimationModel) {
      return args;
    }
    throw ArgumentError('ChargingPreviewView requires ChargingAnimationModel');
  }

  @override
  Widget build(BuildContext context) {
    final model = _model;
    final l10n = context.l10n;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.chargingAnimationTitleFor(model.id),
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
          onPressed: () => Get.back<void>(),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ChargingBackdrop(colors: model.previewColors),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ChargingAnimationHost(
                      config: controller.configFor(model),
                      isActive: true,
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
                    compact: true,
                  );
                }),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        unawaited(controller.applyFromPreview(model));
                      },
                      child: Text(l10n.chargingApplyAnimation),
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
