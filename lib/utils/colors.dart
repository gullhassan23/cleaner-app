import 'dart:ui';

import 'package:flutter/material.dart';

/// Theme-aware aliases for legacy light-only constants below.
extension AppColorScheme on ColorScheme {
  Color get groupedBackground => surfaceContainerLow;
  Color get groupedCard => surface;
  Color get mutedLabel => onSurfaceVariant;
  Color get accentTile => surfaceContainerHighest;
  Color get pillBackground => primary.withValues(alpha: 0.12);
  Color get dashPrimary => primary;
  Color get dashMuted => onSurfaceVariant;
  Color get progressTrack => surfaceContainerHighest;
}

const Color kCardGreyTop = Color(0xFFE8E8ED);
const Color kCardGreyBottom = Color(0xFFC7C7CC);
const Color kDashBlue = Color(0xFF4A89F3);
const Color kDashGrey = Color(0xFF8E8E93);
const Color kNavBlue = Color(0xFF4A89F3);
const Color kNavOrange = Color(0xFFFF9500);
const Color kNavPurple = Color(0xFFAF52DE);
const Color kNavGrey = Color(0xFF8E8E93);
const Color kNavBarFill = Color(0x1A4A89F3);

const guideBackground = Color(0xFFF2F2F7);
const flowBackground = Color(0xFFF5F5F5);
const cardBackground = Color(0xFFFFFFFF);
const cleanPillBackground = Color(0xFFE8EFFF);
const iosBlue = Color(0xFF007AFF);
const sectionLabelColor = Color(0xFF8E8E93);
const iconTileBackground = Color(0xFFE5E5EA);

const cardRadius = 14.0;
const rowHeight = 58.0;

const offloadStepAssets = <String>[
  'assets/cleaning_guide/offload_step_1.png',
  'assets/cleaning_guide/offload_step_2.png',
  'assets/cleaning_guide/offload_step_3.png',
  'assets/cleaning_guide/offload_step_4.png',
];
