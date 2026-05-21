import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';

class VaultSecurityPage extends StatelessWidget {
  const VaultSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Change PIN'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed(AppRoutes.privateVaultChangePin),
          ),
        ],
      ),
    );
  }
}
