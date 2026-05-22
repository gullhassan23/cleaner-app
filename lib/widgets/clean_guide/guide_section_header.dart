
import 'package:cleaner_app/utils/colors.dart';
import 'package:flutter/material.dart';

class GuideSectionHeader extends StatelessWidget {
  const GuideSectionHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: cs.mutedLabel,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}
