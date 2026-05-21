import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/routes/app_routes.dart';
import 'package:cleaner_app/services/contacts/contacts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

class ContactsIncompletePage extends StatelessWidget {
  const ContactsIncompletePage({super.key});

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
        title: Text(l10n.contactsIncompleteContacts),
      ),
      body: Obx(() {
        if (repo.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final list = repo.incompleteContacts;
        if (list.isEmpty) {
          return Center(
            child: Text(
              l10n.contactsIncompleteDescription,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: list.length,
          separatorBuilder:
              (_, __) => Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
          itemBuilder: (context, index) {
            final c = list[index];
            final missing = _missingParts(context, c);
            return ListTile(
              title: Text(
                c.displayName.isEmpty ? l10n.contactsNoName : c.displayName,
              ),
              subtitle: Text(
                l10n.contactsMissingPrefix(missing),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => repo.openInSystemEditor(c.id),
            );
          },
        );
      }),
    );
  }

  static String _missingParts(BuildContext context, Contact c) {
    final l10n = context.l10n;
    final parts = <String>[];
    if (c.displayName.trim().isEmpty) {
      parts.add(l10n.contactsMissingName);
    }
    if (c.phones.isEmpty) {
      parts.add(l10n.contactsMissingNumber);
    }
    if (c.emails.isEmpty) {
      parts.add(l10n.contactsMissingEmail);
    }
    return parts.join(', ');
  }
}
