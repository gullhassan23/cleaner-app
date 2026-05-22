import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cleaner_app/routes/app_routes.dart';

class VaultSecurityPage extends StatelessWidget {
  const VaultSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.vaultSecurity)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.vaultChangePin),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed(
              AppRoutes.privateVaultChangePin,
              id: AppRoutes.vaultNestedNavigatorId,
            ),
          ),
        ],
      ),
    );
  }
}
