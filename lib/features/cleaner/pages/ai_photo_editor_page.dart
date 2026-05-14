// ignore_for_file: public_member_api_docs

import 'dart:typed_data';
import 'dart:ui';

import 'package:cleaner_app/controllers/ai_gallery_sheet_controller.dart';
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
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AiGalleryBottomSheet(
        sheetTitle: switch (feature) {
          AiPhotoEditorFeature.photoEnhance => 'Pick a photo to enhance',
          AiPhotoEditorFeature.fixOldPhoto => 'Pick an old photo to restore',
        },
        onPick: (asset) => _cropPickedAsset(ctx, asset),
      ),
    );
  }

  Future<void> _showPermissionMessage(PermissionStateEntity state) async {
    final openSettings = state.needsSettings;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Photos access'),
        content: Text(
          openSettings
              ? 'Photo access is blocked. Enable it in Settings to pick images.'
              : 'Allow photo library access to choose an image.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
          if (openSettings)
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Get.find<PhotoPermissionService>().openAppSettings();
              },
              child: const Text('Settings'),
            ),
        ],
      ),
    );
  }

  Future<void> _cropPickedAsset(BuildContext sheetContext, AssetEntity asset) async {
    Navigator.of(sheetContext).pop();
    final gallery = Get.find<GalleryMediaService>();
    final file = await gallery.getOriginalFile(asset.id);
    if (!mounted || file == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open that image.')),
        );
      }
      return;
    }

    final cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 92,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black87,
          statusBarLight: true,
          backgroundColor: const Color(0xFFF1F5F9),
          activeControlsWidgetColor: _primaryBlue,
          cropGridColor: Colors.white.withValues(alpha: 0.9),
          cropFrameColor: Colors.white,
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
          title: 'Crop',
          doneButtonTitle: 'Done',
          cancelButtonTitle: 'Cancel',
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
        const SnackBar(content: Text('Photo saved to your gallery.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save to gallery: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF8F6F4);
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'AI Photo Editor',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: 'Choose from library',
            onPressed: () => _openImageSheet(AiPhotoEditorFeature.photoEnhance),
            icon: const Icon(Icons.photo_library_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          _FeatureCard(
            background: const Color(0xFFEDE7F6),
            title: 'Photo Enhance',
            titleColor: const Color(0xFF4527A0),
            subtitle: 'Boost quality',
            subtitleColor: const Color(0xFF6A1B9A).withValues(alpha: 0.75),
            demo: const _SplitDemoThumb(
              left: Color(0xFFD1C4E9),
              right: Color(0xFF7E57C2),
              leftIcon: Icons.blur_on_rounded,
              rightIcon: Icons.auto_awesome_rounded,
            ),
            onTap: () => _openImageSheet(AiPhotoEditorFeature.photoEnhance),
          ),
          const SizedBox(height: 14),
          _FeatureCard(
            background: const Color(0xFFFFE0D4),
            title: 'Fix Old Photo',
            titleColor: const Color(0xFF3E2723),
            subtitle: 'Restore old memories',
            subtitleColor: const Color(0xFF5D4037).withValues(alpha: 0.8),
            demo: const _SplitDemoThumb(
              left: Color(0xFFBDBDBD),
              right: Color(0xFFFFCC80),
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
    required this.leftIcon,
    required this.rightIcon,
  });

  final Color left;
  final Color right;
  final IconData leftIcon;
  final IconData rightIcon;

  @override
  Widget build(BuildContext context) {
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
                  child: Icon(leftIcon, color: Colors.white.withValues(alpha: 0.85), size: 28),
                ),
              ],
            ),
          ),
          Container(width: 1, color: Colors.white.withValues(alpha: 0.85)),
          Expanded(
            child: ColoredBox(
              color: right,
              child: Center(
                child: Icon(rightIcon, color: Colors.white.withValues(alpha: 0.95), size: 28),
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
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: h,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                  color: Colors.grey.shade300,
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
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
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
                  return const Center(child: CircularProgressIndicator());
                }
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'No photos found',
                      style: TextStyle(color: Colors.grey.shade600),
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
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }
                    final a = list[i];
                    return Material(
                      color: Colors.grey.shade200,
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
        return const ColoredBox(color: Color(0xFFE2E8F0));
      },
    );
  }
}
