import 'package:flutter/material.dart';

class AppLockPinDots extends StatelessWidget {
  const AppLockPinDots({
    super.key,
    required this.filledCount,
    this.total = 4,
  });

  final int filledCount;
  final int total;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final filled = i < filledCount;
        return Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? cs.primary : cs.outline.withValues(alpha: 0.45),
          ),
        );
      }),
    );
  }
}
