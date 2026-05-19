import 'package:cleaner_app/controllers/cleaner/cleaner_group_sheet_controller.dart';
import 'package:cleaner_app/models/cleaner/cleaner_sheet_mode.dart';
import 'package:cleaner_app/utils/bytes_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cleaner_thumbnail.dart';

class CleanerGroupBottomSheet extends StatelessWidget {
  const CleanerGroupBottomSheet({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = Get.find<CleanerGroupSheetController>(tag: tag);
    final title =
        c.mode == CleanerSheetMode.duplicates
            ? 'Duplicate Photos'
            : 'Similar Photos';

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
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
                      c.selectionSummaryRx.value;
                      return CustomScrollView(
                        slivers: [
                          for (var gi = 0; gi < c.clusters.length; gi++) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                              child: Text(
                                'Group ${gi + 1}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 0.72,
                                  ),
                              delegate: SliverChildBuilderDelegate(
                                (context, mi) {
                                  final cluster = c.clusters[gi];
                                  final asset = cluster.members[mi];
                                  final isKeeper = asset.id == cluster.keeper.id;
                                  final selected = c.isSelected(asset.id);
                                  return GestureDetector(
                                    onTap: () => c.toggleSelection(asset.id),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        CleanerThumbnail(
                                          asset: asset,
                                          size: 120,
                                          borderRadius: 14,
                                          border: Border.all(
                                            color:
                                                isKeeper
                                                    ? theme.colorScheme.primary
                                                    : selected
                                                    ? theme.colorScheme.primary
                                                        .withValues(alpha: 0.35)
                                                    : theme
                                                        .colorScheme
                                                        .outlineVariant,
                                            width: isKeeper ? 2.6 : 1.4,
                                          ),
                                          overlay:
                                              isKeeper
                                                  ? Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(
                                                        6,
                                                      ),
                                                      child: DecoratedBox(
                                                        decoration: BoxDecoration(
                                                          color: theme
                                                              .colorScheme
                                                              .primary,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                                vertical: 4,
                                                              ),
                                                          child: Text(
                                                            'Best',
                                                            style: theme
                                                                .textTheme
                                                                .labelSmall
                                                                ?.copyWith(
                                                                  color: theme
                                                                      .colorScheme
                                                                      .onPrimary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  : null,
                                        ),
                                        if (!isKeeper)
                                          Positioned(
                                            top: 6,
                                            right: 6,
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 160,
                                              ),
                                              width: 26,
                                              height: 26,
                                              decoration: BoxDecoration(
                                                color:
                                                    selected
                                                        ? theme
                                                            .colorScheme
                                                            .primary
                                                        : Colors.white.withValues(
                                                          alpha: 0.92,
                                                        ),
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                                border: Border.all(
                                                  color:
                                                      selected
                                                          ? theme
                                                              .colorScheme
                                                              .primary
                                                          : theme
                                                              .colorScheme
                                                              .outlineVariant,
                                                ),
                                              ),
                                              child: Icon(
                                                selected
                                                    ? Icons.check
                                                    : Icons.circle_outlined,
                                                size: 16,
                                                color:
                                                    selected
                                                        ? theme
                                                            .colorScheme
                                                            .onPrimary
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
                                childCount: c.clusters[gi].members.length,
                              ),
                            ),
                          ),
                        ],
                          const SliverToBoxAdapter(child: SizedBox(height: 120)),
                        ],
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
                      final summary = c.selectionSummaryRx.value;
                      final busy = c.isDeleting.value;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${summary.selectedCount} selected · ${BytesFormatter.humanize(summary.selectedBytes)}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
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
