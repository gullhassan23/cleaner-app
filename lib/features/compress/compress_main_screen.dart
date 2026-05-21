import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/cleaner/cleaner_dashboard_sort.dart';
import '../../models/compress/compress_entities.dart';
import '../../models/photo_library/photo_asset_entity.dart';
import '../../models/photo_library/scan_state_entity.dart';
import '../../utils/bytes_formatter.dart';
import '../../widgets/state_message_card.dart';
import '../../widgets/compress/asset_thumbnail.dart';
import '../../controllers/compress/compress_picker_controller.dart';

class CompressMainScreen extends GetView<CompressPickerController> {
  const CompressMainScreen({super.key});

  static const double _gridRadius = 14;
  static const double _headerPad = 16;
  static const double _gridGap = 10;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final surface = theme.colorScheme.surfaceContainerLowest;

    return Scaffold(
      backgroundColor: surface,
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
                  title: l10n.compressNoVideosFound,
                  message: l10n.compressNoVideosBody,
                  primaryAction: FilledButton(
                    onPressed: controller.refreshMedia,
                    child: Text(l10n.compressReload),
                  ),
                ),
              ],
            );
          }

          final displayItems = controller.sortedDisplayMedia;
          final savingsBytes = _estimatedVideoSavingsBytes(
            session.mediaItems,
            session.quality,
          );
          final savingsLabel = BytesFormatter.humanize(savingsBytes);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  _headerPad,
                  8,
                  _headerPad,
                  0,
                ),
                child: _CompressHeader(
                  onBack: () => Navigator.maybePop(context),
                  onSortOrRefresh: () {
                    final perm = session.permissionState;
                    final canSort =
                        perm.canAccess &&
                        !session.isLoadingInitial &&
                        session.mediaItems.isNotEmpty;
                    if (canSort) {
                      _openSortSheet(context);
                    } else if (perm.canAccess) {
                      controller.refreshMedia();
                    }
                  },
                  showSortIcon:
                      session.permissionState.canAccess &&
                      !session.isLoadingInitial &&
                      session.mediaItems.isNotEmpty,
                  showRefreshFallback:
                      session.permissionState.canAccess &&
                      (session.isLoadingInitial || session.mediaItems.isEmpty),
                  savingsLabel: savingsLabel,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: NotificationListener<ScrollNotification>(
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
                                padding: const EdgeInsets.fromLTRB(
                                  _headerPad,
                                  0,
                                  _headerPad,
                                  100,
                                ),
                                sliver: SliverGrid(
                                  delegate: SliverChildBuilderDelegate((
                                    context,
                                    index,
                                  ) {
                                    final asset = displayItems[index];
                                    final selected = session.selectedAssetIds
                                        .contains(asset.id);
                                    return _CompressGridTile(
                                      asset: asset,
                                      isSelected: selected,
                                      primaryColor: theme.colorScheme.primary,
                                      onPressed:
                                          () => controller.toggleSelection(
                                            asset.id,
                                          ),
                                    );
                                  }, childCount: displayItems.length),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: _gridGap,
                                        crossAxisSpacing: _gridGap,
                                        childAspectRatio: 0.8,
                                      ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child:
                                      session.isLoadingMore
                                          ? const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(12),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                          : const SizedBox.shrink(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (session.hasSelection)
                      Positioned(
                        left: _headerPad,
                        right: _headerPad,
                        bottom: 12,
                        child: SafeArea(
                          top: false,
                          child: Material(
                            elevation: 3,
                            shadowColor: Colors.black26,
                            borderRadius: BorderRadius.circular(16),
                            color: theme.colorScheme.surface,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      l10n.compressSelectedCount(
                                        session.selectedAssetIds.length,
                                      ),
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: controller.clearSelection,
                                    child: Text(l10n.compressClear),
                                  ),
                                  const SizedBox(width: 4),
                                  FilledButton(
                                    onPressed: controller.openReview,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(l10n.compressNext),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
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
        final l10n = ctx.l10n;
        final current = controller.pickerSort.value;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text(l10n.cleanerSortLargestFirst),
                trailing:
                    current == CleanerDashboardSort.largestFirst
                        ? Icon(Icons.check_rounded, color: primary)
                        : null,
                onTap:
                    () => Navigator.pop(ctx, CleanerDashboardSort.largestFirst),
              ),
              ListTile(
                title: Text(l10n.cleanerSortSmallestFirst),
                trailing:
                    current == CleanerDashboardSort.smallestFirst
                        ? Icon(Icons.check_rounded, color: primary)
                        : null,
                onTap:
                    () =>
                        Navigator.pop(ctx, CleanerDashboardSort.smallestFirst),
              ),
              ListTile(
                title: Text(l10n.cleanerSortNewestDateFirst),
                trailing:
                    current == CleanerDashboardSort.newestDateFirst
                        ? Icon(Icons.check_rounded, color: primary)
                        : null,
                onTap:
                    () => Navigator.pop(
                      ctx,
                      CleanerDashboardSort.newestDateFirst,
                    ),
              ),
              ListTile(
                title: Text(l10n.cleanerSortOldestDateFirst),
                trailing:
                    current == CleanerDashboardSort.oldestDateFirst
                        ? Icon(Icons.check_rounded, color: primary)
                        : null,
                onTap:
                    () => Navigator.pop(
                      ctx,
                      CleanerDashboardSort.oldestDateFirst,
                    ),
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

int _estimatedVideoSavingsBytes(
  List<PhotoAssetEntity> items,
  CompressionQualityPreset quality,
) {
  var total = 0;
  for (final a in items) {
    if (a.isVideo) {
      total += a.fileSize;
    }
  }
  if (total <= 0) {
    return 0;
  }
  final est = (total * quality.estimatedOutputRatio).round();
  return total > est ? total - est : 0;
}

class _CompressHeader extends StatelessWidget {
  const _CompressHeader({
    required this.onBack,
    required this.onSortOrRefresh,
    required this.showSortIcon,
    required this.showRefreshFallback,
    required this.savingsLabel,
  });

  final VoidCallback onBack;
  final VoidCallback onSortOrRefresh;
  final bool showSortIcon;
  final bool showRefreshFallback;
  final String savingsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final onSurface = theme.colorScheme.onSurface;
    const savingsColor = Color(0xFFE53935);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.compressTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: onSurface,
                letterSpacing: -0.5,
              ),
            ),

            if (showSortIcon || showRefreshFallback)
              IconButton(
                onPressed: onSortOrRefresh,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                tooltip:
                    showSortIcon ? l10n.compressSort : l10n.compressRefresh,
                icon: Icon(
                  showSortIcon
                      ? Icons.swap_vert_rounded
                      : Icons.refresh_rounded,
                  color: onSurface,
                ),
              ),
          ],
        ),

        const SizedBox(height: 6),
        Text.rich(
          TextSpan(
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
            children: [
              TextSpan(text: '${l10n.compressVideoSaveUpTo} '),
              TextSpan(
                text: savingsLabel,
                style: const TextStyle(
                  color: savingsColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompressGridTile extends StatelessWidget {
  const _CompressGridTile({
    required this.asset,
    required this.isSelected,
    required this.primaryColor,
    required this.onPressed,
  });

  final PhotoAssetEntity asset;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final sizeLabel = BytesFormatter.humanize(asset.fileSize);

    return ClipRRect(
      borderRadius: BorderRadius.circular(CompressMainScreen._gridRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AssetThumbnail(
            asset: asset,
            width: 480,
            height: 480,
            borderRadius: 0,
            isSelected: isSelected,
            showMeta: false,
            showSelectionBadge: false,
            onTap: onPressed,
            onLongPress: onPressed,
          ),
          if (isSelected) const _CornerBracketOverlay(),
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Material(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.commonSave,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              sizeLabel,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.95),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white.withValues(alpha: 0.95),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// White corner brackets when an item is selected (matches reference).
class _CornerBracketOverlay extends StatelessWidget {
  const _CornerBracketOverlay();

  static const _side = BorderSide(color: Colors.white, width: 2.5);
  static const _inset = 10.0;
  static const _arm = 16.0;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            left: _inset,
            top: _inset,
            child: Container(
              width: _arm,
              height: _arm,
              decoration: const BoxDecoration(
                border: Border(top: _side, left: _side),
              ),
            ),
          ),
          Positioned(
            right: _inset,
            top: _inset,
            child: Container(
              width: _arm,
              height: _arm,
              decoration: const BoxDecoration(
                border: Border(top: _side, right: _side),
              ),
            ),
          ),
          Positioned(
            left: _inset,
            bottom: _inset,
            child: Container(
              width: _arm,
              height: _arm,
              decoration: const BoxDecoration(
                border: Border(bottom: _side, left: _side),
              ),
            ),
          ),
          Positioned(
            right: _inset,
            bottom: _inset,
            child: Container(
              width: _arm,
              height: _arm,
              decoration: const BoxDecoration(
                border: Border(bottom: _side, right: _side),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionBody extends StatelessWidget {
  const _PermissionBody({required this.controller});

  final CompressPickerController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
          title:
              needsSettings
                  ? l10n.compressMediaAccessBlocked
                  : l10n.compressAllowMediaAccess,
          message:
              needsSettings
                  ? l10n.compressMediaBlockedBody
                  : l10n.compressMediaRequestBody,
          primaryAction: FilledButton(
            onPressed:
                needsSettings
                    ? controller.openSettings
                    : controller.requestAccess,
            child: Text(
              needsSettings
                  ? l10n.permissionOpenSettings
                  : l10n.compressAllowAccess,
            ),
          ),
          secondaryAction:
              needsSettings
                  ? OutlinedButton(
                    onPressed: controller.requestAccess,
                    child: Text(l10n.compressRetry),
                  )
                  : null,
        ),
      ],
    );
  }
}
