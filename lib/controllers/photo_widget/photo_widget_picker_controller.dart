import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../services/gallery/gallery_media_service.dart';

class PhotoWidgetPickerController extends GetxController {
  PhotoWidgetPickerController({GalleryMediaService? gallery})
      : _gallery = gallery ?? Get.find<GalleryMediaService>();

  final GalleryMediaService _gallery;

  final ScrollController scroll = ScrollController();
  final assets = <AssetEntity>[].obs;
  final selectedIds = <String>{}.obs;
  final loading = false.obs;
  final end = false.obs;

  int _page = 0;
  static const int pageSize = 80;
  int maxSelection = 30;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is int && args > 0) {
      maxSelection = args;
    }
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

  void toggle(AssetEntity asset) {
    if (selectedIds.contains(asset.id)) {
      selectedIds.remove(asset.id);
      return;
    }
    if (selectedIds.length >= maxSelection) {
      Get.snackbar(
        'Limit reached',
        'You can import up to $maxSelection photos at a time.',
      );
      return;
    }
    selectedIds.add(asset.id);
  }

  void confirm() {
    final out = <AssetEntity>[];
    for (final asset in assets) {
      if (selectedIds.contains(asset.id)) {
        out.add(asset);
      }
    }
    Get.back(result: out);
  }
}
