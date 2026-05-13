import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/cleaner/cleaner_dashboard_sort.dart';
import '../../utils/bytes_formatter.dart';
import '../../widgets/state_message_card.dart';
import '../../models/photo_library/scan_state_entity.dart';
import 'widgets/asset_thumbnail.dart';
import '../../controllers/compress_picker_controller.dart';

class CompressPickerPage extends GetView<CompressPickerController> {
  const CompressPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compress'),
        actions: [
          Obx(() {
            final session = controller.session.state.value;
            final perm = session.permissionState;
            final canSort =
                perm.canAccess &&
                !session.isLoadingInitial &&
                session.mediaItems.isNotEmpty;
            if (canSort) {
              return IconButton(
                onPressed: () => _openSortSheet(context),
                icon: const Icon(Icons.sort_rounded),
                tooltip: 'Sort',
              );
            }
            if (perm.canAccess) {
              return IconButton(
                onPressed: controller.refreshMedia,
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Refresh gallery',
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final session = controller.session.state.value;
        if (!session.hasSelection) {
          return const SizedBox.shrink();
        }

        return SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${session.selectedAssetIds.length} selected',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: controller.clearSelection,
                    child: const Text('Clear'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: controller.openReview,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      body: SafeArea(
        child: Obx(() {
          final session = controller.session.state.value;
          final permission = session.permissionState;

          if (permission.status == MediaPermissionStatus.loading &&
              session.mediaItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!permission.canAccess) {
            return _PermissionBody(controller: controller);
          }

          if (session.isLoadingInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (session.mediaItems.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                StateMessageCard(
                  icon: Icons.perm_media_outlined,
                  title: 'No media found',
                  message:
                      'Images and videos will appear here after gallery access is granted.',
                  primaryAction: FilledButton(
                    onPressed: controller.refreshMedia,
                    child: const Text('Reload'),
                  ),
                ),
              ],
            );
          }

          final displayItems = controller.sortedDisplayMedia;

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 400) {
                controller.loadMoreIfNeeded();
              }
              return false;
            },
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.refreshMedia();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _PickerSummaryCard(
                              totalCount: session.totalCount,
                              selectedCount: session.selectedAssetIds.length,
                              selectedBytes:
                                  controller.session.selectedOriginalBytes,
                              isLimited: permission.isLimited,
                              onManageAccess:
                                  permission.isLimited
                                      ? controller.manageLimitedLibrary
                                      : null,
                            ),
                          ),
                        ),
                        SliverGrid(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final asset = displayItems[index];
                            return AssetThumbnail(
                              asset: asset,
                              width: 420,
                              height: 420,
                              isSelected: controller.session.isSelected(asset.id),
                              onTap: () => controller.toggleSelection(asset.id),
                              onLongPress:
                                  () => controller.toggleSelection(asset.id),
                            );
                          }, childCount: displayItems.length),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child:
                                session.isLoadingMore
                                    ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(12),
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                    : const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> _openSortSheet(BuildContext context) async {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final selected = await showModalBottomSheet<CleanerDashboardSort>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final current = controller.pickerSort.value;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: const Text('Largest first'),
                trailing:
                    current == CleanerDashboardSort.largestFirst
                        ? Icon(Icons.check_rounded, color: primary)
                        : null,
                onTap:
                    () => Navigator.pop(ctx, CleanerDashboardSort.largestFirst),
              ),
              ListTile(
                title: const Text('Smallest first'),
                trailing:
                    current == CleanerDashboardSort.smallestFirst
                        ? Icon(Icons.check_rounded, color: primary)
                        : null,
                onTap:
                    () =>
                        Navigator.pop(ctx, CleanerDashboardSort.smallestFirst),
              ),
              ListTile(
                title: const Text('Newest date first'),
                trailing:
                    current == CleanerDashboardSort.newestDateFirst
                        ? Icon(Icons.check_rounded, color: primary)
                        : null,
                onTap:
                    () =>
                        Navigator.pop(ctx, CleanerDashboardSort.newestDateFirst),
              ),
              ListTile(
                title: const Text('Oldest date first'),
                trailing:
                    current == CleanerDashboardSort.oldestDateFirst
                        ? Icon(Icons.check_rounded, color: primary)
                        : null,
                onTap:
                    () =>
                        Navigator.pop(ctx, CleanerDashboardSort.oldestDateFirst),
              ),
            ],
          ),
        );
      },
    );
    if (selected != null) {
      controller.pickerSort.value = selected;
    }
  }
}

class _PermissionBody extends StatelessWidget {
  const _PermissionBody({required this.controller});

  final CompressPickerController controller;

  @override
  Widget build(BuildContext context) {
    final permission = controller.session.permissionState;
    final needsSettings = permission.needsSettings;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        StateMessageCard(
          icon:
              needsSettings
                  ? Icons.lock_outline_rounded
                  : Icons.photo_library_outlined,
          title: needsSettings ? 'Media access blocked' : 'Allow media access',
          message:
              needsSettings
                  ? 'Open system settings and enable gallery access to compress images and videos.'
                  : 'Cleaner needs access to your gallery before it can show photos and videos for compression.',
          primaryAction: FilledButton(
            onPressed: needsSettings ? controller.openSettings : controller.requestAccess,
            child: Text(needsSettings ? 'Open settings' : 'Allow access'),
          ),
          secondaryAction:
              needsSettings
                  ? OutlinedButton(
                    onPressed: controller.requestAccess,
                    child: const Text('Retry'),
                  )
                  : null,
        ),
      ],
    );
  }
}

class _PickerSummaryCard extends StatelessWidget {
  const _PickerSummaryCard({
    required this.totalCount,
    required this.selectedCount,
    required this.selectedBytes,
    required this.isLimited,
    this.onManageAccess,
  });

  final int totalCount;
  final int selectedCount;
  final int selectedBytes;
  final bool isLimited;
  final VoidCallback? onManageAccess;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Select media to compress', style: theme.textTheme.titleLarge),
                ),
                if (isLimited)
                  TextButton.icon(
                    onPressed: onManageAccess,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Manage access'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Pick one or more images/videos, then continue to quality selection and compression.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _MetricChip(label: 'Visible items', value: '$totalCount'),
                _MetricChip(label: 'Selected', value: '$selectedCount'),
                _MetricChip(
                  label: 'Selected size',
                  value: BytesFormatter.humanize(selectedBytes),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
