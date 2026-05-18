import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../platform/photo_widget_native_bridge.dart';

Future<void> showPhotoWidgetHelpSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Photo Widget',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            if (Platform.isAndroid) ...[
              const Text(
                '1. Import photos in an album (widget turns on automatically)\n'
                '2. Long-press your home screen → Widgets\n'
                '3. Find Cleaner App → Photo Widget\n'
                '4. Drag it to your home screen\n\n'
                'Or tap below to pin the widget (Android 8+).',
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  final pinned = await PhotoWidgetNativeBridge.requestPinWidget();
                  if (!ctx.mounted) return;
                  Get.back();
                  Get.snackbar(
                    pinned ? 'Widget' : 'Pin widget',
                    pinned
                        ? 'Follow the system prompt to add the widget.'
                        : 'Use the manual steps above if pin is unavailable.',
                  );
                },
                child: const Text('Pin widget to home screen'),
              ),
            ] else ...[
              const Text(
                '1. Long-press your home screen\n'
                '2. Tap the + button\n'
                '3. Search for Cleaner App\n'
                '4. Choose Photo Widget size and tap Add Widget\n\n'
                'Note: iOS widgets refresh on a timeline and may not update instantly.',
              ),
            ],
          ],
        ),
      );
    },
  );
}
