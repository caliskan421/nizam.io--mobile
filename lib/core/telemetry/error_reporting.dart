import 'package:flutter/foundation.dart';

import 'error_report.dart';
import 'stack_sanitizer.dart';

/// Firebase'den bağımsız hata raporlama portu. Gerçek gerçekleştirme `app/telemetry`
/// altındadır (S6); varsayılan [NoopErrorReporter] hiçbir şey göndermez.
///
/// SDK'nın OTOMATİK toplaması hep KAPALIDIR. Raporlar cihazda saklanır; yalnız kullanıcı onayı
/// varken [sendPending] ile AÇIKÇA gönderilir, onay yokken [discardPending] ile silinir.
abstract interface class ErrorReporter {
  /// SDK kullanılabilir mi (arayüzde denetimin gösterilip gösterilmeyeceği).
  bool get isAvailable;

  /// Cihazda biriken ÖNCEKİ oturum raporlarını gönderir (yalnız onay varken çağrılır).
  Future<void> sendPending();

  /// Cihazda biriken raporları siler (onay yokken / geri alınırken).
  Future<void> discardPending();

  /// Temizlenmiş raporu SDK'ya verir. Eşzamanlı çağrılır; fırlatırsa [ErrorReporting] yutar.
  void record(ErrorReport report);
}

final class NoopErrorReporter implements ErrorReporter {
  const NoopErrorReporter();

  @override
  bool get isAvailable => false;

  @override
  Future<void> sendPending() async {}

  @override
  Future<void> discardPending() async {}

  @override
  void record(ErrorReport report) {}
}

/// [ErrorReporting.attach] sonucu: bağın sahibi olma kanıtı.
final class ErrorReportingBinding {
  ErrorReportingBinding._(this._token);

  final Object _token;

  /// Bu bağ hâlâ geçerli mi.
  bool get active => identical(ErrorReporting._owner, _token);

  /// Kapıyı yalnız bağ geçerliyse değiştirir; sonuç: değişti mi.
  bool setEnabled(bool value) {
    if (!active) return false;
    ErrorReporting._enabled = value;
    return true;
  }

  /// Bağı söker ve kapıyı kapatır (yalnız bağ geçerliyse).
  void detach() {
    if (!active) return;
    ErrorReporting._owner = null;
    ErrorReporting._reporter = const NoopErrorReporter();
    ErrorReporting._enabled = false;
  }
}

/// Dart tarafı raporlama cephesi: onay kapısı, çift rapor engeli, hız sınırı, yığın
/// temizliği ve "raporlayıcı kendi hatasıyla döngüye girmez" güvencesi.
///
/// ONAY KAPISI SDK'dan bağımsızdır: [enabled] false iken hiçbir şey SDK'ya verilmez.
/// Varsayılan KAPALIDIR. Raporlayıcı bileşim ömrüne bağlıdır: [attach] bir ayırıcı döner
/// (`ErrorReportingController.dispose` çağırır); başka bileşimin raporlayıcısını ezmez.
abstract final class ErrorReporting {
  static ErrorReporter _reporter = const NoopErrorReporter();
  static Object? _owner;
  static bool _enabled = false;
  static bool _inReport = false;
  static Expando<bool> _seen = Expando<bool>('reportedErrors');
  static final Map<String, DateTime> _lastByKey = {};
  static int _sent = 0;

  /// Aynı sınıf+yığın için en kısa rapor aralığı ve oturum başına üst sınır
  /// (ağ/5xx ve döngüsel hata fırtınası).
  static const minInterval = Duration(minutes: 5);
  static const sessionCap = 25;
  static const _maxKeys = 64;

  static DateTime Function() _clock = DateTime.now;

  static bool get enabled => _enabled;

  /// Raporlayıcıyı bağlar. Dönen [ErrorReportingBinding] YALNIZ hâlâ geçerli bağsa kapıyı
  /// açıp kapar / ayırır; yerine başka bileşim bağlandıysa (ya da sökülmüşse) etkisizdir.
  static ErrorReportingBinding attach(ErrorReporter reporter) {
    final token = Object();
    _owner = token;
    _reporter = reporter;
    _enabled = false;
    return ErrorReportingBinding._(token);
  }

  /// Dart kapısını açar/kapatır (`ErrorReportingController` onayı doğruladığı yerde).
  static void setEnabled(bool value) => _enabled = value;

  @visibleForTesting
  static void reset({DateTime Function()? clock}) {
    _reporter = const NoopErrorReporter();
    _owner = null;
    _enabled = false;
    _inReport = false;
    _lastByKey.clear();
    _seen = Expando<bool>('reportedErrors');
    _sent = 0;
    _clock = clock ?? DateTime.now;
  }

  /// Bu hata nesnesi daha önce raporlandı/ele alındı mı (küresel kancalar tekrarlamasın).
  static bool alreadyHandled(Object? error) {
    if (error == null) return false;
    try {
      return _seen[error] ?? false;
    } on ArgumentError {
      return false; // Expando'ya konamayan değer (String, num …)
    }
  }

  /// Dönüştürülmüş hata nesnesini (ör. ApiError) aynı kökten sayar: tekrar raporlanmaz.
  static void markHandled(Object error) {
    try {
      _seen[error] = true;
    } on ArgumentError {
      // işaretlenemedi
    }
  }

  /// Hatayı [kind] sınıfında raporlar. [operation] verilmezse çalışan [ReportContext].
  /// Kapalıysa, daha önce raporlandıysa ya da hız sınırındaysa hiçbir şey yapmaz; hiçbir
  /// koşulda fırlatmaz.
  static void report(
    Object error,
    StackTrace stack, {
    required ReportKind kind,
    ReportOperation? operation,
    String? apiCode,
    int? status,
    bool fatal = false,
  }) {
    if (!_enabled || _inReport) return;
    _inReport = true;
    try {
      if (alreadyHandled(error)) return;
      markHandled(
        error,
      ); // hız sınırına takılsa da aynı nesne bir daha ele alınmaz
      final report = ErrorReport.create(
        operation: operation ?? ReportContext.current,
        kind: kind,
        errorType: ReportErrorType.of(error),
        stack: sanitizeStack(stack),
        apiCode: apiCode,
        status: status,
        fatal: fatal,
      );
      if (!_admit(report)) return;
      _reporter.record(report);
    } on Object {
      // Raporlayıcı hatası uygulamaya taşmaz, yeniden raporlanmaz.
    } finally {
      _inReport = false;
    }
  }

  static bool _admit(ErrorReport r) {
    if (_sent >= sessionCap && !r.fatal) return false;
    final top = r.stack.toString().split('\n').take(3).join('|');
    final key = '${r.label}#$top';
    final now = _clock();
    final last = _lastByKey[key];
    if (!r.fatal && last != null && now.difference(last) < minInterval) {
      return false;
    }
    if (_lastByKey.length >= _maxKeys) _lastByKey.remove(_lastByKey.keys.first);
    _lastByKey[key] = now;
    _sent++;
    return true;
  }
}
