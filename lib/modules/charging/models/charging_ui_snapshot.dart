import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';

@immutable
class ChargingUiSnapshot {
  const ChargingUiSnapshot({
    required this.level,
    required this.state,
  });

  final int level;
  final BatteryState state;

  static ChargingUiSnapshot initial() => const ChargingUiSnapshot(
        level: 0,
        state: BatteryState.unknown,
      );

  bool get isPlugged =>
      state == BatteryState.charging ||
      state == BatteryState.full ||
      state == BatteryState.connectedNotCharging;

  bool get isCharging => state == BatteryState.charging;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChargingUiSnapshot &&
          other.level == level &&
          other.state == state;

  @override
  int get hashCode => Object.hash(level, state);
}
