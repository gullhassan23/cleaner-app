package com.example.cleaner_app.photowidget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.view.View
import android.widget.RemoteViews
import com.example.cleaner_app.MainActivity
import com.example.cleaner_app.R

class PhotoWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (id in appWidgetIds) {
            updateWidget(context, appWidgetManager, id)
        }
        val manifest = PhotoWidgetPrefs.loadManifest(context)
        if (manifest != null && manifest.enabled && manifest.style == "slideshow") {
            PhotoWidgetScheduler.scheduleSlideshowTick(context)
        } else {
            PhotoWidgetScheduler.cancelSlideshowTick(context)
        }
    }

    override fun onDisabled(context: Context) {
        PhotoWidgetScheduler.cancelSlideshowTick(context)
        super.onDisabled(context)
    }

    companion object {
        const val EXTRA_OPEN_PHOTO_WIDGET = "open_photo_widget"

        fun refreshAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val component = ComponentName(context, PhotoWidgetProvider::class.java)
            val ids = manager.getAppWidgetIds(component)
            if (ids.isEmpty()) return
            for (id in ids) {
                updateWidget(context, manager, id)
            }
            val manifest = PhotoWidgetPrefs.loadManifest(context)
            if (manifest != null && manifest.enabled && manifest.style == "slideshow") {
                PhotoWidgetScheduler.scheduleSlideshowTick(context)
            } else {
                PhotoWidgetScheduler.cancelSlideshowTick(context)
            }
        }

        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
        ) {
            val manifest = PhotoWidgetPrefs.loadManifest(context)
            val enabled = PhotoWidgetPrefs.isEnabled(context) &&
                manifest != null &&
                manifest.enabled &&
                manifest.photos.isNotEmpty()

            val clickIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra(EXTRA_OPEN_PHOTO_WIDGET, true)
            }
            val clickFlags = PendingIntent.FLAG_UPDATE_CURRENT or
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    PendingIntent.FLAG_IMMUTABLE
                } else {
                    0
                }
            val pendingClick = PendingIntent.getActivity(
                context,
                appWidgetId,
                clickIntent,
                clickFlags,
            )

            if (!enabled || manifest == null) {
                val views = RemoteViews(context.packageName, R.layout.photo_widget_empty)
                views.setOnClickPendingIntent(R.id.widget_root, pendingClick)
                appWidgetManager.updateAppWidget(appWidgetId, views)
                return
            }

            when (manifest.style) {
                "slideshow" -> updateSlideshow(context, appWidgetManager, appWidgetId, manifest, pendingClick)
                else -> updateGrid(context, appWidgetManager, appWidgetId, manifest, pendingClick)
            }
        }

        private fun updateGrid(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
            manifest: PhotoWidgetManifestData,
            pendingClick: PendingIntent,
        ) {
            val views = RemoteViews(context.packageName, R.layout.photo_widget_grid)
            views.setOnClickPendingIntent(R.id.widget_root, pendingClick)

            val imageIds = intArrayOf(
                R.id.image_1,
                R.id.image_2,
                R.id.image_3,
                R.id.image_4,
            )

            val offset = PhotoWidgetPrefs.getGridOffset(context)
            val photos = manifest.photos
            val nextOffset = if (photos.size > 4) (offset + 4) % photos.size else offset
            PhotoWidgetPrefs.setGridOffset(context, nextOffset)

            for (i in imageIds.indices) {
                val photoIndex = if (photos.isEmpty()) -1 else (offset + i) % photos.size
                if (photoIndex >= 0) {
                    val entry = photos[photoIndex]
                    val bitmap = PhotoWidgetImageLoader.loadBitmap(
                        context,
                        manifest.cacheDirectory,
                        entry.fileName,
                    )
                    if (bitmap != null) {
                        views.setImageViewBitmap(imageIds[i], bitmap)
                        views.setViewVisibility(imageIds[i], View.VISIBLE)
                        continue
                    }
                }
                views.setImageViewResource(imageIds[i], R.drawable.photo_widget_placeholder)
                views.setViewVisibility(imageIds[i], View.VISIBLE)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        private fun updateSlideshow(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
            manifest: PhotoWidgetManifestData,
            pendingClick: PendingIntent,
        ) {
            val views = RemoteViews(context.packageName, R.layout.photo_widget_slideshow)
            views.setOnClickPendingIntent(R.id.widget_root, pendingClick)

            val photos = manifest.photos
            val index = PhotoWidgetPrefs.getSlideshowIndex(context).coerceIn(0, photos.size - 1)
            val entry = photos[index]
            val bitmap = PhotoWidgetImageLoader.loadBitmap(
                context,
                manifest.cacheDirectory,
                entry.fileName,
            )
            if (bitmap != null) {
                views.setImageViewBitmap(R.id.slideshow_image, bitmap)
            } else {
                views.setImageViewResource(
                    R.id.slideshow_image,
                    R.drawable.photo_widget_placeholder,
                )
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
