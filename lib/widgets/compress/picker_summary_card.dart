import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/utils/bytes_formatter.dart';
import 'package:cleaner_app/widgets/compress/metric_card.dart';
import 'package:flutter/material.dart';

class PickerSummaryCard extends StatelessWidget {
  const PickerSummaryCard({super.key, 
    required this.totalCount,
    required this.selectedCount,
    required this.selectedBytes,
    required this.isLimited,
    this.onManageAccess,
  });

  final int totalCount;
  final int selectedCount;
  final int selectedBytes;
  final bool isLimited;
  final VoidCallback? onManageAccess;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.compressSelectMediaTitle,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                if (isLimited)
                  TextButton.icon(
                    onPressed: onManageAccess,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(l10n.compressManageAccess),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.compressSelectMediaBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                MetricChip(
                  label: l10n.compressVisibleItems,
                  value: '$totalCount',
                ),
                MetricChip(label: l10n.compressSelected, value: '$selectedCount'),
                MetricChip(
                  label: l10n.compressSelectedSize,
                  value: BytesFormatter.humanize(selectedBytes),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}