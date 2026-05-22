import 'dart:async';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../services/charging/charging_preferences_service.dart';
import '../../../services/charging/charging_service.dart';
import 'charging_native_bridge.dart';
import 'charging_power_events.dart';

/// Selection-gated auto-show to [AppRoutes.chargingDisplay].
///
/// Android: manifest receiver may launch overlay activity; foreground uses
/// GetX navigation or native overlay. iOS: only while app is resumed.
class ChargingNavCoordinator extends GetxService with WidgetsBindingObserver {
  ChargingNavCoordinator(
    this._prefs,
    this._batteryService,
  );

  final ChargingPreferencesService _prefs;
  final ChargingService _batteryService;

  final Battery _battery = Battery();

  bool _resumed = true;
  BatteryState? _lastBatteryState;

  StreamSubscription<String>? _androidPlugSub;
  StreamSubscription<BatteryState>? _iosBatterySub;
  Worker? _snapshotWorker;
  Timer? _navDebounce;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    unawaited(refreshListeners());
    _snapshotWorker = ever(_batteryService.snapshot, (_) {
      unawaited(_onSnapshotChanged());
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _snapshotWorker?.dispose();
    _disposeListeners();
    _navDebounce?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _resumed = state == AppLifecycleState.resumed;
    if (_resumed) {
      unawaited(_batteryService.refreshNow());
    }
  }

  Future<void> refreshListeners() async {
    _disposeListeners();
    final enabled = await _prefs.isAutoShowEnabled();
    if (!enabled) {
      return;
    }
    if (Platform.isAndroid) {
      _androidPlugSub = ChargingPowerEvents.stream.listen(_onAndroidPlugEvent);
    } else if (Platform.isIOS) {
      try {
        _lastBatteryState = await _battery.batteryState;
      } catch (_) {
        _lastBatteryState = null;
      }
      _iosBatterySub = _battery.onBatteryStateChanged.listen((_) {
        unawaited(_onIosBatteryEdge());
      });
    }
  }

  void _disposeListeners() {
    _androidPlugSub?.cancel();
    _androidPlugSub = null;
    _iosBatterySub?.cancel();
    _iosBatterySub = null;
  }

  Future<void> _onSnapshotChanged() async {
    final snap = _batteryService.snapshot.value;
    if (!snap.isPlugged && Get.currentRoute == AppRoutes.chargingDisplay) {
      await _closeDisplay();
    }
  }

  void _onAndroidPlugEvent(String event) {
    if (event == 'connected') {
      unawaited(_showDisplay());
    } else if (event == 'disconnected') {
      unawaited(_closeDisplay());
    }
  }

  Future<void> _onIosBatteryEdge() async {
    try {
      final next = await _battery.batteryState;
      final prev = _lastBatteryState;
      _lastBatteryState = next;
      final becameCharging =
          next == BatteryState.charging && prev != BatteryState.charging;
      final becameUnplugged =
          prev != null &&
          (prev == BatteryState.charging ||
              prev == BatteryState.full ||
              prev == BatteryState.connectedNotCharging) &&
          next == BatteryState.discharging;
      if (becameCharging) {
        await _showDisplay();
      } else if (becameUnplugged) {
        await _closeDisplay();
      }
    } catch (_) {
      // Best-effort.
    }
  }

  Future<void> _showDisplay() async {
    _navDebounce?.cancel();
    _navDebounce = Timer(const Duration(milliseconds: 400), () async {
      if (!(await _prefs.isAutoShowEnabled())) {
        return;
      }
      if (Get.currentRoute == AppRoutes.chargingDisplay) {
        return;
      }

      if (Platform.isAndroid) {
        if (!_resumed) {
          await ChargingNativeBridge.launchOverlay();
          return;
        }
        await Get.toNamed<void>(AppRoutes.chargingDisplay);
        return;
      }

      if (!_resumed) {
        return;
      }
      await Get.toNamed<void>(AppRoutes.chargingDisplay);
    });
  }

  /// Closes the charging display without leaving a blank route or activity.
  ///
  /// In-app stack: [Get.back]. Overlay / root-only route: finish overlay then
  /// [SystemNavigator.pop] so the Flutter activity exits cleanly.
  Future<void> closeDisplay() async {
    if (Get.currentRoute == AppRoutes.chargingDisplay) {
      final navigator = Get.key.currentState;
      if (navigator != null && navigator.canPop()) {
        Get.back<void>();
        return;
      }
    }
    if (Platform.isAndroid) {
      await ChargingNativeBridge.finishOverlay();
    }
    await SystemNavigator.pop();
  }

  Future<void> _closeDisplay() => closeDisplay();
}
