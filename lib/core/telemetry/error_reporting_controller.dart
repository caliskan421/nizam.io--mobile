import 'dart:async';

import 'package:flutter/foundation.dart';

import '../preferences/app_preferences.dart';
import 'error_reporting.dart';

/// Kullanıcıya gösterilecek tercih sonucu (ARB metnine arayüzde eşlenir).
enum ReportingNotice {
  none,

  /// Açılamadı (tercih yazılamadı, raporlayıcı yok ya da onaydan ÖNCEKİ cihaz raporları
  /// silinemedi); kapalı kaldı.
  enableFailed,

  /// Bu oturumda KAPATILDI ama kapalı olduğu kalıcı kaydedilemedi: sonraki açılışta eski
  /// "açık" kaydı geri gelebilir. "Başarıyla kapatıldı" denmez.
  revokeNotPersisted,
}

/// Kullanıcının hata raporlama tercihi: bellek durumu + kalıcılık + Dart kapısı + SDK
/// bekleyen rapor yaşam döngüsü.
///
/// SDK'nın otomatik toplaması HEP kapalıdır (bu sınıf hiçbir zaman açmaz). Rapor cihazda
/// birikir; onay VARKEN açılışta ÖNCEKİ oturumların raporları açıkça gönderilir
/// ([ErrorReporter.sendPending]), onay YOKKEN silinir ([ErrorReporter.discardPending]).
///
/// - Gönderim, tercih okunduktan SONRA ve çağrı anında hâlâ geçerli olan istek için yapılır
///   (okuma sürerken geri alma geldiyse gönderilmez).
/// - Açma: onaydan ÖNCEKİ cihaz raporlarının silindiği ONAYLANMIŞ olmalıdır
///   ([_discardConfirmed]); silme başarısız/belirsizse tercih YAZILMAZ ve kapı AÇILMAZ
///   (kullanıcıya bildirilir; yalnız sonraki açık eylemde yeniden denenir). Sonra tercih yazılır
///   (yazılamazsa açılmaz), sonra Dart kapısı açılır.
/// - Geri alma: kapı HEMEN kapanır; tercih yazılır, olmazsa kayıt silinir; ikisi de olmazsa
///   [ReportingNotice.revokeNotPersisted]. Sonsuz yeniden deneme yoktur. Bekleyen raporlar silinir.
/// - Kapı yalnız bu denetleyicinin bağı ([ErrorReportingBinding]) hâlâ geçerliyse
///   değişir: yerine başka bileşim bağlandıysa eski denetleyicinin geç sonuçları etkisizdir.
/// - Raporlayıcı kullanılamıyorsa (prod, Firebase açılamadı, geç başlatma) hiçbir şey açılmaz.
class ErrorReportingController {
  ErrorReportingController(
    this._prefs,
    this._reporter, {
    this.sdkTimeout = const Duration(seconds: 2),
  });

  final AppPreferences _prefs;
  final ErrorReporter _reporter;
  final Duration sdkTimeout;

  /// Etkin durum: Dart kapısı açık.
  final ValueNotifier<bool> state = ValueNotifier(false);

  /// Son [set] çağrısının kullanıcıya bildirilecek sonucu.
  final ValueNotifier<ReportingNotice> notice = ValueNotifier(
    ReportingNotice.none,
  );

  Future<void> _queue = Future<void>.value();
  int _gen = 0;
  bool _disposed = false;
  ErrorReportingBinding? _binding;

  /// Onaydan önceki cihaz raporlarının silindiği bu süreçte doğrulandı mı.
  bool _discardConfirmed = false;

  /// Arayüzde denetim gösterilsin mi.
  bool get available => _reporter.isAvailable;

  /// Açılışta kayıtlı onayı uygular. Hiçbir zaman fırlatmaz.
  Future<void> load() => _enqueue(() async {
    if (!_reporter.isAvailable || _disposed) return;
    final gen = _gen;
    _binding ??= ErrorReporting.attach(_reporter);
    final consent = await _prefs.errorReportingConsent();
    if (gen != _gen) return; // okuma sürerken geri alma/yeni istek: GÖNDERME
    if (consent) {
      await _bounded(
        _reporter.sendPending,
      ); // başarısızlık gizlilik sorunu değil
      if (gen == _gen) _open();
    } else {
      _discardConfirmed = await _confirmed(_reporter.discardPending);
    }
  });

  /// Tercihi değiştirir; etkin durumu döner. Sonuç mesajı [notice]'tadır.
  Future<bool> set(bool want) {
    if (want && state.value) return Future.value(true);
    final gen = ++_gen;
    notice.value = ReportingNotice.none;
    if (!want) _close(); // kapı eşzamanlı kapanır; sıradaki iş beklenmez
    return _enqueue(() async {
      if (want) {
        if (!_reporter.isAvailable || _disposed) {
          notice.value = ReportingNotice.enableFailed;
          return;
        }
        _binding ??= ErrorReporting.attach(_reporter);
        if (!_discardConfirmed) {
          _discardConfirmed = await _confirmed(_reporter.discardPending);
        }
        if (gen != _gen) return; // arada geri alındı
        if (!_discardConfirmed) {
          notice.value = ReportingNotice.enableFailed; // yazma ve açma YOK
          return;
        }
        final written = await _prefs.setErrorReportingConsent(true);
        if (gen != _gen) return; // arada geri alındı; geri alma `false` yazar
        if (!written) {
          // Yazı gecikmeli tamamlanıp `true` bırakmasın: kapalıyı sırayla yaz.
          await _prefs.setErrorReportingConsent(false);
          notice.value = ReportingNotice.enableFailed;
          return;
        }
        _open();
      } else {
        var persisted = await _prefs.setErrorReportingConsent(false);
        persisted = persisted || await _prefs.removeErrorReportingConsent();
        if (!persisted && gen == _gen) {
          notice.value = ReportingNotice.revokeNotPersisted;
        }
        _discardConfirmed = await _confirmed(_reporter.discardPending);
      }
    }).then((_) => state.value);
  }

  void _open() {
    if (_disposed) return;
    if (_binding?.setEnabled(true) ?? false) state.value = true;
  }

  void _close() {
    if (_disposed) return;
    _binding?.setEnabled(false);
    state.value = false;
  }

  /// SDK çağrısı süresi içinde BAŞARIYLA bittiyse `true`; hata/zaman aşımı `false`.
  Future<bool> _confirmed(Future<void> Function() sdkCall) async {
    try {
      await sdkCall().timeout(sdkTimeout);
      return true;
    } on Object {
      return false;
    }
  }

  Future<void> _bounded(Future<void> Function() sdkCall) async {
    await _confirmed(sdkCall);
  }

  Future<void> _enqueue(Future<void> Function() job) {
    final next = _queue.then((_) => job()).catchError((Object _) {});
    _queue = next;
    return next;
  }

  /// Kapıyı kapatır ve raporlayıcıyı bu bileşimden ayırır (başka bileşimi etkilemez).
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _gen++;
    _binding
        ?.detach(); // yalnız bu bağ hâlâ geçerliyse kapıyı kapatır ve ayırır
    _binding = null;
    state.dispose();
    notice.dispose();
  }
}
