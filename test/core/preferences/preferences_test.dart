// Tercihler: tipli anahtar, hata → varsayılan, tema modu denetleyicisi + Riverpod yüzü.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/preferences/app_preferences.dart';
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
}
