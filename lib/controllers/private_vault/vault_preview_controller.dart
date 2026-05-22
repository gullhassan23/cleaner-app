import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import 'package:cleaner_app/routes/app_routes.dart';
import 'package:cleaner_app/models/private_vault/vault_constants.dart';
import 'package:cleaner_app/models/private_vault/vault_media.dart';
import 'package:cleaner_app/services/private_vault/vault_media_repository.dart';

class VaultPreviewController extends GetxController {
  VaultPreviewController();

  final VaultMediaRepository _media = Get.find();

  List<VaultMedia> items = [];
  int currentIndex = 0;

  final isLoading = true.obs;
  final errorMessage = RxnString();
  final currentPath = RxnString();

  VideoPlayerController? videoController;
  PageController? pageController;

  bool _initialized = false;

  @override
  void onReady() {
    super.onReady();
    if (!_initialized) {
      _initialized = true;
      _bootstrap();
    }
  }

  @override
  void onClose() {
    pageController?.dispose();
    videoController?.dispose();
    _cleanup();
    super.onClose();
  }

  Future<void> _cleanup() async {
    await _media.purgeScratch();
  }

  Map<String, dynamic> _routeArgs() {
    final fromGet = Get.arguments;
    if (fromGet is Map<String, dynamic>) return fromGet;
    if (fromGet is Map) return Map<String, dynamic>.from(fromGet);

    final context = Get.context;
    if (context != null) {
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      if (routeArgs is Map<String, dynamic>) return routeArgs;
      if (routeArgs is Map) return Map<String, dynamic>.from(routeArgs);
    }
    return {};
  }

  List<VaultMedia> _parseItems(dynamic raw) {
    if (raw is List<VaultMedia>) return List<VaultMedia>.from(raw);
    if (raw is List) return raw.whereType<VaultMedia>().toList();
    return [];
  }

  Future<void> _bootstrap() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final args = _routeArgs();
      final albumId = args['albumId'] as String? ?? VaultConstants.defaultAlbumId;
      final mediaId = args['mediaId'] as String?;
      var index = args['index'] as int? ?? 0;

      items = _parseItems(args['items']);
      if (items.isEmpty) {
        items = await _loadAllForAlbum(albumId);
      }

      if (items.isEmpty) {
        errorMessage.value = 'No media to preview';
        return;
      }

      if (mediaId != null) {
        final byId = items.indexWhere((m) => m.id == mediaId);
        if (byId >= 0) index = byId;
      }

      currentIndex = index.clamp(0, items.length - 1);
      pageController?.dispose();
      pageController = PageController(initialPage: currentIndex);
      await _loadCurrent();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<VaultMedia>> _loadAllForAlbum(String albumId) async {
    final all = <VaultMedia>[];
    var offset = 0;
    while (true) {
      final page = await _media.getPage(
        albumId: albumId,
        offset: offset,
        limit: VaultConstants.mediaPageSize,
      );
      all.addAll(page.items);
      if (!page.hasMore) break;
      offset += page.items.length;
    }
    return all;
  }

  Future<void> _loadCurrent() async {
    if (items.isEmpty) return;

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
    if (items.isEmpty) return;
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
    if (items.isEmpty) return;
    final media = items[currentIndex];
    await _media.deleteMedia([media.id]);
    items.removeAt(currentIndex);
    if (items.isEmpty) {
      Get.back(id: AppRoutes.vaultNestedNavigatorId);
      return;
    }
    if (currentIndex >= items.length) {
      currentIndex = items.length - 1;
    }
    pageController?.jumpToPage(currentIndex);
    await _loadCurrent();
  }
}
