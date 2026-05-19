import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/charging_ui_snapshot.dart';

class BatteryStatusCard extends StatelessWidget {
  const BatteryStatusCard({
    super.key,
    required this.snapshot,
    required this.headline,
    required this.subtitle,
    this.compact = false,
    this.lightText = false,
  });

  final ChargingUiSnapshot snapshot;
  final String headline;
  final String subtitle;
  final bool compact;
  final bool lightText;

  bool get _isCharging => snapshot.state == BatteryState.charging;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final glowColor = Color.lerp(scheme.primary, Colors.white, 0.35)!;
    final onSurface = lightText ? Colors.white : scheme.onSurface;
    final onVariant =
        lightText ? Colors.white.withValues(alpha: 0.78) : scheme.onSurfaceVariant;
    final surfaceColor = lightText
        ? Colors.white.withValues(alpha: 0.12)
        : scheme.surface.withValues(alpha: 0.72);

    Widget glowWrap(Widget child) {
      if (!_isCharging || compact) {
        return child;
      }
      return child
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            duration: 1600.ms,
            curve: Curves.easeInOut,
            begin: const Offset(1, 1),
            end: const Offset(1.02, 1.02),
          )
          .boxShadow(
            duration: 1600.ms,
            begin: BoxShadow(
              color: glowColor.withValues(alpha: 0.22),
              blurRadius: 18,
            ),
            end: BoxShadow(
              color: glowColor.withValues(alpha: 0.55),
              blurRadius: 28,
              spreadRadius: 1,
            ),
          );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, compact ? 8 : 12),
      child: glowWrap(
        DecoratedBox(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (lightText ? Colors.white : scheme.outlineVariant)
                  .withValues(alpha: 0.35),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(18, compact ? 14 : 18, 18, compact ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${snapshot.level}',
                      style: TextStyle(
                        fontSize: compact ? 36 : 44,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        letterSpacing: -1.2,
                        color: onSurface,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 2),
                      child: Text(
                        '%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: onVariant,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      _iconFor(snapshot.state),
                      color: lightText ? Colors.white : scheme.primary,
                      size: 26,
                    ),
                  ],
                ),
                SizedBox(height: compact ? 6 : 10),
                Text(
                  headline,
                  style: TextStyle(
                    fontSize: compact ? 15 : 17,
                    fontWeight: FontWeight.w600,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.25,
                    color: onVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return Icons.bolt_rounded;
      case BatteryState.full:
        return Icons.battery_full_rounded;
      case BatteryState.discharging:
        return Icons.power_off_rounded;
      case BatteryState.unknown:
        return Icons.battery_unknown_rounded;
      case BatteryState.connectedNotCharging:
        return Icons.power_rounded;
    }
  }
}
