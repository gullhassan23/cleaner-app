import 'package:cleaner_app/models/compress/compress_entities.dart';
import 'package:flutter/material.dart';

class CompressionProgressCard extends StatelessWidget {
  const CompressionProgressCard({super.key, required this.progress});

  final CompressionProgressEntity progress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Compression progress',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  '${progress.overallPercent}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              progress.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value:
                  progress.phase == CompressionPhase.running ||
                          progress.phase == CompressionPhase.completed
                      ? progress.progress
                      : 0,
              minHeight: 9,
              borderRadius: BorderRadius.circular(999),
            ),
            const SizedBox(height: 10),
            if (progress.currentFileLabel != null) ...[
              Text(
                'Current file: ${progress.currentFileLabel}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value:
                    progress.phase == CompressionPhase.running ||
                            progress.phase == CompressionPhase.completed
                        ? progress.currentFileProgress.clamp(0.0, 1.0)
                        : 0,
                minHeight: 7,
                borderRadius: BorderRadius.circular(999),
              ),
              const SizedBox(height: 6),
              Text(
                'Current file progress: ${progress.currentFilePercent}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              '${progress.processedCount} of ${progress.totalCount} done • ${progress.remainingCount} remaining',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}