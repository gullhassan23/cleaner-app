import 'package:flutter/material.dart';

import '../../widgets/charging/animation_providers/charging_animation_source.dart';

@immutable
class ChargingAnimationModel {
  const ChargingAnimationModel({
    required this.id,
    required this.title,
    required this.styleTag,
    required this.assetPath,
    required this.source,
    required this.previewColors,
  });

  final String id;
  final String title;
  final String styleTag;
  final String assetPath;
  final ChargingAnimationSource source;
  final List<Color> previewColors;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChargingAnimationModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
