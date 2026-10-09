import 'package:flutter/foundation.dart';

import '../api/generated/models/refresh_response.dart';
import '../errors/api_error.dart';
import '../i18n/generated/client_error_codes.gen.dart';
import '../logging/log.dart';
import 'session_state.dart';
import 'token_pair.dart';
import 'token_store.dart';

/// `POST /v1/auth/refresh` çağrısı (üretilmiş IdentityClient; kimlik ara katmanı OLMADAN).
typedef RefreshCall = Future<RefreshResponse> Function(String refreshToken);

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

  ValueListenable<SessionState> get state => _state;

  String? get accessToken => _pair?.accessToken;

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
  Future<void> establish(TokenPair pair) async {
    if (!await _attempt(() => _store.save(pair))) {
      Log.warn('oturum: güvenli depoya yazılamadı; oturum açılmadı');
      throw ApiError(ClientErrorCode.secureStorageError);
    }
    // Önceki çiftten kalmış işaret yeni çifti açılışta düşürmesin (silinemezse yalnız yeniden
    // giriş istenir — güvenli yön).
    await _attempt(_store.clearRefreshInFlight);
    _set(pair, _active(pair));
  }

  /// Zorunlu parola değişikliği bayrağı (`identity.force_password_change_required` görülünce).
  Future<void> markForcePasswordChange(bool value) async {
    final p = _pair;
    if (p == null || p.forcePasswordChange == value) return;
    final next = p.copyWith(forcePasswordChange: value);
    await _attempt(() => _store.save(next));
    _set(next, _active(next));
  }

  /// Yerel oturumu kapatır (sunucu çıkışından sonra ya da çıkış başarısız olsa da).
  Future<void> clear() async {
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
    return _inflight ??= _rotate(p).whenComplete(() => _inflight = null);
  }

  Future<String> _rotate(TokenPair p) async {
    if (!await _attempt(_store.markRefreshInFlight)) {
      // Belirteç gönderilmedi (tüketilmedi); oturum sürer, istek başarısız.
      Log.warn('oturum: yenileme işareti yazılamadı; yenileme gönderilmedi');
      throw ApiError(ClientErrorCode.secureStorageError);
    }
    final RefreshResponse r;
    try {
      r = await _refreshCall(p.refreshToken);
    } on ApiError catch (e) {
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
      // Ayrıştırma vb. beklenmeyen hata: sunucu döndürmüş olabilir → belirsiz (CX-Ö-01).
      Log.warn('oturum: yenileme yanıtı işlenemedi; K-05 — tekrar deneme yok');
      await _end(ReauthReason.refreshAmbiguous);
      throw ApiError(ClientErrorCode.reauthRequired);
    }
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
      // Yeni çift kalıcılaşmadı: oturum etkin SAYILMAZ (CX-Ö-04). Eski yenileme belirteci
      // sunucuda tüketildi; depodan silinir — silinemezse yazma-öncesi işaret açılışta
      // geri yüklemeyi engeller, bu süreçte de "yanmış" listesi gönderimi engeller.
      Log.warn('oturum: yeni çift depoya yazılamadı; yeniden giriş gerekli');
      await _end(ReauthReason.secureStorageFailure);
      throw ApiError(ClientErrorCode.secureStorageError);
    }
    _burnt.add(p.refreshToken);
    await _attempt(_store.clearRefreshInFlight);
    _set(next, _active(next));
    return access;
  }

  Future<void> _end(ReauthReason reason) async {
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
