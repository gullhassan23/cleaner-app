import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'charging_animation_config.dart';

class LottieChargingAnimation extends StatelessWidget {
  const LottieChargingAnimation({
    super.key,
    required this.config,
    required this.isActive,
  });

  final ChargingAnimationConfig config;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final path = config.lottieAssetPath;
    if (path == null || path.isEmpty) {
      return const _AnimationMissing(message: 'Missing Lottie asset path');
    }
    return Semantics(
      label: config.semanticsLabel ?? 'Charging animation',
      child: Lottie.asset(
        path,
        package: config.package,
        fit: config.fit,
        repeat: isActive,
        animate: isActive,
      ),
    );
  }
}

class _AnimationMissing extends StatelessWidget {
  const _AnimationMissing({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
