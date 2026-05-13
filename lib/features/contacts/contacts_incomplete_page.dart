import 'package:cleaner_app/services/contacts/contacts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

class ContactsIncompletePage extends StatelessWidget {
  const ContactsIncompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nav = Navigator.of(context);
    final repo = Get.find<ContactsRepository>();

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => nav.pop(),
          child: const Text('< Back'),
        ),
        leadingWidth: 88,
        title: const Text('Incomplete Contacts'),
      ),
      body: Obx(() {
        if (repo.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final list = repo.incompleteContacts;
        if (list.isEmpty) {
          return Center(
            child: Text(
              'Every contact has a name, at least one number, and at least one email.',
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
            final missing = _missingParts(c);
            return ListTile(
              title: Text(c.displayName.isEmpty ? 'No name' : c.displayName),
              subtitle: Text(
                'Missing: $missing',
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

  static String _missingParts(Contact c) {
    final parts = <String>[];
    if (c.displayName.trim().isEmpty) {
      parts.add('name');
    }
    if (c.phones.isEmpty) {
      parts.add('number');
    }
    if (c.emails.isEmpty) {
      parts.add('email');
    }
    return parts.join(', ');
  }
}
