import 'package:flutter/material.dart';

import 'charging_animation_source.dart';

@immutable
class ChargingAnimationConfig {
  const ChargingAnimationConfig._({
    required this.source,
    this.lottieAssetPath,
    this.gifAssetPath,
    this.videoAssetPath,
    this.frameAssetPaths = const <String>[],
    this.package,
    this.fit = BoxFit.contain,
    this.semanticsLabel,
  });

  factory ChargingAnimationConfig.lottie(
    String assetPath, {
    String? package,
    BoxFit fit = BoxFit.contain,
    String? semanticsLabel,
  }) {
    return ChargingAnimationConfig._(
      source: ChargingAnimationSource.lottie,
      lottieAssetPath: assetPath,
      package: package,
      fit: fit,
      semanticsLabel: semanticsLabel,
    );
  }

  factory ChargingAnimationConfig.gif(
    String assetPath, {
    String? package,
    BoxFit fit = BoxFit.contain,
    String? semanticsLabel,
  }) {
    return ChargingAnimationConfig._(
      source: ChargingAnimationSource.gif,
      gifAssetPath: assetPath,
      package: package,
      fit: fit,
      semanticsLabel: semanticsLabel,
    );
  }

  factory ChargingAnimationConfig.video(
    String assetPath, {
    String? package,
    BoxFit fit = BoxFit.contain,
    String? semanticsLabel,
  }) {
    return ChargingAnimationConfig._(
      source: ChargingAnimationSource.video,
      videoAssetPath: assetPath,
      package: package,
      fit: fit,
      semanticsLabel: semanticsLabel,
    );
  }

  factory ChargingAnimationConfig.imageSequence(
    List<String> assetPaths, {
    String? package,
    BoxFit fit = BoxFit.contain,
    String? semanticsLabel,
  }) {
    return ChargingAnimationConfig._(
      source: ChargingAnimationSource.imageSequence,
      frameAssetPaths: List<String>.unmodifiable(assetPaths),
      package: package,
      fit: fit,
      semanticsLabel: semanticsLabel,
    );
  }

  final ChargingAnimationSource source;
  final String? lottieAssetPath;
  final String? gifAssetPath;
  final String? videoAssetPath;
  final List<String> frameAssetPaths;
  final String? package;
  final BoxFit fit;
  final String? semanticsLabel;
}
