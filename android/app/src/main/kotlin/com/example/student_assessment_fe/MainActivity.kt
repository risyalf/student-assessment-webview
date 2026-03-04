package com.example.student_assessment_fe

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "student_assessment_fe"

    private fun isPinned(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            return false
        }

        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            activityManager.lockTaskModeState != ActivityManager.LOCK_TASK_MODE_NONE
        } else {
            @Suppress("DEPRECATION")
            activityManager.isInLockTaskMode
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "preventScreenshot" -> {
                    runOnUiThread {
                        window.setFlags(
                            WindowManager.LayoutParams.FLAG_SECURE,
                            WindowManager.LayoutParams.FLAG_SECURE
                        )
                    }
                    result.success(true)
                }

                "startPinning" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        try {
                            startLockTask()
                            result.success(true)
                        } catch (e: Exception) {
                            result.error(
                                "PIN_FAILED",
                                "Screen pinning not enabled on device",
                                null
                            )
                        }
                    } else {
                        result.error(
                            "UNSUPPORTED",
                            "Android version < 5.0",
                            null
                        )
                    }
                }

                "isPinned" -> {
                    result.success(isPinned())
                }

                "stopPinning" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        stopLockTask()
                    }
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }
}
