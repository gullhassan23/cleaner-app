import 'package:flutter/material.dart';

/// Grouped list background (iOS Settings-style).
const Color _kGroupedBackground = Color(0xFFF2F2F7);
const Color _kIOSBlue = Color(0xFF007AFF);

/// “More Tools” screen: light grouped background, centered title, white rounded rows.
class MoreToolsPage extends StatelessWidget {
  const MoreToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kGroupedBackground,
      appBar: AppBar(
        backgroundColor: _kGroupedBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: const _MoreToolsLeading(),
        title: const Text(
          'More Tools',
          style: TextStyle(
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
          _ToolCard(
            iconBackdrop: _kIOSBlue,
            title: 'Charging Animation',
            subtitle: 'Customize charging screen',
            icon: const _ChargingAnimationIcon(),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ToolCard(
            iconBackdrop: const Color(0xFFFFB020),
            title: 'Cleaning Guide',
            subtitle: 'Learn how to clean safely',
            icon: const _CleaningGuideIcon(),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _MoreToolsLeading extends StatelessWidget {
  const _MoreToolsLeading();

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    if (!navigator.canPop()) {
      return const SizedBox(width: 56);
    }
    return IconButton(
      padding: EdgeInsets.zero,
      alignment: Alignment.centerRight,
      icon: const Icon(Icons.chevron_left, color: _kIOSBlue, size: 32),
      onPressed: () => navigator.maybePop(),
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
    return Material(
      color: Colors.white,
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
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
