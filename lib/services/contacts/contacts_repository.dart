import 'dart:io';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

/// Cached contacts access, derived metrics, export, and native editor launch.
class ContactsRepository extends GetxService {
  final RxList<Contact> contacts = <Contact>[].obs;
  final RxBool hasPermission = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasAttemptedLoad = false.obs;

  void _onContactsDbChanged() {
    loadContacts();
  }

  @override
  void onInit() {
    super.onInit();
    FlutterContacts.addListener(_onContactsDbChanged);
  }

  @override
  void onClose() {
    FlutterContacts.removeListener(_onContactsDbChanged);
    super.onClose();
  }

  Future<bool> ensurePermission({bool readonly = true}) async {
    final granted = await FlutterContacts.requestPermission(readonly: readonly);
    hasPermission.value = granted;
    return granted;
  }

  Future<void> loadContacts() async {
    hasAttemptedLoad.value = true;
    isLoading.value = true;
    try {
      if (!await ensurePermission(readonly: true)) {
        contacts.clear();
        return;
      }
      final list = await FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: true,
        withPhoto: false,
        sorted: true,
        deduplicateProperties: true,
      );
      contacts.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  int get totalCount => contacts.length;

  /// Missing display name, or no phone, or no email.
  bool isIncomplete(Contact c) {
    final nameOk = c.displayName.trim().isNotEmpty;
    final phoneOk = c.phones.isNotEmpty;
    final emailOk = c.emails.isNotEmpty;
    return !nameOk || !phoneOk || !emailOk;
  }

  int get incompleteCount => contacts.where(isIncomplete).length;

  List<Contact> get incompleteContacts => contacts.where(isIncomplete).toList();

  static String _normalizePhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    return digits;
  }

  static String _normalizeName(String raw) =>
      raw.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  /// Groups of 2+ distinct contacts sharing the same normalized phone.
  List<List<Contact>> get duplicatePhoneGroups {
    final map = <String, List<Contact>>{};
    for (final c in contacts) {
      for (final p in c.phones) {
        final key = _normalizePhone(p.number);
        if (key.length < 3) continue;
        final list = map.putIfAbsent(key, () => []);
        if (!list.any((x) => x.id == c.id)) {
          list.add(c);
        }
      }
    }
    return map.values.where((g) => g.length >= 2).toList();
  }

  /// Groups of 2+ contacts with the same normalized non-empty display name.
  List<List<Contact>> get duplicateNameGroups {
    final map = <String, List<Contact>>{};
    for (final c in contacts) {
      final key = _normalizeName(c.displayName);
      if (key.isEmpty) continue;
      final list = map.putIfAbsent(key, () => []);
      if (!list.any((x) => x.id == c.id)) {
        list.add(c);
      }
    }
    return map.values.where((g) => g.length >= 2).toList();
  }

  int get duplicateInvolvedCount {
    final ids = <String>{};
    for (final g in duplicatePhoneGroups) {
      for (final c in g) {
        ids.add(c.id);
      }
    }
    for (final g in duplicateNameGroups) {
      for (final c in g) {
        ids.add(c.id);
      }
    }
    return ids.length;
  }

  Future<void> openInSystemEditor(String contactId) async {
    if (!await ensurePermission(readonly: false)) {
      return;
    }
    await FlutterContacts.openExternalEdit(contactId);
  }

  Future<void> openAppSettingsForContacts() async {
    await openAppSettings();
  }

  /// Full fetch for backup (includes photo in vCard when present).
  Future<List<Contact>> fetchAllForExport() async {
    if (!await ensurePermission(readonly: true)) {
      return [];
    }
    return FlutterContacts.getContacts(
      withProperties: true,
      withThumbnail: true,
      withPhoto: true,
      sorted: true,
      deduplicateProperties: true,
    );
  }

  Future<void> exportContactsToVcfAndShare(List<Contact> toExport) async {
    if (toExport.isEmpty) {
      return;
    }
    final buffer = StringBuffer();
    for (final c in toExport) {
      buffer.writeln(c.toVCard());
    }
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/contacts_backup_${DateTime.now().millisecondsSinceEpoch}.vcf',
    );
    await file.writeAsString(buffer.toString());
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], subject: 'Contacts backup'),
    );
  }

  Future<void> exportAllContactsBackup() async {
    final all = await fetchAllForExport();
    await exportContactsToVcfAndShare(all);
  }
}
