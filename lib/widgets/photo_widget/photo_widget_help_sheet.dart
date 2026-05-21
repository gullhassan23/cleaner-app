import 'dart:io';

import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/photo_widget/photo_widget_native_bridge.dart';

Future<void> showPhotoWidgetHelpSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      final l10n = ctx.l10n;
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.photoWidgetAddWidgetTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            if (Platform.isAndroid) ...[
              Text(l10n.photoWidgetHelpAndroid),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  final pinned = await PhotoWidgetNativeBridge.requestPinWidget();
                  if (!ctx.mounted) return;
                  Get.back();
                  Get.snackbar(
                    pinned ? l10n.photoWidgetPinSnackbarTitle : l10n.photoWidgetPinWidget,
                    pinned
                        ? l10n.photoWidgetPinFollowPrompt
                        : l10n.photoWidgetPinManualSteps,
                  );
                },
                child: Text(l10n.photoWidgetPinWidgetButton),
              ),
            ] else ...[
              Text(l10n.photoWidgetHelpIos),
            ],
          ],
        ),
      );
    },
  );
}
