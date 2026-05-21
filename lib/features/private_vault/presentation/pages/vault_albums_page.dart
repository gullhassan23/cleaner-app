import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/vault_albums_controller.dart';

class VaultAlbumsPage extends GetView<VaultAlbumsController> {
  const VaultAlbumsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: controller.createAlbum,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.albums.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final album = controller.albums[index];
            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              title: Text(album.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.back(result: album.id),
            );
          },
        );
      }),
    );
  }
}
