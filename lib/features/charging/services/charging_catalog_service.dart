import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/charging_animation_model.dart';
import '../widgets/animation_providers/charging_animation_source.dart';

class ChargingCatalogService extends GetxService {
  static const String lottieBase = 'assets/charging/lottie';

  List<ChargingAnimationModel> get catalog => _catalog;

  static final List<ChargingAnimationModel> _catalog = [
    ChargingAnimationModel(
      id: 'neon_battery',
      title: 'Neon Battery',
      styleTag: 'Neon',
      assetPath: '$lottieBase/neon_battery.json',
      source: ChargingAnimationSource.lottie,
      previewColors: [
        const Color(0xFF00F5FF),
        const Color(0xFF7B2FFF),
      ],
    ),
    ChargingAnimationModel(
      id: 'circular_charge',
      title: 'Circular Charge',
      styleTag: 'Circular',
      assetPath: '$lottieBase/circular_charge.json',
      source: ChargingAnimationSource.lottie,
      previewColors: [
        const Color(0xFF34C759),
        const Color(0xFF00C7BE),
      ],
    ),
    ChargingAnimationModel(
      id: 'cyberpunk',
      title: 'Cyberpunk',
      styleTag: 'Cyberpunk',
      assetPath: '$lottieBase/cyberpunk.json',
      source: ChargingAnimationSource.lottie,
      previewColors: [
        const Color(0xFFFF2D92),
        const Color(0xFF5E5CE6),
      ],
    ),
    ChargingAnimationModel(
      id: 'glowing_energy',
      title: 'Glowing Energy',
      styleTag: 'Energy',
      assetPath: '$lottieBase/glowing_energy.json',
      source: ChargingAnimationSource.lottie,
      previewColors: [
        const Color(0xFFFFD60A),
        const Color(0xFFFF9500),
      ],
    ),
    ChargingAnimationModel(
      id: 'minimal_battery',
      title: 'Minimal Battery',
      styleTag: 'Minimal',
      assetPath: '$lottieBase/minimal_battery.json',
      source: ChargingAnimationSource.lottie,
      previewColors: [
        const Color(0xFF8E8E93),
        const Color(0xFFAEAEB2),
      ],
    ),
    ChargingAnimationModel(
      id: 'futuristic_pulse',
      title: 'Futuristic Pulse',
      styleTag: 'Futuristic',
      assetPath: '$lottieBase/futuristic_pulse.json',
      source: ChargingAnimationSource.lottie,
      previewColors: [
        const Color(0xFF64D2FF),
        const Color(0xFF0A84FF),
      ],
    ),
    ChargingAnimationModel(
      id: 'liquid_wave',
      title: 'Liquid Wave',
      styleTag: 'Liquid',
      assetPath: '$lottieBase/liquid_wave.json',
      source: ChargingAnimationSource.lottie,
      previewColors: [
        const Color(0xFF30D158),
        const Color(0xFF007AFF),
      ],
    ),
    ChargingAnimationModel(
      id: 'aurora_ring',
      title: 'Aurora Ring',
      styleTag: 'Aurora',
      assetPath: '$lottieBase/aurora_ring.json',
      source: ChargingAnimationSource.lottie,
      previewColors: [
        const Color(0xFFBF5AF2),
        const Color(0xFF32ADE6),
      ],
    ),
  ];

  ChargingAnimationModel? findById(String? id) {
    if (id == null || id.isEmpty) return null;
    for (final item in _catalog) {
      if (item.id == id) return item;
    }
    return null;
  }
}
