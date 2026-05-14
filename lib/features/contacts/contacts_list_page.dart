import 'package:cleaner_app/controllers/contacts_list_controller.dart';
import 'package:cleaner_app/routes/app_routes.dart';
import 'package:cleaner_app/services/contacts/contacts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

class ContactsListPage extends GetView<ContactsListController> {
  const ContactsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = Get.find<ContactsRepository>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Get.back<void>(
            id: AppRoutes.contactsNestedNavigatorId,
          ),
          child: const Text('< Back'),
        ),
        leadingWidth: 88,
        title: const Text('Contacts'),
        actions: [
          Obx(
            () => TextButton(
              onPressed: () => controller.toggleSelectionMode(),
              child: Text(controller.selectionMode.value ? 'Cancel' : 'Select'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final selection = controller.selectionMode.value;
        final count = controller.selectedIds.length;
        if (!selection || count == 0) {
          return const SizedBox.shrink();
        }
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: FilledButton.icon(
              onPressed: () => controller.shareSelectedAsBackup(),
              icon: const Icon(Icons.ios_share_outlined),
              label: Text('Share $count contact(s)'),
            ),
          ),
        );
      }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: controller.setSearch,
              decoration: InputDecoration(
                hintText: 'Search via name, number or email',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.6,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              controller.selectionMode.value;
              controller.searchQuery.value;
              repo.contacts.length;
              if (repo.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final filtered = controller.filteredContacts;
              final grouped = controller.groupedForList(filtered);
              if (filtered.isEmpty) {
                return Center(
                  child: Text(
                    'No contacts match your search.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: _itemCount(grouped),
                itemBuilder: (context, index) {
                  return _buildItem(context, grouped, index);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  static int _itemCount(Map<String, List<Contact>> grouped) {
    var n = 0;
    for (final e in grouped.entries) {
      n += 1 + e.value.length;
    }
    return n;
  }

  Widget _buildItem(
    BuildContext context,
    Map<String, List<Contact>> grouped,
    int index,
  ) {
    var i = index;
    for (final e in grouped.entries) {
      if (i == 0) {
        return _SectionHeader(letter: e.key);
      }
      i -= 1;
      if (i < e.value.length) {
        final c = e.value[i];
        return _ContactTile(
          contact: c,
          onTap: () async {
            if (controller.selectionMode.value) {
              controller.toggleContactSelected(c.id);
              return;
            }
            await Get.find<ContactsRepository>().openInSystemEditor(c.id);
          },
        );
      }
      i -= e.value.length;
    }
    return const SizedBox.shrink();
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.letter});

  final String letter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Text(
        letter,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ContactTile extends GetView<ContactsListController> {
  const _ContactTile({
    required this.contact,
    required this.onTap,
  });

  final Contact contact;
  final Future<void> Function() onTap;

  String _initial(String name) {
    final t = name.trim();
    if (t.isEmpty) {
      return '?';
    }
    return t.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final thumb = contact.photoOrThumbnail;

    return Obx(() {
      final mode = controller.selectionMode.value;
      final selected = mode && controller.isSelected(contact.id);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: theme.colorScheme.surface,
            child: InkWell(
              onTap: () => onTap(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    if (mode) ...[
                      Icon(
                        selected ? Icons.check_circle : Icons.circle_outlined,
                        color:
                            selected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 12),
                    ],
                    CircleAvatar(
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      foregroundColor: theme.colorScheme.onSurface,
                      backgroundImage:
                          thumb != null ? MemoryImage(thumb) : null,
                      child:
                          thumb == null
                              ? Text(
                                _initial(contact.displayName),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                              : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        contact.displayName.isEmpty
                            ? 'No name'
                            : contact.displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
            indent: mode ? 88 : 56,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ],
      );
    });
  }
}
