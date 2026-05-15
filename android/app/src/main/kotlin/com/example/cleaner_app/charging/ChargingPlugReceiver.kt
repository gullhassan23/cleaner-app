package com.example.cleaner_app.charging

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class ChargingPlugReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        when (intent?.action) {
            Intent.ACTION_POWER_CONNECTED -> ChargingOverlayLauncher.launch(context)
            Intent.ACTION_POWER_DISCONNECTED -> {
                ChargingOverlayActivity.finishIfRunning(context)
            }
        }
    }
}
