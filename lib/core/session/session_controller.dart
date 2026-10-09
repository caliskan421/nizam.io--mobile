import 'package:flutter/foundation.dart';

import '../api/generated/models/refresh_response.dart';
import '../errors/api_error.dart';
import '../i18n/generated/client_error_codes.gen.dart';
import '../logging/log.dart';
import 'session_state.dart';
import 'token_pair.dart';
import 'token_store.dart';

/// `POST /v1/auth/refresh` çağrısı (üretilmiş IdentityClient; kimlik ara katmanı OLMADAN).
/// [instanceId]: çiftin ait olduğu kurulum; çağrı yalnız güncel bağ bu kurulumsa ağa çıkar.
typedef RefreshCall = Future<RefreshResponse> Function(
  String refreshToken,
  String instanceId,
);

/// Belirteçlerin tek sahibi: bellekteki çift + güvenli depo + yenileme.
///
/// Yenileme kuralları (F14 kapsam 5; K-05; `docs/refresh-coordination.md` web karşılığı):
/// - **Tek uçuş:** eşzamanlı çağrılar aynı yenilemeyi bekler; 401 alan istek elindeki erişim
///   belirteci zaten değiştiyse yenileme yapılmaz, güncel belirteç döner.
/// - **Yazma-öncesi işaret:** istek ağa çıkmadan önce depoya "yenileme sürüyor" işareti
///   yazılır (yazılamazsa istek GÖNDERİLMEZ); yeni çift kalıcılaşınca silinir. Açılışta işaret
///   varsa kayıtlı çift geri yüklenmez (yanıt kaybı / çökme / yazma hatası: belirteç tüketilmiş
///   olabilir).
/// - **Sonuç tablosu:**
///   | Sonuç                                   | Davranış |
///   |-----------------------------------------|----------|
///   | 200 + iki belirteç, yeni çift yazıldı    | eski kaydın üzerine yazıldı → etkin |
///   | 200 ama yeni çift [storeAttempts] kez yazılamadı | oturum etkin SAYILMAZ: `secureStorageFailure`, eski kayıt silinir (silinemezse işaret açılışta engeller) |
///   | 401                                      | reddedildi → belirteçler silinir, `refreshRejected` |
///   | 429                                      | işlenmedi (hız sınırı) → belirteç kalır, hata çağırana; otomatik tekrar yok |
///   | zaman aşımı, ağ, TLS, 5xx, 409, geçersiz/ayrıştırılamayan yanıt, eksik belirteç | BELİRSİZ → belirteçler silinir, `refreshAmbiguous`; aynı belirteçle tekrar YOK |
/// - Gönderilmiş (429 dışı) her yenileme belirteci bellekte "yanmış" işaretlenir ve bu süreçte
///   bir daha gönderilmez; `SessionReauthRequired` durumunda [refresh] ağa çıkmaz.
class SessionController {
  SessionController(this._store, this._refreshCall, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  /// Yerel depo işlemlerinin (ağ tekrarı OLMADAN) deneme sayısı.
  static const storeAttempts = 3;

  final TokenStore _store;
  final RefreshCall _refreshCall;
  final DateTime Function() _now;

  final ValueNotifier<SessionState> _state = ValueNotifier(const SessionNone());
  final Set<String> _burnt = {};
  TokenPair? _pair;
  Future<String>? _inflight;

  /// Oturum nesli (CX-r1-Ö-01): [establish], [clear] ve yeniden giriş gerektiren son her
  /// geçişte artar. Bekleyen bir giriş/yenileme/me yanıtı ancak başladığı nesil hâlâ geçerliyse
  /// (ve yenilemede kaynak çift aynıysa) uygulanır; aksi hâlde getirdiği çift depoya YAZILMAZ,
  /// bellekte kullanılmaz, yalnız atılır (sunucudaki oturum kendi ömrüyle ölür).
  int _generation = 0;
  int get generation => _generation;

  ValueListenable<SessionState> get state => _state;

  String? get accessToken => _pair?.accessToken;

  /// Erişim belirteci YALNIZ çift [instanceId] kurulumuna aitse (eski bağın dio'su yeni
  /// kurulumun belirtecini taşımaz; tersi de).
  String? accessTokenFor(String instanceId) {
    final p = _pair;
    return p != null && p.instanceId == instanceId ? p.accessToken : null;
  }

  /// Uygulama açılışı: güvenli depodaki çift — yalnız [instanceId] doğrulanan bağın kurulumuyla
  /// eşleşiyorsa, süresi dolmamışsa ve yarım kalmış bir yenileme işareti yoksa.
  Future<void> restore({required String instanceId}) async {
    try {
      if (await _store.refreshInFlight()) {
        Log.warn(
          'oturum: yarım kalmış yenileme işareti; kayıtlı çift geri yüklenmiyor',
        );
        await _wipe();
        _set(null, const SessionReauthRequired(ReauthReason.refreshAmbiguous));
        return;
      }
      final pair = await _store.load();
      if (pair == null ||
          pair.instanceId != instanceId ||
          pair.refreshExpiresAt * 1000 <= _now().millisecondsSinceEpoch) {
        if (pair != null || await _store.exists()) await _wipe();
        _set(null, const SessionNone());
        return;
      }
      _set(pair, _active(pair));
    } on Object {
      Log.warn('oturum: güvenli depo okunamadı');
      _set(
        null,
        const SessionReauthRequired(ReauthReason.secureStorageFailure),
      );
    }
  }

  /// Giriş sonrası: çift önce depoya yazılır, sonra bellekte etkinleşir.
  ///
  /// [generation]: girişin başladığı nesil; o arada çıkış/yeniden bağlanma olduysa çift
  /// kullanılmaz (`client.session_ended`).
  Future<void> establish(TokenPair pair, {int? generation}) async {
    if (generation != null && generation != _generation) {
      throw ApiError(ClientErrorCode.sessionEnded);
    }
    final gen = ++_generation;
    if (!await _attempt(() => _store.save(pair))) {
      Log.warn('oturum: güvenli depoya yazılamadı; oturum açılmadı');
      throw ApiError(ClientErrorCode.secureStorageError);
    }
    // Önceki çiftten kalmış işaret yeni çifti açılışta düşürmesin (silinemezse yalnız yeniden
    // giriş istenir — güvenli yön).
    await _attempt(_store.clearRefreshInFlight);
    if (gen != _generation) {
      // Yazma sürerken temizlendi: temizliğin silmesi bu yazmadan sonra sıralanır.
      throw ApiError(ClientErrorCode.sessionEnded);
    }
    _set(pair, _active(pair));
  }

  /// Zorunlu parola değişikliği bayrağı (`identity.force_password_change_required` görülünce).
  /// [generation]: bayrağı getiren isteğin başladığı nesil (başka oturuma uygulanmaz).
  Future<void> markForcePasswordChange(bool value, {int? generation}) async {
    if (generation != null && generation != _generation) return;
    final p = _pair;
    if (p == null || p.forcePasswordChange == value) return;
    final next = p.copyWith(forcePasswordChange: value);
    await _attempt(() => _store.save(next));
    if (!identical(_pair, p)) return;
    _set(next, _active(next));
  }

  /// Yerel oturumu kapatır (sunucu çıkışından sonra ya da çıkış başarısız olsa da).
  Future<void> clear() async {
    _generation++;
    _inflight = null;
    await _wipe();
    _set(null, const SessionNone());
  }

  /// 401 sonrası erişim belirtecini yeniler; yeni erişim belirtecini döner.
  Future<String> refresh({String? failedAccessToken}) {
    if (_state.value is SessionReauthRequired) {
      return Future.error(ApiError(ClientErrorCode.reauthRequired));
    }
    final p = _pair;
    if (p == null) return Future.error(ApiError(ClientErrorCode.notSignedIn));
    if (failedAccessToken != null && failedAccessToken != p.accessToken) {
      return Future.value(p.accessToken);
    }
    if (_burnt.contains(p.refreshToken)) {
      return Future.error(ApiError(ClientErrorCode.reauthRequired));
    }
    final pending = _inflight;
    if (pending != null) return pending;
    final f = _rotate(p);
    _inflight = f;
    f.then((_) {}, onError: (Object _) {}).whenComplete(() {
      if (identical(_inflight, f)) _inflight = null;
    });
    return f;
  }

  /// Bekleyen sonuç hâlâ geçerli mi? Değilse hiçbir yerel durum/depo değiştirilmez.
  void _ensureCurrent(int gen, TokenPair p) {
    if (gen != _generation || !identical(_pair, p)) {
      _burnt.add(p.refreshToken);
      Log.info('oturum: geçersizleşmiş yenileme sonucu atıldı');
      throw ApiError(ClientErrorCode.sessionEnded);
    }
  }

  Future<String> _rotate(TokenPair p) async {
    final gen = _generation;
    if (!await _attempt(_store.markRefreshInFlight)) {
      // Belirteç gönderilmedi (tüketilmedi); oturum sürer, istek başarısız.
      Log.warn('oturum: yenileme işareti yazılamadı; yenileme gönderilmedi');
      throw ApiError(ClientErrorCode.secureStorageError);
    }
    _ensureCurrent(gen, p);
    final RefreshResponse r;
    try {
      r = await _refreshCall(p.refreshToken, p.instanceId);
    } on ApiError catch (e) {
      _ensureCurrent(gen, p);
      if (e.status == 429) {
        Log.info('oturum: yenileme hız sınırında (429); belirteç korunur');
        await _attempt(_store.clearRefreshInFlight);
        rethrow;
      }
      if (e.status == 401) {
        await _end(ReauthReason.refreshRejected);
        throw ApiError(
          ClientErrorCode.sessionEnded,
          requestId: e.requestId,
          status: 401,
        );
      }
      Log.warn(
        'oturum: yenileme belirsiz düştü (${e.code}); K-05 — tekrar deneme yok',
      );
      await _end(ReauthReason.refreshAmbiguous);
      throw ApiError(ClientErrorCode.reauthRequired);
    } on Object {
      _ensureCurrent(gen, p);
      // Ayrıştırma vb. beklenmeyen hata: sunucu döndürmüş olabilir → belirsiz (CX-Ö-01).
      Log.warn('oturum: yenileme yanıtı işlenemedi; K-05 — tekrar deneme yok');
      await _end(ReauthReason.refreshAmbiguous);
      throw ApiError(ClientErrorCode.reauthRequired);
    }
    _ensureCurrent(gen, p);
    final access = r.accessToken;
    final refresh = r.refreshToken;
    if (access == null ||
        refresh == null ||
        access.isEmpty ||
        refresh.isEmpty ||
        r.accountId != p.accountId) {
      // Sunucu döndürmüş olabilir ama kullanılabilir çift yok: belirsiz.
      await _end(ReauthReason.refreshAmbiguous);
      throw ApiError(ClientErrorCode.reauthRequired);
    }
    final next = TokenPair(
      accountId: r.accountId,
      accessToken: access,
      accessExpiresAt: r.expiresAt,
      refreshToken: refresh,
      refreshExpiresAt: r.refreshExpiresAt,
      forcePasswordChange: p.forcePasswordChange,
      instanceId: p.instanceId,
    );
    if (!await _attempt(() => _store.save(next))) {
      _ensureCurrent(gen, p);
      // Yeni çift kalıcılaşmadı: oturum etkin SAYILMAZ (CX-Ö-04). Eski yenileme belirteci
      // sunucuda tüketildi; depodan silinir — silinemezse yazma-öncesi işaret açılışta
      // geri yüklemeyi engeller, bu süreçte de "yanmış" listesi gönderimi engeller.
      Log.warn('oturum: yeni çift depoya yazılamadı; yeniden giriş gerekli');
      await _end(ReauthReason.secureStorageFailure);
      throw ApiError(ClientErrorCode.secureStorageError);
    }
    _burnt.add(p.refreshToken);
    // Yazma sürerken temizlendiyse temizliğin silmesi bu yazmadan sonra sıralanmıştır; işarete
    // dokunulmaz (yeni oturumun işareti olabilir).
    _ensureCurrent(gen, p);
    await _attempt(_store.clearRefreshInFlight);
    _ensureCurrent(gen, p);
    _set(next, _active(next));
    return access;
  }

  Future<void> _end(ReauthReason reason) async {
    _generation++;
    _inflight = null;
    final p = _pair;
    if (p != null) _burnt.add(p.refreshToken);
    await _wipe();
    _set(null, SessionReauthRequired(reason));
  }

  /// Çifti siler; işaret YALNIZ çift kesin silindiyse silinir (aksi hâlde açılış korunur).
  Future<void> _wipe() async {
    if (await _attempt(_store.clear)) {
      await _attempt(_store.clearRefreshInFlight);
    } else {
      Log.warn('oturum: güvenli depo temizlenemedi; işaret korunuyor');
    }
  }

  Future<bool> _attempt(Future<void> Function() op) async {
    for (var i = 0; i < storeAttempts; i++) {
      try {
        await op();
        return true;
      } on Object {
        // yerel depo hatası: ağ tekrarı yok, yalnız yerel yeniden deneme
      }
    }
    return false;
  }

  void _set(TokenPair? pair, SessionState state) {
    final old = _pair;
    if (old != null) {
      Log.forgetSecret(old.accessToken);
      Log.forgetSecret(old.refreshToken);
    }
    if (pair != null) {
      Log.registerSecret(pair.accessToken);
      Log.registerSecret(pair.refreshToken);
    }
    _pair = pair;
    _state.value = state;
  }

  static SessionState _active(TokenPair p) => SessionActive(
    accountId: p.accountId,
    forcePasswordChange: p.forcePasswordChange,
  );

  @visibleForTesting
  TokenPair? get debugPair => _pair;
}
