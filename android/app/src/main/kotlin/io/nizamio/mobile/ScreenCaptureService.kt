package io.nizamio.mobile

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder

/**
 * Ekran paylaşımı sürerken çalışan ön plan servisi (foregroundServiceType=mediaProjection).
 * Android 14+ MediaProjection'ı yalnız bu türde çalışan bir ön plan servisi varken verir; servis
 * kullanıcı izni alındıktan SONRA başlatılır (livekit_client belgesi, "Screen sharing › Android").
 * Yakalamanın kendisi flutter_webrtc'dedir; servis süreci ön planda tutar ve bildirimi gösterir.
 */
class ScreenCaptureService : Service() {
    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_ID,
                getString(R.string.screen_share_channel),
                NotificationManager.IMPORTANCE_LOW,
            ),
        )
        val open = packageManager.getLaunchIntentForPackage(packageName)?.let {
            PendingIntent.getActivity(this, 0, it, PendingIntent.FLAG_IMMUTABLE)
        }
        val notification = Notification.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_menu_share)
            .setContentTitle(getString(R.string.screen_share_title))
            .setContentText(getString(R.string.screen_share_text))
            .setContentIntent(open)
            .setOngoing(true)
            .build()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION,
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
        return START_NOT_STICKY
    }

    private companion object {
        const val CHANNEL_ID = "screen_share"
        const val NOTIFICATION_ID = 4107
    }
}
