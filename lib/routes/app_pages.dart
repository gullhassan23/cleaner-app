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
import 'package:cleaner_app/features/vault/vault_home_page.dart';
import 'package:cleaner_app/features/vault/vault_setup_pin_page.dart';
import 'package:cleaner_app/features/vault/vault_unlock_page.dart';
import 'package:cleaner_app/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bindings/compress_binding.dart';
import '../bindings/contacts_binding.dart';
import '../bindings/bottomNav_binding.dart';
import '../bindings/vault_binding.dart';
import '../controllers/vault/vault_setup_pin_controller.dart';

import '../features/compress/compress_review_page.dart';
import '../features/contacts/contacts_backup_page.dart';
import '../features/contacts/contacts_duplicates_page.dart';
import '../features/contacts/contacts_hub_page.dart';
import '../features/contacts/contacts_incomplete_page.dart';
import '../features/contacts/contacts_list_page.dart';
import '../features/vault/vault_media_picker_page.dart';
import '../features/vault/vault_media_preview_page.dart';

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
      transition: Transition.leftToRight,
      name: AppRoutes.contactsList,
      page: () => const ContactsListPage(),
      binding: ContactsBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.leftToRight,
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

  static final List<GetPage<dynamic>> vaultStack = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.vaultSetup,
      page: () => const VaultSetupPinPage(),
      bindings: [
        VaultBinding(),
        BindingsBuilder(() {
          Get.lazyPut<VaultSetupPinController>(() => VaultSetupPinController());
        }),
      ],
    ),
    GetPage<dynamic>(
      name: AppRoutes.vaultUnlock,
      page: () => const VaultUnlockPage(),
      binding: VaultBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.vaultHome,
      page: () => const VaultHomePage(),
      binding: VaultBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.downToUp,
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

  static final List<GetPage<dynamic>> moreStack = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.moreTools,
      page: () => const MoreToolsPage(),
    ),
    GetPage<dynamic>(
      transition: Transition.cupertino,
      name: AppRoutes.cleanupGuide,
      page: () => const CleanupGuidePage(),
    ),
    GetPage<dynamic>(
      transition: Transition.cupertino,
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
  ];

  static final pages = <GetPage<dynamic>>[
    ..._rootStack,
    ...cleanerStack,
    ...contactsStack,
    ...compressStack,
    ...vaultStack,
    ...moreStack,
  ];

  static Route<dynamic>? cleanerOnGenerateRoute(RouteSettings settings) =>
      _onGenerateRoute(settings, cleanerStack, AppRoutes.cleanerDashboard);

  static Route<dynamic>? contactsOnGenerateRoute(RouteSettings settings) =>
      _onGenerateRoute(settings, contactsStack, AppRoutes.contactsHub);

  static Route<dynamic>? compressOnGenerateRoute(RouteSettings settings) =>
      _onGenerateRoute(settings, compressStack, AppRoutes.compressMain);

  static Route<dynamic>? vaultOnGenerateRoute(RouteSettings settings) =>
      _onGenerateRoute(settings, vaultStack, AppRoutes.vaultSetup);

  static Route<dynamic>? moreOnGenerateRoute(RouteSettings settings) =>
      _onGenerateRoute(settings, moreStack, AppRoutes.moreTools);

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

