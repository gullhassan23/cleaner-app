import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/models/compress/compress_entities.dart';
import 'package:flutter/material.dart';

class CompressionProgressCard extends StatelessWidget {
  const CompressionProgressCard({super.key, required this.progress});

  final CompressionProgressEntity progress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                    l10n.compressCompressionProgress,
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
              progress.label.isEmpty && progress.phase == CompressionPhase.idle
                  ? l10n.compressReadyToCompress
                  : progress.label,
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

            // if (progress.currentFileLabel != null) ...[
            //   Text(
            //     l10n.compressCurrentFile(progress.currentFileLabel!),
            //     style: Theme.of(context).textTheme.bodyMedium,
            //   ),
            //   const SizedBox(height: 6),
            //   LinearProgressIndicator(
            //     value:
            //         progress.phase == CompressionPhase.running ||
            //                 progress.phase == CompressionPhase.completed
            //             ? progress.currentFileProgress.clamp(0.0, 1.0)
            //             : 0,
            //     minHeight: 7,
            //     borderRadius: BorderRadius.circular(999),
            //   ),
            //   const SizedBox(height: 6),
            //   Text(
            //     l10n.compressCurrentFileProgress(progress.currentFilePercent),
            //     style: Theme.of(context).textTheme.bodySmall?.copyWith(
            //       color: Theme.of(context).colorScheme.onSurfaceVariant,
            //     ),
            //   ),
            //   const SizedBox(height: 8),
            // ],
            // Text(
            //   l10n.compressProgressDone(
            //     progress.processedCount,
            //     progress.totalCount,
            //     '${progress.remainingCount}',
            //   ),
            //   style: Theme.of(context).textTheme.bodySmall,
            // ),
          ],
        ),
      ),
    );
  }
}
