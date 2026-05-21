// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/utils/colors.dart';
import 'package:flutter/material.dart';

import 'package:cleaner_app/models/photo_library/scan_state_entity.dart';

class PermissionBody extends StatelessWidget {
  const PermissionBody({
    super.key,
    required this.permission,
    required this.onRequest,
    required this.onOpenSettings,
    required this.onManageLimited,
  });

  final PermissionStateEntity permission;
  final Future<void> Function() onRequest;
  final Future<void> Function() onOpenSettings;
  final Future<void> Function() onManageLimited;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLimited = permission.isLimited;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.photo_library_outlined, size: 56, color: kDashBlue),
              const SizedBox(height: 16),
              Text(
                isLimited
                    ? context.l10n.permissionLimitedLibraryAccess
                    : context.l10n.permissionAllowPhotosVideos,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isLimited
                    ? context.l10n.permissionLimitedBody
                    : context.l10n.permissionFullBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),
              if (isLimited) ...[
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: kDashBlue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: onManageLimited,
                  child: Text(context.l10n.permissionManageLibraryAccess),
                ),
                const SizedBox(height: 10),
              ],
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: kDashBlue,
                  foregroundColor: Colors.white,
                ),
                onPressed: onRequest,
                child: Text(
                  isLimited
                      ? context.l10n.permissionRefreshAccess
                      : context.l10n.commonContinue,
                ),
              ),
              if (permission.needsSettings) ...[
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: onOpenSettings,
                  child: Text(context.l10n.permissionOpenSettings),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
