package com.FutureDialLabs.phonecleaner.file.junk.app.photowidget

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent

class PhotoWidgetUpdateReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action != ACTION_TICK) return
        val manifest = PhotoWidgetPrefs.loadManifest(context) ?: return
        if (!manifest.enabled || manifest.style != "slideshow") return
        if (manifest.photos.isEmpty()) return

        val current = PhotoWidgetPrefs.getSlideshowIndex(context)
        val next = (current + 1) % manifest.photos.size
        PhotoWidgetPrefs.setSlideshowIndex(context, next)

        val manager = AppWidgetManager.getInstance(context)
        val component = ComponentName(context, PhotoWidgetProvider::class.java)
        val ids = manager.getAppWidgetIds(component)
        for (id in ids) {
            PhotoWidgetProvider.updateWidget(context, manager, id)
        }

        PhotoWidgetScheduler.scheduleSlideshowTick(context)
    }

    companion object {
        const val ACTION_TICK = "com.FutureDialLabs.phonecleaner.file.junk.app.photo_widget.TICK"
    }
}
