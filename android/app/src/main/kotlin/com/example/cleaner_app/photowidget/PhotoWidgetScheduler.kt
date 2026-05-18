package com.example.cleaner_app.photowidget

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.SystemClock

object PhotoWidgetScheduler {
    fun scheduleSlideshowTick(context: Context) {
        val manifest = PhotoWidgetPrefs.loadManifest(context) ?: return
        if (!manifest.enabled || manifest.style != "slideshow") {
            cancelSlideshowTick(context)
            return
        }
        if (manifest.photos.size <= 1) return

        val intervalMs = PhotoWidgetPrefs.getSlideshowIntervalSec(context) * 1000L
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, PhotoWidgetUpdateReceiver::class.java).apply {
            action = PhotoWidgetUpdateReceiver.ACTION_TICK
        }
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_IMMUTABLE
            } else {
                0
            }
        val pending = PendingIntent.getBroadcast(context, 0, intent, flags)
        val triggerAt = SystemClock.elapsedRealtime() + intervalMs
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setAndAllowWhileIdle(
                    AlarmManager.ELAPSED_REALTIME_WAKEUP,
                    triggerAt,
                    pending,
                )
            } else {
                alarmManager.set(
                    AlarmManager.ELAPSED_REALTIME_WAKEUP,
                    triggerAt,
                    pending,
                )
            }
        } catch (_: SecurityException) {
            // Exact alarms may require permission on newer APIs.
        }
    }

    fun cancelSlideshowTick(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, PhotoWidgetUpdateReceiver::class.java).apply {
            action = PhotoWidgetUpdateReceiver.ACTION_TICK
        }
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_IMMUTABLE
            } else {
                0
            }
        val pending = PendingIntent.getBroadcast(context, 0, intent, flags)
        alarmManager.cancel(pending)
    }
}
