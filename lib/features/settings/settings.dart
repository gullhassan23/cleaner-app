import 'package:cleaner_app/controllers/theme_controller.dart';
import 'package:cleaner_app/modules/app_lock/controllers/app_lock_controller.dart';
import 'package:cleaner_app/modules/photo_widget/bindings/photo_widget_binding.dart';
import 'package:cleaner_app/modules/photo_widget/controllers/photo_widget_controller.dart';
import 'package:cleaner_app/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// iOS-style grouped Settings screen (reference layout).
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _usePasscode = false;
  bool _removeAfterImport = false;
  bool _faceId = false;

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      // Rebuild when appearance changes so [Theme.of] picks up the new mode.
      themeController.themeMode.value;
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
          leadingWidth: 88,
          leading: _SettingsBackButton(
            onPressed: () => Navigator.maybePop(context),
          ),
          title: Text(
            'Settings',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
              letterSpacing: -0.4,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            const _SectionHeader(label: 'UPGRADE'),
            const SizedBox(height: 6),
            _SettingsGroup(
              children: [
                _SettingsNavRow(
                  label: 'Restore Purchases',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 22),
            const _SectionHeader(label: 'PRIVATE PHOTO SETTINGS'),
            const SizedBox(height: 6),
            _SettingsGroup(
              children: [
                _SettingsToggleRow(
                  label: 'Use Passcode',
                  value: _usePasscode,
                  onChanged: (v) => setState(() => _usePasscode = v),
                ),
                _SettingsToggleRow(
                  label: 'Remove After Import',
                  value: _removeAfterImport,
                  onChanged: (v) => setState(() => _removeAfterImport = v),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const _SectionHeader(label: 'APPEARANCE'),
            const SizedBox(height: 6),
            const _SettingsGroup(
              children: [
                _ThemeModePicker(),
              ],
            ),
            const SizedBox(height: 22),
            const _SectionHeader(label: 'CUSTOM SETTINGS'),
            const SizedBox(height: 6),
            _SettingsGroup(
              children: [
                _SettingsNavRow(
                  label: 'Photo Widget',
                  onTap: () {
                    PhotoWidgetBinding().dependencies();
                    Get.toNamed(AppRoutes.photoWidgetHub);
                  },
                ),
                const _PhotoWidgetEnableToggleRow(),
                _SettingsToggleRow(
                  label: 'Face ID',
                  value: _faceId,
                  onChanged: (v) => setState(() => _faceId = v),
                ),
                const _AppLockToggleRow(),
                _SettingsNavRow(label: 'Languages', onTap: () {}),
              ],
            ),
            const SizedBox(height: 22),
            const _SectionHeader(label: 'OTHERS'),
            const SizedBox(height: 6),
            _SettingsGroup(
              children: [
                _SettingsNavRow(label: 'Get Help', onTap: () {}),
                _SettingsNavRow(label: 'Rate 5 Stars', onTap: () {}),
                _SettingsNavRow(label: 'Share With Friends', onTap: () {}),
                _SettingsNavRow(label: 'About Us', onTap: () {}),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _SettingsBackButton extends StatelessWidget {
  const _SettingsBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Align(
      alignment: Alignment.centerLeft,
      child: CupertinoButton(
        padding: const EdgeInsets.only(left: 4),
        minSize: 0,
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.back, size: 22, color: primary),
            const SizedBox(width: 2),
            Text(
              'Back',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: primary,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: scheme.onSurfaceVariant,
          letterSpacing: -0.08,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Divider(
                height: 0.5,
                thickness: 0.5,
                indent: 16,
                color: scheme.outlineVariant,
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _SettingsNavRow extends StatelessWidget {
  const _SettingsNavRow({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: scheme.onSurface,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                Icon(
                  CupertinoIcons.chevron_forward,
                  size: 18,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeModePicker extends StatelessWidget {
  const _ThemeModePicker();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ThemeController>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Obx(
        () => SegmentedButton<ThemeMode>(
          style: SegmentedButton.styleFrom(
            visualDensity: VisualDensity.compact,
            textStyle: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          showSelectedIcon: false,
          segments: const [
            ButtonSegment<ThemeMode>(
              value: ThemeMode.light,
              label: Text('Light'),
              icon: Icon(Icons.light_mode_outlined, size: 18),
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.dark,
              label: Text('Dark'),
              icon: Icon(Icons.dark_mode_outlined, size: 18),
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.system,
              label: Text('System'),
              icon: Icon(Icons.brightness_auto_outlined, size: 18),
            ),
          ],
          selected: {c.themeMode.value},
          multiSelectionEnabled: false,
          emptySelectionAllowed: false,
          onSelectionChanged: (next) {
            if (next.isEmpty) return;
            final picked = next.first;
            if (picked == c.themeMode.value) return;
            c.setThemeMode(picked);
          },
        ),
      ),
    );
  }
}

class _PhotoWidgetEnableToggleRow extends StatelessWidget {
  const _PhotoWidgetEnableToggleRow();

  @override
  Widget build(BuildContext context) {
    PhotoWidgetBinding().dependencies();
    final controller = Get.find<PhotoWidgetController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return _SettingsToggleRow(
          label: 'Photo Widget Enabled',
          value: false,
          onChanged: null,
        );
      }
      return _SettingsToggleRow(
        label: 'Photo Widget Enabled',
        value: controller.isEnabled,
        onChanged: controller.isSyncing.value
            ? null
            : (enabled) async {
                if (enabled) {
                  if (!controller.hasWidgetContent) {
                    Get.snackbar(
                      'No photos',
                      'Create an album and import photos first.',
                    );
                    Get.toNamed(AppRoutes.photoWidgetHub);
                    return;
                  }
                }
                final ok = await controller.setEnabled(enabled);
                if (enabled && !ok) {
                  Get.snackbar(
                    'Cannot enable',
                    'Add photos to your widget album first.',
                  );
                }
              },
      );
    });
  }
}

class _AppLockToggleRow extends StatelessWidget {
  const _AppLockToggleRow();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppLockController>();
    return Obx(() {
      final enabled = controller.isEnabled.value;
      final loading = controller.isLoading.value;
      return _SettingsToggleRow(
        label: 'App Lock',
        value: enabled,
        onChanged: loading ? null : (v) => controller.onToggleRequested(v),
      );
    });
  }
}

class _SettingsToggleRow extends StatelessWidget {
  const _SettingsToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: scheme.onSurface,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            CupertinoSwitch(
              value: value,
              activeTrackColor: const Color(0xFF34C759),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
