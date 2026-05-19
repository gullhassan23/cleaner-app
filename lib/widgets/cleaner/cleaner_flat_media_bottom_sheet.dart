import 'package:cleaner_app/models/cleaner/cleaner_selection_summary.dart';
import 'package:cleaner_app/models/photo_library/photo_asset_entity.dart';
import 'package:cleaner_app/services/repositories/photo_library_repository.dart';
import 'package:cleaner_app/utils/bytes_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cleaner_thumbnail.dart';

class _FlatMediaSheetController extends GetxController {
  _FlatMediaSheetController({
    required this.assets,
    required this.onDeleted,
  });

  final List<PhotoAssetEntity> assets;
  final void Function(Set<String> ids) onDeleted;

  final PhotoLibraryRepository _repository = Get.find<PhotoLibraryRepository>();

  final RxMap<String, bool> selected = <String, bool>{}.obs;
  final Rx<CleanerSelectionSummary> summaryRx = CleanerSelectionSummary.empty.obs;
  final RxBool isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    for (final a in assets) {
      selected[a.id] = false;
    }
    _refresh();
  }

  void _refresh() {
    var count = 0;
    var bytes = 0;
    for (final a in assets) {
      if (selected[a.id] == true) {
        count++;
        bytes += a.fileSize;
      }
    }
    summaryRx.value = CleanerSelectionSummary(
      selectedCount: count,
      selectedBytes: bytes,
    );
  }

  void toggle(String id) {
    selected[id] = !(selected[id] ?? false);
    selected.refresh();
    _refresh();
  }

  bool isOn(String id) => selected[id] ?? false;

  Future<void> deleteSelected() async {
    final ids = assets
        .where((a) => selected[a.id] == true)
        .map((a) => a.id)
        .toSet();
    if (ids.isEmpty) {
      return;
    }
    final toDelete = assets.where((a) => ids.contains(a.id)).toList();
    isDeleting.value = true;
    try {
      final result = await _repository.deleteAssets(toDelete);
      final confirmed = ids.difference(result.failedIds.toSet());
      if (result.deletedCount > 0) {
        onDeleted(confirmed);
        Get.back<void>();
        Get.snackbar(
          'Deleted',
          '${result.deletedCount} item(s) · ${BytesFormatter.humanize(result.reclaimedBytes)} freed',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Nothing deleted',
          'Try again or check photo permissions.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isDeleting.value = false;
    }
  }
}

class CleanerFlatMediaBottomSheet extends StatelessWidget {
  const CleanerFlatMediaBottomSheet({
    super.key,
    required this.tag,
    required this.title,
  });

  final String tag;
  final String title;

  static void show({
    required String title,
    required List<PhotoAssetEntity> assets,
    required void Function(Set<String> ids) onDeleted,
  }) {
    final tag = 'cleaner_flat_${DateTime.now().microsecondsSinceEpoch}';
    Get.put(
      _FlatMediaSheetController(assets: assets, onDeleted: onDeleted),
      tag: tag,
    );
    Get.bottomSheet<void>(
      CleanerFlatMediaBottomSheet(tag: tag, title: title),
      isScrollControlled: true,
      enableDrag: true,
    ).whenComplete(() {
      if (Get.isRegistered<_FlatMediaSheetController>(tag: tag)) {
        Get.delete<_FlatMediaSheetController>(tag: tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = Get.find<_FlatMediaSheetController>(tag: tag);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: Get.back<void>,
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      c.summaryRx.value;
                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.72,
                            ),
                        itemCount: c.assets.length,
                        itemBuilder: (context, i) {
                          final asset = c.assets[i];
                          final on = c.isOn(asset.id);
                          return GestureDetector(
                            onTap: () => c.toggle(asset.id),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CleanerThumbnail(
                                  asset: asset,
                                  size: 120,
                                  borderRadius: 14,
                                  border: Border.all(
                                    color:
                                        on
                                            ? theme.colorScheme.primary
                                            : theme
                                                .colorScheme
                                                .outlineVariant,
                                    width: on ? 2.2 : 1.2,
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 160),
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color:
                                          on
                                              ? theme.colorScheme.primary
                                              : Colors.white.withValues(
                                                alpha: 0.92,
                                              ),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color:
                                            on
                                                ? theme.colorScheme.primary
                                                : theme
                                                    .colorScheme
                                                    .outlineVariant,
                                      ),
                                    ),
                                    child: Icon(
                                      on ? Icons.check : Icons.circle_outlined,
                                      size: 16,
                                      color:
                                          on
                                              ? theme.colorScheme.onPrimary
                                              : theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
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
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Obx(() {
                      final summary = c.summaryRx.value;
                      final busy = c.isDeleting.value;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '${summary.selectedCount} selected · ${BytesFormatter.humanize(summary.selectedBytes)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 52,
                            child: FilledButton(
                              onPressed:
                                  busy || summary.selectedCount == 0
                                      ? null
                                      : c.deleteSelected,
                              child:
                                  busy
                                      ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.4,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Text('Delete selected'),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
