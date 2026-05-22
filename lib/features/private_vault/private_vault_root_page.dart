import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cleaner_app/routes/app_pages.dart';
import 'package:cleaner_app/routes/app_routes.dart';

class PrivateVaultRootPage extends StatelessWidget {
  const PrivateVaultRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(AppRoutes.vaultNestedNavigatorId),
      initialRoute: AppRoutes.privateVaultGate,
      onGenerateRoute: AppPages.privateVaultOnGenerateRoute,
    );
  }
}
