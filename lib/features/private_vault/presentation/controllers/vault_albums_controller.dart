import 'package:cleaner_app/l10n/l10n_extension.dart';
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
      const _CreateAlbumDialog(),
    );
    if (name == null || name.trim().isEmpty) return;
    await _albums.createAlbum(name);
    await load();
  }
}

class _CreateAlbumDialog extends StatelessWidget {
  const _CreateAlbumDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final controller = TextEditingController();
    return AlertDialog(
      title: Text(l10n.vaultNewAlbum),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: l10n.vaultAlbumNameHint),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () => Get.back(result: controller.text),
          child: Text(l10n.vaultCreate),
        ),
      ],
    );
  }
}
