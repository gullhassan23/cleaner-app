import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cleaner_app/controllers/vault_controller.dart';
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
            VaultShellState.setup => const VaultSetupPinPage(),
            VaultShellState.unlock => const VaultUnlockPage(),
            VaultShellState.home => const VaultHomePage(),
          },
        ),
      ),
    );
  }
}
