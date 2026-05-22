import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VaultImportBottomSheet extends StatelessWidget {
  const VaultImportBottomSheet({
    super.key,
    required this.onCamera,
    required this.onGallery,
  });

  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _OptionTile(
            icon: Icons.camera_alt_rounded,
            label: l10n.vaultTakePhotoOrVideo,
            onTap: onCamera,
          ),
          const SizedBox(height: 12),
          _OptionTile(
            icon: Icons.photo_library_rounded,
            label: l10n.vaultImportPhotosOrVideos,
            onTap: onGallery,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Get.back(),
            child: Text(l10n.commonCancel),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: cs.onPrimary, size: 22),
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
