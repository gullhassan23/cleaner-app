import 'dart:typed_data';

import 'package:cleaner_app/models/photo_library/photo_asset_entity.dart';
import 'package:cleaner_app/repositories/photo_library_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CleanerThumbnail extends StatefulWidget {
  const CleanerThumbnail({
    super.key,
    required this.asset,
    this.size = 88,
    this.borderRadius = 12,
    this.border,
    this.overlay,
  });

  final PhotoAssetEntity asset;
  final double size;
  final double borderRadius;
  final BoxBorder? border;
  final Widget? overlay;

  @override
  State<CleanerThumbnail> createState() => _CleanerThumbnailState();
}

class _CleanerThumbnailState extends State<CleanerThumbnail> {
  late Future<Uint8List?> _future;
  final PhotoLibraryRepository _repo = Get.find<PhotoLibraryRepository>();

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void didUpdateWidget(covariant CleanerThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset.id != widget.asset.id) {
      _future = _load();
    }
  }

  Future<Uint8List?> _load() {
    final s = widget.size.ceil();
    return _repo.loadPreviewBytes(
      widget.asset.id,
      width: s,
      height: s,
      quality: 78,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = widget.size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          border: widget.border,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder<Uint8List?>(
              future: _future,
              builder: (context, snapshot) {
                final bytes = snapshot.data;
                if (bytes == null) {
                  return Center(
                    child:
                        snapshot.connectionState == ConnectionState.waiting
                            ? SizedBox(
                              width: s * 0.28,
                              height: s * 0.28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.primary,
                              ),
                            )
                            : Icon(
                              Icons.broken_image_outlined,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                  );
                }
                return Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  cacheWidth: s.ceil(),
                  cacheHeight: s.ceil(),
                  filterQuality: FilterQuality.low,
                );
              },
            ),
            if (widget.overlay != null) widget.overlay!,
          ],
        ),
      ),
    );
  }
}
