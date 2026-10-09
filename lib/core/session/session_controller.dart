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
/// - **Sonuç tablosu:**
///   | Sonuç                                   | Davranış |
///   |-----------------------------------------|----------|
///   | 200 + iki belirteç                      | yeni çift depoya yazılır (eskinin üzerine), sonra bellekte |
///   | 401                                      | reddedildi → belirteçler silinir, `refreshRejected` |
///   | 429                                      | işlenmedi (hız sınırı) → belirteç kalır, hata çağırana; otomatik tekrar yok |
///   | zaman aşımı, ağ, TLS, 5xx, 409, geçersiz yanıt, eksik belirteç | BELİRSİZ → belirteçler silinir, `refreshAmbiguous`; aynı belirteçle tekrar YOK |
/// - `SessionReauthRequired` durumunda [refresh] ağa çıkmadan `client.reauth_required` atar.
class SessionController {
  SessionController(this._store, this._refreshCall, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final TokenStore _store;
  final RefreshCall _refreshCall;
  final DateTime Function() _now;

  final ValueNotifier<SessionState> _state = ValueNotifier(const SessionNone());
  TokenPair? _pair;
  Future<String>? _inflight;

  ValueListenable<SessionState> get state => _state;

  String? get accessToken => _pair?.accessToken;

  /// Uygulama açılışı: güvenli depodaki çift (süresi dolmamışsa).
  Future<void> restore() async {
    final pair = await _store.load();
    if (pair == null ||
        pair.refreshExpiresAt * 1000 <= _now().millisecondsSinceEpoch) {
      if (pair != null) await _safeClear();
      _set(null, const SessionNone());
      return;
    }
    _set(pair, _active(pair));
  }

  /// Giriş sonrası: çift önce depoya yazılır, sonra bellekte etkinleşir.
  Future<void> establish(TokenPair pair) async {
    try {
      await _store.save(pair);
    } on Object {
      Log.warn('oturum: güvenli depoya yazılamadı; oturum açılmadı');
      throw ApiError(ClientErrorCode.secureStorageError);
    }
    _set(pair, _active(pair));
  }

  /// Zorunlu parola değişikliği bayrağı (`identity.force_password_change_required` görülünce).
  Future<void> markForcePasswordChange(bool value) async {
    final p = _pair;
    if (p == null || p.forcePasswordChange == value) return;
    final next = p.copyWith(forcePasswordChange: value);
    try {
      await _store.save(next);
    } on Object {
      // Bayrak sunucuda da tutulur; depo hatası oturumu düşürmez.
    }
    _set(next, _active(next));
  }

  /// Yerel oturumu kapatır (sunucu çıkışından sonra ya da çıkış başarısız olsa da).
  Future<void> clear() async {
    await _safeClear();
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
    return _inflight ??= _rotate(p).whenComplete(() => _inflight = null);
  }

  Future<String> _rotate(TokenPair p) async {
    final RefreshResponse r;
    try {
      r = await _refreshCall(p.refreshToken);
    } on ApiError catch (e) {
      if (e.status == 429) {
        Log.info('oturum: yenileme hız sınırında (429); belirteç korunur');
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
    );
    try {
      await _store.save(next);
    } on Object {
      // Eski yenileme belirteci sunucuda artık iptal: depoda kalırsa sonraki açılışta tekrar
      // kullanılır ve hesabın bütün oturumları düşer (TB-16). Yeni çift yalnız bu süreçte
      // bellekte yaşar; eski kayıt silinir (sonraki açılış yeniden giriş ister).
      Log.warn(
        'oturum: yeni çift depoya yazılamadı; iptal edilmiş eski kayıt siliniyor',
      );
      await _safeClear();
    }
    _set(next, _active(next));
    return access;
  }

  Future<void> _end(ReauthReason reason) async {
    await _safeClear();
    _set(null, SessionReauthRequired(reason));
  }

  Future<void> _safeClear() async {
    try {
      await _store.clear();
    } on Object {
      Log.warn('oturum: güvenli depo temizlenemedi');
    }
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
