import 'package:cleaner_app/controllers/theme_controller.dart';
import 'package:cleaner_app/controllers/applock/app_lock_controller.dart';
import 'package:cleaner_app/bindings/photo_widget_binding.dart';
import 'package:cleaner_app/services/private_vault/vault_auth_service.dart';
import 'package:cleaner_app/bindings/private_vault_binding.dart';
import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/routes/app_routes.dart';
import 'package:cleaner_app/utils/common_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// iOS-style grouped Settings screen (reference layout)
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _usePasscode = false;
  bool _removeAfterImport = false;

  @override
  void initState() {
    super.initState();
    _loadVaultPrefs();
  }

  Future<void> _loadVaultPrefs() async {
    try {
      PrivateVaultBinding().dependencies();
      final auth = Get.find<VaultAuthService>();
      final enabled = await auth.isEnabled();
      final remove = await auth.getRemoveAfterImport();
      if (mounted) {
        setState(() {
          _usePasscode = enabled;
          _removeAfterImport = remove;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
        leadingWidth: 80,
        leading: _SettingsBackButton(
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          l10n.settingsTitle,
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
          _SectionHeader(label: l10n.settingsSectionUpgrade),
          const SizedBox(height: 6),
          _SettingsGroup(
            children: [
              _SettingsNavRow(
                label: l10n.settingsRestorePurchases,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 22),
          _SectionHeader(label: l10n.settingsSectionPrivatePhoto),
          const SizedBox(height: 6),
          _SettingsGroup(
            children: [
              _SettingsNavRow(
                label: l10n.settingsPrivateVault,
                onTap: () => Get.toNamed(AppRoutes.privateVaultRoot),
              ),
              _SettingsToggleRow(
                label: l10n.settingsUsePasscode,
                value: _usePasscode,
                onChanged: (v) {
                  Get.toNamed(AppRoutes.privateVaultRoot);
                  setState(() => _usePasscode = v);
                },
              ),
              _SettingsToggleRow(
                label: l10n.settingsRemoveAfterImport,
                value: _removeAfterImport,
                onChanged: (v) async {
                  try {
                    PrivateVaultBinding().dependencies();
                    await Get.find<VaultAuthService>().setRemoveAfterImport(v);
                  } catch (_) {}
                  setState(() => _removeAfterImport = v);
                },
              ),
            ],
          ),
          const SizedBox(height: 22),
          _SectionHeader(label: l10n.settingsSectionCustom),
          const SizedBox(height: 6),
          _SettingsGroup(
            children: [
              _SettingsNavRow(
                label: l10n.settingsPhotoWidget,
                onTap: () {
                  PhotoWidgetBinding().dependencies();
                  Get.toNamed(AppRoutes.photoWidgetHub);
                },
              ),
              // _SettingsToggleRow(
              //   label: l10n.settingsFaceId,
              //   value: _faceId,
              //   onChanged: (v) => setState(() => _faceId = v),
              // ),
              const _DarkModeToggleRow(),
              const _AppLockToggleRow(),
              _SettingsNavRow(
                label: l10n.settingsLanguages,
                onTap: () => Get.toNamed(AppRoutes.languagePicker),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _SectionHeader(label: l10n.settingsSectionOthers),
          const SizedBox(height: 6),
          _SettingsGroup(
            children: [
              _SettingsNavRow(label: l10n.settingsRate5Stars, onTap: () {}),
              _SettingsNavRow(
                label: l10n.settingsShareWithFriends,
                onTap: () => shareAppLink(context),
              ),

              _SettingsNavRow(
                label: l10n.settingsTermsAndConditions,
                onTap: () => openTermsAndConditions(context),
              ),
              _SettingsNavRow(
                label: l10n.settingsPrivacyPolicy,
                onTap: () => openPrivacyPolicy(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsBackButton extends StatelessWidget {
  const _SettingsBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final l10n = context.l10n;

    return Align(
      alignment: Alignment.centerLeft,
      child: CupertinoButton(
        padding: const EdgeInsets.only(left: 10),
        minSize: 0,
        onPressed: onPressed,
        child: Text(
          l10n.commonBack,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: primary,
            letterSpacing: -0.4,
          ),
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
                  Icons.chevron_right,
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

class _DarkModeToggleRow extends StatelessWidget {
  const _DarkModeToggleRow();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ThemeController>();
    final l10n = context.l10n;
    return Obx(
      () => _SettingsToggleRow(
        label: l10n.settingsThemeMode,
        value: c.isDarkMode,
        onChanged: c.setDarkModeEnabled,
      ),
    );
  }
}

class _AppLockToggleRow extends StatelessWidget {
  const _AppLockToggleRow();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppLockController>();
    final l10n = context.l10n;
    return Obx(() {
      final enabled = controller.isEnabled.value;
      final loading = controller.isLoading.value;
      return _SettingsToggleRow(
        label: l10n.settingsAppLock,
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
              activeTrackColor: scheme.primary,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
