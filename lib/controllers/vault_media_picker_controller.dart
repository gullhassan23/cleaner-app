import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../services/gallery/gallery_media_service.dart';

class VaultMediaPickerController extends GetxController {
  final GalleryMediaService _gallery = Get.find<GalleryMediaService>();

  final ScrollController scroll = ScrollController();
  final assets = <AssetEntity>[].obs;
  final selectedIds = <String>{}.obs;
  final loading = false.obs;
  final end = false.obs;

  int _page = 0;
  static const int pageSize = 80;

  @override
  void onInit() {
    super.onInit();
    scroll.addListener(_onScroll);
    unawaited(loadNext());
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
    if (pos.pixels > pos.maxScrollExtent - 400) {
      unawaited(loadNext());
    }
  }

  Future<void> loadNext() async {
    if (loading.value || end.value) return;
    loading.value = true;
    try {
      final batch = await _gallery.getPagedMediaAssets(
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

  void toggle(AssetEntity a) {
    if (selectedIds.contains(a.id)) {
      selectedIds.remove(a.id);
    } else {
      selectedIds.add(a.id);
    }
  }

  void confirm() {
    final out = <AssetEntity>[];
    for (final a in assets) {
      if (selectedIds.contains(a.id)) {
        out.add(a);
      }
    }
    Get.back(result: out);
  }
}
