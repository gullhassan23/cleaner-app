import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoWidgetBackButton extends StatelessWidget {
  const PhotoWidgetBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Align(
      alignment: Alignment.centerLeft,
      child: CupertinoButton(
        padding: const EdgeInsets.only(left: 4),
        minSize: 0,
        onPressed: onPressed ?? () => Navigator.maybePop(context),
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

class PhotoWidgetAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PhotoWidgetAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.leading,
  });

  final String title;
  final List<Widget> actions;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final groupedBg = scheme.surfaceContainerLow;

    return AppBar(
      backgroundColor: groupedBg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leadingWidth: 88,
      leading: leading ?? const PhotoWidgetBackButton(),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
          letterSpacing: -0.4,
        ),
      ),
      actions: actions,
    );
  }
}
