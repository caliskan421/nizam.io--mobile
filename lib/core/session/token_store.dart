import '../storage/secure_store.dart';
import 'token_pair.dart';

/// Belirteç çiftinin güvenli depodaki TEK kaydı.
///
/// "Yeni belirteç kaydedilmeden eski silinmez" (platform §6, F14 kapsam 5): [save] çifti tek
/// anahtara tek yazmayla ÜZERİNE yazar — arada eski kaydın silindiği ve yenisinin henüz
/// yazılmadığı bir an yoktur. Yazma başarısızsa eski kayıt yerinde kalır; ne yapılacağına
/// çağıran ([SessionController]) karar verir.
class TokenStore {
  TokenStore(this._store);

  static const key = 'nizamio.session.v1';

  final SecureStore _store;

  Future<TokenPair?> load() async {
    final raw = await _store.read(key);
    return raw == null ? null : TokenPair.decode(raw);
  }

  Future<void> save(TokenPair pair) => _store.write(key, pair.encode());

  Future<void> clear() => _store.delete(key);
}
