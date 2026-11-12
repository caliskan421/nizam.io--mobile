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
///   -d <İZOLE simülatör> --flavor dev --no-uninstall --no-pub --timeout 120s \
///   --dart-define=NIZAM_NATIVE_PROBE_MODE=record
/// ```
///
/// `--timeout 120s` gerekli: `send` modu 60 sn yaşam süresi payı bekler (varsayılan test
/// zaman aşımı yetmez).
///
/// `record` ve `record_crash` modları İKİNCİ açık opt-in ister (aksi halde SDK init'inden ÖNCE
/// açık hatayla düşer):
///
/// ```
///   --dart-define=NIZAM_NATIVE_PROBE_MODE=record \
///   --dart-define=NIZAM_NATIVE_PROBE_RECORD_DISCARD=true
/// ```
///
/// UYARI: `NIZAM_NATIVE_PROBE_RECORD_DISCARD=true` record öncesi `deleteUnsentReports` çağırır ve
/// önceki gönderilmemiş raporları SİLER. Yalnız İZOLE, sentetik test verisinde kullanılır; gerçek
/// cihazda/kullanıcı verisinde ASLA. Gerekçe: otomatik toplama kapalıyken SDK başlangıç sözü
/// (FIRCLSReportManager) bir rapor kararı (SEND/DELETE) bekler; karar verilmezse
/// `recordExceptionModel` (waitForContextInit) kaydı yazmaz.
///
/// Mod verilmezse (`NIZAM_NATIVE_PROBE_MODE` boş) HİÇBİR init/yazma/send/crash yapılmaz. Her mod
/// TEK TAZE süreç içindir; `record` modunun yukarıdaki açık temizliği DIŞINDA araç otomatik
/// temizlik yapmaz (`check_pending` önbelleği korur): `ErrorReportingController.load/discard`
/// kullanılmaz, yalnız `initializeFirebaseServices` (otomatik toplamayı kapatır; rapor
/// göndermez/silmez) ve aşağıdaki açık çağrılar çalışır.
///
/// Yerel kanıt dizisi (dört AYRI süreç, aynı izole simülatör verisi):
///   A. `record`        → (opt-in) `await sdk.deleteUnsentReports()` ile başlangıç kararı, sonra
///      `await sdk.recordError(güvenli sabit yük)`; yalnız "köprü kabul etti" (disk garantisi değil).
///   B. `check_pending` → yeniden açılan süreçte `checkForUnsentReports == true` beklenir;
///      ardından (aynı süreçte DEĞİL) `delete` modu ayrı süreçte `deleteUnsentReports` çağırır.
///   C. `check_empty`   → yeni süreçte `checkForUnsentReports == false` beklenir.
/// SDK silme çağrısının tamamlanması (ACK) fiziksel disk silme GARANTİSİ değildir; kanıt C'dir.
///
/// `record_crash` (dSYM'li tek bundle iş akışı): AYNI oturumda `deleteUnsentReports` (başlangıç
/// kararı) → güvenli nonfatal `recordError` (3 sn pay) → `crash` akışı (ARMED + log + native
/// çökme + 10 sn sınırlı başarısızlık). Bundle'da iki olay (nonfatal + fatal) olur. Sonraki süreç
/// `check_pending`, sonra `send`. ÖNEMLİ: her build SONRASI, uygulama DEĞİŞMEDEN (yeniden
/// derleme yok) sembol UUID'si/dSYM snapshot'ı alınmalı; farklı build'in dSYM'i eşleşmez. Yalnız
/// kendi izole simülatör verisinde; kullanıcı verisi yok.
///
/// Bulut kanıtları ayrıdır ve Firebase konsol oturumu gerektirir (kullanıcıda; bu harness bulut
/// erişimi iddia etmez):
///   - `send`  → AÇIK dev testi: `sendUnsentReports()` (yalnız dev Firebase; kullanıcı onayı simülasyonu).
///   - `crash` → AÇIK modda YALNIZ native test çökmesi (`FirebaseCrashlytics.crash()`); çökmeden
///               önce sabit güvenli günlük satırı "armed" işaretidir. Sonraki süreç `check_pending`.
/// Ham yük: kullanıcı verisi/sır YOK, yalnız sabit teknik model.
const _mode = String.fromEnvironment('NIZAM_NATIVE_PROBE_MODE');

/// `record` için ikinci opt-in: önceki gönderilmemiş raporları SİLER (yalnız izole sentetik veri).
const _recordDiscard = bool.fromEnvironment(
  'NIZAM_NATIVE_PROBE_RECORD_DISCARD',
);

const _modes = {
  'record',
  'record_crash',
  'check_pending',
  'delete',
  'check_empty',
  'send',
  'crash',
};

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'native probe: tek mod, tek taze süreç',
    timeout: const Timeout(Duration(minutes: 2)),
    (tester) async {
      if (_mode.isEmpty) {
        // ignore: avoid_print
        print(
          'PROBE: mod yok (NIZAM_NATIVE_PROBE_MODE); hiçbir şey yapılmadı.',
        );
        return;
      }
      expect(_modes, contains(_mode), reason: 'bilinmeyen mod: $_mode');
      if ((_mode == 'record' || _mode == 'record_crash') && !_recordDiscard) {
        // SDK init'inden ÖNCE: hiçbir native yan etki olmasın.
        fail(
          '$_mode modu ikinci opt-in ister: '
          '--dart-define=NIZAM_NATIVE_PROBE_RECORD_DISCARD=true. Bu bayrak önceki '
          'gönderilmemiş raporları SİLER; yalnız izole sentetik test verisinde kullanılır.',
        );
      }

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

      // Yaşam süresi payı (flush/teslim GARANTİSİ DEĞİL): native SDK init sonrası async işlerine
      // fırsat verir; test hemen app stop / native crash yapmasın.
      await _grace(3, 'init sonrası');

      switch (_mode) {
        case 'record':
          // Açık opt-in temizlik: otomatik toplama kapalıyken SDK başlangıç sözü bir rapor kararı
          // bekler; silme kararı onu çözer ve recordError yazılabilir. Disk garantisi DEĞİL (ACK).
          await _discardAndRecord(sdk, 'record');
        case 'record_crash':
          // Tek oturum/bundle'da iki olay: güvenli nonfatal + native çökme. Önce başlangıç kararı
          // (deleteUnsentReports; yalnız sentetik izole veri), SONRA nonfatal, 3 sn pay, SONRA
          // `crash` ile aynı akış.
          await _discardAndRecord(sdk, 'record_crash');
          await _armAndCrash(sdk, 'record_crash');
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
          await _grace(3, 'delete sonrası');
        case 'check_empty':
          final pending = await sdk.checkForUnsentReports();
          _out('check_empty: $pending');
          expect(pending, isFalse, reason: 'yeni süreçte bekleyen rapor yok');
        case 'send':
          await sdk.sendUnsentReports();
          _out(
            'send: sendUnsentReports çağrısı tamamlandı (yalnız dev; bulut kanıtı konsolda)',
          );
          // GDT async ağ kuyruğu / test uygulaması sonlanmadan yaşam süresi payı (teslim garantisi
          // DEĞİL; kanıt konsoldadır).
          await _grace(60, 'send sonrası');
        case 'crash':
          await _armAndCrash(sdk, 'crash');
      }
    },
  );
}

/// `record` ve `record_crash` ortak adımı: opt-in başlangıç kararı + güvenli nonfatal kaydı.
Future<void> _discardAndRecord(FirebaseCrashlytics sdk, String label) async {
  // Açık opt-in temizlik: otomatik toplama kapalıyken SDK başlangıç sözü bir rapor kararı
  // bekler; silme kararı onu çözer ve recordError yazılabilir. Disk garantisi DEĞİL (ACK).
  await sdk.deleteUnsentReports();
  _out(
    '$label: öncesinde deleteUnsentReports (opt-in; SDK başlangıç kararı, ACK)',
  );
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
  _out('$label: await recordError tamamlandı (köprü kabul etti)');
  await _grace(3, '$label record sonrası');
}

/// `crash` ve `record_crash` ortak adımı: ARMED günlük + native çökme + sınırlı başarısızlık.
Future<void> _armAndCrash(FirebaseCrashlytics sdk, String label) async {
  _out('$label: ARMED — native test çökmesi şimdi (sabit güvenli günlük)');
  await sdk.log('probe: native-test-crash armed');
  sdk.crash();
  // Android'de çökme ~50 ms GECİKMELİ tetiklenir: test hemen başarıya düşmemeli. Süreç
  // ölümünü sınırlı süre bekle; ölmezse AÇIKÇA başarısız say (ARMED başarı kanıtı değildir).
  await Future<void>.delayed(const Duration(seconds: 10));
  fail(
    '$label: süreç 10 sn içinde ölmedi; native çökme tetiklenmedi '
    '(ARMED başarı kanıtı DEĞİLDİR)',
  );
}

/// Gerçek (fake olmayan) bekleme: SDK async I/O'suna fırsat verir; flush/teslim garantisi değildir.
Future<void> _grace(int seconds, String label) async {
  _out('grace: $seconds sn ($label)');
  await Future<void>.delayed(Duration(seconds: seconds));
}

void _out(String line) {
  // ignore: avoid_print
  print('PROBE ${Platform.operatingSystem}: $line');
}
