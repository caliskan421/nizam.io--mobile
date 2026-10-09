/// Güvenli anahtar-değer deposu soyutlaması. Üretimde [FlutterSecureStore] (Keychain /
/// Android Keystore); testte ve cihazsız entegrasyonda [MemorySecureStore]. Belirteçler
/// YALNIZ bu soyutlamadan yazılır (sınır kuralı S1).
abstract interface class SecureStore {
  Future<String?> read(String key);

  /// Var olan değerin ÜZERİNE yazar (önce silme yoktur).
  Future<void> write(String key, String value);

  Future<void> delete(String key);
}

/// Bellek içi uygulama (testler, host VM entegrasyon testleri). Yazma hatası benzetimi için
/// [failWrites].
class MemorySecureStore implements SecureStore {
  final Map<String, String> values = {};
  bool failWrites = false;

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    if (failWrites) {
      throw StateError('MemorySecureStore: yazma hatası (benzetim)');
    }
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async => values.remove(key);
}
