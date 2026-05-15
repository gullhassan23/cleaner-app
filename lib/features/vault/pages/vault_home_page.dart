import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repositories/vault_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../controllers/vault_controller.dart';
import '../../../models/vault/vault_media_model.dart';
import 'vault_media_preview_page.dart';

class VaultHomePage extends GetView<VaultController> {
  const VaultHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Lock',
                    onPressed: controller.lockVault,
                    icon: Icon(Icons.lock_open, color: cs.onSurface),
                  ),
                  const Spacer(),
                  Obx(
                    () =>
                        controller.selectionMode.value
                            ? TextButton(
                              onPressed: controller.toggleSelectionMode,
                              child: const Text('Cancel'),
                            )
                            : IconButton(
                              tooltip: 'Select',
                              onPressed: controller.toggleSelectionMode,
                              icon: Icon(
                                Icons.checklist_rounded,
                                color: cs.onSurface,
                              ),
                            ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (!controller.isLimitedLibrary.value) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Material(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Limited library access',
                            style: TextStyle(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'iOS may only show photos you selected. Use Manage to add more, '
                            'or open Settings for full access.',
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              TextButton(
                                onPressed:
                                    controller.presentManageLibraryAccess,
                                child: const Text('Manage library'),
                              ),
                              TextButton(
                                onPressed: controller.openSystemPhotoSettings,
                                child: const Text('Open settings'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            Expanded(
              child: Obx(() {
                final items = controller.mediaItems;
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            size: 64,
                            color: cs.onSurfaceVariant.withValues(alpha: 0.45),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No media in your vault yet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: cs.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Import photos and videos from your library. '
                            'They are stored only on this device in private app storage.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: controller.importFromPicker,
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Add media'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    return _VaultThumbTile(model: items[i]);
                  },
                );
              }),
            ),
          ],
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 24,
          child: Obx(() {
            if (controller.selectionMode.value &&
                controller.selectedIds.isNotEmpty) {
              return FilledButton(
                onPressed: () async {
                  final ok = await Get.dialog<bool>(
                    AlertDialog(
                      title: const Text('Delete from vault?'),
                      content: Text(
                        'Delete ${controller.selectedIds.length} item(s)? '
                        'This cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (ok == true) {
                    await controller.deleteSelected();
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: cs.error,
                  foregroundColor: cs.onError,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Obx(
                  () => Text(
                    'Delete (${controller.selectedIds.length})',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              );
            }
            if (!controller.selectionMode.value) {
              return FilledButton.icon(
                onPressed: controller.importFromPicker,
                icon: const Icon(Icons.add_photo_alternate_rounded),
                label: const Text('Add media'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ),
        Obx(() {
          if (!controller.isImporting.value) return const SizedBox.shrink();
          return ColoredBox(
            color: Colors.black54,
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: cs.primary),
                      const SizedBox(height: 16),
                      Obx(
                        () => Text(
                          'Importing ${controller.importDone.value}/${controller.importTotal.value}',
                          style: TextStyle(color: cs.onSurface),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _VaultThumbTile extends StatefulWidget {
  const _VaultThumbTile({required this.model});

  final VaultMediaModel model;

  @override
  State<_VaultThumbTile> createState() => _VaultThumbTileState();
}

class _VaultThumbTileState extends State<_VaultThumbTile> {
  late final Future<File?> _fileFuture;

  @override
  void initState() {
    super.initState();
    _fileFuture = Get.find<VaultRepository>().fileFor(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    final vault = Get.find<VaultController>();
    final repo = Get.find<VaultRepository>();
    final cs = Theme.of(context).colorScheme;
    return Obx(() {
      final selMode = vault.selectionMode.value;
      final selected = vault.selectedIds.contains(widget.model.id);
      return GestureDetector(
        onTap: () async {
          if (selMode) {
            vault.toggleSelect(widget.model.id);
            return;
          }
          final file = await repo.fileFor(widget.model);
          if (file == null) {
            Get.snackbar('Vault', 'File missing');
            return;
          }
          if (!context.mounted) return;
          await Get.toNamed<void>(
            AppRoutes.vaultMediaPreview,
            arguments: VaultMediaPreviewArgs(model: widget.model, file: file),
          );
          await vault.refreshMedia();
        },
        onLongPress: () {
          if (!vault.selectionMode.value) {
            vault.toggleSelectionMode();
          }
          vault.toggleSelect(widget.model.id);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (widget.model.isVideo)
                ColoredBox(
                  color: cs.surfaceContainerHighest,
                  child: Icon(
                    Icons.videocam_rounded,
                    color: cs.onSurfaceVariant,
                    size: 40,
                  ),
                )
              else
                FutureBuilder<File?>(
                  future: _fileFuture,
                  builder: (context, snap) {
                    final f = snap.data;
                    if (f != null) {
                      return Image.file(
                        f,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      );
                    }
                    return ColoredBox(
                      color: cs.surfaceContainerHighest,
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              if (widget.model.isVideo)
                Align(
                  child: Icon(
                    Icons.play_circle_fill_rounded,
                    color: cs.onSurface,
                    size: 36,
                  ),
                ),
              if (selMode)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      selected ? Icons.check_circle : Icons.circle_outlined,
                      color: selected ? cs.primary : cs.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
