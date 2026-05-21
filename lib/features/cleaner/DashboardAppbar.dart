import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/utils/colors.dart';
import 'package:cleaner_app/widgets/storage_strip.dart';
import 'package:flutter/material.dart';

class DashboardAppbar extends StatelessWidget {
  const DashboardAppbar({
    super.key,
    required this.child,
    required this.onSettings,
    this.onSort,
  });

  final Widget child;
  final VoidCallback onSettings;
  final VoidCallback? onSort;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 12, 4),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    context.l10n.cleanerAppTitle,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.8,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: kDashBlue,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap:
                          () => ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            SnackBar(content: Text(context.l10n.cleanerPro)),
                          ),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.thumb_up_alt_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              context.l10n.cleanerPro,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (onSort != null)
                    IconButton(
                      onPressed: onSort,
                      icon: Icon(
                        Icons.sort_rounded,
                        color: kDashGrey,
                        size: 26,
                      ),
                    ),
                  IconButton(
                    onPressed: onSettings,
                    icon: Icon(
                      Icons.settings_outlined,
                      color: kDashGrey,
                      size: 26,
                    ),
                  ),
                ],
              ),
              StorageStrip(),
            ],
          ),
        ),

        Flexible(fit: FlexFit.loose, child: child),
      ],
    );
  }
}
