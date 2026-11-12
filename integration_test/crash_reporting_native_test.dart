import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nizamio/app/config/firebase_services.dart';
import 'package:nizamio/app/telemetry/crashlytics_error_reporter.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/report_source.dart';
import 'package:nizamio/core/telemetry/stack_sanitizer.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Test-only AÇIK OPT-IN: `--dart-define=NIZAM_NATIVE_CRASH_SMOKE=true` olmadan hiçbir şey
/// çalışmaz (varsayılan CI ve gerçek kullanıcı cihazında yan etki yok).
const _optIn = bool.fromEnvironment('NIZAM_NATIVE_CRASH_SMOKE');

/// GERÇEK native Crashlytics SDK (dev Firebase) için DÜRÜST duman testi.
///
/// KANIT SINIRI (yanlış iddia yok):
/// - Yalnız şunu doğrular: `await sdk.recordError(...)` Future'ı hatasız tamamlandı = native
///   köprü çağrıyı KABUL ETTİ. SDK'nın raporu o oturumda diske yazdığı, hangi dosyada olduğu ya
///   da silindiği iddia EDİLMEZ: resmî SDK raporları önceki oturumda/açılışta/ölümcül paketler;
///   `checkForUnsentReports` süreçte bir kez true dönebilir ve ikinci false dönmesi silme kanıtı
///   DEĞİLDİR. Yerel yazma/yeniden açılış/silme kanıtı ayrı bir süreç dizisidir:
///   `crash_reporting_native_probe.dart` (A kaydet → B denetle/sil → C boş).
/// - Üretim `CrashlyticsErrorReporter.record` void'dir ve hatayı yutar; bu yüzden burada
///   adaptörün DEĞİL, aynı güvenli yükün SDK'ya doğrudan verilmesi sınanır.
/// - Rapor gönderilmez (`sendUnsentReports` yok), yerel rapor SİLİNMEZ (`deleteUnsentReports`
///   yok), native çökme üretilmez, bulut/konsol erişimi yoktur. Ham veri yok: etiket + sabit
///   Türkçe iletiden oluşan güvenli yük, temizlenmiş yığın, `automatic=false`, PackageInfo.
/// - Üretim koduna test düğmesi/derleme tanımı eklenmemiştir; bu yalnız test yürütücüsüdür.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'native SDK: toplama kapalı, güvenli yük köprüden KABUL edildi (await recordError)',
    (tester) async {
      final services = await initializeFirebaseServices(
        Flavor.dev,
        timeout: const Duration(seconds: 15),
      );
      expect(services, isNotNull, reason: 'dev Firebase yapılandırması');
      expect(services!.errorReporter.isAvailable, isTrue);

      final sdk = FirebaseCrashlytics.instance;
      expect(
        sdk.isCrashlyticsCollectionEnabled,
        isFalse,
        reason:
            'otomatik toplama kapalı (automatic=false); onaysız gönderim yok',
      );

      // Güvenli yük: ErrorReport yalnız beyaz listeli alanlarla kurulur.
      final report = ErrorReport.create(
        operation: ReportOperation.none,
        kind: ReportKind.unexpected,
        errorType: ReportErrorType.stateError,
        stack: sanitizeStack(StackTrace.current),
        source: ReportSource.app,
      );
      expect(report.label, startsWith('kind=unexpected op=none src=app'));
      expect(report.message, isNotEmpty);
      expect(report.stack.toString(), isNot(contains('/Users/')));

      // GERÇEK Future: tamamlanması = native köprü çağrıyı kabul etti.
      await sdk.recordError(
        SanitizedReportException(report.label, report.message),
        report.stack,
        fatal: false,
        printDetails: false,
      );
      expect(sdk.isCrashlyticsCollectionEnabled, isFalse);

      // Native metadata kaynağı: uygulama sürümü/build.
      final info = await PackageInfo.fromPlatform();
      expect(info.version, isNotEmpty);
      expect(info.buildNumber, isNotEmpty);
    },
    skip: !_optIn,
  );
}
