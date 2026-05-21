import 'dart:async';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:cleaner_app/l10n/app_localizations.dart';
import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../models/charging/charging_animation_model.dart';
import '../../models/charging/charging_ui_snapshot.dart';
import '../../features/charging/platform/charging_native_bridge.dart';
import '../../features/charging/platform/charging_nav_coordinator.dart';
import '../../services/charging/charging_catalog_service.dart';
import '../../services/charging/charging_preferences_service.dart';
import '../../services/charging/charging_service.dart';
import '../../widgets/charging/animation_providers/charging_animation_config.dart';
import '../../widgets/charging/animation_providers/charging_animation_source.dart';

class ChargingController extends GetxController with WidgetsBindingObserver {
  ChargingController({
    required ChargingService batteryService,
    required ChargingCatalogService catalogService,
    required ChargingPreferencesService preferencesService,
    required ChargingNavCoordinator navCoordinator,
  })  : _batteryService = batteryService,
        _catalog = catalogService,
        _prefs = preferencesService,
        _navCoordinator = navCoordinator;

  final ChargingService _batteryService;
  final ChargingCatalogService _catalog;
  final ChargingPreferencesService _prefs;
  final ChargingNavCoordinator _navCoordinator;

  final RxList<ChargingAnimationModel> catalog = <ChargingAnimationModel>[].obs;
  final Rxn<ChargingAnimationModel> selected = Rxn<ChargingAnimationModel>();

  Rx<ChargingUiSnapshot> get snapshot => _batteryService.snapshot;

  AppLocalizations? get _l10n {
    final ctx = Get.context;
    return ctx != null ? AppLocalizations.of(ctx) : null;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    catalog.assignAll(_catalog.catalog);
    unawaited(_loadSelection());
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_batteryService.refreshNow());
    }
  }

  Future<void> _loadSelection() async {
    final id = await _prefs.getSelectedAnimationId();
    selected.value = _catalog.findById(id);
  }

  ChargingAnimationConfig configFor(ChargingAnimationModel model) {
    final title = _l10n?.chargingAnimationTitleFor(model.id) ?? model.id;
    switch (model.source) {
      case ChargingAnimationSource.lottie:
        return ChargingAnimationConfig.lottie(
          model.assetPath,
          semanticsLabel: title,
        );
      case ChargingAnimationSource.gif:
        return ChargingAnimationConfig.gif(
          model.assetPath,
          semanticsLabel: title,
        );
      case ChargingAnimationSource.video:
        return ChargingAnimationConfig.video(
          model.assetPath,
          semanticsLabel: title,
        );
      case ChargingAnimationSource.imageSequence:
        return ChargingAnimationConfig.imageSequence(
          [model.assetPath],
          semanticsLabel: title,
        );
    }
  }

  ChargingAnimationConfig? get selectedConfig {
    final model = selected.value;
    if (model == null) return null;
    return configFor(model);
  }

  Future<void> applyAnimation(
    ChargingAnimationModel model, {
    bool showSnack = true,
  }) async {
    selected.value = model;
    await _prefs.setSelectedAnimationId(model.id);
    await _navCoordinator.refreshListeners();
    if (showSnack) {
      _showAppliedSnackbar(model);
    }
  }

  /// Persists selection, returns to home, then shows confirmation.
  ///
  /// Snackbar must run after navigation — showing it before [Get.back] causes
  /// GetX to dispose the snackbar mid-transition.
  Future<void> applyFromPreview(ChargingAnimationModel model) async {
    await applyAnimation(model, showSnack: false);
    Get.until((route) => route.settings.name == AppRoutes.chargingHome);
    await Future<void>.delayed(Duration.zero);
    _showAppliedSnackbar(model);
  }

  void _showAppliedSnackbar(ChargingAnimationModel model) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    final l10n = _l10n;
    if (l10n == null) return;
    final title = l10n.chargingAnimationTitleFor(model.id);
    Get.snackbar(
      l10n.chargingAppliedTitle,
      l10n.chargingAppliedMessage(title),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void openSelection() {
    Get.toNamed<void>(AppRoutes.chargingSelect);
  }

  void openPreview(ChargingAnimationModel model) {
    Get.toNamed<void>(AppRoutes.chargingPreview, arguments: model);
  }

  void openDisplay() {
    Get.toNamed<void>(AppRoutes.chargingDisplay);
  }

  Future<void> openBatteryOptimizationSettings() async {
    await ChargingNativeBridge.openBatteryOptimizationSettings();
  }

  String headlineFor(BatteryState state) {
    final l10n = _l10n;
    if (l10n == null) return '';
    switch (state) {
      case BatteryState.charging:
        return l10n.chargingHeadlineCharging;
      case BatteryState.full:
        return l10n.chargingHeadlineFullyCharged;
      case BatteryState.discharging:
        return l10n.chargingHeadlineDisconnected;
      case BatteryState.unknown:
        return l10n.chargingHeadlineBatteryStatus;
      case BatteryState.connectedNotCharging:
        return l10n.chargingHeadlinePowerConnected;
    }
  }

  String subtitleFor(ChargingUiSnapshot s) {
    final l10n = _l10n;
    if (l10n == null) return '';
    switch (s.state) {
      case BatteryState.charging:
        return l10n.chargingSubtitleCharging;
      case BatteryState.full:
        return l10n.chargingSubtitleFullyCharged;
      case BatteryState.discharging:
        return l10n.chargingSubtitleDisconnected;
      case BatteryState.unknown:
        return l10n.chargingSubtitleUnknown;
      case BatteryState.connectedNotCharging:
        return l10n.chargingSubtitleConnectedNotCharging;
    }
  }

  String platformNote() {
    final l10n = _l10n;
    if (l10n == null) return '';
    if (Platform.isIOS) {
      return l10n.chargingPlatformNoteIos;
    }
    return l10n.chargingPlatformNoteAndroid;
  }

  List<String> lockScreenSetupSteps() {
    final l10n = _l10n;
    if (l10n == null) return const [];
    if (Platform.isIOS) {
      return [
        l10n.chargingStepApplyAnimation,
        l10n.chargingStepOpenWhileCharging,
        l10n.chargingStepIosNoLockScreen,
      ];
    }
    return [
      l10n.chargingStepBrowsePreviewApply,
      l10n.chargingStepAllowLockScreen,
      l10n.chargingStepLockAndPlugIn,
      l10n.chargingStepOemSettings,
    ];
  }

  bool isAnimationActive(ChargingUiSnapshot s) =>
      s.state == BatteryState.charging || s.state == BatteryState.full;
}
