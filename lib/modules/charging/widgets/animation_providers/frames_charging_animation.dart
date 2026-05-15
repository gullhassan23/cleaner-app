import 'dart:async';

import 'package:flutter/material.dart';

import 'charging_animation_config.dart';

class FramesChargingAnimation extends StatefulWidget {
  const FramesChargingAnimation({
    super.key,
    required this.config,
    required this.isActive,
  });

  final ChargingAnimationConfig config;
  final bool isActive;

  @override
  State<FramesChargingAnimation> createState() =>
      _FramesChargingAnimationState();
}

class _FramesChargingAnimationState extends State<FramesChargingAnimation> {
  Timer? _timer;
  int _index = 0;

  List<String> get _paths => widget.config.frameAssetPaths;

  @override
  void initState() {
    super.initState();
    _syncPlayback();
  }

  @override
  void didUpdateWidget(covariant FramesChargingAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPlayback();
  }

  void _syncPlayback() {
    _timer?.cancel();
    _timer = null;
    if (_paths.isEmpty) return;
    if (!widget.isActive) return;
    _timer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (!mounted || !widget.isActive) return;
      setState(() {
        _index = (_index + 1) % _paths.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_paths.isEmpty) {
      return Center(
        child: Icon(
          Icons.burst_mode_outlined,
          size: 72,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
    final path = _paths[_index.clamp(0, _paths.length - 1)];
    return Semantics(
      label: widget.config.semanticsLabel ?? 'Charging animation',
      child: Image.asset(
        path,
        package: widget.config.package,
        fit: widget.config.fit,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => Icon(
          Icons.broken_image_outlined,
          size: 72,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
