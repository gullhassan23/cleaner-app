import 'package:cleaner_app/features/cleaning_guide/cleanup_guide_constants.dart';
import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS-style blue Back chevron + label for the hub screen.
class GuideHubBackButton extends StatelessWidget {
  const GuideHubBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CupertinoButton(
        padding: const EdgeInsets.only(left: 4),
        minSize: 0,
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.back, size: 22, color: CleanupGuideConstants.iosBlue),
            const SizedBox(width: 2),
            Text(
              context.l10n.commonBack,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: CleanupGuideConstants.iosBlue,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Circular grey back button for the onboarding flow.
class GuideFlowBackButton extends StatelessWidget {
  const GuideFlowBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE8E8ED),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            CupertinoIcons.back,
            size: 20,
            color: Color(0xFF3C3C43),
          ),
        ),
      ),
    );
  }
}
