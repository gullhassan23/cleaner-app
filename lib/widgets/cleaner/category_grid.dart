import 'dart:math' as math;

import 'package:cleaner_app/widgets/cleaner/cleaner_thumbnail.dart';
import 'package:cleaner_app/widgets/video_inline_show.dart';
import 'package:cleaner_app/models/photo_library/photo_asset_entity.dart';
import 'package:flutter/material.dart';

class CategoryGridCard extends StatelessWidget {
  const CategoryGridCard({
    super.key,
    required this.height,
    required this.title,
    required this.sizeLabel,
    required this.placeholderIcon,
    this.preview,
    this.solidBlack = false,
    this.inlineVideo = false,
    this.subtitleAboveTitle,

    this.onTap,
  });

  final double height;
  final String title;
  final String sizeLabel;
  final PhotoAssetEntity? preview;
  final bool placeholderIcon;
  final bool solidBlack;
  final bool inlineVideo;
  final String? subtitleAboveTitle;

  final VoidCallback? onTap;

  static const double _imageInset = 8;

  @override
  Widget build(BuildContext context) {
    final showGreyPlaceholder = placeholderIcon && !solidBlack;
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(_imageInset),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: _buildMediaLayer(context),
                    ),
                  ),
                ),
                if (showGreyPlaceholder)
                  Padding(
                    padding: const EdgeInsets.all(_imageInset),
                    child: Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 42,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.05),
                        Colors.black.withValues(alpha: 0.72),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  left: 12,
                  right: 10,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (subtitleAboveTitle != null) ...[
                        Text(
                          subtitleAboveTitle!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black45,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        sizeLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black54,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildMediaLayer(BuildContext context) {
    if (solidBlack) {
      return const ColoredBox(color: Colors.black);
    }
    if (preview != null) {
      return LayoutBuilder(
        builder: (context, c) {
          if (inlineVideo) {
            return InlineLoopingVideoFill(
              asset: preview!,
              maxWidth: c.maxWidth,
              maxHeight: c.maxHeight,
            );
          }
          final d = math.max(c.maxWidth, c.maxHeight).ceil().clamp(64, 640);
          return CleanerThumbnail(
            asset: preview!,
            size: d.toDouble(),
            borderRadius: 0,
          );
        },
      );
    }
    final cs = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [cs.surfaceContainerHigh, cs.surfaceContainerHighest],
        ),
      ),
    );
  }
}
