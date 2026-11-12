import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../core/telemetry/error_report.dart';
import '../../core/telemetry/error_reporting.dart';

/// Crashlytics'e giden istisna nesnesi: yalnız [ErrorReport.label] ve sabit
/// [ErrorReport.message] (ham hata iletisi yok). `toString` Crashlytics'in `exception` alanıdır.
final class SanitizedReportException implements Exception {
  const SanitizedReportException(this.label, this.message);
  final String label;
  final String message;

  @override
  String toString() => '$label | $message';
}

/// Crashlytics gerçekleştirmesi. Yalnız [ErrorReport] alır; bu tür yalnız beyaz listeli
/// alanlarla kurulabilir. `information`, `reason`, özel anahtar ve kullanıcı kimliği
/// GÖNDERİLMEZ (özel anahtarlar süreç geneli olduğundan eşzamanlı işlemlerin bağlamını
/// karıştırır; işlem sabiti etikette taşınır). `printDetails` kapalı.
///
/// SDK'nın otomatik toplaması HEP kapalıdır: [disableCollection] her başlatmada çağrılır,
/// `setCrashlyticsCollectionEnabled(true)` bu kod tabanında YOKTUR (çağrı kalıcıdır ve bir
/// sonraki süreçte yerel çökmeyi onaysız gönderirdi). Gönderim yalnız [sendPending] ile.
///
/// Bu sınıf Dart hatalarını taşır; yerel (native) çökme verisi SDK'nın kendi
/// toplayıcısındandır ve Dart redaksiyonundan GEÇMEZ (docs/yurutme/hata-takibi.md).
final class CrashlyticsErrorReporter implements ErrorReporter {
  CrashlyticsErrorReporter([FirebaseCrashlytics? crashlytics])
    : _crashlytics = crashlytics;

  FirebaseCrashlytics? _crashlytics;

  FirebaseCrashlytics get _sdk => _crashlytics ??= FirebaseCrashlytics.instance;

  /// Otomatik toplamayı kalıcı olarak kapatır (manifest/plist ile aynı değer).
  Future<void> disableCollection() =>
      _sdk.setCrashlyticsCollectionEnabled(false);

  @override
  bool get isAvailable => true;

  @override
  Future<void> sendPending() => _sdk.sendUnsentReports();

  @override
  Future<void> discardPending() => _sdk.deleteUnsentReports();

  @override
  void record(ErrorReport report) {
    try {
      _sdk
          .recordError(
            SanitizedReportException(report.label, report.message),
            report.stack,
            fatal: report.fatal,
            printDetails: false,
          )
          .catchError((Object _) {});
    } on Object {
      // SDK senkron hatası uygulamaya taşmaz.
    }
  }
}
