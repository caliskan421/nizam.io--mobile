import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../../core/errors/api_error.dart';
import '../../core/telemetry/error_report.dart';
import '../../core/telemetry/error_reporting.dart';

Object? _active;

/// Küresel hata kancalarını kurar; ÖNCEKİ kancaları korur ve çağırır (varsayılan
/// `FlutterError.presentError` davranışı değişmez). Raporlama onay kapısı kapalıyken
/// hiçbir şey yapmaz. Yeni bir `Zone` AÇILMAZ (`runApp` ile aynı bölge).
///
/// Kancalar zaten kuruluysa ikinci çağrı SARMALAMAZ (yığılma yok) ve boş ayırıcı döner.
/// Dönen işlev kancaları, hâlâ bizimkiler ise, eski değerlerine geri koyar (testler).
///
/// Politika (ikisi de FATAL DEĞİL — uygulama çalışmaya devam eder; yerel çökmeler SDK'nın
/// kendi fatal raporudur):
/// - [FlutterError.onError] → `framework`; ham `FlutterErrorDetails` (iletisi, `information`,
///   bağlam) gönderilmez, yalnız türü ve temizlenmiş yığın.
/// - [PlatformDispatcher.onError] → `uncaught_async`; önceki kanca yoksa `false` döner
///   (motorun varsayılan "işlenmedi" davranışı korunur).
/// - [ApiError] beklenmeyen sınıftaysa (geçersiz yanıt, 5xx) sınıflandırılır; aynı kök hata
///   `apiCall`'da raporlandıysa tekrarlanmaz.
void Function() installErrorHooks({
  FlutterExceptionHandler? previousFlutter,
  ErrorCallback? previousPlatform,
}) {
  if (_active != null) return () {};
  final token = _active = Object();
  final originalFlutter = FlutterError.onError;
  final originalPlatform = PlatformDispatcher.instance.onError;
  final flutterBefore = previousFlutter ?? originalFlutter;
  void ours(FlutterErrorDetails details) {
    _reportGlobal(
      details.exception,
      details.stack ?? StackTrace.current,
      ReportKind.framework,
    );
    if (flutterBefore != null) {
      flutterBefore(details);
    } else {
      FlutterError.presentError(details);
    }
  }

  FlutterError.onError = ours;
  final platformBefore = previousPlatform ?? originalPlatform;
  bool oursPlatform(Object error, StackTrace stack) {
    _reportGlobal(error, stack, ReportKind.uncaughtAsync);
    return platformBefore?.call(error, stack) ?? false;
  }

  PlatformDispatcher.instance.onError = oursPlatform;
  return () {
    if (!identical(_active, token)) return;
    _active = null;
    if (identical(FlutterError.onError, ours)) {
      FlutterError.onError = originalFlutter;
    }
    if (identical(PlatformDispatcher.instance.onError, oursPlatform)) {
      PlatformDispatcher.instance.onError = originalPlatform;
    }
  };
}

void _reportGlobal(Object error, StackTrace stack, ReportKind kind) {
  if (error is ApiError) {
    reportApiFailure(error, stack, error);
    return;
  }
  ErrorReporting.report(error, stack, kind: kind);
}
