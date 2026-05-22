
import 'package:cleaner_app/utils/colors.dart';
import 'package:cleaner_app/widgets/clean_guide/clean_pill_button.dart';
import 'package:cleaner_app/widgets/clean_guide/guide_back_button.dart';
import 'package:cleaner_app/widgets/clean_guide/guide_section_header.dart';
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
    final cs = Theme.of(context).colorScheme;
    final groupedBg = cs.groupedBackground;
    return Scaffold(
      backgroundColor: groupedBg,
      appBar: AppBar(
        backgroundColor: groupedBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leadingWidth: 88,
        leading: GuideHubBackButton(onPressed: () => Get.back<void>()),
        title: Text(
          l10n.guideTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
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
    final cardColor = Theme.of(context).colorScheme.groupedCard;
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(cardRadius),
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
            color: Theme.of(context).colorScheme.outlineVariant.withValues(
              alpha: 0.5,
            ),
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
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: rowHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: cs.accentTile,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 22, color: cs.mutedLabel),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: cs.onSurface,
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
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.groupedCard,
      borderRadius: BorderRadius.circular(cardRadius),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: rowHeight,
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: cs.onSurface,
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
