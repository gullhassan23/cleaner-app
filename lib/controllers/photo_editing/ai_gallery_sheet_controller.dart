import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../services/gallery/gallery_media_service.dart';

/// Scoped to the AI editor gallery bottom sheet (put/delete around sheet lifetime).
class AiGallerySheetController extends GetxController {
  AiGallerySheetController({required this.sheetTitle});

  final String sheetTitle;

  final GalleryMediaService _gallery = Get.find<GalleryMediaService>();
  final ScrollController scroll = ScrollController();
  final assets = <AssetEntity>[].obs;
  final loading = false.obs;
  final end = false.obs;

  int _page = 0;
  static const int pageSize = 60;

  @override
  void onInit() {
    super.onInit();
    scroll.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(loadNext());
    });
  }

  @override
  void onClose() {
    scroll.removeListener(_onScroll);
    scroll.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (end.value || loading.value) return;
    if (!scroll.hasClients) return;
    final pos = scroll.position;
    if (pos.pixels > pos.maxScrollExtent - 320) {
      unawaited(loadNext());
    }
  }

  Future<void> loadNext() async {
    if (loading.value || end.value) return;
    loading.value = true;
    try {
      final batch = await _gallery.getPagedPhotoAssets(
        page: _page,
        pageSize: pageSize,
      );
      if (batch.isEmpty) {
        end.value = true;
      } else {
        assets.addAll(batch);
        _page++;
        if (batch.length < pageSize) {
          end.value = true;
        }
      }
    } finally {
      loading.value = false;
    }
  }
}
