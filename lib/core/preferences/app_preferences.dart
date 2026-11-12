import 'dart:convert';

import 'package:flutter/material.dart';

import '../config/mobile_release_policy.dart';
import '../logging/log.dart';
import '../storage/preference_store.dart';
import '../telemetry/report_source.dart';
import '../telemetry/unexpected_error.dart';

/// Tek bir tercihin tipli tanımı: SABİT anahtar + varsayılan + kodlayıcı. Dosya-özel; dışarı
/// açılmaz (ham depo ve anahtar yalnız [AppPreferences] içinde kalır, S5/S7). [decode] tanımsız
/// değerde `null` döner → varsayılan.
class _Pref<T extends Object> {
  const _Pref(this.key, this.fallback, this.encode, this.decode);

  final String key;
  final T fallback;
  final String Function(T) encode;
  final T? Function(String) decode;
}

/// Bir deponun onay şeridi: YALNIZ yazılar sıralanır (okuma kuyruğu uzatmaz; takılan okuma
/// yazıları engellemez). Her yazı bir öncekinin FİZİKSEL bitişinden sonra başlar; çağıranın
/// zaman aşımı yazıyı iptal etmez, sırayı da bozmaz.
final class _ConsentLane {
  Future<void> tail = Future<void>.value();
  int seq = 0;

  /// En yeni onay VERME isteğinin bileti (geri alma bundan eski biletlere dokunur).
  int lastGrant = 0;

  /// Geri alma (`false`) VE silme ikisi de başarısız oldu: kayıtta bayat `true` kalmış olabilir.
  /// Bu durumda okuma KAPALI döner (gönderim 0); yalnız açık başarılı bir `false`/silme ya da
  /// yeni GEÇERLİ bir onay yazısı kilidi kaldırır.
  bool blocked = false;

  /// Geri alma/silme İSTEKLERİ sayacı: istek anında (kuyruk başlamadan) [blocked] kurulur ve bu
  /// sayaç artar. Bir işlem kilidi ancak istek anındaki sayı hâlâ güncelse kaldırır; sonradan
  /// istenmiş bir geri alma/silme varsa onun kilidi ezilmez.
  int blockGen = 0;

  int beginRevoke() {
    blocked = true;
    return ++blockGen;
  }

  void clearIfCurrent(int gen) {
    if (blockGen == gen) blocked = false;
  }
}

/// Uygulama tercihleri: tipli erişim + SABİT anahtar kümesi. Yeni tercih buraya bir [_Pref]
/// ve tipli okuma/yazma olarak eklenir; serbest anahtarla yazma yoktur (gizli veri kaçmasın).
///
/// Okuma hatası varsayılana düşer (tercih kaybı uygulamayı durdurmaz); yazma hatası
/// günlüğe yazılır ve yutulur.
/// Bir onay verme isteğinin CANLI sahiplik/nesil geçerliliği. Sıra işi bunu fiziksel yazıdan
/// ÖNCE ve SONRA okur; `false` ise istek bayattır (sahip değişti, geri alındı, atıldı).
abstract interface class ErrorReportingGrantValidity {
  bool get isCurrent;
}

class _AlwaysCurrentGrant implements ErrorReportingGrantValidity {
  const _AlwaysCurrentGrant();

  @override
  bool get isCurrent => true;
}

class AppPreferences {
  AppPreferences(this._store);

  final PreferenceStore _store;
  Future<void> _releasePolicyWrites = Future<void>.value();

  /// Onay yazı/okuma sırası DEPOYA bağlıdır (örneğe değil): aynı kalıcı depoyu kullanan her
  /// [AppPreferences] (eski/yeni bileşim) aynı şeridi paylaşır.
  static final Expando<_ConsentLane> _lanes = Expando<_ConsentLane>(
    'consentLanes',
  );

  _ConsentLane get _lane {
    final store = _store;
    final Object key = store is PlatformBackedStore
        ? PlatformBackedStore
        : store;
    return _lanes[key] ??= _ConsentLane();
  }

  static const errorReportingKey = 'nizamio.pref.error_reporting.v1';
  static const themeModeKey = 'nizamio.pref.theme_mode';
  static const localeKey = 'nizamio.pref.locale';
  static const releasePolicyKey = 'nizamio.pref.release_policy.v1';

  /// Desteklenen diller (altyapı; şimdilik yalnız Türkçe).
  static const supportedLocales = [Locale('tr')];

  static final _themeMode = _Pref<ThemeMode>(
    themeModeKey,
    ThemeMode.system,
    (m) => m.name,
    (v) => ThemeMode.values.where((m) => m.name == v).firstOrNull,
  );

  static final _locale = _Pref<Locale>(
    localeKey,
    const Locale('tr'),
    (l) => l.languageCode,
    (v) => supportedLocales.where((l) => l.languageCode == v).firstOrNull,
  );

  Future<T> _read<T extends Object>(_Pref<T> pref) async {
    try {
      final v = await _store.getString(pref.key);
      return (v == null ? null : pref.decode(v)) ?? pref.fallback;
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.preferences);
      Log.warn('tercih: okunamadı; varsayılan (${pref.key})');
      return pref.fallback;
    }
  }

  Future<void> _write<T extends Object>(_Pref<T> pref, T value) async {
    try {
      await _store.setString(pref.key, pref.encode(value));
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.preferences);
      Log.warn('tercih: yazılamadı (${pref.key})');
    }
  }

  /// Validated non-personal policy. Mandatory floors do not expire offline:
  /// a network failure or bad publication must not lift a previously accepted gate.
  Future<MobileReleasePolicy?> releasePolicy() async {
    try {
      final raw = await _store
          .getString(releasePolicyKey)
          .timeout(const Duration(milliseconds: 500));
      if (raw == null) return null;
      return MobileReleasePolicy.fromRemoteConfig(
        Map<String, Object?>.from(jsonDecode(raw) as Map),
      );
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.preferences);
      // An unreadable/corrupt existing policy is not proof that no floor exists.
      throw const FormatException('Stored release policy is unavailable');
    }
  }

  Future<void> setReleasePolicy(MobileReleasePolicy policy) async {
    final encoded = jsonEncode(policy.toValues());
    final write = _releasePolicyWrites.then(
      (_) => _store.setString(releasePolicyKey, encoded),
    );
    // Actual platform writes stay in order even when the caller times out. The GERÇEK write
    // failure is reported here exactly once with its original error and stack (the caller's
    // 500 ms wait is only a latency bound and never reports).
    _releasePolicyWrites = write.then<void>(
      (_) {},
      onError: (Object e, StackTrace st) =>
          reportUnexpected(e, st, source: ReportSource.preferences),
    );
    try {
      await write.timeout(const Duration(milliseconds: 500));
    } on Object {
      Log.warn('tercih: sürüm politikası yazılamadı');
    }
  }

  /// Hata raporlama onayı. YALNIZ açıkça `true` yazılmışsa açıktır; kayıt yok, bozuk ya da
  /// okunamıyorsa KAPALI (okunamayan tercih onay sayılmaz). Uzaktan ayar bunun yerine geçmez.
  ///
  /// Okuma, o ana dek İSTENMİŞ onay yazılarının ARDINA girer (yeni sahip eski bir geç `true`
  /// yazısını görmeden okumaz); sırada bekleyen yazı süreyi aşarsa sonuç KAPALIdır.
  Future<bool> errorReportingConsent() async {
    try {
      final lane = _lane;
      final raw = await lane.tail
          .then(
            (_) => lane.blocked ? null : _store.getString(errorReportingKey),
          )
          .timeout(const Duration(milliseconds: 500));
      return raw == 'true';
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.preferences);
      Log.warn('tercih: hata raporlama onayı okunamadı; kapalı');
      return false;
    }
  }

  /// Kullanıcı geri alma isteği ANINDA (çağıranın kuyruğuna/SDK işine girmeden): ortak depo
  /// şeridini kilitler (okuma kapalı) VE `false` yazısını (olmazsa kaydı silmeyi) TEK atomik
  /// fiziksel şerit işi olarak hemen sıraya alır. Böylece bekleyen eski bir yükleme/denetleyici
  /// değişse, atılsa ya da süreç ölse de sağlıklı depoda kayıt `true` KALMAZ; sonradan kabul edilen
  /// geçerli onay bu işin ARDINA girer, ezilmez. Dönen gelecek yalnız gecikme sınırlı (500 ms)
  /// sonuçtur: `true` = `false` yazıldı ya da kayıt silindi; ikisi de olmazsa şerit kilitli kalır.
  Future<bool> beginErrorReportingRevoke() {
    final lane = _lane;
    final gen = lane.beginRevoke(); // eşzamanlı: okuma kapalı
    return _confirmConsentWrite(
      _queueConsentWrite(() async {
        await _revertToClosed(lane, gen);
        return true;
      }),
      'kapatılamadı',
    );
  }

  /// Onayı yazar; yazılabildiyse (süresi içinde) `true`. Yazılamadıysa/süre aşıldıysa `false`
  /// (çağıran açmaz). Yazılar DEPO bazında (tüm [AppPreferences] örnekleri arasında) fiziksel
  /// bitiş sırasıyla işler; geç biten eski yazı sonradan istenmiş yazının üzerine yazamaz.
  Future<bool> setErrorReportingConsent(bool value) {
    if (value) {
      return grantErrorReportingConsent(validity: const _AlwaysCurrentGrant())
          .written;
    }
    final lane = _lane;
    final gen = lane.beginRevoke(); // eşzamanlı: okuma kapalı
    return _confirmConsentWrite(
      _queueConsentWrite(() async {
        await _store.setString(errorReportingKey, 'false');
        lane.clearIfCurrent(gen); // açık, başarılı kapatma
        return true;
      }),
      'yazılamadı',
    );
  }

  /// Onay VERME yazısı: yazıyı sıraya alır; [ticket] bayat kalırsa [rollbackErrorReportingGrant]
  /// için kimliktir. Bilet ve yazı eşzamanlı alınır (arada başka istek giremez).
  ///
  /// [validity] `isCurrent` sıra işinin İÇİNDE, fiziksel yazıdan ÖNCE ve SONRA sorulur (sahiplik/nesil).
  /// Yazıdan önce bayatsa hiç yazılmaz. Yazıdan sonra bayatsa `false`/silme geri alması AYNI sıra
  /// işinde yapılır ve şerit ancak ondan sonra serbest kalır: sonradan gelen okuma bayat `true`'yu
  /// hiç göremez; sonradan sıralanan gerçek yeni onay geri almanın ARDINA girdiğinden ezilmez.
  /// [written] yalnız yazı geçerli sahip için kalıcılaştıysa `true` olur. 500 ms bekleme yalnız
  /// gecikme sınırıdır; gerçek yazı ve geri alma bitmeden şerit ilerlemez.
  ({int ticket, Future<bool> written}) grantErrorReportingConsent({
    required ErrorReportingGrantValidity validity,
  }) {
    final lane = _lane;
    final gen = lane.blockGen;
    final ticket = ++lane.seq;
    lane.lastGrant = ticket;
    final write = _queueConsentWrite(() async {
      if (!validity.isCurrent) {
        return false; // sıra gelince bayat: hiçbir şey yazılmaz
      }
      await _store.setString(errorReportingKey, 'true');
      if (validity.isCurrent) {
        // Geçerli yeni onay kayıttaki bayat durumu aşar; sonradan istenmiş geri alma ezilmez.
        lane.clearIfCurrent(gen);
        return true;
      }
      await _revertToClosed(
        lane,
        gen,
      ); // bayat `true`: tail serbest kalmadan geri al
      return false;
    });
    return (ticket: ticket, written: _confirmConsentWrite(write, 'yazılamadı'));
  }

  /// `false` yazar; olmazsa kaydı siler; ikisi de olmazsa şerit KİLİTLENİR (okuma kapalı).
  /// Silme hatası çağırana (sıra kuyruğunun tek raporlayıcısına) fırlar.
  Future<void> _revertToClosed(_ConsentLane lane, int gen) async {
    try {
      await _store.setString(errorReportingKey, 'false');
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.preferences);
      try {
        await _store.remove(errorReportingKey);
      } on Object {
        lane.blocked = true;
        rethrow;
      }
    }
    lane.clearIfCurrent(gen);
  }

  /// BAYAT kalan (iptal edilen, bağı başkasına geçen ya da atılan denetleyicinin) onay VERME
  /// yazısını geri alır. Başlamış fiziksel yazı iptal EDİLEMEZ: bu yüzden geri alma o yazının
  /// (ve arada istenmiş yazıların) ARDINA `false` yazar, olmazsa kaydı siler. Arada [ticket]'tan
  /// YENİ gerçek bir onay verme isteği geldiyse dokunmaz (daha yeni `true` ezilmez).
  ///
  /// Geri alma süresi içinde doğrulanamazsa `false` döner: kapı bu süreçte zaten kapalıdır
  /// (hiçbir şey gönderilmez); sıradaki geri alma yine de çalışır, ama süreç ondan önce
  /// ölürse kayıtta `true` kalabilir (kullanıcıya iptal edilmiş sayılmaz, bkz. `ReportingNotice`).
  Future<bool> rollbackErrorReportingGrant(int ticket) {
    final lane = _lane;
    final gen = lane.blockGen;
    return _confirmConsentWrite(
      _queueConsentWrite(() async {
        if (lane.lastGrant > ticket) return true; // daha yeni gerçek onay kalır
        await _revertToClosed(lane, gen);
        return true;
      }),
      'geri alınamadı',
    );
  }

  /// Şeride sıralı yazı. GERÇEK yazı hatası (500 ms geçse de) burada ve YALNIZ burada, özgün
  /// hata + yığınla bir kez raporlanır; çağıranın zaman aşımı bunu raporlamaz. Kuyruk kendi
  /// raporundan etkilenmez (rapor yolu kuyruğa yazmaz → döngü yok).
  Future<bool> _queueConsentWrite(Future<bool> Function() op) {
    final lane = _lane;
    final run = lane.tail.then((_) => op());
    lane.tail = run.then<void>(
      (_) {},
      onError: (Object e, StackTrace st) =>
          reportUnexpected(e, st, source: ReportSource.preferences),
    );
    return run;
  }

  /// Çağıranın beklemesi: yalnız gecikme sınırı. Zaman aşımı/hata `false` döner ve rapor
  /// etmez (gerçek yazı hatasını [_queueConsentWrite] raporlar).
  Future<bool> _confirmConsentWrite(Future<bool> run, String what) async {
    try {
      return await run.timeout(const Duration(milliseconds: 500));
    } on Object {
      Log.warn('tercih: hata raporlama onayı $what');
      return false;
    }
  }

  Future<ThemeMode> themeMode() => _read(_themeMode);

  Future<void> setThemeMode(ThemeMode mode) => _write(_themeMode, mode);

  /// Desteklenen dillerden biri; kayıt yok/tanımsız → Türkçe.
  Future<Locale> locale() => _read(_locale);

  /// Desteklenmeyen dil yazılmaz (sessizce yok sayılır).
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(Locale(locale.languageCode))) return;
    await _write(_locale, Locale(locale.languageCode));
  }
}
