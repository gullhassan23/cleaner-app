import 'package:cleaner_app/features/cleaner/ai_photo_editor_page.dart';
import 'package:cleaner_app/features/settings/settings.dart';
import 'package:cleaner_app/modules/app_lock/bindings/app_lock_binding.dart';
import 'package:cleaner_app/modules/app_lock/views/app_lock_setup_view.dart';
import 'package:cleaner_app/modules/app_lock/views/app_lock_verify_pin_view.dart';
import 'package:cleaner_app/modules/charging/bindings/charging_binding.dart';
import 'package:cleaner_app/modules/charging/views/charging_display_view.dart';
import 'package:cleaner_app/modules/charging/views/charging_home_view.dart';
import 'package:cleaner_app/modules/charging/views/charging_preview_view.dart';
import 'package:cleaner_app/modules/charging/views/charging_selection_view.dart';
import 'package:cleaner_app/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bindings/compress_binding.dart';
import '../bindings/contacts_binding.dart';
import '../bindings/main_shell_binding.dart';
import '../bindings/vault_binding.dart';

import '../features/compress/compress_review_page.dart';
import '../features/contacts/contacts_backup_page.dart';
import '../features/contacts/contacts_duplicates_page.dart';
import '../features/contacts/contacts_hub_page.dart';
import '../features/contacts/contacts_incomplete_page.dart';
import '../features/contacts/contacts_list_page.dart';
import '../features/vault/pages/vault_media_picker_page.dart';
import '../features/vault/pages/vault_media_preview_page.dart';

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
      transition: Transition.downToUp,
      name: AppRoutes.aiPhotoEditor,
      page: () => const AiPhotoEditorPage(),
    ),
    GetPage<dynamic>(
      transition: Transition.leftToRight,
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: AppLockBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.appLockSetup,
      page: () => const AppLockSetupView(),
      binding: AppLockSetupBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.appLockVerifyDisable,
      page: () => const AppLockVerifyPinView(),
      binding: AppLockVerifyBinding(),
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
    GetPage<dynamic>(
      name: AppRoutes.chargingHome,
      page: () => const ChargingHomeView(),
      binding: ChargingBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.chargingSelect,
      page: () => const ChargingSelectionView(),
      binding: ChargingBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.chargingPreview,
      page: () => const ChargingPreviewView(),
      binding: ChargingBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.chargingDisplay,
      page: () => const ChargingDisplayView(),
      binding: ChargingBinding(),
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
