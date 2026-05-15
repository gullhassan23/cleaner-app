import 'package:flutter/material.dart';

import 'animation_providers/charging_animation_config.dart';
import 'animation_providers/charging_animation_source.dart';
import 'animation_providers/frames_charging_animation.dart';
import 'animation_providers/gif_charging_animation.dart';
import 'animation_providers/lottie_charging_animation.dart';
import 'animation_providers/video_charging_animation.dart';

class ChargingAnimationHost extends StatelessWidget {
  const ChargingAnimationHost({
    super.key,
    required this.config,
    required this.isActive,
  });

  final ChargingAnimationConfig config;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    switch (config.source) {
      case ChargingAnimationSource.lottie:
        return LottieChargingAnimation(config: config, isActive: isActive);
      case ChargingAnimationSource.gif:
        return GifChargingAnimation(config: config, isActive: isActive);
      case ChargingAnimationSource.video:
        return VideoChargingAnimation(config: config, isActive: isActive);
      case ChargingAnimationSource.imageSequence:
        return FramesChargingAnimation(config: config, isActive: isActive);
    }
  }
}
