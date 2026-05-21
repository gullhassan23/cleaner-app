import 'package:cleaner_app/features/cleaner/ai_photo_editor_page.dart';
import 'package:cleaner_app/features/cleaner/cleaner_dashboard_page.dart';
import 'package:cleaner_app/features/compress/compress_main_screen.dart';
import 'package:cleaner_app/features/settings/settings.dart';
import 'package:cleaner_app/bindings/app_lock_binding.dart';
import 'package:cleaner_app/features/appLock/app_lock_setup_view.dart';
import 'package:cleaner_app/features/appLock/app_lock_verify_pin_view.dart';
import 'package:cleaner_app/bindings/charging_binding.dart';
import 'package:cleaner_app/bindings/photo_widget_binding.dart';
import 'package:cleaner_app/features/photo_widget/photo_widget_album_view.dart';
import 'package:cleaner_app/features/photo_widget/photo_widget_hub_view.dart';
import 'package:cleaner_app/features/photo_widget/photo_widget_picker_view.dart';
import 'package:cleaner_app/features/photo_widget/photo_widget_style_view.dart';
import 'package:cleaner_app/features/charging/charging_display_view.dart';
import 'package:cleaner_app/features/charging/charging_home_view.dart';
import 'package:cleaner_app/features/charging/charging_preview_view.dart';
import 'package:cleaner_app/features/charging/charging_selection_view.dart';
import 'package:cleaner_app/features/cleaning_guide/cleanup_guide_flow_page.dart';
import 'package:cleaner_app/features/cleaning_guide/cleanup_guide_page.dart';
import 'package:cleaner_app/features/more/more_tools.dart';
import 'package:cleaner_app/features/private_vault/presentation/bindings/private_vault_binding.dart';
import 'package:cleaner_app/features/private_vault/presentation/bindings/vault_route_bindings.dart';
import 'package:cleaner_app/features/private_vault/presentation/pages/private_vault_root_page.dart';
import 'package:cleaner_app/features/private_vault/presentation/pages/vault_albums_page.dart';
import 'package:cleaner_app/features/private_vault/presentation/pages/vault_change_pin_page.dart';
import 'package:cleaner_app/features/private_vault/presentation/pages/vault_gate_page.dart';
import 'package:cleaner_app/features/private_vault/presentation/pages/vault_home_page.dart';
import 'package:cleaner_app/features/private_vault/presentation/pages/vault_pin_setup_page.dart';
import 'package:cleaner_app/features/private_vault/presentation/pages/vault_preview_page.dart';
import 'package:cleaner_app/features/private_vault/presentation/pages/vault_security_page.dart';
import 'package:cleaner_app/features/private_vault/presentation/pages/vault_settings_page.dart';
import 'package:cleaner_app/features/private_vault/presentation/pages/vault_unlock_page.dart';
import 'package:cleaner_app/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bindings/compress_binding.dart';
import '../bindings/contacts_binding.dart';
import '../bindings/bottomNav_binding.dart';

import '../features/compress/compress_review_page.dart';
import '../features/contacts/contacts_backup_page.dart';
import '../features/contacts/contacts_duplicates_page.dart';
import '../features/contacts/contacts_hub_page.dart';
import '../features/contacts/contacts_incomplete_page.dart';
import '../features/contacts/contacts_list_page.dart';

import 'app_routes.dart';

abstract final class AppPages {
  static final List<GetPage<dynamic>> cleanerStack = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.cleanerDashboard,
      page: () => const CleanerDashboardPage(),
    ),
    GetPage<dynamic>(
      transition: Transition.downToUp,
      name: AppRoutes.aiPhotoEditor,
      page: () => const AiPhotoEditorPage(),
    ),
  ];

  static final List<GetPage<dynamic>> contactsStack = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.contactsHub,
      page: () => const ContactsHubPage(),
      binding: ContactsBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.upToDown,
      name: AppRoutes.contactsList,
      page: () => const ContactsListPage(),
      binding: ContactsBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.upToDown,
      name: AppRoutes.contactsBackup,
      page: () => const ContactsBackupPage(),
      binding: ContactsBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.downToUp,
      name: AppRoutes.contactsDuplicates,
      page: () => const ContactsDuplicatesPage(),
      binding: ContactsBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.upToDown,
      name: AppRoutes.contactsIncomplete,
      page: () => const ContactsIncompletePage(),
      binding: ContactsBinding(),
    ),
  ];

  static final List<GetPage<dynamic>> compressStack = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.compressMain,
      page: () => const CompressMainScreen(),
      binding: CompressBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.leftToRight,
      name: AppRoutes.compressReview,
      page: CompressReviewPage.new,
      binding: CompressBinding(),
    ),
  ];

  static final List<GetPage<dynamic>> moreStack = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.moreTools,
      page: () => const MoreToolsPage(),
    ),
    GetPage<dynamic>(
      transition: Transition.upToDown,
      name: AppRoutes.cleanupGuide,
      page: () => const CleanupGuidePage(),
    ),
    GetPage<dynamic>(
      transition: Transition.upToDown,
      name: AppRoutes.cleanupGuideFlow,
      page: () => const CleanupGuideFlowPage(),
    ),
  ];

  static final List<GetPage<dynamic>> _rootStack = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.main,
      page: BottomNav.new,
      binding: BottomNavBinding(),
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
    GetPage<dynamic>(
      name: AppRoutes.photoWidgetHub,
      page: () => const PhotoWidgetHubView(),
      binding: PhotoWidgetRouteBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.photoWidgetAlbum,
      page: () => const PhotoWidgetAlbumView(),
      binding: PhotoWidgetRouteBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.photoWidgetPicker,
      page: () => const PhotoWidgetPickerView(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.photoWidgetStyle,
      page: () => const PhotoWidgetStyleView(),
      binding: PhotoWidgetRouteBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.privateVaultRoot,
      page: () => const PrivateVaultRootPage(),
      binding: PrivateVaultBinding(),
    ),
  ];

  static final List<GetPage<dynamic>> privateVaultStack = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.privateVaultGate,
      page: () => const VaultGatePage(),
      binding: VaultGateBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.privateVaultSetup,
      page: () => const VaultPinSetupPage(),
      binding: VaultAuthSetupBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.privateVaultUnlock,
      page: () => const VaultUnlockPage(),
      binding: VaultAuthUnlockBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.privateVaultHome,
      page: () => const VaultHomePage(),
      binding: VaultHomeBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.privateVaultAlbums,
      page: () => const VaultAlbumsPage(),
      binding: VaultAlbumsBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.privateVaultPreview,
      page: () => const VaultPreviewPage(),
      binding: VaultPreviewBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.privateVaultSettings,
      page: () => const VaultSettingsPage(),
      binding: VaultSettingsBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.privateVaultSecurity,
      page: () => const VaultSecurityPage(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.privateVaultChangePin,
      page: () => const VaultChangePinPage(),
      binding: VaultChangePinBinding(),
    ),
  ];

  static final pages = <GetPage<dynamic>>[
    ..._rootStack,
    ...cleanerStack,
    ...contactsStack,
    ...compressStack,
    ...moreStack,
    ...privateVaultStack,
  ];

  static Route<dynamic>? cleanerOnGenerateRoute(RouteSettings settings) =>
      _onGenerateRoute(settings, cleanerStack, AppRoutes.cleanerDashboard);

  static Route<dynamic>? contactsOnGenerateRoute(RouteSettings settings) =>
      _onGenerateRoute(settings, contactsStack, AppRoutes.contactsHub);

  static Route<dynamic>? compressOnGenerateRoute(RouteSettings settings) =>
      _onGenerateRoute(settings, compressStack, AppRoutes.compressMain);

  static Route<dynamic>? moreOnGenerateRoute(RouteSettings settings) =>
      _onGenerateRoute(settings, moreStack, AppRoutes.moreTools);

  static Route<dynamic>? privateVaultOnGenerateRoute(RouteSettings settings) =>
      _onGenerateRoute(settings, privateVaultStack, AppRoutes.privateVaultGate);

  static Route<dynamic>? _onGenerateRoute(
    RouteSettings settings,
    List<GetPage<dynamic>> stack,
    String fallbackRoute,
  ) {
    final def = _pageFor(stack, settings.name, fallbackRoute);
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

  static GetPage<dynamic> _pageFor(
    List<GetPage<dynamic>> stack,
    String? name,
    String fallbackRoute,
  ) {
    for (final p in stack) {
      if (p.name == name) {
        return p;
      }
    }
    return stack.firstWhere((p) => p.name == fallbackRoute);
  }
}
