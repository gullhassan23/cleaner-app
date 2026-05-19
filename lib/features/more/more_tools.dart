import 'package:cleaner_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// “More Tools” screen: grouped list, centered title, rounded rows.
class MoreToolsPage extends StatelessWidget {
  const MoreToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final groupedBg = scheme.surfaceContainerLow;

    return Scaffold(
      backgroundColor: groupedBg,
      appBar: AppBar(
        backgroundColor: groupedBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        title: Text(
          'More Tools',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _ToolCard(
            iconBackdrop: scheme.primary,
            title: 'Charging Animation',
            subtitle: 'Customize charging screen',
            icon: const _ChargingAnimationIcon(),
            onTap: () => Get.toNamed<void>(AppRoutes.chargingHome),
          ),
          const SizedBox(height: 12),
          _ToolCard(
            iconBackdrop: const Color(0xFFFFB020),
            title: 'Cleaning Guide',
            subtitle: 'Learn how to clean safely',
            icon: const _CleaningGuideIcon(),
            onTap: () => Get.toNamed<void>(AppRoutes.cleanupGuide),
          ),
        ],
      ),
    );
  }
}

class _ChargingAnimationIcon extends StatelessWidget {
  const _ChargingAnimationIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.battery_charging_full_rounded,
      color: Colors.white,
      size: 28,
    );
  }
}

class _CleaningGuideIcon extends StatelessWidget {
  const _CleaningGuideIcon();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        const Icon(Icons.menu_book_rounded, color: Colors.white, size: 26),
        Positioned(
          top: -4,
          right: 2,
          child: Container(
            width: 9,
            height: 7,
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.iconBackdrop,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  final Color iconBackdrop;
  final String title;
  final String subtitle;
  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconBackdrop,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: icon,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: scheme.onSurfaceVariant,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
