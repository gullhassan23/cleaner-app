import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/charging/charging_controller.dart';
import '../../widgets/charging/animation_tile_card.dart';

class ChargingSelectionView extends GetView<ChargingController> {
  const ChargingSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.chargingChooseAnimationAppBar),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          final items = controller.catalog;
          final selectedId = controller.selected.value?.id;
          return GridView.builder(
            physics: const BouncingScrollPhysics(),

            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final model = items[index];
              return AnimationTileCard(
                model: model,
                isSelected: model.id == selectedId,
                onTap: () => controller.openPreview(model),
              );
            },
          );
        }),
      ),
    );
  }
}
