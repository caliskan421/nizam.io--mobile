import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../../core/errors/api_error.dart';
import '../../core/telemetry/error_report.dart';
import '../../core/telemetry/error_reporting.dart';
import '../../core/telemetry/expected_failure.dart';
import '../../core/telemetry/provider_unwrap.dart';
import '../../core/telemetry/report_source.dart';

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
  // Küresel hatanın hangi kullanıcı işleminden geldiği bilinemez (kancalar kök bölgede
  // çalışır): işlem AÇIKÇA `none`, kaynak `framework`/`uncaught` — sahte atıf yok.
  final source = kind == ReportKind.framework
      ? ReportSource.framework
      : ReportSource.uncaught;
  // Riverpod sarmalayıcısı asıl hata ve özgün yığına iner; beklenen hata 0 rapor.
  final (root, rootStack) = unwrapProviderException(error, stack);
  if (root is ExpectedFailure) return;
  if (root is ApiError) {
    reportApiFailure(
      root,
      rootStack,
      root,
      operation: ReportOperation.none,
      source: source,
    );
    return;
  }
  ErrorReporting.report(
    root,
    rootStack,
    kind: kind,
    operation: ReportOperation.none,
    source: source,
  );
}
