import 'dart:math' as math;
import 'dart:typed_data';

import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/models/photo_library/photo_asset_entity.dart';
import 'package:cleaner_app/services/repositories/photo_library/photo_library_repository.dart';
import 'package:cleaner_app/widgets/compress/dark_pill.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const double _kMaxPreviewHeight = 420;
const double _kMaxPreviewHeightFraction = 0.42;

double previewMaxHeight(BuildContext context) {
  return math.min(
    MediaQuery.sizeOf(context).height * _kMaxPreviewHeightFraction,
    _kMaxPreviewHeight,
  );
}

Size previewDisplaySize({
  required double maxWidth,
  required double aspectRatio,
  required double maxHeight,
}) {
  final safeAspect =
      aspectRatio.isFinite && aspectRatio > 0 ? aspectRatio : 1.0;
  var height = maxWidth / safeAspect;
  var width = maxWidth;
  if (height > maxHeight) {
    height = maxHeight;
    width = height * safeAspect;
  }
  return Size(width, height);
}

class CompressPreviewPager extends StatefulWidget {
  const CompressPreviewPager({
    super.key,
    required this.assets,
    required this.repository,
  });

  final List<PhotoAssetEntity> assets;
  final PhotoLibraryRepository repository;

  @override
  State<CompressPreviewPager> createState() => _CompressPreviewPagerState();
}

class _CompressPreviewPagerState extends State<CompressPreviewPager> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double _pagerHeight(BuildContext context) {
    final maxH = previewMaxHeight(context);
    final listWidth = MediaQuery.sizeOf(context).width - 32;
    const cardPadding = 24.0;
    final innerWidth = listWidth - cardPadding;

    var tallest = 0.0;
    for (final asset in widget.assets) {
      final size = previewDisplaySize(
        maxWidth: innerWidth,
        aspectRatio: asset.aspectRatio,
        maxHeight: maxH,
      );
      tallest = math.max(tallest, size.height + cardPadding);
    }
    return tallest;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.assets.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.assets.length == 1) {
      return PreviewCard(
        asset: widget.assets.first,
        repository: widget.repository,
      );
    }

    final pagerHeight = _pagerHeight(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: pagerHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.assets.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return PreviewCard(
                asset: widget.assets[index],
                repository: widget.repository,
                expandVertically: true,
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.assets.length, (index) {
            final isActive = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 10 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color:
                    isActive
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.35),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class PreviewCard extends StatefulWidget {
  const PreviewCard({
    super.key,
    required this.asset,
    required this.repository,
    this.expandVertically = false,
  });

  final PhotoAssetEntity asset;
  final PhotoLibraryRepository repository;
  final bool expandVertically;

  @override
  State<PreviewCard> createState() => _PreviewCardState();
}

class _PreviewCardState extends State<PreviewCard> {
  VideoPlayerController? _videoController;
  bool _isLoadingVideo = false;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _toggleVideoPlayback() async {
    if (!widget.asset.isVideo) {
      return;
    }

    final existing = _videoController;
    if (existing != null && existing.value.isInitialized) {
      if (existing.value.isPlaying) {
        await existing.pause();
      } else {
        await existing.play();
      }
      setState(() {});
      return;
    }

    setState(() => _isLoadingVideo = true);
    final file = await widget.repository.loadOriginalFile(widget.asset.id);
    if (!mounted) {
      return;
    }
    if (file == null) {
      setState(() => _isLoadingVideo = false);
      return;
    }

    final controller = VideoPlayerController.file(file);
    try {
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      controller.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
      _videoController = controller;
      await controller.play();
    } catch (_) {
      await controller.dispose();
    } finally {
      if (mounted) {
        setState(() => _isLoadingVideo = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final aspectRatio =
        widget.asset.aspectRatio.isFinite && widget.asset.aspectRatio > 0
            ? widget.asset.aspectRatio
            : 1.0;
    final videoController = _videoController;
    final isVideoPlaying =
        videoController != null &&
        videoController.value.isInitialized &&
        videoController.value.isPlaying;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxHeight = previewMaxHeight(context);
            final displaySize = previewDisplaySize(
              maxWidth: constraints.maxWidth,
              aspectRatio: aspectRatio,
              maxHeight: maxHeight,
            );

            final preview = ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                width: displaySize.width,
                height: displaySize.height,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _PreviewMedia(
                      asset: widget.asset,
                      repository: widget.repository,
                      videoController: videoController,
                    ),
                    if (!isVideoPlaying)
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
                    if (widget.asset.isVideo && !isVideoPlaying)
                      Center(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap:
                                _isLoadingVideo ? null : _toggleVideoPlayback,
                            customBorder: const CircleBorder(),
                            child: DecoratedBox(
                              decoration: const BoxDecoration(
                                color: Color(0x99000000),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(
                                  _isLoadingVideo ? 18 : 14,
                                ),
                                child:
                                    _isLoadingVideo
                                        ? const SizedBox(
                                          width: 34,
                                          height: 34,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                        : const Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: 34,
                                        ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (isVideoPlaying)
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: _toggleVideoPlayback,
                          behavior: HitTestBehavior.opaque,
                          child: const SizedBox.expand(),
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
                              widget.asset.title ??
                                  (widget.asset.isVideo
                                      ? l10n.compressSelectedVideo
                                      : l10n.compressSelectedImage),
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (widget.asset.isVideo)
                            DarkPill(
                              label: _formatDuration(widget.asset.duration),
                            )
                          else
                            DarkPill(
                              label:
                                  '${widget.asset.width} x ${widget.asset.height}',
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );

            if (widget.expandVertically) {
              return Center(child: preview);
            }
            return Align(alignment: Alignment.topCenter, child: preview);
          },
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

class _PreviewMedia extends StatelessWidget {
  const _PreviewMedia({
    required this.asset,
    required this.repository,
    required this.videoController,
  });

  final PhotoAssetEntity asset;
  final PhotoLibraryRepository repository;
  final VideoPlayerController? videoController;

  @override
  Widget build(BuildContext context) {
    final controller = videoController;
    if (controller != null && controller.value.isInitialized) {
      final size = controller.value.size;
      if (size.width > 0 && size.height > 0) {
        return FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: VideoPlayer(controller),
          ),
        );
      }
    }

    return DecoratedBox(
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
    );
  }
}
