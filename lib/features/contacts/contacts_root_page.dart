import 'package:cleaner_app/routes/app_pages.dart';
import 'package:cleaner_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsRootPage extends StatelessWidget {
  const ContactsRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(AppRoutes.contactsNestedNavigatorId),
      initialRoute: AppRoutes.contactsHub,
      onGenerateRoute: AppPages.contactsOnGenerateRoute,
    );
  }
}
