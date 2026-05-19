import 'dart:async';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
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
    switch (model.source) {
      case ChargingAnimationSource.lottie:
        return ChargingAnimationConfig.lottie(
          model.assetPath,
          semanticsLabel: model.title,
        );
      case ChargingAnimationSource.gif:
        return ChargingAnimationConfig.gif(
          model.assetPath,
          semanticsLabel: model.title,
        );
      case ChargingAnimationSource.video:
        return ChargingAnimationConfig.video(
          model.assetPath,
          semanticsLabel: model.title,
        );
      case ChargingAnimationSource.imageSequence:
        return ChargingAnimationConfig.imageSequence(
          [model.assetPath],
          semanticsLabel: model.title,
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
      _showAppliedSnackbar(model.title);
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
    _showAppliedSnackbar(model.title);
  }

  void _showAppliedSnackbar(String title) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    Get.snackbar(
      'Applied',
      '$title is now your charging animation.',
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
    switch (state) {
      case BatteryState.charging:
        return 'Charging';
      case BatteryState.full:
        return 'Fully charged';
      case BatteryState.discharging:
        return 'Disconnected';
      case BatteryState.unknown:
        return 'Battery status';
      case BatteryState.connectedNotCharging:
        return 'Power connected';
    }
  }

  String subtitleFor(ChargingUiSnapshot s) {
    switch (s.state) {
      case BatteryState.charging:
        return 'Your device is drawing power.';
      case BatteryState.full:
        return 'You can unplug whenever you are ready.';
      case BatteryState.discharging:
        return 'Plug in to see your charging animation.';
      case BatteryState.unknown:
        return 'Battery state unavailable on this device.';
      case BatteryState.connectedNotCharging:
        return 'Power connected; battery is not actively charging.';
    }
  }

  String platformNote() {
    if (Platform.isIOS) {
      return 'iPhone par lock screen animation allowed nahi hai. App khol kar charging par animation dikhegi.';
    }
    return 'Android par charger lagate hi animation lock screen par khul sakti hai — pehle animation Apply karein, phir neeche battery setting allow karein.';
  }

  List<String> lockScreenSetupSteps() {
    if (Platform.isIOS) {
      return const [
        'Apply an animation from Browse animations.',
        'Open the app while the phone is charging.',
        'Lock-screen auto show is not supported on iPhone.',
      ];
    }
    return const [
      'Browse animations → Preview → Apply animation.',
      'Tap "Allow lock screen on charge" below (battery optimization).',
      'Lock the phone, plug in the charger — animation should appear.',
      'Samsung / Xiaomi / Oppo: Settings → Apps → Cleaner App → allow background & display on lock screen.',
    ];
  }

  bool isAnimationActive(ChargingUiSnapshot s) =>
      s.state == BatteryState.charging || s.state == BatteryState.full;
}
