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
    "${_me}final MeResponse _dto = const MeResponse(accountId: 'a', email: 'b', fullName: 'c', companyAdmin: false);\n"
        'final exposed = _dto;',
    {'A2'},
  ),
  'çıkarımlı genel alan': (
    '$_data/zz_field.dart',
    "${_me}class R { final _d = const MeResponse(accountId: 'a', email: 'b', fullName: 'c', companyAdmin: false); "
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
        "  final MeResponse _c = const MeResponse(accountId: 'a', email: 'b', fullName: 'c', companyAdmin: false);\n"
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
        "final exposed = const MeResponse(accountId: 'a', email: 'b', fullName: 'c', companyAdmin: false);",
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

  group('G3 sunumda servis/depo kurma (tip çözümlemeli)', () {
    const svc = 'features/zz/application/zz_service.dart';
    const repo = 'features/zz/data/zz_repository.dart';
    const other = 'features/zz/application/zz_helper.dart';
    const pres = 'features/zz/presentation/pages';
    const imports =
        "import 'package:nizamio/features/zz/application/zz_service.dart';\n"
        "import 'package:nizamio/features/zz/application/zz_service.dart' as s;\n"
        "import 'package:nizamio/features/zz/data/zz_repository.dart' as r;\n"
        "import 'package:nizamio/features/zz/application/zz_helper.dart';\n";
    final support = {
      svc:
          'class ZzService {\n'
          '  ZzService();\n  ZzService.named();\n'
          '  factory ZzService.make() => ZzService();\n}\n',
      repo: 'class ZzRepository { const ZzRepository(int x); }\n',
      other: 'class ZzHelper { ZzHelper(); }\n',
    };
    final cases = <String, (String, Set<String>)>{
      'doğrudan yapıcı (tablo 1)': ('final a = ZzService();', {'G3'}),
      'adlı yapıcı': ('final a = ZzService.named();', {'G3'}),
      'fabrika yapıcı': ('final a = ZzService.make();', {'G3'}),
      'önekli import (tablo 3)': ('final a = r.ZzRepository(1);', {'G3'}),
      'önekli import const': ('final a = const r.ZzRepository(1);', {'G3'}),
      'typedef takma adı (tablo 2)': (
        'typedef Svc = ZzService;\nfinal a = Svc();',
        {'G3'},
      ),
      'typedef adlı yapıcı': (
        'typedef Svc = ZzService;\nfinal a = Svc.named();',
        {'G3'},
      ),
      'tear-off (tablo 3)': ('final f = r.ZzRepository.new;', {'G3'}),
      'typedef tear-off': (
        'typedef Svc = ZzService;\nfinal f = Svc.new;',
        {'G3'},
      ),
      'alt sınıf + super (Codex 6 G3)': (
        'class Local extends ZzService { Local() : super(); }',
        {'G3'},
      ),
      'alt sınıf adlı super (Codex 6 G3)': (
        'class Local extends ZzService { Local() : super.named(); }',
        {'G3'},
      ),
      'alt sınıf typedef üzerinden (Codex 6 G3)': (
        'typedef Svc = ZzService;\nclass Local extends Svc { Local(); }',
        {'G3'},
      ),
      'yönlendirmeli fabrika (Codex 6 G3)': (
        'class Base { Base(); factory Base.make() = ZzFooService; }\n'
            'class ZzFooService extends Base {}',
        {'G3'},
      ),
      'ad tabanlı değil: Service ile bitmeyen sınıf serbest': (
        'final a = ZzHelper();',
        <String>{},
      ),
      'ad tabanlı değil: takma ad Service ile bitse de hedef Helper': (
        'typedef MyService = ZzHelper;\nfinal a = MyService();',
        <String>{},
      ),
      'servis tipi başvurusu (kurma değil) serbest': (
        'ZzService? held; void f(ZzService x) {}',
        <String>{},
      ),
    };
    late List<Violation> got;
    setUpAll(() async {
      got = await checkServiceConstruction(
        '.',
        overlays: {
          ...support,
          for (final (i, e) in cases.entries.indexed)
            '$pres/p$i.dart': '$imports${e.value.$1}\n',
          // presentation dışı: serbest (modül/bileşim).
          'features/zz/zz_module.dart': '${imports}final a = ZzService();\n',
          'features/zz/application/zz_use.dart':
              "import 'zz_service.dart';\nfinal a = ZzService();\n",
        },
      );
    });
    for (final (i, e) in cases.entries.indexed) {
      test(e.key, () {
        final rules = got
            .where((v) => v.path == 'lib/$pres/p$i.dart')
            .map((v) => v.rule)
            .toSet();
        expect(rules, e.value.$2, reason: got.join('\n'));
      });
    }
    test('presentation dışı (module, application) serbest', () {
      expect(got.where((v) => !v.path.contains('/presentation/')), isEmpty);
    });
    test('derleme hatası → A0 (sessiz temiz değil)', () async {
      final v = await checkServiceConstruction(
        '.',
        overlays: {'$pres/broken.dart': 'final a = Yok();'},
        only: ['$pres/broken.dart'],
      );
      expect(v.map((e) => e.rule).toSet(), {'A0'});
    });
    test('gerçek lib/ ağacında ihlal yok', () async {
      expect(await checkServiceConstruction('.'), isEmpty);
    });
  });

  group('N1 gezinme kimlik kuralı (tip çözümlemeli)', () {
    const dir = 'features/zz/presentation/pages';
    const imports =
        "import 'package:flutter/widgets.dart';\n"
        "import 'package:go_router/go_router.dart';\n"
        "import 'package:go_router/go_router.dart' as gr;\n"
        "import 'package:dio/dio.dart';\n"
        "import 'package:nizamio/app/router/routes.dart';\n";
    final cases = <String, (String, Set<String>)>{
      'context.go(dize)': ("void f(BuildContext c) => c.go('/x');", {'N1'}),
      'context.push(dize)': ("void f(BuildContext c) => c.push('/x');", {'N1'}),
      'GoRouter.of(context).go': (
        "void f(BuildContext c) => GoRouter.of(c).go('/x');",
        {'N1'},
      ),
      'context.goNamed': ("void f(BuildContext c) => c.goNamed('a');", {'N1'}),
      'context.pushNamed': (
        "void f(BuildContext c) => c.pushNamed('a');",
        {'N1'},
      ),
      'context.pushReplacement': (
        "void f(BuildContext c) => c.pushReplacement('/x');",
        {'N1'},
      ),
      'context.replace': ("void f(BuildContext c) => c.replace('/x');", {'N1'}),
      'context.pushReplacementNamed': (
        "void f(BuildContext c) => c.pushReplacementNamed('a');",
        {'N1'},
      ),
      'context.replaceNamed': (
        "void f(BuildContext c) => c.replaceNamed('a');",
        {'N1'},
      ),
      'tear-off context.go': (
        'void f(BuildContext c) { final g = c.go; g; }',
        {'N1'},
      ),
      'tear-off GoRouter.go': (
        'void f(GoRouter r) { final g = r.go; g; }',
        {'N1'},
      ),
      'extra: nesne': (
        "void f(BuildContext c) => c.go('/x', extra: Object());",
        {'N1'},
      ),
      'GoRouterState.extra okuması': (
        'Object? f(GoRouterState s) => s.extra;',
        {'N1'},
      ),
      'takma adlı import': (
        "void f(BuildContext c) => gr.GoRouterHelper(c).go('/x');",
        {'N1'},
      ),
      'takma adlı import GoRouter': (
        "void f(gr.GoRouter r) => r.push('/x');",
        {'N1'},
      ),
      'pozitif: tipli rota .go': (
        'void f(BuildContext c) => const HomeRoute().go(c);',
        <String>{},
      ),
      'pozitif: tipli rota .push': (
        "void f(BuildContext c) => const TaskDetailRoute(code: '1').push(c);",
        <String>{},
      ),
      'pozitif: dio options.extra': (
        "void f(RequestOptions o) { o.extra['k'] = 1; final e = o.extra; e; }",
        <String>{},
      ),
      'pozitif: dio Options(extra:)': (
        "final o = Options(extra: {'k': 1});",
        <String>{},
      ),
      'pozitif: ilgisiz go/extra adları': (
        'class Z { void go() {} Object? get extra => null; }\n'
            'void f(Z z) { z.go(); z.extra; }',
        <String>{},
      ),
    };
    late List<Violation> got;
    setUpAll(() async {
      got = await checkNavigation(
        '.',
        overlays: {
          for (final (i, e) in cases.entries.indexed)
            '$dir/p$i.dart': '$imports${e.value.$1}\n',
          // app/ ağacı (router hariç) da kapsamdadır; router içinde dize yol serbest.
          'app/zz_nav.dart':
              "${imports}void f(BuildContext c) => c.go('/x');\n",
          'app/router/zz_router.dart':
              "${imports}void f(BuildContext c) => c.go('/x');\n"
              'Object? g(GoRouterState s) => s.extra;\n',
          'core/zz_nav.dart':
              "${imports}void f(BuildContext c) => c.go('/x');\n",
        },
      );
    });
    for (final (i, e) in cases.entries.indexed) {
      test(e.key, () {
        final rules = got
            .where((v) => v.path == 'lib/$dir/p$i.dart')
            .map((v) => v.rule)
            .toSet();
        expect(rules, e.value.$2, reason: got.join('\n'));
      });
    }
    test('lib/app/** (router hariç) kapsamda', () {
      expect(got.where((v) => v.path == 'lib/app/zz_nav.dart'), isNotEmpty);
    });
    test('lib/app/router/** içinde dize yol ve extra serbest', () {
      expect(got.where((v) => v.path.startsWith('lib/app/router/')), isEmpty);
    });
    test(
      'lib/core/** kapsamda: dolaylı dize gezinme yardımcısı (Codex 6 N1)',
      () {
        expect(got.where((v) => v.path == 'lib/core/zz_nav.dart'), isNotEmpty);
      },
    );
    test('derleme hatası -> A0 (sessiz temiz değil)', () async {
      final v = await checkNavigation(
        '.',
        overlays: {'$dir/broken.dart': 'final a = Yok();'},
        only: ['$dir/broken.dart'],
      );
      expect(v.map((e) => e.rule).toSet(), {'A0'});
    });
    test('gerçek lib/ ağacında ihlal yok', () async {
      expect(await checkNavigation('.'), isEmpty);
    });
  });

  group('A5 genel tip parametresi (Codex 8)', () {
    // Aynı bağdaştırıcı yolu farklı gövdelerle denendiğinden vaka başına ayrı çözümleme.
    final cases = <String, (String, String, Set<String>)>{
      'T expose<T>() => _s.setString as T': (
        'core/preferences/app_preferences.dart',
        "import '../storage/preference_store.dart';\n"
            'class AppPreferences {\n'
            '  AppPreferences(this._s);\n'
            '  final PreferenceStore _s;\n'
            '  T expose<T>() => _s.setString as T;\n'
            '}',
        {'A5'},
      ),
      'sınırlı T extends Object alan': (
        'core/telemetry/telemetry.dart',
        'class Telemetry<T extends Object> { Telemetry(this.v); T v; }',
        {'A5'},
      ),
      'tip parametresi parametre olarak': (
        'core/preferences/app_preferences.dart',
        'class AppPreferences { void put<T>(T v) {} }',
        {'A5'},
      ),
      'somut sınırlı T extends num serbest': (
        'core/preferences/app_preferences.dart',
        'class AppPreferences {\n'
            '  T clamp<T extends num>(T v) => v;\n'
            '  String? get theme => null;\n'
            '}',
        <String>{},
      ),
    };
    for (final MapEntry(key: name, value: (path, src, expected))
        in cases.entries) {
      test(name, () async {
        final v = await checkApiSurface(
          '.',
          overlays: {path: src},
          only: [path],
        );
        expect(v.map((e) => e.rule).toSet(), expected, reason: v.join('\n'));
      });
    }
  });

  group('U1–U6 tip çözümlemeli (Codex 6)', () {
    const alias = 'core/ui/theme/zz_alias.dart';
    const pres = 'features/zz/presentation/pages';
    const imports =
        "import 'package:flutter/material.dart';\n"
        "import 'package:flutter/widgets.dart' as m;\n"
        "import 'package:nizamio/core/ui/theme/zz_alias.dart';\n";
    const zx =
        'class Zx extends ThemeExtension<Zx> {\n'
        '  @override Zx copyWith() => this;\n'
        '  @override Zx lerp(ThemeExtension<Zx>? o, double t) => this;\n}\n';
    final cases = <String, (String, Set<String>)>{
      'U1: yerel SizedBox + önekli Flutter SizedBox': (
        'class SizedBox { SizedBox({double? height}); }\n'
            'final w = m.SizedBox(height: 8);',
        {'U1'},
      ),
      'U1: yerel SizedBox + önekli const kare': (
        'class SizedBox { SizedBox({double? height}); }\n'
            'final w = const m.SizedBox.square(dimension: 8);',
        {'U1'},
      ),
      'U1 pozitif: yalnız yerel SizedBox serbest': (
        'class SizedBox { SizedBox({double? height}); }\n'
            'final w = SizedBox(height: 8);',
        <String>{},
      ),
      'U1 pozitif: çocuklu Flutter SizedBox serbest': (
        'final w = m.SizedBox(height: 8, child: const Text(""));',
        <String>{},
      ),
      'U2: typedef C = Color çağrısı': ('final c = C(0xFF000000);', {'U2'}),
      'U2: typedef Color adlı yapıcı': (
        'final c = C.fromARGB(1, 2, 3, 4);',
        {'U2'},
      ),
      'U2: typedef Color tear-off': ('final f = C.new;', {'U2'}),
      'U2: typedef Colors.x': ('final c = Cs.red;', {'U2'}),
      'U2: önekli Color': ('final c = m.Color(1);', {'U2'}),
      'U3: typedef T = TextStyle': ('final t = T(fontSize: 3);', {'U3'}),
      'U6: typedef S = Scaffold': (
        'final w = S(body: m.SizedBox.shrink());',
        {'U6'},
      ),
      'U4: typedef M = MediaQuery.of': (
        'Object f(BuildContext context) => M.of(context);',
        {'U4'},
      ),
      'U4 pozitif: sizeOf serbest': (
        'Object f(BuildContext context) => M.sizeOf(context);',
        <String>{},
      ),
      'U5: extension içinde örtük extensions[...]': (
        '${zx}extension E on ThemeData { Object? get x => extensions[Zx]; }',
        {'U5'},
      ),
      'U5: örtük extension<T>() çağrısı': (
        '${zx}extension E on ThemeData { Object? get x => extension<Zx>(); }',
        {'U5'},
      ),
      'U5: örtük tear-off final f = extension<T>': (
        '${zx}extension E on ThemeData {\n'
            '  Object? get x { final f = extension<Zx>; return f; }\n}',
        {'U5'},
      ),
      'U5: typedef ThemeData üzerinden extensions': (
        'typedef TD = ThemeData;\nObject? f(TD t) => t.extensions;',
        {'U5'},
      ),
      'U5 pozitif: ThemeData(extensions:) ve ilgisiz extension adı': (
        '${zx}final t = ThemeData(extensions: [Zx()]);\n'
            'class Other { Object? extension() => null; Object? get extensions => null; }\n'
            'Object? f(Other o) => o.extension() ?? o.extensions;',
        <String>{},
      ),
    };
    late List<Violation> got;
    setUpAll(() async {
      got = await checkUiResolved(
        '.',
        overlays: {
          alias:
              "import 'package:flutter/material.dart';\n"
              'typedef C = Color;\ntypedef T = TextStyle;\n'
              'typedef S = Scaffold;\ntypedef Cs = Colors;\n'
              'typedef M = MediaQuery;\n',
          for (final (i, e) in cases.entries.indexed)
            '$pres/p$i.dart': '$imports${e.value.$1}\n',
          // izinli dosya (tema dizini): renk/metin stili serbest.
          'core/ui/theme/zz_use.dart':
              "import 'zz_alias.dart';\nfinal c = C(1);\nfinal t = T();\n",
        },
      );
    });
    for (final (i, e) in cases.entries.indexed) {
      test(e.key, () {
        final rules = got
            .where((v) => v.path == 'lib/$pres/p$i.dart')
            .map((v) => v.rule)
            .toSet();
        expect(rules, e.value.$2, reason: got.join('\n'));
      });
    }
    test('izinli tema dizini ve alias dosyası serbest', () {
      expect(got.where((v) => v.path.startsWith('lib/core/')), isEmpty);
    });
    test('derleme hatası → A0 (sessiz temiz değil)', () async {
      final v = await checkUiResolved(
        '.',
        overlays: {'$pres/broken.dart': 'final a = Yok();'},
        only: ['$pres/broken.dart'],
      );
      expect(v.map((e) => e.rule).toSet(), {'A0'});
    });
    test('gerçek lib/ ağacında ihlal yok', () async {
      expect(await checkUiResolved('.'), isEmpty);
    });
  });

  test('boş hedef kümesi → A0', () async {
    final v = await checkApiSurface('.', only: const []);
    expect(v.map((e) => e.rule), ['A0']);
  });

  test('gerçek lib/ ağacında açık API sızıntısı yok', () {
    expect(real.map((v) => v.toString()), isEmpty);
  });
}
