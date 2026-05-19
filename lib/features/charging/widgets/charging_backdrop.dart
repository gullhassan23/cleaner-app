import 'package:flutter/material.dart';

class ChargingBackdrop extends StatelessWidget {
  const ChargingBackdrop({
    super.key,
    this.colors,
  });

  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final top = colors?.first ??
        Color.lerp(scheme.primary, Colors.black, 0.55)!;
    final bottom = colors?.last ??
        Color.lerp(scheme.tertiary, Colors.black, 0.72)!;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            top.withValues(alpha: 0.95),
            bottom.withValues(alpha: 0.92),
          ],
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.35),
            radius: 1.05,
            colors: [
              Colors.white.withValues(alpha: 0.14),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
