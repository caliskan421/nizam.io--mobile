import 'package:flutter/widgets.dart';

import 'app_preferences.dart';

/// Uygulama dili: bellek durumu + kalıcılık (altyapı; yalnız `tr`). Açılışta [load] bir kez
/// çağrılır (bootstrap, `runApp`'ten önce); [set] desteklenen dili hemen günceller ve yazar,
/// desteklenmeyeni yok sayar. [ThemeModeController] ile aynı kalıp.
class LocaleController {
  LocaleController(this._prefs);

  final AppPreferences _prefs;
  final ValueNotifier<Locale> state = ValueNotifier(
    AppPreferences.supportedLocales.first,
  );

  Future<void> load() async => state.value = await _prefs.locale();

  Future<void> set(Locale locale) async {
    if (!AppPreferences.supportedLocales.contains(
      Locale(locale.languageCode),
    )) {
      return;
    }
    state.value = Locale(locale.languageCode);
    await _prefs.setLocale(locale);
  }

  void dispose() => state.dispose();
}
