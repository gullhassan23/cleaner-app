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
    final repo = Get.find<ContactsRepository>();

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Get.back<void>(
            id: AppRoutes.contactsNestedNavigatorId,
          ),
          child: const Text('< Back'),
        ),
        leadingWidth: 88,
        title: const Text('Contacts Backup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StateMessageCard(
              icon: Icons.cloud_upload_outlined,
              title: 'Export your contacts',
              message:
                  'Creates a single .vcf file with your contacts so you can save it to Files, AirDrop it, or open it in another app.',
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
                child: Text(busy ? 'Preparing…' : 'Export all & share'),
              );
            }),
            const SizedBox(height: 12),
            Text(
              'You can also pick contacts from the main list, tap Select, then share a subset.',
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
