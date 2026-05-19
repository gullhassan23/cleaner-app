import 'package:cleaner_app/features/cleaning_guide/cleanup_guide_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CleanPillButton extends StatelessWidget {
  const CleanPillButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CleanupGuideConstants.cleanPillBackground,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Clean',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: CleanupGuideConstants.iosBlue,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(width: 2),
              Icon(
                CupertinoIcons.chevron_forward,
                size: 14,
                color: CleanupGuideConstants.iosBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
