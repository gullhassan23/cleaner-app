import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../bindings/photo_widget_binding.dart';

/// Platform channel for home screen photo widget sync.
class PhotoWidgetNativeBridge {
  PhotoWidgetNativeBridge._();

  static const MethodChannel _channel =
      MethodChannel('cleaner_app/photo_widget');

  static bool _handlerInstalled = false;

  /// Handles deep links when user taps the home screen widget.
  static void installNavigationHandler() {
    if (_handlerInstalled) return;
    _handlerInstalled = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'openPhotoWidget') {
        PhotoWidgetBinding().dependencies();
        if (Get.currentRoute != AppRoutes.photoWidgetHub) {
          await Get.toNamed(AppRoutes.photoWidgetHub);
        }
      }
    });
  }

  static Future<void> saveWidgetConfig() async {
    try {
      await _channel.invokeMethod<void>('saveWidgetConfig');
    } on PlatformException {
      // Native may be unavailable on unsupported platforms.
    }
  }

  static Future<void> updateWidget() async {
    try {
      await _channel.invokeMethod<void>('updateWidget');
    } on PlatformException {
      // Ignore.
    }
  }

  static Future<void> refreshWidget() async {
    try {
      await _channel.invokeMethod<void>('refreshWidget');
    } on PlatformException {
      // Ignore.
    }
  }

  static Future<bool> requestPinWidget() async {
    if (!Platform.isAndroid) return false;
    try {
      final result = await _channel.invokeMethod<bool>('requestPinWidget');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> isWidgetPinned() async {
    if (!Platform.isAndroid) return false;
    try {
      final result = await _channel.invokeMethod<bool>('isWidgetPinned');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }
}
