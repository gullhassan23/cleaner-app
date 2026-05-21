// ignore_for_file: public_member_api_docs

import 'dart:typed_data';
import 'dart:ui';

import 'package:cleaner_app/controllers/photo_editing/ai_gallery_sheet_controller.dart';
import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/models/photo_library/scan_state_entity.dart';
import 'package:cleaner_app/services/gallery/gallery_media_service.dart';
import 'package:cleaner_app/services/permissions/photo_permission_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_manager/photo_manager.dart';

enum AiPhotoEditorFeature { photoEnhance, fixOldPhoto }

class AiPhotoEditorPage extends StatefulWidget {
  const AiPhotoEditorPage({super.key});

  @override
  State<AiPhotoEditorPage> createState() => _AiPhotoEditorPageState();
}

class _AiPhotoEditorPageState extends State<AiPhotoEditorPage> {
  static const _primaryBlue = Color(0xFF2563EB);

  Future<void> _openImageSheet(AiPhotoEditorFeature feature) async {
    final perm = Get.find<PhotoPermissionService>();
    var state = await perm.getPhotoPermissionState();
    if (!state.canAccess) {
      state = await perm.requestPermission();
    }
    if (!mounted) return;
    if (!state.canAccess) {
      await _showPermissionMessage(state);
      return;
    }
    if (!mounted) return;
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AiGalleryBottomSheet(
        sheetTitle: switch (feature) {
          AiPhotoEditorFeature.photoEnhance => l10n.cleanerPickPhotoToEnhance,
          AiPhotoEditorFeature.fixOldPhoto => l10n.cleanerPickOldPhotoToRestore,
        },
        onPick: (asset) => _cropPickedAsset(ctx, asset),
      ),
    );
  }

  Future<void> _showPermissionMessage(PermissionStateEntity state) async {
    final openSettings = state.needsSettings;
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        final l10n = ctx.l10n;
        final cs = Theme.of(ctx).colorScheme;
        return AlertDialog(
          backgroundColor: cs.surface,
          title: Text(
            l10n.cleanerPhotosAccessTitle,
            style: TextStyle(color: cs.onSurface),
          ),
          content: Text(
            openSettings
                ? l10n.cleanerPhotosAccessBlocked
                : l10n.cleanerPhotosAccessRequest,
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.commonOk),
            ),
            if (openSettings)
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Get.find<PhotoPermissionService>().openAppSettings();
                },
                child: Text(l10n.commonSettings),
              ),
          ],
        );
      },
    );
  }

  Future<void> _cropPickedAsset(BuildContext sheetContext, AssetEntity asset) async {
    Navigator.of(sheetContext).pop();
    final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
    final gallery = Get.find<GalleryMediaService>();
    final file = await gallery.getOriginalFile(asset.id);
    if (!mounted || file == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.cleanerCouldNotOpenImage)),
        );
      }
      return;
    }

    final l10n = context.l10n;
    final cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 92,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: l10n.cleanerCrop,
          toolbarColor: isDark ? const Color(0xFF1C1B1F) : Colors.white,
          toolbarWidgetColor: isDark ? Colors.white : Colors.black87,
          statusBarLight: !isDark,
          backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF1F5F9),
          activeControlsWidgetColor: _primaryBlue,
          cropGridColor: Colors.white.withValues(alpha: 0.9),
          cropFrameColor: isDark ? const Color(0xFFE0E0E0) : Colors.white,
          showCropGrid: true,
          cropGridColumnCount: 3,
          cropGridRowCount: 3,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: const [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        IOSUiSettings(
          title: l10n.cleanerCrop,
          doneButtonTitle: l10n.commonDone,
          cancelButtonTitle: l10n.commonCancel,
          aspectRatioLockEnabled: false,
          resetAspectRatioEnabled: true,
          rotateButtonsHidden: false,
          aspectRatioPickerButtonHidden: false,
        ),
      ],
    );

    if (!mounted) return;
    if (cropped == null) return;

    try {
      await PhotoManager.editor.saveImageWithPath(
        cropped.path,
        title: 'AI_crop_${DateTime.now().millisecondsSinceEpoch}',
        creationDate: DateTime.now(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.cleanerPhotoSavedToGallery)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.cleanerCouldNotSaveToGallery('$e')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final scaffoldBg = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.cleanerAiPhotoEditorTitle,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: cs.onSurface,
          ),
        ),
        actions: [
          IconButton(
            tooltip: l10n.cleanerChooseFromLibrary,
            onPressed: () => _openImageSheet(AiPhotoEditorFeature.photoEnhance),
            icon: Icon(Icons.photo_library_outlined, color: cs.onSurface),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          _FeatureCard(
            background: isDark ? const Color(0xFF352A47) : const Color(0xFFEDE7F6),
            title: l10n.cleanerPhotoEnhance,
            titleColor: isDark ? const Color(0xFFE1BEE7) : const Color(0xFF4527A0),
            subtitle: l10n.cleanerBoostQuality,
            subtitleColor: isDark
                ? const Color(0xFFCE93D8).withValues(alpha: 0.85)
                : const Color(0xFF6A1B9A).withValues(alpha: 0.75),
            demo: _SplitDemoThumb(
              left: isDark ? const Color(0xFF4A3F5C) : const Color(0xFFD1C4E9),
              right: isDark ? const Color(0xFF6A4BA8) : const Color(0xFF7E57C2),
              dividerColor: cs.outline.withValues(alpha: 0.45),
              leftIcon: Icons.blur_on_rounded,
              rightIcon: Icons.auto_awesome_rounded,
            ),
            onTap: () => _openImageSheet(AiPhotoEditorFeature.photoEnhance),
          ),
          const SizedBox(height: 14),
          _FeatureCard(
            background: isDark ? const Color(0xFF3D2E26) : const Color(0xFFFFE0D4),
            title: l10n.cleanerFixOldPhoto,
            titleColor: isDark ? const Color(0xFFFFCCBC) : const Color(0xFF3E2723),
            subtitle: l10n.cleanerRestoreOldMemories,
            subtitleColor: isDark
                ? const Color(0xFFFFAB91).withValues(alpha: 0.9)
                : const Color(0xFF5D4037).withValues(alpha: 0.8),
            demo: _SplitDemoThumb(
              left: isDark ? const Color(0xFF5D5D5D) : const Color(0xFFBDBDBD),
              right: isDark ? const Color(0xFF8D6E63) : const Color(0xFFFFCC80),
              dividerColor: cs.outline.withValues(alpha: 0.45),
              leftIcon: Icons.history_edu_rounded,
              rightIcon: Icons.palette_rounded,
            ),
            onTap: () => _openImageSheet(AiPhotoEditorFeature.fixOldPhoto),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.background,
    required this.title,
    required this.titleColor,
    required this.subtitle,
    required this.subtitleColor,
    required this.demo,
    required this.onTap,
  });

  final Color background;
  final String title;
  final Color titleColor;
  final String subtitle;
  final Color subtitleColor;
  final Widget demo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(width: 96, height: 96, child: demo),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: titleColor.withValues(alpha: 0.45)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplitDemoThumb extends StatelessWidget {
  const _SplitDemoThumb({
    required this.left,
    required this.right,
    required this.dividerColor,
    required this.leftIcon,
    required this.rightIcon,
  });

  final Color left;
  final Color right;
  final Color dividerColor;
  final IconData leftIcon;
  final IconData rightIcon;

  @override
  Widget build(BuildContext context) {
    const iconOnDemo = Color(0xE6FFFFFF);
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: left),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.2, sigmaY: 1.2),
                  child: const ColoredBox(color: Colors.transparent),
                ),
                Center(
                  child: Icon(leftIcon, color: iconOnDemo, size: 28),
                ),
              ],
            ),
          ),
          Container(width: 1, color: dividerColor),
          Expanded(
            child: ColoredBox(
              color: right,
              child: Center(
                child: Icon(rightIcon, color: iconOnDemo, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiGalleryBottomSheet extends StatefulWidget {
  const _AiGalleryBottomSheet({
    required this.sheetTitle,
    required this.onPick,
  });

  final String sheetTitle;
  final Future<void> Function(AssetEntity asset) onPick;

  @override
  State<_AiGalleryBottomSheet> createState() => _AiGalleryBottomSheetState();
}

class _AiGalleryBottomSheetState extends State<_AiGalleryBottomSheet> {
  @override
  void initState() {
    super.initState();
    Get.put(AiGallerySheetController(sheetTitle: widget.sheetTitle));
  }

  @override
  void dispose() {
    if (Get.isRegistered<AiGallerySheetController>()) {
      Get.delete<AiGallerySheetController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AiGallerySheetBody(onPick: widget.onPick);
  }
}

class _AiGallerySheetBody extends GetView<AiGallerySheetController> {
  const _AiGallerySheetBody({required this.onPick});

  final Future<void> Function(AssetEntity asset) onPick;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height * 0.62;
    final cs = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: h,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.sheetTitle,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: cs.onSurface),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final list = controller.assets;
                final loading = controller.loading.value;
                final ended = controller.end.value;
                if (list.isEmpty && loading) {
                  return Center(child: CircularProgressIndicator(color: cs.primary));
                }
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      context.l10n.cleanerNoPhotosFound,
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  );
                }
                return GridView.builder(
                  controller: controller.scroll,
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemCount: list.length + (loading && !ended ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i >= list.length) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: cs.primary,
                            ),
                          ),
                        ),
                      );
                    }
                    final a = list[i];
                    return Material(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => onPick(a),
                        child: _GalleryThumb(asset: a),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _GalleryThumb extends StatelessWidget {
  const _GalleryThumb({required this.asset});

  final AssetEntity asset;

  static const _size = ThumbnailSize.square(220);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(_size),
      builder: (context, snap) {
        if (snap.hasData && snap.data != null) {
          return Image.memory(
            snap.data!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            gaplessPlayback: true,
          );
        }
        return ColoredBox(color: Theme.of(context).colorScheme.surfaceContainerHigh);
      },
    );
  }
}
