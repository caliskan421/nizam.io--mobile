import 'dart:convert';

import 'package:flutter/material.dart';

import '../config/mobile_release_policy.dart';
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
  Future<void> _releasePolicyWrites = Future<void>.value();
  Future<void> _consentWrites = Future<void>.value();

  static const errorReportingKey = 'nizamio.pref.error_reporting.v1';
  static const themeModeKey = 'nizamio.pref.theme_mode';
  static const localeKey = 'nizamio.pref.locale';
  static const releasePolicyKey = 'nizamio.pref.release_policy.v1';

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

  /// Validated non-personal policy. Mandatory floors do not expire offline:
  /// a network failure or bad publication must not lift a previously accepted gate.
  Future<MobileReleasePolicy?> releasePolicy() async {
    try {
      final raw = await _store
          .getString(releasePolicyKey)
          .timeout(const Duration(milliseconds: 500));
      if (raw == null) return null;
      return MobileReleasePolicy.fromRemoteConfig(
        Map<String, Object?>.from(jsonDecode(raw) as Map),
      );
    } on Object {
      // An unreadable/corrupt existing policy is not proof that no floor exists.
      throw const FormatException('Stored release policy is unavailable');
    }
  }

  Future<void> setReleasePolicy(MobileReleasePolicy policy) async {
    final encoded = jsonEncode(policy.toValues());
    final write = _releasePolicyWrites.then(
      (_) => _store.setString(releasePolicyKey, encoded),
    );
    // Keep actual platform writes in order even when the caller times out.
    _releasePolicyWrites = write.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    try {
      await write.timeout(const Duration(milliseconds: 500));
    } on Object {
      Log.warn('tercih: sürüm politikası yazılamadı');
    }
  }

  /// Hata raporlama onayı. YALNIZ açıkça `true` yazılmışsa açıktır; kayıt yok, bozuk ya da
  /// okunamıyorsa KAPALI (okunamayan tercih onay sayılmaz). Uzaktan ayar bunun yerine geçmez.
  Future<bool> errorReportingConsent() async {
    try {
      final raw = await _store
          .getString(errorReportingKey)
          .timeout(const Duration(milliseconds: 500));
      return raw == 'true';
    } on Object {
      Log.warn('tercih: hata raporlama onayı okunamadı; kapalı');
      return false;
    }
  }

  /// Onayı yazar; yazılabildiyse `true`. Yazılamadıysa `false` (çağıran açmaz). Yazıların
  /// gerçek sırası korunur; geç biten eski yazı yenisinin üzerine yazamaz.
  Future<bool> setErrorReportingConsent(bool value) async {
    final write = _consentWrites.then(
      (_) => _store.setString(errorReportingKey, value ? 'true' : 'false'),
    );
    _consentWrites = write.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    try {
      await write.timeout(const Duration(milliseconds: 500));
      return true;
    } on Object {
      Log.warn('tercih: hata raporlama onayı yazılamadı');
      return false;
    }
  }

  /// Eski `true` kaydını siler (okuma `null` → kapalı); [setErrorReportingConsent] yazılamadığında
  /// ikinci ve SON yol. Başarılıysa `true`.
  Future<bool> removeErrorReportingConsent() async {
    final write = _consentWrites.then((_) => _store.remove(errorReportingKey));
    _consentWrites = write.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    try {
      await write.timeout(const Duration(milliseconds: 500));
      return true;
    } on Object {
      Log.warn('tercih: hata raporlama onayı silinemedi');
      return false;
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
