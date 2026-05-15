package com.example.cleaner_app.charging

import android.content.Context
import android.content.Intent
import android.view.WindowManager

object ChargingOverlayLauncher {

    fun launch(context: Context) {
        if (!ChargingPrefs.shouldAutoShow(context)) {
            return
        }
        val intent = Intent(context, ChargingOverlayActivity::class.java).apply {
            addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP,
            )
            @Suppress("DEPRECATION")
            addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON,
            )
        }
        context.startActivity(intent)
    }
}
