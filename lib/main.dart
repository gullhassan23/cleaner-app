import 'package:cleaner_app/app.dart';
import 'package:cleaner_app/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialTheme = await ThemeController.loadSaved();
  Get.put(ThemeController(initialTheme), permanent: true);
  Get.changeThemeMode(initialTheme);
  runApp(const MyApp());
}
