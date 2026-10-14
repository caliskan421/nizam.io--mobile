// Dil denetleyicisi: yükleme, kalıcılık, desteklenmeyen dilin yok sayılması.
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/preferences/app_preferences.dart';
import 'package:nizamio/core/preferences/locale_controller.dart';

import 'package:nizamio/core/storage/preference_store.dart';

void main() {
  test('load kayıtlı dili okur; kayıt yoksa tr', () async {
    final store = MemoryPreferenceStore();
    final c = LocaleController(AppPreferences(store));
    expect(c.state.value, const Locale('tr'));
    await c.load();
    expect(c.state.value, const Locale('tr'));
    c.dispose();
  });

  test('set desteklenen dili yazar; desteklenmeyeni yok sayar', () async {
    final store = MemoryPreferenceStore();
    final c = LocaleController(AppPreferences(store));
    await c.set(const Locale('tr', 'TR'));
    expect(c.state.value, const Locale('tr'));
    expect(store.values[AppPreferences.localeKey], 'tr');
    await c.set(const Locale('en'));
    expect(c.state.value, const Locale('tr'));
    c.dispose();
  });
}
