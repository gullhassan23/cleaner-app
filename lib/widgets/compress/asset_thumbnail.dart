import 'dart:typed_data';

import 'package:cleaner_app/models/photo_library/photo_asset_entity.dart';
import 'package:cleaner_app/services/repositories/photo_library_repository.dart';
import 'package:cleaner_app/utils/bytes_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AssetThumbnail extends StatefulWidget {
  const AssetThumbnail({
    super.key,
    required this.asset,
    required this.width,
    required this.height,
    this.borderRadius = 20,
    this.isSelected = false,
    this.badgeLabel,
    this.onTap,
    this.onLongPress,
    this.showMeta = true,
    this.showSelectionBadge = true,
  });

  final PhotoAssetEntity asset;
  final int width;
  final int height;
  final double borderRadius;
  final bool isSelected;
  final String? badgeLabel;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showMeta;
  /// When false, the top-right selection chip is omitted (caller may draw its own).
  final bool showSelectionBadge;

  @override
  State<AssetThumbnail> createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail> {
  late Future<Uint8List?> _thumbnailFuture;
  final PhotoLibraryRepository _repository = Get.find<PhotoLibraryRepository>();

  @override
  void initState() {
    super.initState();
    _thumbnailFuture = _loadThumbnail();
  }

  @override
  void didUpdateWidget(covariant AssetThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset.id != widget.asset.id ||
        oldWidget.width != widget.width ||
        oldWidget.height != widget.height) {
      _thumbnailFuture = _loadThumbnail();
    }
  }

  Future<Uint8List?> _loadThumbnail() async {
    return _repository.loadPreviewBytes(
      widget.asset.id,
      width: widget.width,
      height: widget.height,
      quality: 82,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              child: FutureBuilder<Uint8List?>(
                future: _thumbnailFuture,
                builder: (context, snapshot) {
                  final bytes = snapshot.data;
                  if (bytes == null) {
                    return Center(
                      child:
                          snapshot.connectionState == ConnectionState.waiting
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                ),
                              )
                              : Icon(
                                Icons.broken_image_outlined,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                    );
                  }

                  return RepaintBoundary(
                    child: Image.memory(
                      bytes,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      cacheWidth: widget.width,
                      cacheHeight: widget.height,
                      filterQuality: FilterQuality.low,
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.04),
                      Colors.black.withValues(
                        alpha: widget.showMeta ? 0.42 : 0.12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.showMeta)
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Row(
                  children: [
                    if (widget.asset.isVideo) ...[
                      const Icon(
                        Icons.play_circle_outline_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(widget.asset.duration),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        BytesFormatter.humanize(widget.asset.fileSize),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.asset.isFavorite)
                      const Icon(Icons.favorite, color: Colors.white, size: 14),
                  ],
                ),
              ),
            if (widget.badgeLabel != null)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    widget.badgeLabel!,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            if (widget.showSelectionBadge)
              Positioned(
                top: 10,
                right: 10,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color:
                        widget.isSelected
                            ? theme.colorScheme.primary
                            : Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color:
                          widget.isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant,
                    ),
                  ),
                  child: Icon(
                    widget.isSelected ? Icons.check : Icons.circle_outlined,
                    size: 16,
                    color:
                        widget.isSelected
                            ? Colors.white
                            : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
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
