import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bindings/compress_binding.dart';
import '../bindings/contacts_binding.dart';
import '../bindings/main_shell_binding.dart';
import '../bindings/vault_binding.dart';
import '../features/cleaner/pages/ai_photo_editor_page.dart';
import '../features/compress/compress_review_page.dart';
import '../features/contacts/contacts_backup_page.dart';
import '../features/contacts/contacts_duplicates_page.dart';
import '../features/contacts/contacts_hub_page.dart';
import '../features/contacts/contacts_incomplete_page.dart';
import '../features/contacts/contacts_list_page.dart';
import '../features/vault/pages/vault_media_picker_page.dart';
import '../features/vault/pages/vault_media_preview_page.dart';
import '../widgets/bottomNavbar.dart';
import 'app_routes.dart';

abstract final class AppPages {
  /// Routes pushed inside the Contacts tab nested [Navigator].
  static final List<GetPage<dynamic>> contactsStack = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.contactsHub,
      page: () => const ContactsHubPage(),
      binding: ContactsBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.contactsList,
      page: () => const ContactsListPage(),
      binding: ContactsBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.contactsBackup,
      page: () => const ContactsBackupPage(),
      binding: ContactsBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.contactsDuplicates,
      page: () => const ContactsDuplicatesPage(),
      binding: ContactsBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.contactsIncomplete,
      page: () => const ContactsIncompletePage(),
      binding: ContactsBinding(),
    ),
  ];

  static final List<GetPage<dynamic>> _rootStack = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.main,
      page: MainShellPage.new,
      binding: MainShellBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.compressReview,
      page: CompressReviewPage.new,
      binding: CompressBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.aiPhotoEditor,
      page: () => const AiPhotoEditorPage(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.vaultMediaPicker,
      page: () => const VaultMediaPickerPage(),
      binding: VaultBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.vaultMediaPreview,
      page: () {
        final args = Get.arguments;
        if (args is! VaultMediaPreviewArgs) {
          return const SizedBox.shrink();
        }
        return VaultMediaPreviewPage(model: args.model, file: args.file);
      },
      binding: VaultBinding(),
    ),
  ];

  static final pages = <GetPage<dynamic>>[..._rootStack, ...contactsStack];

  static GetPage<dynamic> _contactsPageFor(String? name) {
    for (final p in contactsStack) {
      if (p.name == name) {
        return p;
      }
    }
    return contactsStack.firstWhere((p) => p.name == AppRoutes.contactsHub);
  }

  static Route<dynamic>? contactsOnGenerateRoute(RouteSettings settings) {
    final def = _contactsPageFor(settings.name);
    return GetPageRoute<dynamic>(
      settings: settings,
      page: def.page,
      binding: def.binding,
      bindings: def.bindings,
      transition: def.transition,
      opaque: def.opaque,
      popGesture: def.popGesture,
    );
  }
}
