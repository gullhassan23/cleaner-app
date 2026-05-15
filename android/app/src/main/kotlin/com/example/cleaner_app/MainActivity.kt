package com.example.cleaner_app

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import com.example.cleaner_app.charging.ChargingOverlayActivity
import com.example.cleaner_app.charging.ChargingOverlayLauncher
import com.example.cleaner_app.charging.ChargingPrefs
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private var powerReceiver: android.content.BroadcastReceiver? = null
    private var powerEvents: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "cleaner_app/charging_power",
        ).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    powerEvents = events
                }

                override fun onCancel(arguments: Any?) {
                    powerEvents = null
                }
            },
        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "cleaner_app/charging_native",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "launchOverlay" -> {
                    if (!ChargingPrefs.shouldAutoShow(this)) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    ChargingOverlayLauncher.launch(this)
                    result.success(true)
                }
                "finishOverlay" -> {
                    ChargingOverlayActivity.finishIfRunning(this)
                    result.success(null)
                }
                "openBatteryOptimizationSettings" -> {
                    try {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            val pm = getSystemService(POWER_SERVICE) as PowerManager
                            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                                val intent = Intent(
                                    Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
                                ).apply {
                                    data = Uri.parse("package:$packageName")
                                }
                                startActivity(intent)
                            } else {
                                val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                                startActivity(intent)
                            }
                        } else {
                            val intent = Intent(Settings.ACTION_SETTINGS)
                            startActivity(intent)
                        }
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("UNAVAILABLE", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onStart() {
        super.onStart()
        val receiver = object : android.content.BroadcastReceiver() {
            override fun onReceive(context: android.content.Context?, intent: Intent?) {
                when (intent?.action) {
                    Intent.ACTION_POWER_CONNECTED -> powerEvents?.success("connected")
                    Intent.ACTION_POWER_DISCONNECTED -> powerEvents?.success("disconnected")
                }
            }
        }
        powerReceiver = receiver
        val filter = android.content.IntentFilter().apply {
            addAction(Intent.ACTION_POWER_CONNECTED)
            addAction(Intent.ACTION_POWER_DISCONNECTED)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(receiver, filter, RECEIVER_NOT_EXPORTED)
        } else {
            @Suppress("DEPRECATION")
            registerReceiver(receiver, filter)
        }
    }

    override fun onStop() {
        val receiver = powerReceiver
        if (receiver != null) {
            try {
                unregisterReceiver(receiver)
            } catch (_: IllegalArgumentException) {
                // Not registered.
            }
        }
        powerReceiver = null
        super.onStop()
    }
}
