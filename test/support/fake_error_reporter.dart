import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';

/// Sahte raporlayıcı: kaydedilen raporlar ve SDK yaşam döngüsü çağrıları.
/// NOT: `reports` Dart cephesinin SDK'ya VERDİĞİ nesnedir; gerçek Firebase kanal yükü
/// `test/app/telemetry/crashlytics_channel_test.dart` ile ayrıca doğrulanır.
class FakeErrorReporter implements ErrorReporter {
  final reports = <ErrorReport>[];
  final calls = <String>[];
  bool available = true;
  Error? recordThrows;
  Error? sdkThrows;

  /// Verilirse `sendPending`/`discardPending` bu tamamlanana kadar bekler.
  Future<void>? sdkGate;

  @override
  bool get isAvailable => available;

  /// Yalnız `discardPending` için hata / bekleme (silme belirsizliği benzetimi).
  Error? discardThrows;
  Future<void>? discardGate;

  Future<void> _sdk(String name, {Error? error, Future<void>? gate}) async {
    calls.add(name);
    await sdkGate;
    await gate;
    final e = error ?? sdkThrows;
    if (e != null) throw e;
  }

  @override
  Future<void> sendPending() => _sdk('send');

  @override
  Future<void> discardPending() =>
      _sdk('discard', error: discardThrows, gate: discardGate);

  @override
  void record(ErrorReport report) {
    reports.add(report);
    final e = recordThrows;
    if (e != null) throw e;
  }
}

String wireOf(ErrorReport r) => '${r.label}\n${r.stack}';
