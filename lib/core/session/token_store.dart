import '../storage/secure_store.dart';
import 'token_pair.dart';

/// Belirteç çiftinin güvenli depodaki TEK kaydı + yenileme öncesi işaret.
///
/// "Yeni belirteç kaydedilmeden eski silinmez" (platform §6, F14 kapsam 5): [save] çifti tek
/// anahtara tek yazmayla ÜZERİNE yazar — arada eski kaydın silindiği ve yenisinin henüz
/// yazılmadığı bir an yoktur.
///
/// Yazma-öncesi işaret ([inflightKey], CX-Ö-04): yenileme isteği ağa çıkmadan ÖNCE yazılır,
/// yeni çift kalıcılaştıktan SONRA silinir. Diskte işaret varken kayıtlı çiftin yenileme
/// belirteci sunucuda tüketilmiş olabilir (yanıt kaybı, süreç çökmesi, yeni çiftin
/// yazılamaması): açılışta böyle bir çift geri YÜKLENMEZ ve bir daha gönderilmez.
class TokenStore {
  TokenStore(this._store);

  static const key = 'nizamio.session.v1';
  static const inflightKey = 'nizamio.session.refresh_inflight';

  final SecureStore _store;

  /// Ham kayıt var mı (çözülemese bile)?
  Future<bool> exists() async => await _store.read(key) != null;

  Future<TokenPair?> load() async {
    final raw = await _store.read(key);
    return raw == null ? null : TokenPair.decode(raw);
  }

  Future<void> save(TokenPair pair) => _store.write(key, pair.encode());

  Future<void> clear() => _store.delete(key);

  Future<void> markRefreshInFlight() => _store.write(inflightKey, '1');

  Future<bool> refreshInFlight() async =>
      await _store.read(inflightKey) != null;

  Future<void> clearRefreshInFlight() => _store.delete(inflightKey);
}
