// Tercihler: tipli anahtar, hata → varsayılan, tema modu denetleyicisi + Riverpod yüzü.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/bootstrap.dart';
import 'package:nizamio/core/preferences/app_preferences.dart';
import 'package:nizamio/core/preferences/locale_controller.dart';
import 'package:nizamio/core/preferences/theme_mode_controller.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/storage/preference_store.dart';

import '../../support/harness.dart';

void main() {
  group('AppPreferences', () {
    test('kayıt yoksa sistem teması; yazılan değer geri okunur', () async {
      final store = MemoryPreferenceStore();
      final prefs = AppPreferences(store);
      expect(await prefs.themeMode(), ThemeMode.system);
      await prefs.setThemeMode(ThemeMode.dark);
      expect(store.values[AppPreferences.themeModeKey], 'dark');
      expect(await prefs.themeMode(), ThemeMode.dark);
    });

    test('bilinmeyen değer → sistem teması', () async {
      final store = MemoryPreferenceStore()
        ..values[AppPreferences.themeModeKey] = 'mor';
      expect(await AppPreferences(store).themeMode(), ThemeMode.system);
    });

    test(
      'depo hatası açılışı durdurmaz: okuma varsayılan, yazma yutulur',
      () async {
        final store = MemoryPreferenceStore()..failAll = true;
        final prefs = AppPreferences(store);
        expect(await prefs.themeMode(), ThemeMode.system);
        await prefs.setThemeMode(ThemeMode.light); // fırlatmaz
      },
    );
  });

  group('AppPreferences dil', () {
    test('kayıt yok → tr; yazılan geri okunur; anahtar sabit', () async {
      final store = MemoryPreferenceStore();
      final prefs = AppPreferences(store);
      expect(await prefs.locale(), const Locale('tr'));
      await prefs.setLocale(const Locale('tr'));
      expect(store.values[AppPreferences.localeKey], 'tr');
      expect(await prefs.locale(), const Locale('tr'));
    });

    test(
      'bilinmeyen/desteklenmeyen kayıt → tr; desteklenmeyen yazılmaz',
      () async {
        final store = MemoryPreferenceStore()
          ..values[AppPreferences.localeKey] = 'xx';
        final prefs = AppPreferences(store);
        expect(await prefs.locale(), const Locale('tr'));
        await prefs.setLocale(const Locale('en'));
        expect(store.values[AppPreferences.localeKey], 'xx');
      },
    );

    test('depo hatası: okuma varsayılan, yazma yutulur', () async {
      final store = MemoryPreferenceStore()..failAll = true;
      final prefs = AppPreferences(store);
      expect(await prefs.locale(), const Locale('tr'));
      await prefs.setLocale(const Locale('tr')); // fırlatmaz
    });

    test('eski kayıtlı tema değeri (anahtar uyumu) okunur', () async {
      final store = MemoryPreferenceStore()
        ..values['nizamio.pref.theme_mode'] = 'dark';
      expect(await AppPreferences(store).themeMode(), ThemeMode.dark);
    });
  });

  test('ThemeModeController: load + set kalıcı ve anında', () async {
    final store = MemoryPreferenceStore()
      ..values[AppPreferences.themeModeKey] = 'light';
    final c = ThemeModeController(AppPreferences(store));
    expect(c.state.value, ThemeMode.system);
    await c.load();
    expect(c.state.value, ThemeMode.light);
    await c.set(ThemeMode.dark);
    expect(c.state.value, ThemeMode.dark);
    expect(store.values[AppPreferences.themeModeKey], 'dark');
    c.dispose();
  });

  test(
    'bileşim kökü: themeModeProvider get_it denetleyicisini izler',
    () async {
      final h = Harness();
      addTearDown(h.dispose);
      expect(h.read(themeModeProvider), ThemeMode.system);
      await h.read(themeModeControllerProvider).set(ThemeMode.dark);
      expect(h.read(themeModeProvider), ThemeMode.dark);
      expect(h.prefs.values[AppPreferences.themeModeKey], 'dark');
    },
  );

  test('bileşim kökü: localeProvider get_it denetleyicisini izler', () async {
    final h = Harness();
    addTearDown(h.dispose);
    expect(h.read(localeProvider), const Locale('tr'));
    await h.read(localeControllerProvider).set(const Locale('tr'));
    expect(h.read(localeProvider), const Locale('tr'));
    expect(h.prefs.values[AppPreferences.localeKey], 'tr');
  });

  test(
    'tamamlanmayan tercih okuması açılışı kilitlemez (CX-r3-Ö-01)',
    () async {
      final prefs = AppPreferences(_HangingStore());
      final c = ThemeModeController(prefs);
      final l = LocaleController(prefs);
      final sw = Stopwatch()..start();
      await loadPreferences(c, l, timeout: const Duration(milliseconds: 50));
      expect(sw.elapsed, lessThan(const Duration(seconds: 2)));
      expect(c.state.value, ThemeMode.system);
      expect(l.state.value, const Locale('tr'));
      c.dispose();
      l.dispose();
    },
  );
}

/// Hiç tamamlanmayan platform kanalı benzetimi.
class _HangingStore implements PreferenceStore {
  @override
  Future<String?> getString(String key) => Completer<String?>().future;

  @override
  Future<void> setString(String key, String value) => Completer<void>().future;

  @override
  Future<void> remove(String key) => Completer<void>().future;
}
