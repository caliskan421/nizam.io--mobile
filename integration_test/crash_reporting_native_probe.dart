import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nizamio/app/config/firebase_services.dart';
import 'package:nizamio/app/telemetry/crashlytics_error_reporter.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/report_source.dart';
import 'package:nizamio/core/telemetry/stack_sanitizer.dart';

/// MANUEL native Crashlytics yerel-kanıt harness'i. Dosya adı `_test.dart` ile BİTMEZ: otomatik
/// test keşfine (`flutter test integration_test`) girmez; yalnız açıkça adıyla ve bir mod ile
/// çalışır:
///
/// ```
/// flutter test integration_test/crash_reporting_native_probe.dart \
///   -d <İZOLE simülatör> --dart-define=NIZAM_NATIVE_PROBE_MODE=record
/// ```
///
/// Mod verilmezse (`NIZAM_NATIVE_PROBE_MODE` boş) HİÇBİR record/send/crash yapılmaz. Her mod TEK
/// TAZE süreç içindir; araç kendi temizliğini yapmaz: `ErrorReportingController.load/discard`
/// kullanılmaz (önbellek kanıtını yanlışlıkla silmesin), yalnız `initializeFirebaseServices`
/// (otomatik toplamayı kapatır; rapor göndermez/silmez) ve aşağıdaki açık çağrı çalışır.
///
/// Yerel kanıt dizisi (dört AYRI süreç, aynı izole simülatör verisi):
///   A. `record`        → `await sdk.recordError(güvenli sabit yük)`; yalnız "köprü kabul etti".
///   B. `check_pending` → yeniden açılan süreçte `checkForUnsentReports == true` beklenir;
///      ardından (aynı süreçte DEĞİL) `delete` modu ayrı süreçte `deleteUnsentReports` çağırır.
///   C. `check_empty`   → yeni süreçte `checkForUnsentReports == false` beklenir.
/// SDK silme çağrısının tamamlanması (ACK) fiziksel disk silme GARANTİSİ değildir; kanıt C'dir.
///
/// Bulut kanıtları ayrıdır ve Firebase konsol oturumu gerektirir (kullanıcıda; bu harness bulut
/// erişimi iddia etmez):
///   - `send`  → AÇIK dev testi: `sendUnsentReports()` (yalnız dev Firebase; kullanıcı onayı simülasyonu).
///   - `crash` → AÇIK modda YALNIZ native test çökmesi (`FirebaseCrashlytics.crash()`); çökmeden
///               önce sabit güvenli günlük satırı "armed" işaretidir. Sonraki süreç `check_pending`.
/// Ham yük: kullanıcı verisi/sır YOK, yalnız sabit teknik model.
const _mode = String.fromEnvironment('NIZAM_NATIVE_PROBE_MODE');

const _modes = {
  'record',
  'check_pending',
  'delete',
  'check_empty',
  'send',
  'crash',
};

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('native probe: tek mod, tek taze süreç', (tester) async {
    if (_mode.isEmpty) {
      // ignore: avoid_print
      print('PROBE: mod yok (NIZAM_NATIVE_PROBE_MODE); hiçbir şey yapılmadı.');
      return;
    }
    expect(_modes, contains(_mode), reason: 'bilinmeyen mod: $_mode');

    final services = await initializeFirebaseServices(
      Flavor.dev,
      timeout: const Duration(seconds: 15),
    );
    expect(services, isNotNull, reason: 'dev Firebase yapılandırması');
    final sdk = FirebaseCrashlytics.instance;
    expect(
      sdk.isCrashlyticsCollectionEnabled,
      isFalse,
      reason: 'otomatik toplama kapalı olmalı',
    );

    switch (_mode) {
      case 'record':
        final report = ErrorReport.create(
          operation: ReportOperation.none,
          kind: ReportKind.unexpected,
          errorType: ReportErrorType.stateError,
          stack: sanitizeStack(StackTrace.current),
          source: ReportSource.app,
        );
        await sdk.recordError(
          SanitizedReportException(report.label, report.message),
          report.stack,
          fatal: false,
          printDetails: false,
        );
        _out('record: await recordError tamamlandı (köprü kabul etti)');
      case 'check_pending':
        final pending = await sdk.checkForUnsentReports();
        _out('check_pending: $pending');
        expect(
          pending,
          isTrue,
          reason: 'yeniden açılan süreçte bekleyen rapor',
        );
      case 'delete':
        await sdk.deleteUnsentReports();
        _out(
          'delete: deleteUnsentReports çağrısı tamamlandı (ACK; disk garantisi değil)',
        );
      case 'check_empty':
        final pending = await sdk.checkForUnsentReports();
        _out('check_empty: $pending');
        expect(pending, isFalse, reason: 'yeni süreçte bekleyen rapor yok');
      case 'send':
        await sdk.sendUnsentReports();
        _out(
          'send: sendUnsentReports çağrısı tamamlandı (yalnız dev; bulut kanıtı konsolda)',
        );
      case 'crash':
        _out('crash: ARMED — native test çökmesi şimdi (sabit güvenli günlük)');
        await sdk.log('probe: native-test-crash armed');
        sdk.crash();
        // Android'de çökme ~50 ms GECİKMELİ tetiklenir: test hemen başarıya düşmemeli. Süreç
        // ölümünü sınırlı süre bekle; ölmezse AÇIKÇA başarısız say (ARMED başarı kanıtı değildir).
        await Future<void>.delayed(const Duration(seconds: 10));
        fail(
          'crash: süreç 10 sn içinde ölmedi; native çökme tetiklenmedi '
          '(ARMED başarı kanıtı DEĞİLDİR)',
        );
    }
  });
}

void _out(String line) {
  // ignore: avoid_print
  print('PROBE ${Platform.operatingSystem}: $line');
}
