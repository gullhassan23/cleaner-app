
import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CleanPillButton extends StatelessWidget {
  const CleanPillButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.pillBackground,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.guideClean,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: cs.primary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                CupertinoIcons.chevron_forward,
                size: 14,
                color: cs.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
