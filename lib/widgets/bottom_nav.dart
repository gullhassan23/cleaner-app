import 'package:cleaner_app/features/cleaner/cleaner_dashboard_page.dart';

import 'package:cleaner_app/features/compress/compress_main_screen.dart';
import 'package:cleaner_app/features/contacts/contacts_root_page.dart';
import 'package:cleaner_app/features/more/more_settting.dart';
import 'package:cleaner_app/controllers/main_shell_controller.dart';
import 'package:cleaner_app/features/vault/vault_root_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Matches reference app bottom bar accent colors.
const Color _kNavBlue = Color(0xFF4A89F3);
const Color _kNavOrange = Color(0xFFFF9500);
const Color _kNavPurple = Color(0xFFAF52DE);
const Color _kNavGrey = Color(0xFF8E8E93);
const Color _kNavBarFill = Color(0x1A4A89F3);

class MainShellPage extends GetView<MainShellController> {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      extendBody: true,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            const CleanerDashboardPage(),
            Obx(
              () =>
                  controller.contactsNavigatorReady.value
                      ? const ContactsRootPage()
                      : const SizedBox.shrink(),
            ),
            const CompressMainScreen(),
            Obx(() {
              if (!controller.vaultTabReady.value) {
                if (controller.currentIndex.value == 3) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const SizedBox.shrink();
              }
              return const VaultRootPage();
            }),
            const MoreToolsPage(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(14, 0, 14, 10 + bottomInset),
        child: Obx(() {
          final idx = controller.currentIndex.value;
          return _FloatingBottomBar(controller: controller, selectedIndex: idx);
        }),
      ),
    );
  }
}

class _FloatingBottomBar extends StatelessWidget {
  const _FloatingBottomBar({
    required this.controller,
    required this.selectedIndex,
  });

  final MainShellController controller;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final idx = selectedIndex;

    final scheme = Theme.of(context).colorScheme;
    final barFill =
        scheme.brightness == Brightness.dark
            ? scheme.surfaceContainerHigh.withValues(alpha: 0.94)
            : _kNavBarFill;

    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: barFill,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: scheme.brightness == Brightness.dark ? 0.35 : 0.06,
              ),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              _NavCell(
                label: 'Clean',
                selected: idx == 0,
                icon: Icons.delete_rounded,
                selectedColor: _kNavBlue,
                idleColor: _kNavGrey,
                onTap: () => controller.selectTab(0),
              ),
              _NavCell(
                label: 'Contacts',
                selected: idx == 1,
                icon: Icons.person_rounded,
                selectedColor: _kNavBlue,
                idleColor: _kNavOrange,
                onTap: () => controller.selectTab(1),
              ),
              _NavCell(
                label: 'Compress',
                selected: idx == 2,
                icon: Icons.video_camera_back_rounded,
                selectedColor: _kNavBlue,
                idleColor: _kNavPurple,
                onTap: () => controller.selectTab(2),
              ),
              _NavCell(
                label: 'Vault',
                selected: idx == 3,
                icon: Icons.lock_rounded,
                selectedColor: _kNavBlue,
                idleColor: _kNavBlue,
                onTap: () => controller.selectTab(3),
              ),
              _NavCell(
                label: 'More',
                selected: idx == 4,
                icon: Icons.grid_view_rounded,
                selectedColor: _kNavBlue,
                idleColor: _kNavPurple,
                onTap: () => controller.selectTab(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef _IconBuilder = Widget Function(Color color, double size);

class _NavCell extends StatelessWidget {
  const _NavCell({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.idleColor,
    required this.onTap,
    this.icon,
    this.iconBuilder,
  }) : assert(icon != null || iconBuilder != null);

  final String label;
  final bool selected;
  final IconData? icon;
  final _IconBuilder? iconBuilder;
  final Color selectedColor;
  final Color idleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const iconSize = 22.0;
    final iconColor = selected ? selectedColor : idleColor;
    final labelColor = selected ? selectedColor : _kNavGrey;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      selected
                          ? selectedColor.withValues(alpha: 0.18)
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child:
                      iconBuilder != null
                          ? iconBuilder!(iconColor, iconSize)
                          : Icon(icon, size: iconSize, color: iconColor),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: labelColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
