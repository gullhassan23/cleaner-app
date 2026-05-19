import 'package:cleaner_app/routes/app_pages.dart';
import 'package:cleaner_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompressRootPage extends StatelessWidget {
  const CompressRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(AppRoutes.compressNestedNavigatorId),
      initialRoute: AppRoutes.compressMain,
      onGenerateRoute: AppPages.compressOnGenerateRoute,
    );
  }
}
