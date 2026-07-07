package com.example.afya_sos

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "afya_sos/notifications"
    private val permissionRequestCode = 2026
    private var permissionResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "initialize" -> {
                        createNotificationChannels()
                        result.success(null)
                    }
                    "requestPermission" -> requestNotificationPermission(result)
                    "showNotification" -> {
                        showNotification(
                            id = call.argument<Int>("id") ?: 0,
                            title = call.argument<String>("title") ?: "AfyaSOS",
                            body = call.argument<String>("body") ?: "",
                            importance = call.argument<String>("importance") ?: "default",
                            sound = call.argument<Boolean>("sound") ?: true,
                            vibration = call.argument<Boolean>("vibration") ?: true
                        )
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun requestNotificationPermission(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            result.success(true)
            return
        }

        if (checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            result.success(true)
            return
        }

        permissionResult = result
        requestPermissions(
            arrayOf(Manifest.permission.POST_NOTIFICATIONS),
            permissionRequestCode
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == permissionRequestCode) {
            val granted = grantResults.isNotEmpty() &&
                grantResults.first() == PackageManager.PERMISSION_GRANTED
            permissionResult?.success(granted)
            permissionResult = null
        }
    }

    private fun showNotification(
        id: Int,
        title: String,
        body: String,
        importance: String,
        sound: Boolean,
        vibration: Boolean
    ) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            return
        }

        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = channelIdFor(importance, sound, vibration)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createNotificationChannel(channelId, importance, sound, vibration)
        }

        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
            ?: Intent(this, MainActivity::class.java)
        launchIntent.flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP

        val pendingIntent = PendingIntent.getActivity(
            this,
            id,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, channelId)
        } else {
            Notification.Builder(this)
        }

        val priority = if (importance == "high") {
            Notification.PRIORITY_HIGH
        } else {
            Notification.PRIORITY_DEFAULT
        }

        val defaults = listOfNotNull(
            if (sound) Notification.DEFAULT_SOUND else null,
            if (vibration) Notification.DEFAULT_VIBRATE else null
        ).fold(0) { acc, value -> acc or value }

        val notification = builder
            .setSmallIcon(android.R.drawable.ic_dialog_alert)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(Notification.BigTextStyle().bigText(body))
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .setPriority(priority)
            .setDefaults(defaults)
            .build()

        manager.notify(id, notification)
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        for (importance in listOf("high", "default")) {
            for (sound in listOf(true, false)) {
                for (vibration in listOf(true, false)) {
                    createNotificationChannel(
                        channelIdFor(importance, sound, vibration),
                        importance,
                        sound,
                        vibration
                    )
                }
            }
        }
    }

    private fun createNotificationChannel(
        channelId: String,
        importance: String,
        sound: Boolean,
        vibration: Boolean
    ) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelImportance = if (importance == "high") {
            NotificationManager.IMPORTANCE_HIGH
        } else {
            NotificationManager.IMPORTANCE_DEFAULT
        }
        val channel = NotificationChannel(
            channelId,
            if (importance == "high") "Emergency Alerts" else "AfyaSOS Notifications",
            channelImportance
        )

        if (!sound) {
            channel.setSound(null, null)
        }

        channel.enableVibration(vibration)
        manager.createNotificationChannel(channel)
    }

    private fun channelIdFor(
        importance: String,
        sound: Boolean,
        vibration: Boolean
    ): String {
        return "afya_sos_${importance}_${if (sound) "sound" else "silent"}_" +
            if (vibration) "vibrate" else "still"
    }
}
