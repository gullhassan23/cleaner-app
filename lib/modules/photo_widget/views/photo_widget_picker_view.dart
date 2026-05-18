import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../controllers/photo_widget_picker_controller.dart';

class PhotoWidgetPickerView extends StatefulWidget {
  const PhotoWidgetPickerView({super.key});

  @override
  State<PhotoWidgetPickerView> createState() => _PhotoWidgetPickerViewState();
}

class _PhotoWidgetPickerViewState extends State<PhotoWidgetPickerView> {
  @override
  void initState() {
    super.initState();
    Get.put(PhotoWidgetPickerController());
  }

  @override
  void dispose() {
    if (Get.isRegistered<PhotoWidgetPickerController>()) {
      Get.delete<PhotoWidgetPickerController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PhotoWidgetPickerController>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Import photos'),
        actions: [
          Obx(() {
            final n = controller.selectedIds.length;
            return TextButton(
              onPressed: n == 0 ? null : controller.confirm,
              child: Text(
                'Done ($n)',
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Select up to ${controller.maxSelection} photos.',
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
            ),
          ),
          Expanded(
            child: Obx(() {
              final list = controller.assets;
              final loading = controller.loading.value;
              final ended = controller.end.value;
              final selected = controller.selectedIds;

              return GridView.builder(
                controller: controller.scroll,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: list.length + (loading && !ended ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i >= list.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final asset = list[i];
                  final isSelected = selected.contains(asset.id);
                  return _PickerCell(
                    asset: asset,
                    isSelected: isSelected,
                    onTap: () => controller.toggle(asset),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _PickerCell extends StatelessWidget {
  const _PickerCell({
    required this.asset,
    required this.isSelected,
    required this.onTap,
  });

  final AssetEntity asset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder<Uint8List?>(
            future: asset.thumbnailDataWithSize(
              const ThumbnailSize(200, 200),
            ),
            builder: (context, snapshot) {
              final bytes = snapshot.data;
              if (bytes == null) {
                return ColoredBox(color: cs.surfaceContainerHighest);
              }
              return Image.memory(bytes, fit: BoxFit.cover);
            },
          ),
          if (isSelected)
            Container(
              color: cs.primary.withValues(alpha: 0.35),
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(6),
              child: Icon(Icons.check_circle, color: cs.onPrimary, size: 22),
            ),
        ],
      ),
    );
  }
}
