import 'dart:typed_data';

import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/models/photo_library/photo_asset_entity.dart';
import 'package:cleaner_app/services/repositories/photo_library_repository.dart';
import 'package:cleaner_app/widgets/compress/dark_pill.dart';
import 'package:flutter/material.dart';

class PreviewCard extends StatelessWidget {
  const PreviewCard({required this.asset, required this.repository});

  final PhotoAssetEntity asset;
  final PhotoLibraryRepository repository;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final aspectRatio =
        asset.aspectRatio.isFinite && asset.aspectRatio > 0
            ? asset.aspectRatio
            : 1.0;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: FutureBuilder<Uint8List?>(
                    future: repository.loadPreviewBytes(
                      asset.id,
                      width: 1400,
                      height: 1400,
                      quality: 90,
                    ),
                    builder: (context, snapshot) {
                      final bytes = snapshot.data;
                      if (bytes == null) {
                        return Center(
                          child:
                              snapshot.connectionState == ConnectionState.waiting
                                  ? const CircularProgressIndicator()
                                  : const Icon(Icons.broken_image_outlined),
                        );
                      }
                      return Image.memory(bytes, fit: BoxFit.cover, gaplessPlayback: true);
                    },
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.04),
                        Colors.black.withValues(alpha: 0.35),
                      ],
                    ),
                  ),
                ),
                if (asset.isVideo)
                  const Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0x99000000),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(14),
                        child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 34),
                      ),
                    ),
                  ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          asset.title ??
                              (asset.isVideo
                                  ? l10n.compressSelectedVideo
                                  : l10n.compressSelectedImage),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (asset.isVideo)
                        DarkPill(label: _formatDuration(asset.duration))
                      else
                        DarkPill(label: '${asset.width} x ${asset.height}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}