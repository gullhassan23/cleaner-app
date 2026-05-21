import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/vault_album.dart';
import '../../domain/repositories/vault_album_repository.dart';

class VaultAlbumsController extends GetxController {
  final VaultAlbumRepository _albums = Get.find();

  final albums = <VaultAlbum>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      await _albums.ensureDefaultAlbum();
      albums.value = await _albums.getAlbums();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createAlbum() async {
    final name = await Get.dialog<String>(
      _CreateAlbumDialog(),
    );
    if (name == null || name.trim().isEmpty) return;
    await _albums.createAlbum(name);
    await load();
  }
}

class _CreateAlbumDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return AlertDialog(
      title: const Text('New Album'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Album name'),
        autofocus: true,
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        TextButton(
          onPressed: () => Get.back(result: controller.text),
          child: const Text('Create'),
        ),
      ],
    );
  }
}
