import 'package:flutter/material.dart';

import 'app_preferences.dart';

/// Tema modu (sistem/açık/koyu): bellek durumu + kalıcılık. Açılışta [load] bir kez çağrılır
/// (bootstrap, `runApp`'ten önce; titreşim olmasın); [set] durumu hemen günceller ve yazar.
class ThemeModeController {
  ThemeModeController(this._prefs);

  final AppPreferences _prefs;
  final ValueNotifier<ThemeMode> state = ValueNotifier(ThemeMode.system);

  Future<void> load() async => state.value = await _prefs.themeMode();

  Future<void> set(ThemeMode mode) async {
    state.value = mode;
    await _prefs.setThemeMode(mode);
  }

  void dispose() => state.dispose();
}
