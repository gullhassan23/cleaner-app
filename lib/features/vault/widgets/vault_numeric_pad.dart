import 'package:flutter/material.dart';

class VaultNumericPad extends StatelessWidget {
  const VaultNumericPad({
    super.key,
    required this.onDigit,
    required this.onDelete,
    this.bottomLeft,
  });

  final void Function(String digit) onDigit;
  final VoidCallback onDelete;
  final Widget? bottomLeft;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final spacing = 10.0;
        final cell = (c.maxWidth - spacing * 2) / 3;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.center,
          children: [
            for (final d in ['1', '2', '3', '4', '5', '6', '7', '8', '9'])
              _Key(
                size: cell,
                onTap: () => onDigit(d),
                child: Text(
                  d,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            SizedBox(
              width: cell,
              height: cell,
              child: bottomLeft ?? const SizedBox.shrink(),
            ),
            _Key(
              size: cell,
              onTap: () => onDigit('0'),
              child: const Text(
                '0',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            _Key(
              size: cell,
              onTap: onDelete,
              child: const Icon(Icons.backspace_outlined, color: Colors.white70),
            ),
          ],
        );
      },
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({
    required this.size,
    required this.onTap,
    required this.child,
  });

  final double size;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1A2235),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size * 0.72,
          child: Center(child: child),
        ),
      ),
    );
  }
}
