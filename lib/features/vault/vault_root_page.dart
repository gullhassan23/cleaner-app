import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cleaner_app/controllers/vault_controller.dart';
import 'package:cleaner_app/controllers/vault_setup_pin_controller.dart';
import 'package:cleaner_app/features/vault/pages/vault_home_page.dart';
import 'package:cleaner_app/features/vault/pages/vault_setup_pin_page.dart';
import 'package:cleaner_app/features/vault/pages/vault_unlock_page.dart';

class VaultRootPage extends GetView<VaultController> {
  const VaultRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Obx(
          () => switch (controller.shell.value) {
            VaultShellState.setup => const _VaultSetupPinHost(),
            VaultShellState.unlock => const VaultUnlockPage(),
            VaultShellState.home => const VaultHomePage(),
          },
        ),
      ),
    );
  }
}

/// Owns [VaultSetupPinController] for the duration the vault shell is on setup.
class _VaultSetupPinHost extends StatefulWidget {
  const _VaultSetupPinHost();

  @override
  State<_VaultSetupPinHost> createState() => _VaultSetupPinHostState();
}

class _VaultSetupPinHostState extends State<_VaultSetupPinHost> {
  @override
  void initState() {
    super.initState();
    Get.put(VaultSetupPinController());
  }

  @override
  void dispose() {
    if (Get.isRegistered<VaultSetupPinController>()) {
      Get.delete<VaultSetupPinController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const VaultSetupPinPage();
  }
}
