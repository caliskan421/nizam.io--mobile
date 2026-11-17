package io.nizamio.mobile

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Ekran paylaşımı (lib/features/meetings/data/screen_capture_channel.dart): MediaProjection
        // izni alındıktan sonra ön plan servisi başlatılır, paylaşım bitince durdurulur.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "io.nizamio.mobile/screen_capture")
            .setMethodCallHandler { call, result ->
                val service = Intent(this, ScreenCaptureService::class.java)
                when (call.method) {
                    "available" -> result.success(true)
                    "start" -> {
                        startForegroundService(service)
                        result.success(null)
                    }
                    "stop" -> {
                        stopService(service)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
