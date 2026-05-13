import 'package:cleaner_app/controllers/contacts_hub_controller.dart';
import 'package:cleaner_app/features/contacts/contacts_nav_routes.dart';
import 'package:cleaner_app/widgets/state_message_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsHubPage extends GetView<ContactsHubController> {
  const ContactsHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nav = Navigator.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.4,
      ),
      appBar: AppBar(title: const Text('Contacts')),
      body: Obx(() {
        final repo = controller.repo;
        repo.contacts.length;
        repo.hasPermission.value;
        repo.hasAttemptedLoad.value;
        if (repo.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (repo.hasAttemptedLoad.value && !repo.hasPermission.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: StateMessageCard(
                icon: Icons.contact_page_outlined,
                title: 'Contacts access needed',
                message:
                    'Allow access to your contacts to see counts, lists, backups, and to open the system editor.',
                primaryAction: FilledButton(
                  onPressed: () => repo.loadContacts(),
                  child: const Text('Try again'),
                ),
                secondaryAction: OutlinedButton(
                  onPressed: () => repo.openAppSettingsForContacts(),
                  child: const Text('Open settings'),
                ),
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _HubRow(
              icon: Icons.person,
              title: 'Contacts',
              trailingCount: repo.totalCount,
              onTap: () => nav.pushNamed(ContactsNavRoutes.list),
            ),
            _HubRow(
              icon: Icons.cloud_upload_outlined,
              title: 'Contacts Backup',
              onTap: () => nav.pushNamed(ContactsNavRoutes.backup),
            ),
            _HubRow(
              icon: Icons.people_outline,
              title: 'Duplicate Contacts',
              subtitle: 'Names. Numbers. Emails.',
              trailingCount: repo.duplicateInvolvedCount,
              onTap: () => nav.pushNamed(ContactsNavRoutes.duplicates),
            ),
            _HubRow(
              icon: Icons.person_off_outlined,
              title: 'Incomplete Contacts',
              subtitle: 'Names. Numbers. Emails.',
              trailingCount: repo.incompleteCount,
              onTap: () => nav.pushNamed(ContactsNavRoutes.incomplete),
            ),
          ],
        );
      }),
    );
  }
}

class _HubRow extends StatelessWidget {
  const _HubRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailingCount,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final int? trailingCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  child: Icon(icon, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailingCount != null) ...[
                  Text(
                    '$trailingCount',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                Icon(Icons.chevron_right, color: theme.colorScheme.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
