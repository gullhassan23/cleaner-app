import 'package:cleaner_app/utils/bytes_formatter.dart';
import 'package:cleaner_app/utils/size_metric.dart';
import 'package:flutter/material.dart';

class SizeSummaryCard extends StatelessWidget {
  const SizeSummaryCard({super.key, 
    required this.originalBytes,
    required this.estimatedBytes,
    required this.savedBytes,
  });

  final int originalBytes;
  final int estimatedBytes;
  final int savedBytes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizeMetric(
                    label: 'Original',
                    value: BytesFormatter.humanize(originalBytes),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizeMetric(
                    label: 'Compressed',
                    value: BytesFormatter.humanize(estimatedBytes),
                    valueColor: const Color(0xFFD14A4A),
                    alignEnd: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Estimated savings: ${BytesFormatter.humanize(savedBytes)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}