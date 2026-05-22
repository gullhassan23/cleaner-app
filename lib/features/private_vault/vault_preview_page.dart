import 'dart:io';

import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'package:cleaner_app/controllers/private_vault/vault_preview_controller.dart';

class VaultPreviewPage extends GetView<VaultPreviewController> {
  const VaultPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: cs.primary),
          );
        }
        if (controller.errorMessage.value != null) {
          return Center(
            child: Text(
              controller.errorMessage.value!,
              style: TextStyle(color: cs.onSurface),
            ),
          );
        }
        final pageController = controller.pageController;
        if (pageController == null) {
          return Center(
            child: CircularProgressIndicator(color: cs.primary),
          );
        }
        return PageView.builder(
          controller: pageController,
          itemCount: controller.items.length,
          onPageChanged: controller.onPageChanged,
          itemBuilder: (context, index) {
            final media = controller.items[index];
            final path = controller.currentPath.value;
            if (path == null) return const SizedBox.shrink();

            if (media.isVideo) {
              final vc = controller.videoController;
              if (vc == null || !vc.value.isInitialized) {
                return Center(
                  child: CircularProgressIndicator(color: cs.primary),
                );
              }
              return Center(
                child: AspectRatio(
                  aspectRatio: vc.value.aspectRatio,
                  child: VideoPlayer(vc),
                ),
              );
            }

            return InteractiveViewer(
              child: Center(child: Image.file(File(path), fit: BoxFit.contain)),
            );
          },
        );
      }),
      bottomNavigationBar: BottomAppBar(
        color: cs.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: controller.shareCurrent,
                icon: Icon(Icons.share, color: cs.primary),
                label: Text(
                  l10n.commonShare,
                  style: TextStyle(color: cs.primary),
                ),
              ),
              TextButton.icon(
                onPressed: controller.deleteCurrent,
                icon: Icon(Icons.delete_outline, color: cs.primary),
                label: Text(
                  l10n.commonDelete,
                  style: TextStyle(color: cs.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
