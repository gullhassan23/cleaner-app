import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'charging_animation_config.dart';

class VideoChargingAnimation extends StatefulWidget {
  const VideoChargingAnimation({
    super.key,
    required this.config,
    required this.isActive,
  });

  final ChargingAnimationConfig config;
  final bool isActive;

  @override
  State<VideoChargingAnimation> createState() => _VideoChargingAnimationState();
}

class _VideoChargingAnimationState extends State<VideoChargingAnimation> {
  VideoPlayerController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final path = widget.config.videoAssetPath;
    if (path == null || path.isEmpty) {
      setState(() => _failed = true);
      return;
    }
    try {
      final c = VideoPlayerController.asset(
        path,
        package: widget.config.package,
      );
      await c.initialize();
      c.setLooping(true);
      if (!mounted) {
        await c.dispose();
        return;
      }
      setState(() => _controller = c);
      if (widget.isActive) {
        await c.play();
      } else {
        await c.pause();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _failed = true);
      }
    }
  }

  @override
  void didUpdateWidget(covariant VideoChargingAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    if (widget.isActive) {
      c.play();
    } else {
      c.pause();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Center(
        child: Icon(
          Icons.videocam_off_outlined,
          size: 72,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
    final c = _controller;
    if (c == null || !c.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Semantics(
      label: widget.config.semanticsLabel ?? 'Charging animation',
      child: FittedBox(
        fit: widget.config.fit,
        child: SizedBox(
          width: c.value.size.width,
          height: c.value.size.height,
          child: VideoPlayer(c),
        ),
      ),
    );
  }
}
