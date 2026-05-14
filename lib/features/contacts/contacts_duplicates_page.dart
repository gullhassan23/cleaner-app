import 'package:cleaner_app/routes/app_routes.dart';
import 'package:cleaner_app/services/contacts/contacts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

class ContactsDuplicatesPage extends StatelessWidget {
  const ContactsDuplicatesPage({super.key});

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
        title: const Text('Duplicate Contacts'),
      ),
      body: Obx(() {
        if (repo.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final phoneGroups = repo.duplicatePhoneGroups;
        final nameGroups = repo.duplicateNameGroups;
        if (phoneGroups.isEmpty && nameGroups.isEmpty) {
          return Center(
            child: Text(
              'No duplicate groups found by phone or name.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            if (phoneGroups.isNotEmpty) ...[
              _SectionTitle(theme: theme, label: 'Same number'),
              ...phoneGroups.map(
                (group) => _DuplicateGroupCard(
                  subtitle: _phoneLabel(group),
                  contacts: group,
                  onOpen: (c) => repo.openInSystemEditor(c.id),
                ),
              ),
            ],
            if (nameGroups.isNotEmpty) ...[
              _SectionTitle(theme: theme, label: 'Same name'),
              ...nameGroups.map(
                (group) => _DuplicateGroupCard(
                  subtitle: group.first.displayName,
                  contacts: group,
                  onOpen: (c) => repo.openInSystemEditor(c.id),
                ),
              ),
            ],
          ],
        );
      }),
    );
  }

  static String _phoneLabel(List<Contact> group) {
    for (final c in group) {
      for (final p in c.phones) {
        final digits = p.number.replaceAll(RegExp(r'\D'), '');
        if (digits.length >= 3) {
          return p.number;
        }
      }
    }
    return 'Shared number';
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.theme, required this.label});

  final ThemeData theme;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        label,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _DuplicateGroupCard extends StatelessWidget {
  const _DuplicateGroupCard({
    required this.subtitle,
    required this.contacts,
    required this.onOpen,
  });

  final String subtitle;
  final List<Contact> contacts;
  final void Function(Contact) onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ExpansionTile(
        title: Text(
          '${contacts.length} contacts',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
        children:
            contacts
                .map(
                  (c) => ListTile(
                    title: Text(
                      c.displayName.isEmpty ? 'No name' : c.displayName,
                    ),
                    subtitle:
                        c.phones.isNotEmpty
                            ? Text(c.phones.first.number)
                            : null,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => onOpen(c),
                  ),
                )
                .toList(),
      ),
    );
  }
}
