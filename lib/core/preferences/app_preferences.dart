import 'package:flutter/material.dart';

import '../logging/log.dart';
import '../storage/preference_store.dart';

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

/// Uygulama tercihleri: tipli erişim + SABİT anahtar kümesi. Yeni tercih buraya bir [_Pref]
/// ve tipli okuma/yazma olarak eklenir; serbest anahtarla yazma yoktur (gizli veri kaçmasın).
///
/// Okuma hatası varsayılana düşer (tercih kaybı uygulamayı durdurmaz); yazma hatası
/// günlüğe yazılır ve yutulur.
class AppPreferences {
  AppPreferences(this._store);

  final PreferenceStore _store;

  static const themeModeKey = 'nizamio.pref.theme_mode';
  static const localeKey = 'nizamio.pref.locale';

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
    } on Object {
      Log.warn('tercih: okunamadı; varsayılan (${pref.key})');
      return pref.fallback;
    }
  }

  Future<void> _write<T extends Object>(_Pref<T> pref, T value) async {
    try {
      await _store.setString(pref.key, pref.encode(value));
    } on Object {
      Log.warn('tercih: yazılamadı (${pref.key})');
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
