package com.FutureDialLabs.phonecleaner.file.junk.app.photowidget

import android.content.Context
import org.json.JSONObject
import java.io.File

data class PhotoWidgetManifestData(
    val enabled: Boolean,
    val style: String,
    val slideshowIntervalSec: Int,
    val cacheDirectory: String,
    val photos: List<PhotoEntry>,
    val updatedAt: Long,
) {
    data class PhotoEntry(val fileName: String, val order: Int)
}

object PhotoWidgetPrefs {
    private const val PREFS_NAME = "FlutterSharedPreferences"
    private const val KEY_ENABLED = "flutter.photo_widget_enabled"
    private const val KEY_STYLE = "flutter.photo_widget_style"
    private const val KEY_INTERVAL = "flutter.photo_widget_slideshow_interval"
    private const val KEY_MANIFEST_PATH = "flutter.photo_widget_manifest_path"
    const val KEY_GRID_OFFSET = "flutter.photo_widget_grid_offset"
    const val KEY_SLIDESHOW_INDEX = "flutter.photo_widget_slideshow_index"

    fun isEnabled(context: Context): Boolean {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        return prefs.getBoolean(KEY_ENABLED, false)
    }

    fun getStyle(context: Context): String {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        return prefs.getString(KEY_STYLE, "grid") ?: "grid"
    }

    fun getSlideshowIntervalSec(context: Context): Int {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        return prefs.getInt(KEY_INTERVAL, 30).coerceIn(15, 300)
    }

    fun getGridOffset(context: Context): Int {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        return prefs.getInt(KEY_GRID_OFFSET, 0)
    }

    fun setGridOffset(context: Context, offset: Int) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit().putInt(KEY_GRID_OFFSET, offset).apply()
    }

    fun getSlideshowIndex(context: Context): Int {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        return prefs.getInt(KEY_SLIDESHOW_INDEX, 0)
    }

    fun setSlideshowIndex(context: Context, index: Int) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit().putInt(KEY_SLIDESHOW_INDEX, index).apply()
    }

    fun loadManifest(context: Context): PhotoWidgetManifestData? {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val path = prefs.getString(KEY_MANIFEST_PATH, null) ?: return null
        val file = File(path)
        if (!file.exists()) return null
        return try {
            val json = JSONObject(file.readText())
            val photosArray = json.optJSONArray("photos") ?: return null
            val photos = mutableListOf<PhotoWidgetManifestData.PhotoEntry>()
            for (i in 0 until photosArray.length()) {
                val item = photosArray.getJSONObject(i)
                photos.add(
                    PhotoWidgetManifestData.PhotoEntry(
                        fileName = item.getString("fileName"),
                        order = item.optInt("order", i),
                    ),
                )
            }
            photos.sortBy { it.order }
            PhotoWidgetManifestData(
                enabled = json.optBoolean("enabled", false),
                style = json.optString("style", "grid"),
                slideshowIntervalSec = json.optInt("slideshowIntervalSec", 30),
                cacheDirectory = json.optString("cacheDirectory", ""),
                photos = photos,
                updatedAt = json.optLong("updatedAt", 0L),
            )
        } catch (_: Exception) {
            null
        }
    }
}
