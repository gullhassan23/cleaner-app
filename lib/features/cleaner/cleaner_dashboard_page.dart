import 'dart:async';

import 'package:cleaner_app/controllers/cleaner_controller.dart';
import 'package:cleaner_app/features/cleaner/DashboardAppbar.dart';

import 'package:cleaner_app/features/cleaner/result_scroll.dart';

import 'package:cleaner_app/models/cleaner/cleaner_dashboard_sort.dart';
import 'package:cleaner_app/models/cleaner/cleaner_scan_phase.dart';

import 'package:cleaner_app/models/photo_library/scan_state_entity.dart';
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
              onSettings: () => _openSettingsMenu(context, perm),
            );
          }

          if (controller.phase.value == CleanerScanPhase.failed) {
            return DashboardAppbar(
              child: _ErrorBody(
                message: controller.lastError.value ?? 'Unknown error',
                onRetry: controller.startFullScan,
              ),
              onSettings: () => _openSettingsMenu(context, perm),
            );
          }

          if (!controller.hasResults) {
            return DashboardAppbar(
              child: _ScanningBody(
                progress: controller.scanProgress.value,
                label: controller.scanStageLabel.value,
              ),
              onSettings: () => _openSettingsMenu(context, perm),
            );
          }

          return DashboardAppbar(
            onSettings: () => _openSettingsMenu(context, perm),
            onSort: () => _openSortSheet(context),
            child: ResultsScrollBody(controller: controller),
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
                        ? const Icon(Icons.check_rounded, color: kDashBlue)
                        : null,
                onTap:
                    () => Navigator.pop(ctx, CleanerDashboardSort.largestFirst),
              ),
              ListTile(
                title: const Text('Smallest first'),
                trailing:
                    current == CleanerDashboardSort.smallestFirst
                        ? const Icon(Icons.check_rounded, color: kDashBlue)
                        : null,
                onTap:
                    () =>
                        Navigator.pop(ctx, CleanerDashboardSort.smallestFirst),
              ),
              ListTile(
                title: const Text('Newest date first'),
                trailing:
                    current == CleanerDashboardSort.newestDateFirst
                        ? const Icon(Icons.check_rounded, color: kDashBlue)
                        : null,
                onTap:
                    () => Navigator.pop(
                      ctx,
                      CleanerDashboardSort.newestDateFirst,
                    ),
              ),
              ListTile(
                title: const Text('Oldest date first'),
                trailing:
                    current == CleanerDashboardSort.oldestDateFirst
                        ? const Icon(Icons.check_rounded, color: kDashBlue)
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
                'Analyzing your library',
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
                style: const TextStyle(
                  fontSize: 15,
                  color: kDashGrey,
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
                  color: kDashBlue,
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
                backgroundColor: kDashBlue,
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
