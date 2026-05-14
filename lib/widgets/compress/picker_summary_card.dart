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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Select media to compress', style: theme.textTheme.titleLarge),
                ),
                if (isLimited)
                  TextButton.icon(
                    onPressed: onManageAccess,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Manage access'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Pick one or more images/videos, then continue to quality selection and compression.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                MetricChip(label: 'Visible items', value: '$totalCount'),
                MetricChip(label: 'Selected', value: '$selectedCount'),
                MetricChip(
                  label: 'Selected size',
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