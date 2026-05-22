import 'dart:async';

import 'package:cleaner_app/controllers/cleaner/cleaner_controller.dart';
import 'package:cleaner_app/features/cleaner/DashboardAppbar.dart';
import 'package:cleaner_app/l10n/l10n_extension.dart';

import 'package:cleaner_app/features/cleaner/result_scroll.dart';

import 'package:cleaner_app/models/cleaner/cleaner_dashboard_sort.dart';
import 'package:cleaner_app/models/cleaner/cleaner_scan_phase.dart';

import 'package:cleaner_app/routes/app_routes.dart';
import 'package:cleaner_app/utils/colors.dart';
import 'package:cleaner_app/utils/permission.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Reference-style palette (see design screenshot).

class CleanerDashboardPage extends GetView<CleanerController> {
  const CleanerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Obx(() {
          final perm = controller.permission.value;

          if (!perm.canAccess) {
            return DashboardAppbar(
              child: PermissionBody(
                permission: perm,
                onRequest: controller.requestPermissionAndScan,
                onOpenSettings: controller.openAppSettings,
                onManageLimited: controller.presentLimitedMediaPicker,
              ),
              onSettings: () => Get.toNamed<void>(AppRoutes.settings),
            );
          }

          if (controller.phase.value == CleanerScanPhase.failed) {
            return DashboardAppbar(
              child: _ErrorBody(
                message:
                    controller.lastError.value ??
                    context.l10n.cleanerUnknownError,
                onRetry: controller.startFullScan,
              ),
              onSettings: () => Get.toNamed<void>(AppRoutes.settings),
            );
          }

          if (!controller.hasResults) {
            return DashboardAppbar(
              child: _ScanningBody(
                progress: controller.scanProgress.value,
                label: controller.scanStageLabel.value,
              ),
              onSettings: () => Get.toNamed<void>(AppRoutes.settings),
            );
          }

          return DashboardAppbar(
            onSettings: () => Get.toNamed<void>(AppRoutes.settings),
            onSort: () => _openSortSheet(context),
            child: ResultsScrollBody(controller: controller),
          );
        }),
      ),
    );
  }

  Future<void> _openSortSheet(BuildContext context) async {
    final selected = await showModalBottomSheet<CleanerDashboardSort>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final l10n = ctx.l10n;
        final primary = Theme.of(ctx).colorScheme.primary;
        final current = controller.dashboardSort.value;
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
      controller.dashboardSort.value = selected;
    }
  }
}

/// Muted looping preview for the dashboard Videos tile.

class _ScanningBody extends StatelessWidget {
  const _ScanningBody({required this.progress, required this.label});

  final double progress;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.cleanerAnalyzingLibrary,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: theme.colorScheme.progressTrack,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: theme.colorScheme.onSurface,
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
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: cs.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: cs.onSurface),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onRetry,
              child: Text(context.l10n.commonTryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
