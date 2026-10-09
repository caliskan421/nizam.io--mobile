// Bileşim kökünün davranışını SABİTLEYEN test (D-0182 get_it taşımasından ÖNCE yazıldı; taşıma
// sonrası aynen geçmeli): taze açılış sırası, yeniden bağlanma kablosu, oturum→kapsam temizliği,
// yenileme çağrısının kuruluma bağlılığı, Bearer'ın kuruluma bağlılığı.
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:nizamio/core/storage/secure_store.dart';
import 'package:nizamio/features/identity/identity.dart';

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

void main() {
  setUp(() => instance = 'inst-1');

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
