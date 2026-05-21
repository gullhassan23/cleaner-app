import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../controllers/vault_settings_controller.dart';

class VaultSettingsPage extends GetView<VaultSettingsController> {
  const VaultSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final groupedBg = Theme.of(context).colorScheme.surfaceContainerLow;
    return Scaffold(
      backgroundColor: groupedBg,
      appBar: AppBar(
        title: const Text('Vault Settings'),
        backgroundColor: groupedBg,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Remove After Import'),
              subtitle: const Text(
                'Delete originals from gallery after successful import',
              ),
              value: controller.removeAfterImport.value,
              onChanged: controller.setRemoveAfterImport,
            ),
            if (controller.canUseBiometrics.value)
              SwitchListTile(
                title: const Text('Use Face ID / Fingerprint'),
                value: controller.biometricEnabled.value,
                onChanged: controller.setBiometric,
              ),
            ListTile(
              title: const Text('Albums'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed(
                AppRoutes.privateVaultAlbums,
                id: AppRoutes.vaultNestedNavigatorId,
              ),
            ),
            ListTile(
              title: const Text('Security'),
              trailing: const Icon(Icons.chevron_right),
              onTap: controller.openSecurity,
            ),
            ListTile(
              title: const Text('Lock Vault Now'),
              onTap: controller.lockNow,
            ),
          ],
        );
      }),
    );
  }
}
