import 'package:cleaner_app/app.dart';
import 'package:cleaner_app/controllers/theme_controller.dart';
import 'package:cleaner_app/services/theme/theme_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ThemePreferencesService(), permanent: true);
  final initialTheme =
      await Get.find<ThemePreferencesService>().loadThemeMode();
  Get.put(
    ThemeController(
      prefs: Get.find<ThemePreferencesService>(),
      initial: initialTheme,
    ),
    permanent: true,
  );
  runApp(const MyApp());
}
