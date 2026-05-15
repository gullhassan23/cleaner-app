import 'package:cleaner_app/modules/app_lock/controllers/app_lock_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _kGroupedBg = Color(0xFFF2F2F7);
const _kSectionLabel = Color(0xFF8E8E93);
const _kIosBlue = Color(0xFF007AFF);
const _kChevron = Color(0xFFC7C7CC);
const _kDivider = Color(0xFFC6C6C8);
const _kRowLabel = Color(0xFF000000);

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
    return Scaffold(
      backgroundColor: _kGroupedBg,
      appBar: AppBar(
        backgroundColor: _kGroupedBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leadingWidth: 88,
        leading: _SettingsBackButton(onPressed: () => Navigator.maybePop(context)),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: _kRowLabel,
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
          const _SectionHeader(label: 'CUSTOM SETTINGS'),
          const SizedBox(height: 6),
          _SettingsGroup(
            children: [
              _SettingsNavRow(label: 'Photo Widget', onTap: () {}),
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
  }
}

class _SettingsBackButton extends StatelessWidget {
  const _SettingsBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CupertinoButton(
        padding: const EdgeInsets.only(left: 4),
        minSize: 0,
        onPressed: onPressed,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.back, size: 22, color: _kIosBlue),
            SizedBox(width: 2),
            Text(
              'Back',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: _kIosBlue,
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
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: _kSectionLabel,
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              const Divider(
                height: 0.5,
                thickness: 0.5,
                indent: 16,
                color: _kDivider,
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
    return Material(
      color: Colors.white,
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
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: _kRowLabel,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                const Icon(
                  CupertinoIcons.chevron_forward,
                  size: 18,
                  color: _kChevron,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: _kRowLabel,
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
