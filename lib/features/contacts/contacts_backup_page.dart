import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/routes/app_routes.dart';
import 'package:cleaner_app/services/contacts/contacts_repository.dart';
import 'package:cleaner_app/widgets/state_message_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsBackupPage extends StatelessWidget {
  const ContactsBackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final repo = Get.find<ContactsRepository>();

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Get.back<void>(
            id: AppRoutes.contactsNestedNavigatorId,
          ),
          child: Text(l10n.commonBack),
        ),
        leadingWidth: 88,
        title: Text(l10n.contactsBackup),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StateMessageCard(
              icon: Icons.cloud_upload_outlined,
              title: l10n.contactsExportTitle,
              message: l10n.contactsExportBody,
            ),
            const SizedBox(height: 24),
            Obx(() {
              final busy = repo.isLoading.value;
              return FilledButton(
                onPressed:
                    busy
                        ? null
                        : () async {
                          await repo.exportAllContactsBackup();
                        },
                child: Text(
                  busy ? l10n.contactsExportPreparing : l10n.contactsExportAllShare,
                ),
              );
            }),
            const SizedBox(height: 12),
            Text(
              l10n.contactsExportSubsetHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
