import 'package:cleaner_app/features/cleaning_guide/cleanup_guide_constants.dart';
import 'package:cleaner_app/features/cleaning_guide/widgets/clean_pill_button.dart';
import 'package:cleaner_app/features/cleaning_guide/widgets/guide_back_button.dart';
import 'package:cleaner_app/features/cleaning_guide/widgets/guide_section_header.dart';
import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CleanupGuidePage extends StatelessWidget {
  const CleanupGuidePage({super.key});

  void _openFlow() => Get.toNamed<void>(AppRoutes.cleanupGuideFlow);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: CleanupGuideConstants.guideBackground,
      appBar: AppBar(
        backgroundColor: CleanupGuideConstants.guideBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leadingWidth: 88,
        leading: GuideHubBackButton(onPressed: () => Get.back<void>()),
        title: Text(
          l10n.guideTitle,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          GuideSectionHeader(label: l10n.guideSectionApps),
          _AppsGroup(onClean: _openFlow),
          const SizedBox(height: 22),
          GuideSectionHeader(label: l10n.guideSectionCache),
          _CacheAppRow(
            title: 'Tiktok',
            color: const Color(0xFF010101),
            label: 'T',
            onClean: _openFlow,
          ),
          const SizedBox(height: 10),
          _CacheAppRow(
            title: 'WhatsApp',
            color: const Color(0xFF25D366),
            label: 'W',
            onClean: _openFlow,
          ),
          const SizedBox(height: 10),
          _CacheAppRow(
            title: 'Youtube',
            color: const Color(0xFFFF0000),
            label: 'Y',
            onClean: _openFlow,
          ),
          const SizedBox(height: 10),
          _CacheAppRow(
            title: 'Snapchat',
            color: const Color(0xFFFFFC00),
            label: 'S',
            textColor: Colors.black,
            onClean: _openFlow,
          ),
          const SizedBox(height: 10),
          _CacheAppRow(
            title: 'Safari',
            color: const Color(0xFF0A84FF),
            label: 'S',
            onClean: _openFlow,
          ),
        ],
      ),
    );
  }
}

class _AppsGroup extends StatelessWidget {
  const _AppsGroup({required this.onClean});

  final VoidCallback onClean;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: CleanupGuideConstants.cardBackground,
      borderRadius: BorderRadius.circular(CleanupGuideConstants.cardRadius),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AppsRow(
            title: l10n.guideOffloadUnusedApps,
            icon: Icons.settings_outlined,
            onClean: onClean,
          ),
          Divider(
            height: 0.5,
            thickness: 0.5,
            indent: 16,
            color: Colors.black.withValues(alpha: 0.08),
          ),
          _AppsRow(
            title: l10n.guideDeleteUnusedApps,
            icon: Icons.delete_outline_rounded,
            onClean: onClean,
          ),
        ],
      ),
    );
  }
}

class _AppsRow extends StatelessWidget {
  const _AppsRow({
    required this.title,
    required this.icon,
    required this.onClean,
  });

  final String title;
  final IconData icon;
  final VoidCallback onClean;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CleanupGuideConstants.rowHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: CleanupGuideConstants.iconTileBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 22, color: const Color(0xFF8E8E93)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            CleanPillButton(onTap: onClean),
          ],
        ),
      ),
    );
  }
}

class _CacheAppRow extends StatelessWidget {
  const _CacheAppRow({
    required this.title,
    required this.color,
    required this.label,
    required this.onClean,
    this.textColor = Colors.white,
  });

  final String title;
  final Color color;
  final String label;
  final Color textColor;
  final VoidCallback onClean;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CleanupGuideConstants.cardBackground,
      borderRadius: BorderRadius.circular(CleanupGuideConstants.cardRadius),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: CleanupGuideConstants.rowHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              CleanPillButton(onTap: onClean),
            ],
          ),
        ),
      ),
    );
  }
}
