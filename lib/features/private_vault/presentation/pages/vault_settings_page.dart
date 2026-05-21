import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../controllers/vault_settings_controller.dart';

class VaultSettingsPage extends GetView<VaultSettingsController> {
  const VaultSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final groupedBg = Theme.of(context).colorScheme.surfaceContainerLow;
    return Scaffold(
      backgroundColor: groupedBg,
      appBar: AppBar(
        title: Text(l10n.vaultSettings),
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
              title: Text(l10n.vaultRemoveAfterImport),
              subtitle: Text(l10n.vaultRemoveAfterImportSubtitle),
              value: controller.removeAfterImport.value,
              onChanged: controller.setRemoveAfterImport,
            ),
            if (controller.canUseBiometrics.value)
              SwitchListTile(
                title: Text(l10n.vaultUseFaceIdFingerprint),
                value: controller.biometricEnabled.value,
                onChanged: controller.setBiometric,
              ),
            ListTile(
              title: Text(l10n.vaultAlbums),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed(
                AppRoutes.privateVaultAlbums,
                id: AppRoutes.vaultNestedNavigatorId,
              ),
            ),
            ListTile(
              title: Text(l10n.vaultSecurity),
              trailing: const Icon(Icons.chevron_right),
              onTap: controller.openSecurity,
            ),
            ListTile(
              title: Text(l10n.vaultLockNow),
              onTap: controller.lockNow,
            ),
          ],
        );
      }),
    );
  }
}
