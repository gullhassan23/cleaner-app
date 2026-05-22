
import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS-style blue Back chevron + label for the hub screen.
class GuideHubBackButton extends StatelessWidget {
  const GuideHubBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Align(
      alignment: Alignment.centerLeft,
      child: CupertinoButton(
        padding: const EdgeInsets.only(left: 4),
        minSize: 0,
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.back, size: 22, color: primary),
            const SizedBox(width: 2),
            Text(
              context.l10n.commonBack,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: primary,
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
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.accentTile,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            CupertinoIcons.back,
            size: 20,
            color: cs.onSurface,
          ),
        ),
      ),
    );
  }
}
