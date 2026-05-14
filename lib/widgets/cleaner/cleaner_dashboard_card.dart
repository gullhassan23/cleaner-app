import 'package:cleaner_app/models/cleaner/cleaner_dashboard_kind.dart';
import 'package:cleaner_app/models/photo_library/photo_asset_entity.dart';
import 'package:cleaner_app/utils/bytes_formatter.dart';
import 'package:flutter/material.dart';

import 'cleaner_thumbnail.dart';

class CleanerDashboardCard extends StatelessWidget {
  const CleanerDashboardCard({
    super.key,
    required this.type,
    required this.count,
    required this.totalBytes,
    required this.preview,
    required this.onTap,
  });

  final CleanerDashboardKind type;
  final int count;
  final int totalBytes;
  final PhotoAssetEntity? preview;
  final VoidCallback onTap;

  String get _title {
    switch (type) {
      case CleanerDashboardKind.similarPhotos:
        return 'Similar Photos';
      case CleanerDashboardKind.duplicatePhotos:
        return 'Duplicate Photos';
      case CleanerDashboardKind.videos:
        return 'Videos';
      case CleanerDashboardKind.screenshots:
        return 'Screenshots';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: count == 0 ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 88,
                height: 88,
                child:
                    preview == null
                        ? DecoratedBox(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.photo_library_outlined,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        )
                        : CleanerThumbnail(
                          asset: preview!,
                          size: 88,
                          borderRadius: 14,
                        ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$count items',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      BytesFormatter.humanize(totalBytes),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
