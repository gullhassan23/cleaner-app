import 'package:cleaner_app/features/cleaning_guide/cleanup_guide_constants.dart';
import 'package:flutter/material.dart';

class GuideSectionHeader extends StatelessWidget {
  const GuideSectionHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: CleanupGuideConstants.sectionLabelColor,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}
