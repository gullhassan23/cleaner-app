import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/photo_widget_controller.dart';
import '../widgets/photo_widget_help_sheet.dart';
import '../widgets/photo_widget_scaffold.dart';

class PhotoWidgetHubView extends GetView<PhotoWidgetController> {
  const PhotoWidgetHubView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      appBar: PhotoWidgetAppBar(
        title: 'Photo Widget',
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
              title: const Text('Show on home screen'),
              subtitle: Text(
                controller.hasWidgetContent
                    ? (controller.isEnabled
                        ? 'Widget is active'
                        : 'Turn on after importing photos')
                    : 'Import photos into an album first',
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
                'My albums',
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
              title: const Text('Widget style'),
              trailing: const Icon(CupertinoIcons.chevron_forward, size: 18),
              onTap: () => Get.toNamed(AppRoutes.photoWidgetStyle),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _showCreateAlbumDialog(BuildContext context) async {
    final nameController = TextEditingController(
      text: 'Album ${controller.albums.length + 1}',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        return AlertDialog(
          title: const Text('Create an Album'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the name of album:',
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
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Confirm'),
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
                'Widget source',
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
            const Text(
              'Create an Album',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
