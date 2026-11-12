import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' show DioException;
import 'package:flutter/services.dart';

import '../errors/api_error.dart';
import 'api_call_scope.dart';
import 'error_report.dart';
import 'error_reporting.dart';
import 'expected_failure.dart';
import 'provider_unwrap.dart';
import 'report_source.dart';

/// İşlem sınırındaki `catch`'te, hata ApiError'a/arayüz durumuna çevrilmeden ÖNCE çağrılır.
/// Yalnız BEKLENMEYEN hatayı raporlar; aynı kök hata tek rapor üretir:
/// - [ApiError] / [DioException]: yalnız beklenmeyen sınıf (geçersiz yanıt, 5xx) — `apiCall`
///   ya da başka sınır zaten raporladıysa tekrarlanmaz;
/// - zaman aşımı ve ağ/IO kopması: beklenen durum (yerel dosya hatası hariç);
/// Yerel dosya/depolama → `storage`; ayrıştırma/tür → `serialization`; kalanı `unexpected`.
///
/// Operasyon: [operation] verilmişse o; yoksa çalışan [ReportContext]; o da `none` ise
/// [fallbackOperation]. [source]: hatanın yakalandığı alan (kapalı küme; zorunlu).
///
/// [expected]: çağıranın alanına özgü DAR beklenen-durum ölçütü (ör. isteğe bağlı platform
/// kanalı yok). Ayıklanmış asıl hata için `true` dönerse rapor üretilmez; diğer her hata
/// raporlanır. Koşul çağrının İÇİNDE olduğundan çağrı `catch` girişinde koşulsuz kalır.
void reportUnexpected(
  Object error,
  StackTrace stack, {
  required ReportSource source,
  ReportOperation? operation,
  ReportOperation? fallbackOperation,
  bool Function(Object error)? expected,
}) {
  final op =
      operation ??
      (ReportContext.current == ReportOperation.none
          ? fallbackOperation
          : ReportContext.current);
  // Riverpod bağımlılık sarmalayıcısı: asıl hata ve özgün yığın (ayrı hata sayılmaz).
  final (root, rootStack) = unwrapProviderException(error, stack);
  if (root is ExpectedFailure) return;
  if (expected != null && expected(root)) return;
  if (root is ApiError) {
    reportApiFailure(root, rootStack, root, operation: op, source: source);
    return;
  }
  if (root is DioException) {
    reportApiFailure(
      root.error ?? root,
      rootStack,
      toApiError(root),
      operation: op,
      source: source,
      apiOperationId: ApiCallScope.ofRequest(root.requestOptions),
    );
    return;
  }
  if (root is TimeoutException) return;
  if (root is IOException && root is! FileSystemException) return;
  final kind = switch (root) {
    FileSystemException() || PlatformException() => ReportKind.storage,
    FormatException() || TypeError() => ReportKind.serialization,
    _ => ReportKind.unexpected,
  };
  ErrorReporting.report(
    root,
    rootStack,
    kind: kind,
    operation: op,
    source: source,
  );
}

/// `catch` içinde hatayı arayüz durumuna çevirmenin TEK yolu: önce [reportUnexpected] (özgün
/// yığın elde), sonra [toApiError]. Dönen [ApiError] aynı kökten sayılır (üst katman,
/// sağlayıcı gözlemcisi ve küresel kancalar tekrar raporlamaz). Davranış `toApiError(e)` ile
/// aynıdır; yalnız beklenmeyen hata artık kaybolmaz.
ApiError toReportedApiError(
  Object error,
  StackTrace stack, {
  required ReportSource source,
  ReportOperation? operation,
  ReportOperation? fallbackOperation,
}) {
  reportUnexpected(
    error,
    stack,
    source: source,
    operation: operation,
    fallbackOperation: fallbackOperation,
  );
  final api = toApiError(error);
  if (!identical(api, error)) {
    final (_, rootStack) = unwrapProviderException(error, stack);
    ErrorReporting.markHandled(api, rootStack);
    ErrorReporting.markCreated(
      api,
    ); // bu olay için yeni nesne: katmanlarda yığın değişir
  }
  return api;
}
