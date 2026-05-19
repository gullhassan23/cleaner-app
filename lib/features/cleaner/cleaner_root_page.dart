import 'package:cleaner_app/routes/app_pages.dart';
import 'package:cleaner_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CleanerRootPage extends StatelessWidget {
  const CleanerRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(AppRoutes.cleanerNestedNavigatorId),
      initialRoute: AppRoutes.cleanerDashboard,
      onGenerateRoute: AppPages.cleanerOnGenerateRoute,
    );
  }
}
