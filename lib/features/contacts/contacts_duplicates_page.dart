import 'package:cleaner_app/l10n/app_localizations.dart';
import 'package:cleaner_app/l10n/l10n_extension.dart';
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
        title: Text(l10n.contactsDuplicateContacts),
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
              l10n.contactsNoDuplicates,
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
              _SectionTitle(theme: theme, label: l10n.contactsSameNumber),
              ...phoneGroups.map(
                (group) => _DuplicateGroupCard(
                  subtitle: _phoneLabel(group, l10n),
                  contacts: group,
                  onOpen: (c) => repo.openInSystemEditor(c.id),
                ),
              ),
            ],
            if (nameGroups.isNotEmpty) ...[
              _SectionTitle(theme: theme, label: l10n.contactsSameName),
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

  static String _phoneLabel(List<Contact> group, AppLocalizations l10n) {
    for (final c in group) {
      for (final p in c.phones) {
        final digits = p.number.replaceAll(RegExp(r'\D'), '');
        if (digits.length >= 3) {
          return p.number;
        }
      }
    }
    return l10n.contactsSharedNumber;
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
    final l10n = context.l10n;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ExpansionTile(
        title: Text(
          l10n.contactsGroupCount(contacts.length),
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
                      c.displayName.isEmpty ? l10n.contactsNoName : c.displayName,
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
