import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/app_binding.dart';
import 'controllers/theme_controller.dart';
import 'modules/app_lock/controllers/app_lock_controller.dart';
import 'modules/app_lock/views/app_lock_unlock_view.dart';
import 'utils/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return GetMaterialApp(
      title: 'Cleaner App',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.main,
      getPages: AppPages.pages,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.themeMode.value,
      defaultTransition: Transition.cupertino,
      builder: (context, child) {
        return Obx(() {
          final lock = Get.find<AppLockController>();
          return Stack(
            fit: StackFit.expand,
            children: [
              child ?? const SizedBox.shrink(),
              if (lock.shouldShowLockOverlay) const AppLockUnlockView(),
            ],
          );
        });
      },
    );
  }
}
