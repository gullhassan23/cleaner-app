package com.example.cleaner_app.charging

import android.content.Context

object ChargingPrefs {
    private const val PREFS_NAME = "FlutterSharedPreferences"
    private const val SELECTED_ID = "flutter.selected_animation_id"
    private const val AUTO_SHOW = "flutter.charging_auto_show_enabled"

    fun shouldAutoShow(context: Context): Boolean {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val id = prefs.getString(SELECTED_ID, null)
        if (id.isNullOrEmpty()) {
            return false
        }
        return prefs.getBoolean(AUTO_SHOW, true)
    }
}
