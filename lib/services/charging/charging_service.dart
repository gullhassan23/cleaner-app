import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:get/get.dart';

import '../../models/charging/charging_ui_snapshot.dart';

class ChargingService extends GetxService {
  ChargingService() : _battery = Battery();

  final Battery _battery;

  final Rx<ChargingUiSnapshot> snapshot = Rx<ChargingUiSnapshot>(
    ChargingUiSnapshot.initial(),
  );

  StreamSubscription<BatteryState>? _subscription;

  @override
  void onInit() {
    super.onInit();
    unawaited(refreshNow());
    _subscription = _battery.onBatteryStateChanged.listen((_) {
      unawaited(refreshNow());
    });
  }

  Future<void> refreshNow() async {
    try {
      final level = (await _battery.batteryLevel).clamp(0, 100);
      final state = await _battery.batteryState;
      final next = ChargingUiSnapshot(level: level, state: state);
      if (snapshot.value != next) {
        snapshot.value = next;
      }
    } catch (_) {
      final fallback = ChargingUiSnapshot(
        level: snapshot.value.level,
        state: BatteryState.unknown,
      );
      if (snapshot.value != fallback) {
        snapshot.value = fallback;
      }
    }
  }

  @override
  void onClose() {
    final sub = _subscription;
    _subscription = null;
    sub?.cancel();
    super.onClose();
  }
}
