import 'dart:io';

import 'package:cleaner_app/l10n/app_localizations.dart';
import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../routes/app_routes.dart';
import '../../controllers/photo_widget/photo_widget_controller.dart';
import '../../services/photo_widget/photo_widget_native_bridge.dart';
import '../../widgets/photo_widget/photo_widget_storage_service.dart';
import '../../widgets/photo_widget/photo_widget_help_sheet.dart';
import '../../widgets/photo_widget/photo_widget_scaffold.dart';

class PhotoWidgetAlbumView extends GetView<PhotoWidgetController> {
  const PhotoWidgetAlbumView({super.key});

  String get _albumId {
    final args = Get.arguments;
    return args is String ? args : '';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Obx(() {
      final album = controller.albumById(_albumId);
      if (album == null) {
        return Scaffold(
          appBar: PhotoWidgetAppBar(title: l10n.photoWidgetAlbum),
          body: Center(child: Text(l10n.photoWidgetAlbumNotFound)),
        );
      }

      final photos = album.photos;

      return Scaffold(
        backgroundColor: scheme.surface,
        appBar: PhotoWidgetAppBar(
          title: album.name,
          actions: [
            IconButton(
              icon: Icon(CupertinoIcons.pencil, color: scheme.primary, size: 20),
              onPressed: () => _renameAlbum(context, album.id, album.name),
            ),
            if (photos.isNotEmpty)
              IconButton(
                icon: Icon(CupertinoIcons.delete, color: scheme.error),
                onPressed: () => _confirmDeleteAlbum(context, album.id),
              ),
          ],
        ),
        body: photos.isEmpty
            ? _EmptyAlbumBody(onImport: () => _importPhotos(context, album.id))
            : Column(
                children: [
                  if (!album.isWidgetSource)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            controller.setWidgetSourceAlbum(album.id),
                        icon: const Icon(Icons.widgets_outlined, size: 18),
                        label: Text(l10n.photoWidgetUseForHomeScreen),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: scheme.primary, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            l10n.photoWidgetActiveAlbum,
                            style: TextStyle(color: scheme.primary),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        final photo = photos[index];
                        return _PhotoTile(
                          fileName: photo.fileName,
                          onDelete: () => controller.removePhoto(
                            album.id,
                            photo.id,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: photos.isNotEmpty
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: FilledButton(
                    onPressed: () => _importPhotos(context, album.id),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(l10n.photoWidgetAddNewPhotos),
                  ),
                ),
              )
            : null,
      );
    });
  }

  Future<void> _importPhotos(BuildContext context, String albumId) async {
    final l10n = AppLocalizations.of(Get.context!);
    final ok = await controller.ensurePhotoPermission();
    if (!ok) {
      Get.snackbar(
        l10n.photoWidgetPermissionRequired,
        l10n.photoWidgetAllowPhotoAccess,
      );
      return;
    }

    final album = controller.albumById(albumId);
    if (album == null) return;

    final remaining = PhotoWidgetStorageService.maxPhotosPerAlbum -
        album.photos.length;
    if (remaining <= 0) {
      Get.snackbar(
        l10n.photoWidgetLimitReached,
        l10n.photoWidgetAlbumFull,
      );
      return;
    }

    final pickedRaw = await Get.toNamed<dynamic>(
      AppRoutes.photoWidgetPicker,
      arguments: remaining,
    );
    if (pickedRaw is! List<AssetEntity> || pickedRaw.isEmpty) return;

    final count = await controller.importPhotos(albumId, pickedRaw);
    if (count == 0) {
      Get.snackbar(
        l10n.photoWidgetImportFailed,
        l10n.photoWidgetCouldNotSave,
      );
      return;
    }

    if (count < pickedRaw.length) {
      Get.snackbar(
        l10n.photoWidgetPartialImport,
        l10n.photoWidgetPartialImportMessage(count, pickedRaw.length),
      );
    }

    if (Platform.isAndroid) {
      final pinned = await PhotoWidgetNativeBridge.isWidgetPinned();
      if (!pinned && context.mounted) {
        Get.snackbar(
          l10n.photoWidgetAddToHomeTitle,
          l10n.photoWidgetAddToHomeBody,
          duration: const Duration(seconds: 5),
          mainButton: TextButton(
            onPressed: () => showPhotoWidgetHelpSheet(context),
            child: Text(l10n.photoWidgetHelp),
          ),
        );
      }
    } else {
      Get.snackbar(
        l10n.photoWidgetUpdated,
        l10n.photoWidgetUpdatedBody,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> _renameAlbum(
    BuildContext context,
    String albumId,
    String currentName,
  ) async {
    final l10n = context.l10n;
    final nameController = TextEditingController(text: currentName);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dialogL10n = ctx.l10n;
        return AlertDialog(
          title: Text(dialogL10n.photoWidgetRenameAlbum),
          content: TextField(
            controller: nameController,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(dialogL10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(dialogL10n.commonSave),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      await controller.renameAlbum(albumId, nameController.text);
    }
  }

  Future<void> _confirmDeleteAlbum(BuildContext context, String albumId) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dialogL10n = ctx.l10n;
        return AlertDialog(
          title: Text(dialogL10n.photoWidgetDeleteAlbumTitle),
          content: Text(dialogL10n.photoWidgetDeleteAlbumBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(dialogL10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
              ),
              child: Text(dialogL10n.commonDelete),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      await controller.deleteAlbum(albumId);
      Get.back();
    }
  }
}

class _EmptyAlbumBody extends StatelessWidget {
  const _EmptyAlbumBody({required this.onImport});

  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo_outlined,
            size: 72,
            color: scheme.primary,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onImport,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(l10n.photoWidgetImportPhotos),
          ),
        ],
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.fileName, required this.onDelete});

  final String fileName;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: Get.find<PhotoWidgetStorageService>().cachedFileAsync(fileName),
      builder: (context, snapshot) {
        final file = snapshot.data;
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: file != null && file.existsSync()
                  ? Image.file(file, fit: BoxFit.cover)
                  : ColoredBox(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Material(
                color: Colors.black54,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onDelete,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
