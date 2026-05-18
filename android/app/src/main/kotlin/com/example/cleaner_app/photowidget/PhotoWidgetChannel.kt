package com.example.cleaner_app.photowidget

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.os.Build
import io.flutter.plugin.common.MethodChannel

object PhotoWidgetChannel {
    private const val CHANNEL = "cleaner_app/photo_widget"

    fun register(context: Context, messenger: io.flutter.plugin.common.BinaryMessenger) {
        MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveWidgetConfig" -> {
                    result.success(null)
                }
                "updateWidget", "refreshWidget" -> {
                    PhotoWidgetProvider.refreshAll(context)
                    result.success(null)
                }
                "requestPinWidget" -> {
                    result.success(requestPin(context))
                }
                "isWidgetPinned" -> {
                    result.success(isWidgetPinned(context))
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun requestPin(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return false
        val manager = AppWidgetManager.getInstance(context)
        if (!manager.isRequestPinAppWidgetSupported) return false
        val component = ComponentName(context, PhotoWidgetProvider::class.java)
        return try {
            manager.requestPinAppWidget(component, null, null)
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun isWidgetPinned(context: Context): Boolean {
        val manager = AppWidgetManager.getInstance(context)
        val component = ComponentName(context, PhotoWidgetProvider::class.java)
        val ids = manager.getAppWidgetIds(component)
        return ids.isNotEmpty()
    }
}
