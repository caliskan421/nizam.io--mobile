import 'package:flutter/material.dart';

import '../logging/log.dart';
import '../storage/preference_store.dart';

/// Uygulama tercihleri: tipli erişim + SABİT anahtar kümesi. Yeni tercih buraya bir anahtar
/// ve tipli okuma/yazma olarak eklenir; serbest anahtarla yazma yoktur (gizli veri kaçmasın).
///
/// Okuma hatası varsayılana düşer (tercih kaybı uygulamayı durdurmaz); yazma hatası
/// günlüğe yazılır ve yutulur.
class AppPreferences {
  AppPreferences(this._store);

  final PreferenceStore _store;

  static const themeModeKey = 'nizamio.pref.theme_mode';

  Future<ThemeMode> themeMode() async {
    try {
      final v = await _store.getString(themeModeKey);
      return ThemeMode.values.firstWhere(
        (m) => m.name == v,
        orElse: () => ThemeMode.system,
      );
    } on Object {
      Log.warn('tercih: tema okunamadı; sistem teması');
      return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      await _store.setString(themeModeKey, mode.name);
    } on Object {
      Log.warn('tercih: tema yazılamadı');
    }
  }
}
