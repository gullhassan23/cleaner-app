import 'package:flutter/material.dart';

class DarkPill extends StatelessWidget {
  const DarkPill({super.key, required this.label, this.dark = true});

  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final color =
        dark
            ? Colors.black.withValues(alpha: 0.45)
            : Theme.of(context).colorScheme.surfaceContainerHigh;
    final textColor =
        dark ? Colors.white : Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}
