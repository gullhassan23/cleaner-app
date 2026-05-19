import 'dart:io';

import 'package:flutter/services.dart';

class ChargingPowerEvents {
  ChargingPowerEvents._();

  static const EventChannel _channel = EventChannel('cleaner_app/charging_power');

  static Stream<String> get stream {
    if (!Platform.isAndroid) {
      return const Stream<String>.empty();
    }
    return _channel.receiveBroadcastStream().map((event) => '$event');
  }
}
