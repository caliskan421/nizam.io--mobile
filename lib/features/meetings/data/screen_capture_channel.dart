import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';

/// Ekran paylaşımının platform kanalı (`io.nizamio.mobile/screen_capture`). `available`: iOS'ta
/// yayın uzantısı ve App Group bu derlemenin imzasında var mı (AppDelegate), Android'de her zaman.
///
/// Android ekran yakalama hazırlığı (livekit_client belgesi, "Screen sharing › Android"):
/// MediaProjection izni (`Helper.requestCapturePermission`) alındıktan SONRA ve yakalama
/// başlamadan ÖNCE `mediaProjection` türlü ön plan servisi çalışmalıdır (Android 14+). Servis
/// uygulamanın kendi kodudur (`android/app/.../ScreenCaptureService.kt`), bu kanalla açılıp
/// kapanır. Android dışında her çağrı hiçbir şey yapmaz.
class ScreenCaptureChannel {
  const ScreenCaptureChannel();

  static const _channel = MethodChannel('io.nizamio.mobile/screen_capture');

  bool get _android =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Bu derlemede ekran paylaşımı kurulu mu; kanal yoksa (test, masaüstü) false.
  Future<bool> available() async {
    if (kIsWeb) return false;
    if (_android) return true;
    if (defaultTargetPlatform != TargetPlatform.iOS) return false;
    try {
      return await _channel.invokeMethod<bool>('available') ?? false;
    } on Object catch (e, st) {
      // Kanal yok (eski yerel kod) beklenen durumdur; diğer hata raporlanır. İkisinde de düğme yok.
      reportUnexpected(
        e,
        st,
        source: ReportSource.meetings,
        expected: _missingChannel,
      );
      return false;
    }
  }

  /// Kullanıcıdan ekran yakalama izni ister ve ön plan servisini başlatır.
  /// false → kullanıcı izin vermedi (servis başlatılmaz).
  Future<bool> prepare() async {
    if (!_android) return true;
    if (!await rtc.Helper.requestCapturePermission()) return false;
    await _channel.invokeMethod<void>('start');
    return true;
  }

  /// Ön plan servisini durdurur (çalışmıyorsa etkisiz).
  Future<void> release() async {
    if (!_android) return;
    await _channel.invokeMethod<void>('stop');
  }
}

/// Platform kanalı bu yerel derlemede yok (beklenen; raporlanmaz).
bool _missingChannel(Object e) => e is MissingPluginException;
