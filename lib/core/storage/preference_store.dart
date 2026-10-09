/// Kalıcı, GİZLİ OLMAYAN tercih deposu soyutlaması (tema, dil, son seçimler gibi). Üretimde
/// [SharedPreferenceStore]; testte [MemoryPreferenceStore].
///
/// Belirteç, parola, sunucu bağı ve kişisel veri BURAYA YAZILMAZ — onlar yalnız [SecureStore]
/// içindir (sınır kuralı S1). Anahtarlar serbest dize değil, `AppPreferences`'taki sabit
/// kümedir; shared_preferences yalnız `lib/core/storage/` içinde import edilir (S5).
abstract interface class PreferenceStore {
  Future<String?> getString(String key);

  Future<void> setString(String key, String value);

  Future<void> remove(String key);
}

/// Bellek içi uygulama (testler, host VM entegrasyonu). [failAll]: her çağrı hata verir.
class MemoryPreferenceStore implements PreferenceStore {
  final Map<String, String> values = {};
  bool failAll = false;

  void _check() {
    if (failAll) throw StateError('MemoryPreferenceStore: hata (benzetim)');
  }

  @override
  Future<String?> getString(String key) async {
    _check();
    return values[key];
  }

  @override
  Future<void> setString(String key, String value) async {
    _check();
    values[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _check();
    values.remove(key);
  }
}
