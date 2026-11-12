import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' show DioException;
import 'package:flutter/services.dart';

import '../errors/api_error.dart';
import 'error_report.dart';
import 'error_reporting.dart';

/// İşlem sınırındaki `catch`'te, hata ApiError'a/arayüz durumuna çevrilmeden ÖNCE çağrılır.
/// Yalnız BEKLENMEYEN hatayı raporlar; aynı kök hata tek rapor üretir:
/// - [ApiError] / [DioException]: yalnız beklenmeyen sınıf (geçersiz yanıt, 5xx) — `apiCall`
///   ya da başka sınır zaten raporladıysa tekrarlanmaz;
/// - zaman aşımı ve ağ/IO kopması: beklenen durum (yerel dosya hatası hariç);
/// Yerel dosya/depolama → `storage`; ayrıştırma/tür → `serialization`; kalanı `unexpected`.
///
/// Operasyon: [operation] verilmişse o; yoksa çalışan [ReportContext]; o da `none` ise
/// [fallbackOperation].
void reportUnexpected(
  Object error,
  StackTrace stack, {
  ReportOperation? operation,
  ReportOperation? fallbackOperation,
}) {
  final op =
      operation ??
      (ReportContext.current == ReportOperation.none
          ? fallbackOperation
          : ReportContext.current);
  if (error is ApiError) {
    reportApiFailure(error, stack, error, operation: op);
    return;
  }
  if (error is DioException) {
    reportApiFailure(
      error.error ?? error,
      stack,
      toApiError(error),
      operation: op,
    );
    return;
  }
  if (error is TimeoutException) return;
  if (error is IOException && error is! FileSystemException) return;
  final kind = switch (error) {
    FileSystemException() || PlatformException() => ReportKind.storage,
    FormatException() || TypeError() => ReportKind.serialization,
    _ => ReportKind.unexpected,
  };
  ErrorReporting.report(error, stack, kind: kind, operation: op);
}
