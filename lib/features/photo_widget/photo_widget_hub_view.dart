import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../controllers/photo_widget/photo_widget_controller.dart';
import '../../widgets/photo_widget/photo_widget_help_sheet.dart';
import '../../widgets/photo_widget/photo_widget_scaffold.dart';

class PhotoWidgetHubView extends GetView<PhotoWidgetController> {
  const PhotoWidgetHubView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      appBar: PhotoWidgetAppBar(
        title: l10n.photoWidgetTitle,
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.question_circle,
              color: scheme.primary,
            ),
            onPressed: () => showPhotoWidgetHelpSheet(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.photoWidgetShowOnHomeScreen),
              subtitle: Text(
                controller.hasWidgetContent
                    ? (controller.isEnabled
                        ? l10n.photoWidgetActive
                        : l10n.photoWidgetTurnOnAfterImport)
                    : l10n.photoWidgetImportFirst,
                style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
              ),
              value: controller.isEnabled,
              onChanged: controller.isSyncing.value || !controller.hasWidgetContent
                  ? null
                  : (enabled) => controller.setEnabled(enabled),
            ),
            const Divider(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                l10n.photoWidgetMyAlbums,
                style: TextStyle(
                  fontSize: 13,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final album in controller.albums)
                  _AlbumTile(
                    albumName: album.name,
                    photoCount: album.photos.length,
                    isWidgetSource: album.isWidgetSource,
                    onTap: () => Get.toNamed(
                      AppRoutes.photoWidgetAlbum,
                      arguments: album.id,
                    ),
                  ),
                _CreateAlbumTile(onTap: () => _showCreateAlbumDialog(context)),
              ],
            ),
            const SizedBox(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.photoWidgetWidgetStyle),
              trailing: const Icon(CupertinoIcons.chevron_forward, size: 18),
              onTap: () => Get.toNamed(AppRoutes.photoWidgetStyle),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _showCreateAlbumDialog(BuildContext context) async {
    final l10n = context.l10n;
    final nameController = TextEditingController(
      text: l10n.photoWidgetDefaultAlbumName(controller.albums.length + 1),
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dialogL10n = ctx.l10n;
        final scheme = Theme.of(ctx).colorScheme;
        return AlertDialog(
          title: Text(dialogL10n.photoWidgetCreateAlbum),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dialogL10n.photoWidgetEnterAlbumName,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: scheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: nameController.clear,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(dialogL10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(dialogL10n.commonConfirm),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final album = await controller.createAlbum(nameController.text);
    if (album != null) {
      Get.toNamed(AppRoutes.photoWidgetAlbum, arguments: album.id);
    }
  }
}

class _AlbumTile extends StatelessWidget {
  const _AlbumTile({
    required this.albumName,
    required this.photoCount,
    required this.isWidgetSource,
    required this.onTap,
  });

  final String albumName;
  final int photoCount;
  final bool isWidgetSource;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    const size = 108.0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        child: Column(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: photoCount > 0
                  ? Icon(Icons.photo_library_outlined, color: scheme.primary)
                  : Icon(Icons.folder_outlined, color: scheme.outline),
            ),
            const SizedBox(height: 8),
            Text(
              albumName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
            if (isWidgetSource)
              Text(
                l10n.photoWidgetWidgetSource,
                style: TextStyle(fontSize: 11, color: scheme.primary),
              ),
          ],
        ),
      ),
    );
  }
}

class _CreateAlbumTile extends StatelessWidget {
  const _CreateAlbumTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    const size = 108.0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        child: Column(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: scheme.outline.withValues(alpha: 0.5),
                      width: 1.5,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.add, color: scheme.primary, size: 28),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.photoWidgetCreateAlbum,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
