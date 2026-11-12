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
/// - Onay yazı/okumaları DEPO bazında (tüm [AppPreferences] örnekleri arasında) tek şeritte
///   sıralanır. Başlamış bir `true` yazısı iptal edilemez: bağı başkasına geçen/atılan
///   denetleyicinin geç biten `true` yazısı depo sırasında `false`/silme ile geri alınır; daha
///   yeni gerçek bir onay verme isteği varsa ezilmez. Yeni sahibin okuma ve yazıları eski yazının
///   ARDINA girer.
/// - Dürüst sınır (fail-closed): geri alma/iptal yazısı süresinde doğrulanamazsa kapı bu süreçte
///   KAPALI kalır (hiçbir şey gönderilmez); sıradaki yazı yine çalışır, ama süreç ondan önce ölürse
///   kayıtta `true` kalabilir ve sonraki açılış onaylı sayar. Bu durum yalnız
///   [ReportingNotice.revokeNotPersisted] ile bildirilir, "kapatıldı" diye sunulmaz.
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
  Future<void> load() {
    // Nesil İSTEK anında alınır: sıradaki işe geçmeden gelen `set` (ör. geri alma) bu yüklemeyi
    // bayatlatır; yükleme sonradan kapıyı açıp geri almayı ezemez.
    final gen = _gen;
    return _enqueue(() => _load(gen));
  }

  Future<void> _load(int gen) async {
    if (!_reporter.isAvailable || _disposed) return;
    _binding ??= ErrorReporting.attach(_reporter);
    final consent = await _prefs.errorReportingConsent();
    // Her await SONRASI ve her SDK/tercih yan etkisi ÖNCESİ: istek nesli, bağ sahipliği ve
    // dispose birlikte denetlenir (yerine başka denetleyici bağlandıysa eski yükleme etkisizdir).
    if (!_current(gen)) return;
    if (consent) {
      await _bounded(
        _reporter.sendPending,
      ); // başarısızlık gizlilik sorunu değil
      if (_current(gen)) _open();
    } else {
      final confirmed = await _confirmed(_reporter.discardPending);
      if (_current(gen)) _discardConfirmed = confirmed;
    }
  }

  /// Bu istek hâlâ geçerli mi: aynı nesil, bu denetleyici dispose edilmedi ve ortak
  /// [ErrorReporting] bağı hâlâ bu denetleyicinin.
  bool _current(int gen) =>
      gen == _gen && !_disposed && (_binding?.active ?? false);

  /// Tercih/silme yan etkisi için bağ sahipliği (bağ henüz kurulmadıysa sahiplik çatışması yok).
  bool get _owned => !_disposed && (_binding?.active ?? true);

  /// Tercihi değiştirir; etkin durumu döner. Sonuç mesajı [notice]'tadır.
  Future<bool> set(bool want) {
    if (want && state.value) return Future.value(true);
    final gen = ++_gen;
    notice.value = ReportingNotice.none;
    if (!want) _close(); // kapı eşzamanlı kapanır; sıradaki iş beklenmez
    // Geri alma isteği anında (await/enqueue ÖNCESİ) ortak depo şeridi kilitlenir: SDK kapısında
    // bekleyen eski yükleme ya da yeni bir denetleyicinin okuması `true` görmez. Yalnız geçerli
    // sahip kilitler; bağı zaten başkasına geçmiş/atılmış denetleyici yeni sahibi kapatmaz.
    final revoke = !want && _owned ? _prefs.beginErrorReportingRevoke() : null;
    return _enqueue(() async {
      if (want) {
        if (!_reporter.isAvailable || _disposed) {
          notice.value = ReportingNotice.enableFailed;
          return;
        }
        _binding ??= ErrorReporting.attach(_reporter);
        if (!_current(gen)) return; // geri alındı / yerine başkası bağlandı
        if (!_discardConfirmed) {
          final confirmed = await _confirmed(_reporter.discardPending);
          if (!_current(gen)) {
            return; // arada geri alındı ya da bağ el değiştirdi
          }
          _discardConfirmed = confirmed;
        }
        if (!_discardConfirmed) {
          notice.value = ReportingNotice.enableFailed; // yazma ve açma YOK
          return;
        }
        // Sahiplik/nesil depo sırasının İÇİNDE (fiziksel yazıdan önce ve sonra) sorulur: bayat
        // `true` aynı sıra işinde geri alınır, yeni sahibin okuması onu hiç görmez.
        final grant = _prefs.grantErrorReportingConsent(
          isCurrent: () => _current(gen),
        );
        final written = await grant.written;
        if (!_current(gen)) {
          // Yalnız dar aralık: yazı geçerliyken tamamlandı, ardından (mikro görev aralığında) sahip
          // değişti. Başlamış fiziksel yazı iptal edilemez; daha yeni gerçek onaya dokunulmaz.
          if (written && !_owned) {
            await _prefs.rollbackErrorReportingGrant(grant.ticket);
          }
          return;
        }
        if (!written) {
          // Yazı gecikmeli tamamlanıp `true` bırakmasın: kapalıyı sırayla yaz.
          await _prefs.setErrorReportingConsent(false);
          notice.value = ReportingNotice.enableFailed;
          return;
        }
        _open();
      } else {
        // Değiştirilmiş/atılmış denetleyici yeni bileşimin tercihlerine ya da SDK'sına dokunmaz.
        // Sahiplik sonradan düşse bile kurulmuş kilit kapalı kalır (güvenli yön).
        if (revoke == null || !_owned) return;
        var persisted = await _prefs.setErrorReportingConsent(
          false,
          revokeTicket: revoke,
        );
        if (!persisted && _owned) {
          persisted = await _prefs.removeErrorReportingConsent(
            revokeTicket: revoke,
          );
        }
        if (!persisted && gen == _gen && !_disposed) {
          notice.value = ReportingNotice.revokeNotPersisted;
        }
        if (!_owned) return;
        final confirmed = await _confirmed(_reporter.discardPending);
        if (_owned) _discardConfirmed = confirmed;
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
