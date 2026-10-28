// Bileşim kökünün davranışını SABİTLEYEN test (D-0182 get_it taşımasından ÖNCE yazıldı; taşıma
// sonrası aynen geçmeli): taze açılış sırası, yeniden bağlanma kablosu, oturum→kapsam temizliği,
// yenileme çağrısının kuruluma bağlılığı, Bearer'ın kuruluma bağlılığı.
import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nizamio/app/bootstrap.dart';
import 'package:nizamio/app/di/composition.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/server/server_binding.dart';
import 'package:nizamio/core/session/session_controller.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/core/session/token_pair.dart';
import 'package:nizamio/core/session/token_store.dart';
import 'package:nizamio/core/storage/preference_store.dart';
import 'package:nizamio/core/storage/secure_store.dart';
import 'package:nizamio/features/identity/identity.dart';
import 'package:nizamio/features/scope/scope.dart';

import '../support/fake_backend.dart';
import '../support/harness.dart';

String instance = 'inst-1';

Future<ResponseBody> handler(Seen r) async {
  switch ('${r.method} ${r.path}') {
    case 'GET /.well-known/nizamio-instance':
      return jsonResponse(200, {
        'product_id': 'nizamio',
        'instance_id': instance,
        'company_display_name': 'x',
        'server_version': 'x',
        'api_version': 'v1',
        'minimum_mobile_version': '0.0.0',
        'capabilities': null,
      });
    case 'POST /v1/auth/login':
      return jsonResponse(200, loginBody('1'));
    case 'POST /v1/auth/logout':
      return ResponseBody.fromString('', 204);
    case 'GET /v1/me':
      return jsonResponse(200, {'account_id': 'acc-1', 'email': 'a@b.test'});
  }
  return discoveryHandler(r);
}

Future<MemorySecureStore> seeded(String id) async {
  final store = MemorySecureStore();
  await store.write(
    ServerBindingController.storeKey,
    '{"origin":"$testUrl","instance_id":"$id"}',
  );
  await TokenStore(store).save(
    TokenPair(
      accountId: 'acc-1',
      accessToken: 'access-token-old',
      accessExpiresAt: 4102444800,
      refreshToken: 'refresh-token-old',
      refreshExpiresAt: 4102444800,
      forcePasswordChange: false,
      instanceId: id,
    ),
  );
  return store;
}

/// Q3 — kayıt denetimi (ADR-0003 karar 13). Port listesi KODDAN toplanır: `lib/` altında
/// `_unbound('<ad>')` (core) ya da `throw UnimplementedError('<ad> …')` (feature) ile
/// bileşim kökünde bağlanmayı bekleyen her sağlayıcı bir porttur. Dart'ta ada göre sağlayıcı
/// nesnesi çözülemediğinden nesne eşlemesi aşağıdaki [portProviders] tablosundadır; tablo
/// koddan toplanan listeyle birebir olmak ZORUNDA (yeni port eklenip tabloya yazılmazsa test
/// kırılır), tablodaki her port da bileşim kökünde okunur.
final portProviders = <String, ProviderBase<Object?>>{
  'flavorProvider': flavorProvider,
  'httpAdapterProvider': httpAdapterProvider,
  'scopeControllerProvider': scopeControllerProvider,
  'serverBindingProvider': serverBindingProvider,
  'sessionControllerProvider': sessionControllerProvider,
  'themeModeControllerProvider': themeModeControllerProvider,
  'connectivityMonitorProvider': connectivityMonitorProvider,
  'localeControllerProvider': localeControllerProvider,
  'identityServiceProvider': identityServiceProvider,
  'scopeServiceProvider': scopeServiceProvider,
  'homeDashboardRepositoryProvider': homeDashboardRepositoryProvider,
};

const compositionPath = 'lib/app/di/composition.dart';

Map<String, String> libSources() => {
  for (final f in Directory('lib').listSync(recursive: true))
    if (f is File &&
        f.path.endsWith('.dart') &&
        !f.path.endsWith('.g.dart') &&
        !f.path.contains('/generated/'))
      f.path: f.readAsStringSync(),
};

CompilationUnit _parse(String path, String src) =>
    parseString(content: src, path: path, throwIfDiagnostics: false).unit;

bool _isRiverpodAnnotation(Annotation a) {
  final n = a.name is PrefixedIdentifier
      ? (a.name as PrefixedIdentifier).identifier.name
      : a.name.name;
  return n == 'Riverpod' || n == 'riverpod';
}

/// Gövdede (iç işlev gövdelerine inmeden) `throw UnimplementedError(…)` ya da [helpers]'tan
/// birinin çağrısı var mı. Yorumlar ve dizeler AST'de yoktur.
class _UnboundFinder extends RecursiveAstVisitor<void> {
  _UnboundFinder(this.helpers);

  final Set<String> helpers;
  bool found = false;

  @override
  void visitThrowExpression(ThrowExpression node) {
    final e = node.expression;
    final name = switch (e) {
      InstanceCreationExpression() => e.constructorName.type.name.lexeme,
      MethodInvocation() when e.target == null => e.methodName.name,
      _ => null,
    };
    if (name == 'UnimplementedError') found = true;
    super.visitThrowExpression(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.target == null && helpers.contains(node.methodName.name)) {
      found = true;
    }
    super.visitMethodInvocation(node);
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {}
}

bool _unboundBody(FunctionBody body, Set<String> helpers) {
  final f = _UnboundFinder(helpers);
  body.accept(f);
  return f.found;
}

String _providerName(String declName) =>
    '${declName[0].toLowerCase()}${declName.substring(1)}Provider';

/// Q3 port envanteri (AST): `@Riverpod`/`@riverpod` açıklamalı işlev (ya da sınıfın `build`
/// metodu) gövdesi bağsız bir port ise: `throw UnimplementedError(…)` (tırnak türü, bağımsız
/// değişken, blok/ifade gövdesi fark etmez) ya da aynı yazılımda yalnız `UnimplementedError`
/// fırlatan bir yardımcının (`_unbound`) çağrısı. Sağlayıcı adı bildirim adından türer.
Set<String> discoverPortsIn(Map<String, String> sources) {
  final units = [for (final e in sources.entries) _parse(e.key, e.value)];
  // `_unbound(name)` gibi yardımcılar: açıklamasız üst düzey işlev, gövdesi UnimplementedError.
  final helpers = <String>{};
  for (final u in units) {
    for (final d in u.declarations) {
      if (d is FunctionDeclaration &&
          d.metadata.isEmpty &&
          _unboundBody(d.functionExpression.body, const {})) {
        helpers.add(d.name.lexeme);
      }
    }
  }
  final names = <String>{};
  for (final u in units) {
    for (final d in u.declarations) {
      if (d is FunctionDeclaration &&
          d.metadata.any(_isRiverpodAnnotation) &&
          _unboundBody(d.functionExpression.body, helpers)) {
        names.add(_providerName(d.name.lexeme));
      } else if (d is ClassDeclaration &&
          d.metadata.any(_isRiverpodAnnotation)) {
        for (final m
            in d.body is BlockClassBody
                ? (d.body as BlockClassBody).members
                : const <ClassMember>[]) {
          if (m is MethodDeclaration &&
              m.name.lexeme == 'build' &&
              _unboundBody(m.body, helpers)) {
            names.add(_providerName(d.namePart.typeName.lexeme));
          }
        }
      }
    }
  }
  return names;
}

Set<String> discoverPorts() => discoverPortsIn(libSources());

/// `ProviderContainer(overrides: […])` listesine GERÇEKTEN katılan sağlayıcı adları (AST):
/// `<ad>.overrideWithValue/overrideWith(…)` öğeleri ve `...<f>Overrides(locator)` yayılımının
/// [sources]'ta tanımlı işlevinin döndürdüğü liste. Yorum satırları ve koşullu (`if`/`for`)
/// öğeler sayılmaz. Liste bulunamazsa boş küme (test başarısız olur: fail-closed).
Set<String> overrideTargetsIn(
  String compositionPath,
  Map<String, String> sources,
) {
  final units = {
    for (final e in sources.entries) e.key: _parse(e.key, e.value),
  };
  final functions = <String, FunctionDeclaration>{};
  for (final u in units.values) {
    for (final d in u.declarations) {
      if (d is FunctionDeclaration) functions[d.name.lexeme] = d;
    }
  }
  ListLiteral? listOf(FunctionBody body) {
    if (body is ExpressionFunctionBody && body.expression is ListLiteral) {
      return body.expression as ListLiteral;
    }
    if (body is BlockFunctionBody) {
      for (final st in body.block.statements) {
        if (st is ReturnStatement && st.expression is ListLiteral) {
          return st.expression as ListLiteral;
        }
      }
    }
    return null;
  }

  final targets = <String>{};
  final visiting = <String>{};
  void walk(ListLiteral list) {
    for (final el in list.elements) {
      if (el is MethodInvocation &&
          el.target is SimpleIdentifier &&
          const {
            'overrideWithValue',
            'overrideWith',
          }.contains(el.methodName.name)) {
        targets.add((el.target as SimpleIdentifier).name);
      } else if (el is SpreadElement) {
        final e = el.expression;
        if (e is MethodInvocation && e.target == null) {
          final fn = functions[e.methodName.name];
          final inner = fn == null ? null : listOf(fn.functionExpression.body);
          if (inner != null && visiting.add(e.methodName.name)) {
            walk(inner);
          }
        } else if (e is ListLiteral) {
          walk(e);
        }
      }
    }
  }

  final comp = units[compositionPath];
  if (comp == null) return targets;
  final finder = _ContainerOverrides();
  comp.accept(finder);
  for (final l in finder.lists) {
    walk(l);
  }
  return targets;
}

/// `ProviderContainer(…, overrides: [...])` çağrılarının `overrides` listeleri.
class _ContainerOverrides extends RecursiveAstVisitor<void> {
  final lists = <ListLiteral>[];

  void _args(ArgumentList args) {
    for (final a in args.arguments) {
      if (a is NamedArgument &&
          a.name.lexeme == 'overrides' &&
          a.argumentExpression is ListLiteral) {
        lists.add(a.argumentExpression as ListLiteral);
      }
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.target == null && node.methodName.name == 'ProviderContainer') {
      _args(node.argumentList);
    }
    super.visitMethodInvocation(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (node.constructorName.type.name.lexeme == 'ProviderContainer') {
      _args(node.argumentList);
    }
    super.visitInstanceCreationExpression(node);
  }
}

/// `*_module.dart` dosyalarında tanımlı `List<Override> <ad>Overrides(…)` işlevleri.
Set<String> moduleOverrideFunctions(Map<String, String> sources) {
  final out = <String>{};
  for (final e in sources.entries) {
    if (!e.key.endsWith('_module.dart')) continue;
    for (final d in _parse(e.key, e.value).declarations) {
      if (d is FunctionDeclaration &&
          d.returnType is NamedType &&
          (d.returnType as NamedType).name.lexeme == 'List' &&
          d.name.lexeme.endsWith('Overrides')) {
        out.add(d.name.lexeme);
      }
    }
  }
  return out;
}

/// Bileşim kökünün `overrides:` listesinde doğrudan yayılan (`...f(…)`) işlev adları.
Set<String> spreadFunctionsIn(
  String compositionPath,
  Map<String, String> sources,
) {
  final unit = _parse(compositionPath, sources[compositionPath] ?? '');
  final finder = _ContainerOverrides();
  unit.accept(finder);
  return {
    for (final l in finder.lists)
      for (final el in l.elements)
        if (el is SpreadElement &&
            el.expression is MethodInvocation &&
            (el.expression as MethodInvocation).target == null)
          (el.expression as MethodInvocation).methodName.name,
  };
}

bool isUnbound(Object e) =>
    e is UnimplementedError ||
    (e is ProviderException && e.exception is UnimplementedError);

/// [container]'da okununca `UnimplementedError` atan portların adları.
Set<String> unboundPorts(ProviderContainer container) {
  final out = <String>{};
  for (final MapEntry(:key, :value) in portProviders.entries) {
    try {
      container.read(value);
    } catch (e) {
      if (isUnbound(e)) {
        out.add(key);
      } else {
        rethrow;
      }
    }
  }
  return out;
}

void registrationTests() {
  group('Q3: kayıt denetimi (bütün portlar bileşim kökünde bağlı)', () {
    test(
      'koddan toplanan port listesi tabloyla birebir (yeni port unutulmaz)',
      () {
        final found = discoverPorts();
        expect(found, isNotEmpty);
        expect(
          portProviders.keys.toSet(),
          found,
          reason: 'yeni port: portProviders tablosuna ekle; kaldırılan port: tablodan sil',
        );
      },
    );

    test(
      'her feature modülünün *Overrides listesi bileşim kökünde yayılır (AST)',
      () {
        final sources = libSources();
        final defined = moduleOverrideFunctions(sources);
        expect(defined, isNotEmpty);
        expect(
          spreadFunctionsIn(compositionPath, sources),
          containsAll(defined),
          reason: 'modül Overrides işlevi ProviderContainer(overrides:) içinde yayılmamış',
        );
      },
    );

    test('her port ProviderContainer(overrides:) listesine gerçekten katılır (AST)', () {
      final sources = libSources();
      final ports = discoverPortsIn(sources);
      expect(ports, isNotEmpty);
      expect(
        overrideTargetsIn(compositionPath, sources),
        containsAll(ports),
        reason: 'bileşim kökü overrides listesinde olmayan port',
      );
    });

    test(
      'bileşim kökü kurulunca hiçbir port UnimplementedError atmaz',
      () async {
        final comp = Composition.create(
          flavor: Flavor.prod,
          secureStore: MemorySecureStore(),
          preferenceStore: MemoryPreferenceStore(),
        );
        addTearDown(comp.dispose);
        expect(unboundPorts(comp.container), isEmpty);
      },
    );

    group('AST envanteri negatifleri (Codex 9)', () {
      const hdr =
          "import 'package:riverpod_annotation/riverpod_annotation.dart';\n";
      test('throw UnimplementedError() (bağımsız değişkensiz) port sayılır', () {
        expect(
          discoverPortsIn({
            'a.dart':
                '$hdr@Riverpod(keepAlive: true)\nFoo foo(Ref ref) => throw UnimplementedError();',
          }),
          {'fooProvider'},
        );
      });
      test('çift tırnak, blok gövde ve yardımcı çağrısı port sayılır', () {
        expect(
          discoverPortsIn({
            'a.dart':
                '$hdr@riverpod\nFoo foo(Ref ref) { throw UnimplementedError("x"); }\n'
                '@Riverpod(keepAlive: true)\nBar bar(Ref ref) { return _nope("bar"); }\n'
                'Never _nope(String n) => throw UnimplementedError(n);',
          }),
          {'fooProvider', 'barProvider'},
        );
      });
      test('sınıf tabanlı build() portu sayılır', () {
        expect(
          discoverPortsIn({
            'a.dart':
                '$hdr@riverpod\nclass Baz extends _\$Baz {\n'
                '  @override\n  int build() => throw UnimplementedError();\n}',
          }),
          {'bazProvider'},
        );
      });
      test('yorum, dize, açıklamasız ve bağlı sağlayıcılar port değildir', () {
        expect(
          discoverPortsIn({
            'a.dart':
                '$hdr// throw UnimplementedError();\n'
                '@Riverpod(keepAlive: true)\nint ok(Ref ref) => 1;\n'
                '@Riverpod(keepAlive: true)\nString s(Ref ref) => "throw UnimplementedError()";\n'
                'void plain() { throw UnimplementedError(); }\n'
                '@Riverpod(keepAlive: true)\nint lam(Ref ref) { final f = () => throw UnimplementedError(); return 1; }',
          }),
          isEmpty,
        );
      });

      const comp = 'lib/app/di/composition.dart';
      String compSrc(String overrides) =>
          'class Composition { Composition() {\n'
          '  container = ProviderContainer(retry: (_, _) => null, overrides: [\n'
          '$overrides\n  ]);\n} }';
      const mod = 'lib/features/x/x_module.dart';
      const modSrc =
          'List<Override> xOverrides(GetIt l) => [\n'
          '  xServiceProvider.overrideWith((ref) => l()),\n];';
      test('yorum satırındaki override sayılmaz', () {
        final sources = {
          comp: compSrc(
            '  // flavorProvider.overrideWithValue(flavor),\n'
            '  /* ...xOverrides(locator), */\n'
            '  gProvider.overrideWithValue(1),',
          ),
          mod: modSrc,
        };
        expect(overrideTargetsIn(comp, sources), {'gProvider'});
        expect(spreadFunctionsIn(comp, sources), isEmpty);
      });
      test('yayılım modül işlevinin listesini genişletir', () {
        final sources = {
          comp: compSrc('  ...xOverrides(locator),'),
          mod: modSrc,
        };
        expect(overrideTargetsIn(comp, sources), {'xServiceProvider'});
        expect(spreadFunctionsIn(comp, sources), {'xOverrides'});
        expect(moduleOverrideFunctions(sources), {'xOverrides'});
      });
      test('ProviderContainer(overrides:) dışındaki liste sayılmaz', () {
        final sources = {
          comp:
              'void f() {\n'
              '  final unused = [aProvider.overrideWithValue(1)];\n'
              '  other(overrides: [bProvider.overrideWithValue(1)]);\n'
              '  ProviderContainer(overrides: [cProvider.overrideWithValue(1)]);\n}',
        };
        expect(overrideTargetsIn(comp, sources), {'cProvider'});
      });
      test('koşullu öğe ve bulunamayan işlev yayılımı sayılmaz', () {
        final sources = {
          comp: compSrc(
            '  if (false) aProvider.overrideWithValue(1),\n'
            '  ...yokOverrides(locator),',
          ),
        };
        expect(overrideTargetsIn(comp, sources), isEmpty);
      });
      test('bileşim dosyası ya da liste yoksa boş (fail-closed)', () {
        expect(overrideTargetsIn(comp, {}), isEmpty);
        expect(overrideTargetsIn(comp, {comp: 'void f() {}'}), isEmpty);
      });
    });

    test('negatif: geçersiz kılınmayan port yakalanır (testin dişi var)', () {
      // Boş kap: bütün portlar bağsız.
      final bare = ProviderContainer();
      addTearDown(bare.dispose);
      expect(unboundPorts(bare), portProviders.keys.toSet());

      // Yalnız flavor ve http portları bağlı bir kap: bağlanmayan diğer portların
      // hepsi (ve yalnız onlar) raporlanır.
      final missing = ProviderContainer(
        overrides: [
          flavorProvider.overrideWithValue(Flavor.prod),
          httpAdapterProvider.overrideWithValue(null),
        ],
      );
      addTearDown(missing.dispose);
      expect(
        unboundPorts(missing),
        portProviders.keys.toSet().difference({
          'flavorProvider',
          'httpAdapterProvider',
        }),
      );
    });
  });
}

void main() {
  setUp(() => instance = 'inst-1');
  registrationTests();

  testWidgets('hata veren sağlayıcı kendiliğinden yeniden denenmez (A3)', (
    tester,
  ) async {
    final h = Harness();
    addTearDown(h.dispose);
    var runs = 0;
    final failing = FutureProvider<int>((ref) {
      runs++;
      return Future<int>.error(ApiError(ClientErrorCode.timeout));
    });
    h.container.listen(failing, (_, _) {});
    await tester.pump();
    expect(runs, 1);
    await tester.pump(const Duration(minutes: 5));
    expect(runs, 1, reason: 'üstel geri çekilmeyle otomatik deneme yok');
  });

  test('taze açılış, aynı kurulum: bağ doğrulanır → oturum geri yüklenir → Bearer gider', () async {
    final h = Harness(handler: handler, store: await seeded('inst-1'));
    addTearDown(h.dispose);
    await startup(h.container);
    expect(h.read(bindingStateProvider), isA<BindingVerified>());
    expect(h.read(sessionStateProvider), isA<SessionActive>());
    await h.identity.me();
    expect(
      h.backend.requests.last.header('Authorization'),
      'Bearer access-token-old',
    );
    // Sıra: önce keşif + profil, sonra kimlikli istek.
    expect(h.backend.requests.map((r) => r.path).take(2), [
      '/.well-known/nizamio-instance',
      '/v1/instance/profile',
    ]);
  });

  test(
    'taze açılış, değişmiş kurulum: oturum geri yüklenmez, belirteçler silinir',
    () async {
      instance = 'inst-2';
      final h = Harness(handler: handler, store: await seeded('inst-1'));
      addTearDown(h.dispose);
      await startup(h.container);
      expect(h.read(sessionStateProvider), isA<SessionNone>());
      expect(h.store.values.containsKey(TokenStore.key), isFalse);
    },
  );

  test(
    'kablo: farklı kuruluma yeniden bağlanma oturumu ve kapsamı temizler',
    () async {
      final h = Harness(handler: handler);
      addTearDown(h.dispose);
      await h.read(serverBindingProvider).verify(testUrl);
      await h.identity.login(email: 'a@b.test', password: 'p');
      h.read(scopeControllerProvider).selectProgram('p-1');
      instance = 'inst-2';
      await h.read(serverBindingProvider).verify(testUrl);
      expect(h.read(sessionStateProvider), isA<SessionNone>());
      expect(h.read(scopeStateProvider).hasProgram, isFalse);
      expect(h.store.values.containsKey(TokenStore.key), isFalse);
    },
  );

  test('kablo: çıkış kapsamı temizler; apiDio bağa göre türetilir', () async {
    final h = Harness(handler: handler);
    addTearDown(h.dispose);
    expect(h.read(apiDioProvider), isNull);
    await h.read(serverBindingProvider).verify(testUrl);
    expect(h.read(apiDioProvider), isNotNull);
    await h.identity.login(email: 'a@b.test', password: 'p');
    h.read(scopeControllerProvider).selectProgram('p-1');
    await h.identity.logout();
    expect(h.read(scopeStateProvider).hasProgram, isFalse);
    expect(h.read(appPhaseProvider).name, 'serverVerified');
  });

  test(
    'kablo: yenileme yalnız çiftin kurulumu güncel bağsa ağa çıkar',
    () async {
      final h = Harness(handler: handler);
      addTearDown(h.dispose);
      await h.read(serverBindingProvider).verify(testUrl);
      await h.identity.login(email: 'a@b.test', password: 'p');
      // Bağ geçişte (doğrulanmış değil): yenileme ağa çıkmadan düşer.
      final verifying = h
          .read(serverBindingProvider)
          .verify('http://kotu.example.test');
      await verifying;
      final before = h.backend.count('POST', '/v1/auth/refresh');
      await expectLater(
        h.read(sessionControllerProvider).refresh(),
        throwsA(isA<ApiError>()),
      );
      expect(h.backend.count('POST', '/v1/auth/refresh'), before);
      expect(ClientErrorCode.all, contains(ClientErrorCode.reauthRequired));
    },
  );

  group('get_it bileşim kökü (ADR-0001)', () {
    test(
      'her bileşim yalıtık örnek; global GetIt.instance kullanılmaz',
      () async {
        final a = Composition.create(
          flavor: Flavor.prod,
          secureStore: MemorySecureStore(),
        );
        final b = Composition.create(
          flavor: Flavor.prod,
          secureStore: MemorySecureStore(),
        );
        expect(identical(a.locator, b.locator), isFalse);
        expect(
          identical(
            a.container.read(sessionControllerProvider),
            b.container.read(sessionControllerProvider),
          ),
          isFalse,
        );
        expect(
          identical(
            a.container.read(sessionControllerProvider),
            a.locator<SessionController>(),
          ),
          isTrue,
        );
        expect(GetIt.instance.isRegistered<SessionController>(), isFalse);
        await a.dispose();
        expect(
          a.locator.isRegistered<SessionController>(),
          isFalse,
          reason: 'dispose → reset',
        );
        await b.dispose();
      },
    );

    test('port bileşim kökü olmadan okunursa sessiz varsayılan yok (UnimplementedError)', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      expect(() => c.read(sessionControllerProvider), throwsA(anything));
      expect(() => c.read(identityServiceProvider), throwsA(anything));
    });
  });

  group('CX-g-K-01: dispose sonrası eski grafik çalışmaz', () {
    Future<
      (Composition, ServerBindingController, SessionController, ScopeController)
    >
    loggedIn(FakeHandler h) async {
      final comp = Composition.create(
        flavor: Flavor.prod,
        secureStore: MemorySecureStore(),
        httpAdapter: FakeBackend(h),
      );
      final binding = comp.locator<ServerBindingController>();
      final session = comp.locator<SessionController>();
      final scope = comp.locator<ScopeController>();
      await binding.verify(testUrl);
      await comp.container
          .read(identityServiceProvider)
          .login(email: 'a@b.test', password: 'p');
      scope.selectProgram('p-1');
      return (comp, binding, session, scope);
    }

    test('eski bağ dispose SONRASI yeniden bağlanırsa eski oturum/kapsam temizlenmez', () async {
      final (comp, binding, session, scope) = await loggedIn(handler);
      await comp.dispose();
      instance = 'inst-2';
      await binding.verify(testUrl);
      expect(
        session.state.value,
        isA<SessionActive>(),
        reason: 'sökülmüş dinleyici çalışmadı',
      );
      expect(scope.current.programId, 'p-1');
    });

    test('bekleyen doğrulama sırasında dispose: doğrulama bitince eski grafik çalışmaz', () async {
      final gate = Completer<void>();
      var gated = false;
      Future<ResponseBody> h(Seen r) async {
        if (gated && r.path == '/.well-known/nizamio-instance') {
          await gate.future;
        }
        return handler(r);
      }

      final (comp, binding, session, scope) = await loggedIn(h);
      gated = true;
      instance = 'inst-2';
      final pending = binding.verify(testUrl);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await comp.dispose();
      gate.complete();
      await pending;
      expect(session.state.value, isA<SessionActive>());
      expect(scope.current.programId, 'p-1');
    });

    test('iki kez dispose güvenli', () async {
      final (comp, _, _, _) = await loggedIn(handler);
      await comp.dispose();
      await comp.dispose();
    });

    test('dispose öncesi kablo hâlâ çalışır (regresyon)', () async {
      final (comp, binding, session, scope) = await loggedIn(handler);
      addTearDown(comp.dispose);
      instance = 'inst-2';
      await binding.verify(testUrl);
      expect(session.state.value, isA<SessionNone>());
      expect(scope.current.hasProgram, isFalse);
    });
  });
}
