package com.FutureDialLabs.phonecleaner.file.junk.app.charging

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

/**
 * Lock-screen-capable Flutter entry for the charging display route.
 */
class ChargingOverlayActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        if (intent?.getBooleanExtra(EXTRA_FINISH, false) == true) {
            finish()
            return
        }
        super.onCreate(savedInstanceState)
        applyLockScreenFlags()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.getBooleanExtra(EXTRA_FINISH, false)) {
            finish()
        }
    }

    override fun getInitialRoute(): String = "/charging/display"

    private fun applyLockScreenFlags() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        }
        @Suppress("DEPRECATION")
        window.addFlags(
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
        )
    }

    companion object {
        const val EXTRA_FINISH = "finish"

        fun finishIfRunning(context: android.content.Context) {
            val intent = Intent(context, ChargingOverlayActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
                putExtra(EXTRA_FINISH, true)
            }
            context.startActivity(intent)
        }
    }
}
