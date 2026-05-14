import 'package:cleaner_app/models/compress/compress_entities.dart';
import 'package:cleaner_app/models/photo_library/photo_asset_entity.dart';
import 'package:cleaner_app/utils/bytes_formatter.dart';
import 'package:cleaner_app/widgets/compress/dark_pill.dart';
import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({required this.asset, required this.result});

  final PhotoAssetEntity? asset;
  final CompressedMediaResultEntity result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              asset?.title ?? 'Compressed file',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                DarkPill(
                  label:
                      'From ${BytesFormatter.humanize(result.originalBytes)}',
                  dark: false,
                ),
                DarkPill(
                  label:
                      'To ${BytesFormatter.humanize(result.compressedBytes)}',
                  dark: false,
                ),
                DarkPill(
                  label: 'Saved ${BytesFormatter.humanize(result.savedBytes)}',
                  dark: false,
                ),
              ],
            ),
            if (result.errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                result.errorMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
