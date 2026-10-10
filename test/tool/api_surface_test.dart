// tool/api_surface.dart (A2/A3, tip çözümlemeli) negatif/pozitif matrisi + gerçek lib/ ağacı.
// Vakalar diskte değil bellek katmanında (overlay) kütüphane olarak çözümlenir.
@Timeout(Duration(minutes: 3))
library;

import 'package:flutter_test/flutter_test.dart';

import '../../tool/api_surface.dart';
import '../../tool/boundaries.dart';

const _me =
    "import 'package:nizamio/core/api/generated/models/me_response.dart';\n";
const _data = 'features/identity/data';

/// Vaka adı → (lib göreli yol, içerik, beklenen kural kümesi).
final _cases = <String, (String, String, Set<String>)>{
  'genel metot dönüşü': (
    '$_data/zz_return.dart',
    '${_me}class R { Future<MeResponse> me() async => throw 0; }',
    {'A2'},
  ),
  'çıkarımlı genel değişken (CX-a-Ö-02)': (
    '$_data/zz_inferred.dart',
    "${_me}final MeResponse _dto = const MeResponse(accountId: 'a', email: 'b');\n"
        'final exposed = _dto;',
    {'A2'},
  ),
  'çıkarımlı genel alan': (
    '$_data/zz_field.dart',
    "${_me}class R { final _d = const MeResponse(accountId: 'a', email: 'b'); "
        'late final exposed = _d; }',
    {'A2'},
  ),
  'genel yapıcı parametresi (CX-a-Ö-02)': (
    '$_data/zz_ctor.dart',
    '${_me}class R { R(MeResponse value) : _v = value; final MeResponse _v; '
        'String get email => _v.email; }',
    {'A2'},
  ),
  'core typedef zinciri (CX-a-Ö-02)': (
    '$_data/zz_alias_use.dart',
    "import '../../../core/zz_alias.dart';\nclass R { Me? m; }",
    {'A2'},
  ),
  'core typedef kendisi': (
    'core/zz_alias.dart',
    '${_me}typedef Me = MeResponse;',
    {'A3'},
  ),
  'core genel API': (
    'core/zz_leak.dart',
    '${_me}class C { MeResponse? last; }',
    {'A3'},
  ),
  'üst tip (implements)': (
    '$_data/zz_super.dart',
    '${_me}abstract class R implements MeResponse {}',
    {'A2'},
  ),
  'extension ve extension type': (
    '$_data/zz_ext.dart',
    '${_me}extension X on MeResponse { int get n => 1; }\n'
        'extension type E(MeResponse r) {}',
    {'A2'},
  ),
  'işlev ve kayıt tipi içinde': (
    '$_data/zz_nested.dart',
    '${_me}class R { void Function(MeResponse)? cb; (int, {MeResponse m})? rec; }',
    {'A2'},
  ),
  'takma adlı import (çözümleme)': (
    '$_data/zz_prefix.dart',
    "import 'package:nizamio/core/api/generated/models/me_response.dart' as api;\n"
        'class R { api.MeResponse? m; }',
    {'A2'},
  ),
  'yerel aynı adlı tip yanlış pozitif değil (CX-a-K-02)': (
    '$_data/zz_shadow.dart',
    "import 'package:nizamio/core/api/generated/models/me_response.dart' as api;\n"
        'class MeResponse { const MeResponse(); }\n'
        'class R { MeResponse? m; api.MeResponse? _p; String? get e => _p?.email; }',
    <String>{},
  ),
  'gövde ve özel bildirimler serbest': (
    '$_data/zz_private.dart',
    '${_me}class R {\n'
        "  final MeResponse _c = const MeResponse(accountId: 'a', email: 'b');\n"
        '  String me() { final m = _c; return m.email; }\n'
        '  static String _map(MeResponse r) => r.email;\n'
        '  String other() => _map(_c);\n'
        '}\n'
        'class _P { MeResponse? m; }\n'
        'String f() => _P().m?.email ?? "";',
    <String>{},
  ),
  '.g.dart kütüphane kökü + part (CX-a-Ö-04)': (
    '$_data/zz_root.g.dart',
    "${_me}part 'zz_root_part.dart';",
    {'A2'},
  ),
  '.g.dart kökünün parçası (sahibi tarandı)': (
    '$_data/zz_root_part.dart',
    "part of 'zz_root.g.dart';\n"
        "final exposed = const MeResponse(accountId: 'a', email: 'b');",
    <String>{},
  ),
  'sahibi olmayan part → A0 (CX-a-Ö-05)': (
    '$_data/zz_orphan.dart',
    "part of 'zz_none.dart';\nfinal x = 1;",
    {'A0'},
  ),
  'çözümlenemeyen import → A0, sessiz temiz değil (CX-a-Ö-05)': (
    '$_data/zz_broken.dart',
    "import 'zz_yok.dart';\nclass R { Yok? y; }",
    {'A0'},
  ),
  'A4: izinli dizindeki facade ham depoyu getter ile taşır (CX-r3-Ö-04)': (
    'core/storage/zz_prefs_facade.dart',
    "import 'preference_store.dart';\nimport 'shared_preference_store.dart';\n"
        'PreferenceStore get raw => SharedPreferenceStore();',
    {'A4'},
  ),
  'A4: typedef ve kalıtım': (
    'core/session/zz_prefs_alias.dart',
    "import '../storage/preference_store.dart';\n"
        'typedef Prefs = PreferenceStore;\n'
        'abstract class P implements PreferenceStore {}',
    {'A4'},
  ),
  'A4: telemetri Firebase nesnesini dışa verir': (
    'core/telemetry/zz_tel.dart',
    "import 'package:firebase_analytics/firebase_analytics.dart';\n"
        'FirebaseAnalytics analytics() => FirebaseAnalytics.instance;',
    {'A4'},
  ),
  'A4: shared_preferences tipi fabrika ile': (
    'core/storage/zz_sp_factory.dart',
    "import 'package:shared_preferences/shared_preferences.dart';\n"
        'SharedPreferencesAsync open() => SharedPreferencesAsync();',
    {'A4'},
  ),
  'A4: SDK yalnız gövde/özel üyede serbest': (
    'core/telemetry/zz_tel_ok.dart',
    "import 'package:firebase_analytics/firebase_analytics.dart';\n"
        'class Telemetry {\n'
        '  FirebaseAnalytics get _a => FirebaseAnalytics.instance;\n'
        '  Future<void> event(String name) => _a.logEvent(name: name);\n'
        '}',
    <String>{},
  ),
  'A5: ham depo dynamic ile taşınır (CX-r3-Ö-04)': (
    'core/storage/shared_preference_store.dart',
    "import 'package:shared_preferences/shared_preferences.dart';\n"
        "import 'preference_store.dart';\n"
        'class SharedPreferenceStore implements PreferenceStore {\n'
        '  @override Future<String?> getString(String k) async => null;\n'
        '  @override Future<void> setString(String k, String v) async {}\n'
        '  @override Future<void> remove(String k) async {}\n'
        '}\n'
        'dynamic get raw => SharedPreferencesAsync();',
    {'A5'},
  ),
  'A5: AppPreferences Object ve geri çağrı ile taşır': (
    'core/preferences/app_preferences.dart',
    "import '../storage/preference_store.dart';\n"
        'class AppPreferences {\n'
        '  AppPreferences(this._s);\n'
        '  final PreferenceStore _s;\n'
        '  Object get store => _s;\n'
        '  Future<void> Function(String, String) get writer => _s.setString;\n'
        '  List<dynamic> all() => [];\n'
        '}',
    {'A5'},
  ),
  'A5: telemetri tipsiz nesne': (
    'core/telemetry/telemetry.dart',
    "import 'package:firebase_analytics/firebase_analytics.dart';\n"
        'dynamic analytics() => FirebaseAnalytics.instance;',
    {'A5'},
  ),
  'A4: AppPreferences ham depoyu adlandırılmış tiple verir (CX-r3-Ö-04)': (
    'core/preferences/zz_app_prefs_leak.dart',
    "import '../storage/preference_store.dart';\n"
        'class AppPrefs2 {\n'
        '  AppPrefs2(this._store);\n'
        '  final PreferenceStore _store;\n'
        '  PreferenceStore get raw => _store;\n'
        '}',
    {'A4'},
  ),
  'A4: tip parametresi sınırı': (
    'core/preferences/zz_bound.dart',
    "import '../storage/preference_store.dart';\n"
        'class Holder<T extends PreferenceStore> { Holder(this._t); final T _t; '
        'int get n => _t.hashCode; }',
    {'A4'},
  ),
  'A4: yalnız yapıcı girdisi serbest (AppPreferences biçimi)': (
    'core/preferences/zz_ctor_only.dart',
    "import '../storage/preference_store.dart';\n"
        'class Prefs3 {\n'
        '  Prefs3(this._store);\n'
        '  final PreferenceStore _store;\n'
        "  Future<String?> theme() => _store.getString('k');\n"
        '}',
    <String>{},
  ),
};

void main() {
  late List<Violation> overlayed;
  late List<Violation> real;

  setUpAll(() async {
    overlayed = await checkApiSurface(
      '.',
      overlays: {for (final c in _cases.values) c.$1: c.$2},
      only: [for (final c in _cases.values) c.$1],
    );
    real = await checkApiSurface('.');
  });

  for (final MapEntry(key: name, value: (path, _, expected))
      in _cases.entries) {
    test(name, () {
      final got = overlayed
          .where((v) => v.path == 'lib/$path')
          .map((v) => v.rule)
          .toSet();
      expect(got, expected, reason: overlayed.join('\n'));
    });
  }

  test('boş hedef kümesi → A0', () async {
    final v = await checkApiSurface('.', only: const []);
    expect(v.map((e) => e.rule), ['A0']);
  });

  test('gerçek lib/ ağacında açık API sızıntısı yok', () {
    expect(real.map((v) => v.toString()), isEmpty);
  });
}
