import 'dart:io';

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../domain/entities/vault_media.dart';
import '../../domain/repositories/vault_media_repository.dart';

class VaultPreviewController extends GetxController {
  final VaultMediaRepository _media = Get.find();

  late List<VaultMedia> items;
  late int currentIndex;

  final isLoading = true.obs;
  final errorMessage = RxnString();
  final currentPath = RxnString();

  VideoPlayerController? videoController;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    items = (args['items'] as List<VaultMedia>?) ?? [];
    currentIndex = args['index'] as int? ?? 0;
    _loadCurrent();
  }

  @override
  void onClose() {
    videoController?.dispose();
    _cleanup();
    super.onClose();
  }

  Future<void> _cleanup() async {
    await _media.purgeScratch();
  }

  Future<void> _loadCurrent() async {
    isLoading.value = true;
    errorMessage.value = null;
    videoController?.dispose();
    videoController = null;
    currentPath.value = null;

    try {
      final media = items[currentIndex];
      final path = await _media.decryptToTemp(media);
      currentPath.value = path;

      if (media.isVideo) {
        videoController = VideoPlayerController.file(File(path))
          ..initialize().then((_) {
            videoController?.play();
            update();
          });
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void onPageChanged(int index) {
    currentIndex = index;
    _loadCurrent();
  }

  Future<void> shareCurrent() async {
    final media = items[currentIndex];
    try {
      final path = await _media.exportForShare(media);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(path)]),
      );
    } finally {
      await _media.purgeScratch();
    }
  }

  Future<void> deleteCurrent() async {
    final media = items[currentIndex];
    await _media.deleteMedia([media.id]);
    items.removeAt(currentIndex);
    if (items.isEmpty) {
      Get.back();
      return;
    }
    if (currentIndex >= items.length) {
      currentIndex = items.length - 1;
    }
    await _loadCurrent();
  }
}
