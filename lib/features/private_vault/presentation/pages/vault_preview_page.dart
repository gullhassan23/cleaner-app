import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../controllers/vault_preview_controller.dart';

class VaultPreviewPage extends GetView<VaultPreviewController> {
  const VaultPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (controller.errorMessage.value != null) {
          return Center(
            child: Text(
              controller.errorMessage.value!,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
        return PageView.builder(
          controller: PageController(initialPage: controller.currentIndex),
          itemCount: controller.items.length,
          onPageChanged: controller.onPageChanged,
          itemBuilder: (context, index) {
            final media = controller.items[index];
            final path = controller.currentPath.value;
            if (path == null) return const SizedBox.shrink();

            if (media.isVideo) {
              final vc = controller.videoController;
              if (vc == null || !vc.value.isInitialized) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
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
              child: Center(
                child: Image.file(File(path), fit: BoxFit.contain),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: controller.shareCurrent,
                icon: const Icon(Icons.share, color: Color(0xFF007AFF)),
                label: const Text(
                  'Share',
                  style: TextStyle(color: Color(0xFF007AFF)),
                ),
              ),
              TextButton.icon(
                onPressed: controller.deleteCurrent,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFF007AFF),
                ),
                label: const Text(
                  'Delete',
                  style: TextStyle(color: Color(0xFF007AFF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
