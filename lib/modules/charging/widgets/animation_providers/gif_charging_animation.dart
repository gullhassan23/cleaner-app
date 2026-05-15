import 'package:flutter/material.dart';

import 'charging_animation_config.dart';

class GifChargingAnimation extends StatelessWidget {
  const GifChargingAnimation({
    super.key,
    required this.config,
    required this.isActive,
  });

  final ChargingAnimationConfig config;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final path = config.gifAssetPath;
    if (path == null || path.isEmpty) {
      return const _GifPlaceholder();
    }
    return Semantics(
      label: config.semanticsLabel ?? 'Charging animation',
      child: Opacity(
        opacity: isActive ? 1 : 0.55,
        child: Image.asset(
          path,
          package: config.package,
          fit: config.fit,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => const _GifPlaceholder(),
        ),
      ),
    );
  }
}

class _GifPlaceholder extends StatelessWidget {
  const _GifPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 72,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
