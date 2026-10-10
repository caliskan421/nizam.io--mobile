import 'package:shared_preferences/shared_preferences.dart';

import 'preference_store.dart';

/// [PreferenceStore]'un shared_preferences uygulaması (önbelleksiz `SharedPreferencesAsync`:
/// her okuma platform deposundan; çoklu izolat ve dış değişiklikte bayat değer yok).
/// Platform örneği ilk kullanımda oluşturulur: bileşim kökü kurulurken (ve platform eklentisi
/// olmayan testlerde) kanal gerekmez.
class SharedPreferenceStore implements PreferenceStore {
  SharedPreferenceStore([SharedPreferencesAsync? prefs]) : _given = prefs;

  final SharedPreferencesAsync? _given;
  late final SharedPreferencesAsync _prefs = _given ?? SharedPreferencesAsync();

  @override
  Future<String?> getString(String key) => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  Future<void> remove(String key) => _prefs.remove(key);
}
