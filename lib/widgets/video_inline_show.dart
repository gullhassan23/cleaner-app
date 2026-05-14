import 'dart:async';
import 'dart:math' as math;

import 'package:cleaner_app/widgets/cleaner/cleaner_thumbnail.dart';
import 'package:cleaner_app/models/photo_library/photo_asset_entity.dart';
import 'package:cleaner_app/repositories/photo_library_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class InlineLoopingVideoFill extends StatefulWidget {
  const InlineLoopingVideoFill({
    super.key,
    required this.asset,
    required this.maxWidth,
    required this.maxHeight,
  });

  final PhotoAssetEntity asset;
  final double maxWidth;
  final double maxHeight;

  @override
  State<InlineLoopingVideoFill> createState() => _InlineLoopingVideoFillState();
}

class _InlineLoopingVideoFillState extends State<InlineLoopingVideoFill> {
  final ValueNotifier<VideoPlayerController?> _controllerNotifier =
      ValueNotifier<VideoPlayerController?>(null);

  PhotoLibraryRepository get _repo => Get.find<PhotoLibraryRepository>();

  @override
  void initState() {
    super.initState();
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    final id = widget.asset.id;
    final file = await _repo.loadOriginalFile(id);
    if (!mounted || widget.asset.id != id) {
      return;
    }
    if (file == null) {
      return;
    }
    final c = VideoPlayerController.file(
      file,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    try {
      await c.initialize();
      if (!mounted || widget.asset.id != id) {
        await c.dispose();
        return;
      }
      await c.setLooping(true);
      await c.setVolume(0);
      await c.play();
      if (!mounted || widget.asset.id != id) {
        await c.dispose();
        return;
      }
      _controllerNotifier.value = c;
    } catch (_) {
      await c.dispose();
    }
  }

  @override
  void didUpdateWidget(covariant InlineLoopingVideoFill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset.id != widget.asset.id) {
      unawaited(_controllerNotifier.value?.dispose() ?? Future<void>.value());
      _controllerNotifier.value = null;
      unawaited(_bootstrap());
    }
  }

  @override
  void dispose() {
    final c = _controllerNotifier.value;
    unawaited(c?.dispose() ?? Future<void>.value());
    _controllerNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d =
        math
            .max(widget.maxWidth, widget.maxHeight)
            .ceil()
            .clamp(64, 640)
            .toDouble();

    return ValueListenableBuilder<VideoPlayerController?>(
      valueListenable: _controllerNotifier,
      builder: (context, c, _) {
        if (c != null && c.value.isInitialized) {
          return AnimatedBuilder(
            animation: c,
            builder: (context, _) {
              final sz = c.value.size;
              final w = sz.width;
              final h = sz.height;
              if (w > 0 && h > 0) {
                return FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(width: w, height: h, child: VideoPlayer(c)),
                );
              }
              return CleanerThumbnail(asset: widget.asset, size: d, borderRadius: 0);
            },
          );
        }
        return CleanerThumbnail(asset: widget.asset, size: d, borderRadius: 0);
      },
    );
  }
}
