import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

class VaultEmptyState extends StatelessWidget {
  const VaultEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 100,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.folder_special_rounded,
                size: 56,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.vaultEmptyState,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: cs.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
