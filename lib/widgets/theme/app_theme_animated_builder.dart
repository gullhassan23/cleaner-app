import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/theme_controller.dart';

/// Minimal reactive scope for theme transitions.
///
/// Rebuilds only [AnimatedTheme] when [ThemeController.themeMode] changes.
/// [GetMaterialApp] stays stable so navigation and bindings are preserved.
class AppThemeAnimatedBuilder extends StatelessWidget {
  const AppThemeAnimatedBuilder({required this.child, super.key});

  final Widget? child;

  static const Duration transitionDuration = Duration(milliseconds: 350);
  static const Curve transitionCurve = Curves.easeInOutCubic;

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(
      () => AnimatedTheme(
        duration: transitionDuration,
        curve: transitionCurve,
        data: themeController.activeTheme,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
