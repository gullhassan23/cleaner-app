import 'package:cleaner_app/controllers/locale_controller.dart';
import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// iOS-style language picker for the 5 supported locales.
class LanguagePickerPage extends StatelessWidget {
  const LanguagePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final groupedBg = scheme.surfaceContainerLow;
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      backgroundColor: groupedBg,
      appBar: AppBar(
        backgroundColor: groupedBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leadingWidth: 88,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: CupertinoButton(
            padding: const EdgeInsets.only(left: 4),
            minSize: 0,
            onPressed: () => Navigator.maybePop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? CupertinoIcons.forward
                      : CupertinoIcons.back,
                  size: 22,
                  color: scheme.primary,
                ),
                const SizedBox(width: 2),
                Text(
                  l10n.commonBack,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: scheme.primary,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        title: Text(
          l10n.languagePickerTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Obx(() {
            final current = localeController.locale.value;
            return Material(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < LocaleController.languageOptions.length; i++) ...[
                    if (i > 0)
                      Divider(
                        height: 0.5,
                        thickness: 0.5,
                        indent: 16,
                        color: scheme.outlineVariant,
                      ),
                    _LanguageRow(
                      label: localeController.labelFor(
                        l10n,
                        LocaleController.languageOptions[i].locale,
                      ),
                      selected: current.languageCode ==
                          LocaleController.languageOptions[i]
                              .locale
                              .languageCode,
                      onTap: () {
                        localeController.setLocale(
                          LocaleController.languageOptions[i].locale,
                        );
                        Navigator.maybePop(context);
                      },
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: scheme.onSurface,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                if (selected)
                  Icon(
                    CupertinoIcons.checkmark,
                    size: 20,
                    color: scheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
