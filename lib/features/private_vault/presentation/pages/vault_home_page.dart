import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../controllers/vault_home_controller.dart';
import '../widgets/vault_empty_state.dart';
import '../widgets/vault_media_tile.dart';

class VaultHomePage extends GetView<VaultHomeController> {
  const VaultHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(controller: controller),
              if (controller.isImporting.value)
                LinearProgressIndicator(value: controller.importProgress.value),
              Expanded(
                child: controller.items.isEmpty
                    ? const VaultEmptyState()
                    : _MediaGrid(controller: controller),
              ),
              _BottomBar(controller: controller),
            ],
          );
        }),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});
  final VaultHomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Private Photos',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    '${controller.photoCount.value} Photos, ${controller.videoCount.value} Videos',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.lock_outline),
            onPressed: () => Get.toNamed(
              AppRoutes.privateVaultSettings,
              id: AppRoutes.vaultNestedNavigatorId,
            ),
          ),
          Obx(
            () => controller.items.isNotEmpty
                ? TextButton(
                    onPressed: () {
                      if (!controller.selectionMode.value) {
                        controller.toggleSelectionMode();
                        controller.selectAll();
                      } else if (controller.selectedIds.length ==
                          controller.items.length) {
                        controller.toggleSelectionMode();
                      } else {
                        controller.selectAll();
                      }
                    },
                    child: Text(
                      controller.selectionMode.value ? 'Cancel' : 'Select All',
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _MediaGrid extends StatefulWidget {
  const _MediaGrid({required this.controller});
  final VaultHomeController controller;

  @override
  State<_MediaGrid> createState() => _MediaGridState();
}

class _MediaGridState extends State<_MediaGrid> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 400) {
      widget.controller.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return Obx(() {
      return GridView.builder(
        controller: _scroll,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: c.items.length,
        itemBuilder: (context, index) {
          final media = c.items[index];
          return VaultMediaTile(
            media: media,
            selectionMode: c.selectionMode.value,
            selected: c.selectedIds.contains(media.id),
            onTap: () => c.openPreview(index),
            onToggleSelect: () => c.toggleSelect(media.id),
          );
        },
      );
    });
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.controller});
  final VaultHomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.selectionMode.value && controller.selectedIds.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: controller.deleteSelected,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size.fromHeight(52),
            ),
            child: const Text('Delete Selected'),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: controller.isImporting.value
              ? null
              : controller.showImportSheet,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF007AFF),
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            'Add Photos',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ),
      );
    });
  }
}
