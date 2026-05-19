import 'dart:typed_data';

import 'package:cleaner_app/controllers/vault/vault_media_picker_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';



/// Multi-select recent photos and videos (newest first).
class VaultMediaPickerPage extends StatelessWidget {
  const VaultMediaPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _VaultMediaPickerHost();
  }
}

class _VaultMediaPickerHost extends StatefulWidget {
  const _VaultMediaPickerHost();

  @override
  State<_VaultMediaPickerHost> createState() => _VaultMediaPickerHostState();
}

class _VaultMediaPickerHostState extends State<_VaultMediaPickerHost> {
  @override
  void initState() {
    super.initState();
    Get.put(VaultMediaPickerController());
  }

  @override
  void dispose() {
    if (Get.isRegistered<VaultMediaPickerController>()) {
      Get.delete<VaultMediaPickerController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const _VaultMediaPickerView();
  }
}

class _VaultMediaPickerView extends GetView<VaultMediaPickerController> {
  const _VaultMediaPickerView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Import to vault'),
        actions: [
          Obx(() {
            final n = controller.selectedIds.length;
            return TextButton(
              onPressed: n == 0 ? null : controller.confirm,
              child: Text(
                'Import ($n)',
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
              'Tap items to select. Only selected items are imported.',
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
                    return Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: cs.primary,
                        ),
                      ),
                    );
                  }
                  final a = list[i];
                  final sel = selected.contains(a.id);
                  return GestureDetector(
                    onTap: () => controller.toggle(a),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _VaultPickerThumb(asset: a),
                        if (a.type == AssetType.video)
                          const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.play_circle_fill_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: sel ? cs.primary : Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                sel ? Icons.check_rounded : Icons.circle_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

class _VaultPickerThumb extends StatelessWidget {
  const _VaultPickerThumb({required this.asset});

  final AssetEntity asset;

  static const _size = ThumbnailSize.square(200);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(_size),
      builder: (context, snap) {
        if (snap.hasData && snap.data != null) {
          return Image.memory(snap.data!, fit: BoxFit.cover, gaplessPlayback: true);
        }
        return Container(color: Theme.of(context).colorScheme.surfaceContainerHighest);
      },
    );
  }
}
