import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

import '../../services/contacts/contacts_repository.dart';

class ContactsListController extends GetxController {
  late final ContactsRepository repo;

  final searchQuery = ''.obs;
  final selectionMode = false.obs;
  final RxSet<String> selectedIds = <String>{}.obs;

  @override
  void onInit() {
    repo = Get.find<ContactsRepository>();
    super.onInit();
  }

  void setSearch(String value) {
    searchQuery.value = value;
  }

  void toggleSelectionMode() {
    selectionMode.value = !selectionMode.value;
    if (!selectionMode.value) {
      selectedIds.clear();
    }
  }

  void toggleContactSelected(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    selectedIds.refresh();
  }

  bool isSelected(String id) => selectedIds.contains(id);

  List<Contact> get filteredContacts {
    final q = searchQuery.value.trim().toLowerCase();
    final list = repo.contacts.toList();
    if (q.isEmpty) {
      return list;
    }
    final qDigits = q.replaceAll(RegExp(r'\D'), '');
    return list.where((c) {
      if (c.displayName.toLowerCase().contains(q)) {
        return true;
      }
      for (final p in c.phones) {
        final n = p.number.replaceAll(RegExp(r'\s'), '').toLowerCase();
        if (n.contains(q.replaceAll(RegExp(r'\s'), ''))) {
          return true;
        }
        if (qDigits.isNotEmpty &&
            n.replaceAll(RegExp(r'\D'), '').contains(qDigits)) {
          return true;
        }
      }
      for (final e in c.emails) {
        if (e.address.toLowerCase().contains(q)) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  /// A–Z buckets; non-letters under '#'. Keys sorted with '#' last.
  Map<String, List<Contact>> groupedForList(List<Contact> list) {
    final map = <String, List<Contact>>{};
    for (final c in list) {
      final key = _sectionLetter(c.displayName);
      map.putIfAbsent(key, () => []).add(c);
    }
    final keys =
        map.keys.toList()..sort((a, b) {
          if (a == '#') return 1;
          if (b == '#') return -1;
          return a.compareTo(b);
        });
    return {for (final k in keys) k: map[k]!};
  }

  static String _sectionLetter(String displayName) {
    final t = displayName.trim();
    if (t.isEmpty) {
      return '#';
    }
    final first = t.substring(0, 1).toUpperCase();
    if (RegExp(r'^[A-Z]$').hasMatch(first)) {
      return first;
    }
    if (RegExp(r'^\p{L}', unicode: true).hasMatch(first)) {
      return first.toUpperCase();
    }
    return '#';
  }

  Future<void> shareSelectedAsBackup() async {
    if (selectedIds.isEmpty) {
      return;
    }
    final full = await repo.fetchAllForExport();
    final idSet = selectedIds.toSet();
    final toShare = full.where((c) => idSet.contains(c.id)).toList();
    if (toShare.isEmpty) {
      return;
    }
    await repo.exportContactsToVcfAndShare(toShare);
    selectionMode.value = false;
    selectedIds.clear();
    selectedIds.refresh();
  }
}
