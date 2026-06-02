import 'package:cleaner_app/app.dart';
import 'package:cleaner_app/controllers/locale_controller.dart';
import 'package:cleaner_app/controllers/theme_controller.dart';
import 'package:cleaner_app/services/locale/locale_preferences_service.dart';
import 'package:cleaner_app/services/theme/theme_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: 'lib/.env');
  } catch (_) {}
  Get.put(ThemePreferencesService(), permanent: true);
  Get.put(LocalePreferencesService(), permanent: true);
  final initialTheme =
      await Get.find<ThemePreferencesService>().loadThemeMode();
  final initialLocale = await Get.find<LocalePreferencesService>().loadLocale();
  Get.put(
    ThemeController(
      prefs: Get.find<ThemePreferencesService>(),
      initial: initialTheme,
    ),
    permanent: true,
  );
  Get.put(
    LocaleController(
      prefs: Get.find<LocalePreferencesService>(),
      initial: initialLocale,
    ),
    permanent: true,
  );
  runApp(const MyApp());
}
