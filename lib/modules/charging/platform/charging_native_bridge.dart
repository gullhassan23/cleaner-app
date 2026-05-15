import 'dart:io';

import 'package:flutter/services.dart';

class ChargingNativeBridge {
  ChargingNativeBridge._();

  static const MethodChannel _channel =
      MethodChannel('cleaner_app/charging_native');

  static Future<bool> launchOverlay() async {
    if (!Platform.isAndroid) return false;
    try {
      final result = await _channel.invokeMethod<bool>('launchOverlay');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  static Future<void> finishOverlay() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod<void>('finishOverlay');
    } on PlatformException {
      // Ignore.
    }
  }

  static Future<void> openBatteryOptimizationSettings() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod<void>('openBatteryOptimizationSettings');
    } on PlatformException {
      // Ignore.
    }
  }
}
