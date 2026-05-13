import 'dart:async';
import 'dart:math' as math;

import 'package:cleaner_app/controllers/cleaner_controller.dart';
import 'package:cleaner_app/models/cleaner/cleaner_dashboard_kind.dart';
import 'package:cleaner_app/models/cleaner/cleaner_dashboard_sort.dart';
import 'package:cleaner_app/models/cleaner/cleaner_scan_phase.dart';
import 'package:cleaner_app/models/photo_library/photo_asset_entity.dart';
import 'package:cleaner_app/models/photo_library/scan_state_entity.dart';
import 'package:cleaner_app/utils/bytes_formatter.dart';
import 'package:disk_usage/disk_usage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../repositories/photo_library_repository.dart';
import '../widgets/cleaner_thumbnail.dart';

/// Reference-style palette (see design screenshot).
const Color _kDashBlue = Color(0xFF4A89F3);
const Color _kDashGrey = Color(0xFF8E8E93);
const Color _kCardGreyTop = Color(0xFFE8E8ED);
const Color _kCardGreyBottom = Color(0xFFC7C7CC);

class CleanerDashboardPage extends GetView<CleanerController> {
  const CleanerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Obx(() {
          final perm = controller.permission.value;

          if (!perm.canAccess) {
            return _DashboardChrome(
              child: _PermissionBody(
                permission: perm,
                onRequest: controller.requestPermissionAndScan,
                onOpenSettings: controller.openAppSettings,
                onManageLimited: controller.presentLimitedMediaPicker,
              ),
              onSettings: () => _openSettingsMenu(context, perm),
            );
          }

          if (controller.phase.value == CleanerScanPhase.failed) {
            return _DashboardChrome(
              child: _ErrorBody(
                message: controller.lastError.value ?? 'Unknown error',
                onRetry: controller.startFullScan,
              ),
              onSettings: () => _openSettingsMenu(context, perm),
            );
          }

          if (!controller.hasResults) {
            return _DashboardChrome(
              child: _ScanningBody(
                progress: controller.scanProgress.value,
                label: controller.scanStageLabel.value,
              ),
              onSettings: () => _openSettingsMenu(context, perm),
            );
          }

          return _DashboardChrome(
            onSettings: () => _openSettingsMenu(context, perm),
            onSort: () => _openSortSheet(context),
            child: _ResultsScrollBody(controller: controller),
          );
        }),
      ),
    );
  }

  Future<void> _openSettingsMenu(
    BuildContext context,
    PermissionStateEntity perm,
  ) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder:
          (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (perm.canAccess) ...[
                  ListTile(
                    leading: const Icon(Icons.refresh_rounded),
                    title: const Text('Refresh library'),
                    onTap: () => Navigator.pop(ctx, 'refresh'),
                  ),
                ],
                ListTile(
                  leading: const Icon(Icons.settings_rounded),
                  title: const Text('App settings'),
                  onTap: () => Navigator.pop(ctx, 'settings'),
                ),
              ],
            ),
          ),
    );
    if (choice == 'refresh' && perm.canAccess) {
      if (perm.isLimited || perm.canOpenSystemPicker) {
        await controller.changeGalleryAccess();
      } else {
        await controller.startFullScan();
      }
    } else if (choice == 'settings') {
      await controller.openAppSettings();
    }
  }

  Future<void> _openSortSheet(BuildContext context) async {
    final selected = await showModalBottomSheet<CleanerDashboardSort>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final current = controller.dashboardSort.value;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: const Text('Largest first'),
                trailing:
                    current == CleanerDashboardSort.largestFirst
                        ? const Icon(Icons.check_rounded, color: _kDashBlue)
                        : null,
                onTap:
                    () => Navigator.pop(ctx, CleanerDashboardSort.largestFirst),
              ),
              ListTile(
                title: const Text('Smallest first'),
                trailing:
                    current == CleanerDashboardSort.smallestFirst
                        ? const Icon(Icons.check_rounded, color: _kDashBlue)
                        : null,
                onTap:
                    () =>
                        Navigator.pop(ctx, CleanerDashboardSort.smallestFirst),
              ),
              ListTile(
                title: const Text('Newest date first'),
                trailing:
                    current == CleanerDashboardSort.newestDateFirst
                        ? const Icon(Icons.check_rounded, color: _kDashBlue)
                        : null,
                onTap:
                    () =>
                        Navigator.pop(ctx, CleanerDashboardSort.newestDateFirst),
              ),
              ListTile(
                title: const Text('Oldest date first'),
                trailing:
                    current == CleanerDashboardSort.oldestDateFirst
                        ? const Icon(Icons.check_rounded, color: _kDashBlue)
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
      controller.dashboardSort.value = selected;
    }
  }
}

class _DashboardChrome extends StatelessWidget {
  const _DashboardChrome({
    required this.child,
    required this.onSettings,
    this.onSort,
  });

  final Widget child;
  final VoidCallback onSettings;
  final VoidCallback? onSort;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 12, 4),
          child: Row(
            children: [
              const Text(
                'Cleaner',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Material(
                color: _kDashBlue,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap:
                      () => ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('PRO'))),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.thumb_up_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'PRO',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (onSort != null)
                IconButton(
                  onPressed: onSort,
                  icon: const Icon(
                    Icons.sort_rounded,
                    color: _kDashGrey,
                    size: 26,
                  ),
                ),
              IconButton(
                onPressed: onSettings,
                icon: const Icon(
                  Icons.settings_outlined,
                  color: _kDashGrey,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _ResultsScrollBody extends StatelessWidget {
  const _ResultsScrollBody({required this.controller});

  final CleanerController controller;

  String _sizeLabel(int bytes) {
    if (bytes <= 0) {
      return '0 KB';
    }
    final s = BytesFormatter.humanize(bytes);
    if (s.endsWith('.0 KB')) {
      return '${s.substring(0, s.length - 4)} KB';
    }
    if (s.endsWith('.0 MB')) {
      return '${s.substring(0, s.length - 4)} MB';
    }
    if (s.endsWith('.0 GB')) {
      return '${s.substring(0, s.length - 4)} GB';
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final gap = 10.0;
      final similarBytes = controller.bytesForKind(
        CleanerDashboardKind.similarPhotos,
      );
      final dupBytes = controller.bytesForKind(
        CleanerDashboardKind.duplicatePhotos,
      );
      final videoBytes = controller.bytesForKind(CleanerDashboardKind.videos);
      final shotBytes = controller.bytesForKind(
        CleanerDashboardKind.screenshots,
      );

      final similarPreview = controller.previewForKind(
        CleanerDashboardKind.similarPhotos,
      );
      final dupPreview = controller.previewForKind(
        CleanerDashboardKind.duplicatePhotos,
      );
      final videoPreview = controller.previewForKind(
        CleanerDashboardKind.videos,
      );
      final shotPreview = controller.previewForKind(
        CleanerDashboardKind.screenshots,
      );

      final similarCount = controller.countForKind(
        CleanerDashboardKind.similarPhotos,
      );
      final dupCount = controller.countForKind(
        CleanerDashboardKind.duplicatePhotos,
      );
      final videoCount = controller.countForKind(CleanerDashboardKind.videos);
      final shotCount = controller.countForKind(
        CleanerDashboardKind.screenshots,
      );

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _StorageStrip(),
            SizedBox(height: gap + 56),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _CategoryGridCard(
                        height: 118,
                        title: 'Similar Photos',
                        sizeLabel: _sizeLabel(similarBytes),
                        preview: similarPreview,
                        placeholderIcon: similarPreview == null,
                        onTap:
                            similarCount == 0
                                ? null
                                : controller.openSimilarSheet,
                      ),
                      SizedBox(height: gap),
                      _CategoryGridCard(
                        height: 118,
                        title: 'Duplicate Photos',
                        sizeLabel: _sizeLabel(dupBytes),
                        preview: dupPreview,
                        placeholderIcon: dupPreview == null,
                        onTap:
                            dupCount == 0
                                ? null
                                : controller.openDuplicateSheet,
                      ),
                      SizedBox(height: gap),
                      _CategoryGridCard(
                        height: 118,
                        title: 'Similar Videos',
                        sizeLabel: '0 KB',
                        preview: null,
                        placeholderIcon: true,
                        onTap: null,
                      ),
                      SizedBox(height: gap),
                      _CategoryGridCard(
                        height: 118,
                        title: 'Similar Burst Photos',
                        sizeLabel: '0 KB',
                        preview: null,
                        placeholderIcon: true,
                        onTap: null,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: gap),
                Expanded(
                  child: Column(
                    children: [
                      _CategoryGridCard(
                        height: 200,
                        title: 'Videos',
                        sizeLabel: _sizeLabel(videoBytes),
                        preview: videoPreview,
                        solidBlack: videoPreview == null,
                        inlineVideo: videoPreview != null,
                        placeholderIcon: false,
                        onTap:
                            videoCount == 0 ? null : controller.openVideosSheet,
                      ),
                      SizedBox(height: gap),
                      _CategoryGridCard(
                        height: 168,
                        title: 'Screenshots',
                        sizeLabel: _sizeLabel(shotBytes),
                        preview: shotPreview,
                        placeholderIcon: shotPreview == null,
                        subtitleAboveTitle: 'Optimize Your Storage',
                        topInset: _screenshotsFakeRow(),
                        onTap:
                            shotCount == 0
                                ? null
                                : controller.openScreenshotsSheet,
                      ),
                      SizedBox(height: gap),
                      _CategoryGridCard(
                        height: 118,
                        title: 'Similar Live Photos',
                        sizeLabel: _sizeLabel(similarBytes),
                        preview: similarPreview,
                        placeholderIcon: similarPreview == null,
                        onTap:
                            similarCount == 0
                                ? null
                                : controller.openSimilarSheet,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _screenshotsFakeRow() {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.contacts_rounded,
            size: 18,
            color: _kDashBlue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '3.0 GB',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _StorageStrip extends StatefulWidget {
  const _StorageStrip();

  @override
  State<_StorageStrip> createState() => _StorageStripState();
}

class _StorageStripState extends State<_StorageStrip> {
  int? _total;
  int? _free;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final total = await DiskUsage.totalSpace();
    final free = await DiskUsage.freeSpace();
    if (!mounted) {
      return;
    }
    setState(() {
      _total = total;
      _free = free;
    });
  }

  String _gb(int bytes) {
    final g = bytes / (1024 * 1024 * 1024);
    if (g >= 10) {
      return '${g.toStringAsFixed(0)} GB';
    }
    return '${g.toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final total = _total;
    final free = _free;
    int? used;
    double? progressValue;
    if (total != null && free != null && total > 0) {
      used = (total - free).clamp(0, total);
      final r = used / total;
      if (r <= 0) {
        progressValue = 0;
      } else if (r < 0.02) {
        progressValue = 0.02;
      } else {
        progressValue = r;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 15,
              color: _kDashGrey,
              fontWeight: FontWeight.w500,
            ),
            children: [
              const TextSpan(text: 'Used: '),
              TextSpan(
                text: used != null ? _gb(used) : '—',
                style: const TextStyle(
                  color: _kDashBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: total != null ? ' / ${_gb(total)}' : '',
                style: const TextStyle(color: _kDashGrey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progressValue,
            minHeight: 10,
            backgroundColor: const Color(0xFFE9E9EE),
            color: _kDashBlue,
          ),
        ),
      ],
    );
  }
}

/// Muted looping preview for the dashboard Videos tile.
class _InlineLoopingVideoFill extends StatefulWidget {
  const _InlineLoopingVideoFill({
    required this.asset,
    required this.maxWidth,
    required this.maxHeight,
  });

  final PhotoAssetEntity asset;
  final double maxWidth;
  final double maxHeight;

  @override
  State<_InlineLoopingVideoFill> createState() => _InlineLoopingVideoFillState();
}

class _InlineLoopingVideoFillState extends State<_InlineLoopingVideoFill> {
  VideoPlayerController? _controller;

  PhotoLibraryRepository get _repo => Get.find<PhotoLibraryRepository>();

  @override
  void initState() {
    super.initState();
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    final id = widget.asset.id;
    final file = await _repo.loadOriginalFile(id);
    if (!mounted || widget.asset.id != id) {
      return;
    }
    if (file == null) {
      return;
    }
    final c = VideoPlayerController.file(
      file,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    try {
      await c.initialize();
      if (!mounted || widget.asset.id != id) {
        await c.dispose();
        return;
      }
      await c.setLooping(true);
      await c.setVolume(0);
      await c.play();
      if (!mounted || widget.asset.id != id) {
        await c.dispose();
        return;
      }
      setState(() => _controller = c);
    } catch (_) {
      await c.dispose();
    }
  }

  @override
  void didUpdateWidget(covariant _InlineLoopingVideoFill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset.id != widget.asset.id) {
      unawaited(_controller?.dispose() ?? Future<void>.value());
      _controller = null;
      setState(() {});
      unawaited(_bootstrap());
    }
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose() ?? Future<void>.value());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final d =
        math.max(widget.maxWidth, widget.maxHeight).ceil().clamp(64, 640).toDouble();

    if (c != null && c.value.isInitialized) {
      final sz = c.value.size;
      final w = sz.width;
      final h = sz.height;
      if (w > 0 && h > 0) {
        return FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(width: w, height: h, child: VideoPlayer(c)),
        );
      }
    }

    return CleanerThumbnail(
      asset: widget.asset,
      size: d,
      borderRadius: 0,
    );
  }
}

class _CategoryGridCard extends StatelessWidget {
  const _CategoryGridCard({
    required this.height,
    required this.title,
    required this.sizeLabel,
    required this.placeholderIcon,
    this.preview,
    this.solidBlack = false,
    this.inlineVideo = false,
    this.subtitleAboveTitle,
    this.topInset,
    this.onTap,
  });

  final double height;
  final String title;
  final String sizeLabel;
  final PhotoAssetEntity? preview;
  final bool placeholderIcon;
  final bool solidBlack;
  final bool inlineVideo;
  final String? subtitleAboveTitle;
  final Widget? topInset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final showGreyPlaceholder = placeholderIcon && !solidBlack;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (solidBlack)
                  const ColoredBox(color: Colors.black)
                else if (preview != null)
                  LayoutBuilder(
                    builder: (context, c) {
                      if (inlineVideo) {
                        return _InlineLoopingVideoFill(
                          asset: preview!,
                          maxWidth: c.maxWidth,
                          maxHeight: c.maxHeight,
                        );
                      }
                      final d = math
                          .max(c.maxWidth, c.maxHeight)
                          .ceil()
                          .clamp(64, 640);
                      return CleanerThumbnail(
                        asset: preview!,
                        size: d.toDouble(),
                        borderRadius: 0,
                      );
                    },
                  )
                else
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [_kCardGreyTop, _kCardGreyBottom],
                      ),
                    ),
                  ),
                if (showGreyPlaceholder)
                  const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 42,
                      color: _kDashGrey,
                    ),
                  ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.05),
                        Colors.black.withValues(alpha: 0.72),
                      ],
                    ),
                  ),
                ),
                if (topInset != null)
                  Positioned(top: 10, left: 10, right: 10, child: topInset!),
                Positioned(
                  left: 12,
                  right: 10,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (subtitleAboveTitle != null) ...[
                        Text(
                          subtitleAboveTitle!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black45,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        sizeLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black54,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScanningBody extends StatelessWidget {
  const _ScanningBody({required this.progress, required this.label});

  final double progress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Analyzing your library',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: _kDashGrey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: const Color(0xFFE9E9EE),
                  color: _kDashBlue,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Color(0xFFFF3B30),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 18),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _kDashBlue,
                foregroundColor: Colors.white,
              ),
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionBody extends StatelessWidget {
  const _PermissionBody({
    required this.permission,
    required this.onRequest,
    required this.onOpenSettings,
    required this.onManageLimited,
  });

  final PermissionStateEntity permission;
  final Future<void> Function() onRequest;
  final Future<void> Function() onOpenSettings;
  final Future<void> Function() onManageLimited;

  @override
  Widget build(BuildContext context) {
    final isLimited = permission.isLimited;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.photo_library_outlined,
                size: 56,
                color: _kDashBlue,
              ),
              const SizedBox(height: 16),
              Text(
                isLimited ? 'Limited library access' : 'Allow photos & videos',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isLimited
                    ? 'You can manage which items Cleaner can see, or grant full access in Settings.'
                    : 'Cleaner needs access to scan for duplicates, similar shots, videos, and screenshots.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: _kDashGrey,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),
              if (isLimited) ...[
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _kDashBlue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: onManageLimited,
                  child: const Text('Manage library access'),
                ),
                const SizedBox(height: 10),
              ],
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _kDashBlue,
                  foregroundColor: Colors.white,
                ),
                onPressed: onRequest,
                child: Text(isLimited ? 'Refresh access' : 'Continue'),
              ),
              if (permission.needsSettings) ...[
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: onOpenSettings,
                  child: const Text('Open settings'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
