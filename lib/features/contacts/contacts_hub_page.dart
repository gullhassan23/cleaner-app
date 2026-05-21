import 'package:cleaner_app/controllers/contacts/contacts_hub_controller.dart';
import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:cleaner_app/routes/app_routes.dart';
import 'package:cleaner_app/widgets/state_message_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsHubPage extends GetView<ContactsHubController> {
  const ContactsHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.4,
      ),

      appBar: AppBar(
        title: Text(l10n.contactsTitle),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
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
                title: l10n.contactsAccessNeeded,
                message: l10n.contactsAccessBody,
                primaryAction: FilledButton(
                  onPressed: () => repo.loadContacts(),
                  child: Text(l10n.commonTryAgain),
                ),
                secondaryAction: OutlinedButton(
                  onPressed: () => repo.openAppSettingsForContacts(),
                  child: Text(l10n.contactsOpenSettings),
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
              title: l10n.contactsTitle,
              trailingCount: repo.totalCount,
              onTap:
                  () => Get.toNamed<void>(
                    AppRoutes.contactsList,
                    id: AppRoutes.contactsNestedNavigatorId,
                  ),
            ),
            _HubRow(
              icon: Icons.cloud_upload_outlined,
              title: l10n.contactsBackup,
              onTap:
                  () => Get.toNamed<void>(
                    AppRoutes.contactsBackup,
                    id: AppRoutes.contactsNestedNavigatorId,
                  ),
            ),
            _HubRow(
              icon: Icons.people_outline,
              title: l10n.contactsDuplicateContacts,
              subtitle: l10n.contactsNamesNumbersEmails,
              trailingCount: repo.duplicateInvolvedCount,
              onTap:
                  () => Get.toNamed<void>(
                    AppRoutes.contactsDuplicates,
                    id: AppRoutes.contactsNestedNavigatorId,
                  ),
            ),
            _HubRow(
              icon: Icons.person_off_outlined,
              title: l10n.contactsIncompleteContacts,
              subtitle: l10n.contactsNamesNumbersEmails,
              trailingCount: repo.incompleteCount,
              onTap:
                  () => Get.toNamed<void>(
                    AppRoutes.contactsIncomplete,
                    id: AppRoutes.contactsNestedNavigatorId,
                  ),
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
