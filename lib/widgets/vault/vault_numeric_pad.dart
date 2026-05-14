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
    final cs = Theme.of(context).colorScheme;
    final digitStyle = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: cs.onSurface,
    );
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
                child: Text(d, style: digitStyle),
              ),
            SizedBox(
              width: cell,
              height: cell,
              child: bottomLeft ?? const SizedBox.shrink(),
            ),
            _Key(
              size: cell,
              onTap: () => onDigit('0'),
              child: Text('0', style: digitStyle),
            ),
            _Key(
              size: cell,
              onTap: onDelete,
              child: Icon(Icons.backspace_outlined, color: cs.onSurfaceVariant),
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
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
