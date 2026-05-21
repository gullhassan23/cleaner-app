import 'package:cleaner_app/controllers/applock/app_lock_controller.dart';
import 'package:cleaner_app/controllers/locale_controller.dart';
import 'package:cleaner_app/features/appLock/app_lock_unlock_view.dart';
import 'package:cleaner_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/app_binding.dart';
import 'controllers/theme_controller.dart';
import 'utils/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'widgets/theme/app_theme_animated_builder.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StableAppShell();
  }
}

/// [GetMaterialApp] is built once — navigation, bindings, and routes stay alive.
/// Theme changes are applied only inside [AppThemeAnimatedBuilder].
class _StableAppShell extends StatelessWidget {
  const _StableAppShell();

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localeController = Get.find<LocaleController>();

    return Obx(() {
      final locale = localeController.locale.value;
      final themeMode = themeController.themeMode.value;
      final direction = localeController.textDirection;
      final appTitle = lookupAppLocalizations(locale).appTitle;

      return GetMaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        initialBinding: AppBinding(),
        initialRoute: AppRoutes.main,
        getPages: AppPages.pages,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        locale: locale,
        fallbackLocale: const Locale('en'),
        supportedLocales: LocaleController.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        localeResolutionCallback: (deviceLocale, supported) {
          for (final s in supported) {
            if (s.languageCode == locale.languageCode) return s;
          }
          return supported.first;
        },
        defaultTransition: Transition.cupertino,
        builder: (context, child) => Localizations.override(
          context: context,
          locale: locale,
          child: Directionality(
            textDirection: direction,
            child: AppThemeAnimatedBuilder(
              child: _AppShell(child: child),
            ),
          ),
        ),
      );
    });
  }
}

/// App content + lock overlay. Lock state is isolated so route changes do not
/// rebuild the overlay unless lock visibility actually changes.
class _AppShell extends StatelessWidget {
  const _AppShell({required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child ?? const SizedBox.shrink(),
        const _AppLockOverlay(),
      ],
    );
  }
}

class _AppLockOverlay extends StatelessWidget {
  const _AppLockOverlay();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final lock = Get.find<AppLockController>();
      if (!lock.shouldShowLockOverlay) {
        return const SizedBox.shrink();
      }
      return const AppLockUnlockView();
    });
  }
}
