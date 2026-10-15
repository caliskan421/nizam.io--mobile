// CX-Ö-03: taze container açılışı — eski kurulumun belirteçleri yeni kuruluma taşınmaz.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/bootstrap.dart';
import 'package:nizamio/app/di/composition.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/scope/scope_store.dart';
import 'package:nizamio/core/server/server_binding.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/core/session/token_pair.dart';
import 'package:nizamio/core/session/token_store.dart';
import 'package:nizamio/core/storage/secure_store.dart';

import '../support/fake_backend.dart';

ResponseBodyHandler instance(String id) =>
    (r) => r.path == '/.well-known/nizamio-instance'
    ? jsonResponse(200, {
        'product_id': 'nizamio',
        'instance_id': id,
        'company_display_name': 'x',
        'server_version': 'x',
        'api_version': 'v1',
        'minimum_mobile_version': '0.0.0',
        'capabilities': null,
      })
    : discoveryHandler(r);

typedef ResponseBodyHandler = FakeHandler;

Future<MemorySecureStore> seeded(String instanceId) async {
  final store = MemorySecureStore();
  await store.write(
    ServerBindingController.storeKey,
    '{"origin":"https://nizam.example.test","instance_id":"$instanceId"}',
  );
  await TokenStore(store).save(
    TokenPair(
      accountId: 'acc-1',
      accessToken: 'access-token-old',
      accessExpiresAt: 4102444800,
      refreshToken: 'refresh-token-old',
      refreshExpiresAt: 4102444800,
      forcePasswordChange: false,
      instanceId: instanceId,
    ),
  );
  return store;
}

Composition compose(MemorySecureStore store, FakeBackend backend) =>
    Composition.create(
      flavor: Flavor.prod,
      secureStore: store,
      httpAdapter: backend,
    );

void main() {
  test('taze açılış + değişmiş instance_id → oturum geri yüklenmez, belirteçler silinir', () async {
    final store = await seeded('inst-1');
    final comp = compose(store, FakeBackend(instance('inst-2')));
    addTearDown(comp.dispose);
    final c = comp.container;
    await startup(c);
    expect(c.read(bindingStateProvider), isA<BindingVerified>());
    expect(c.read(sessionStateProvider), isA<SessionNone>());
    expect(store.values.containsKey(TokenStore.key), isFalse);
  });

  test('taze açılış + aynı kurulum → oturum geri yüklenir', () async {
    final store = await seeded('inst-1');
    final comp = compose(store, FakeBackend(instance('inst-1')));
    addTearDown(comp.dispose);
    final c = comp.container;
    await startup(c);
    expect(c.read(sessionStateProvider), isA<SessionActive>());
  });

  group('son seçili kapsam (ADR-0003 karar 20)', () {
    Future<MemorySecureStore> withScope(
      String instanceId, {
      String account = 'acc-1',
      String scopeInstance = 'inst-1',
    }) async {
      final store = await seeded(instanceId);
      await ScopeStore(store).save(
        ScopeOwner(accountId: account, instanceId: scopeInstance),
        const ScopeSelection(programId: 'p-1', departmentId: 'd-1'),
      );
      return store;
    }

    test('eşleşen kayıt: açılış doğrudan scoped fazına gider', () async {
      final store = await withScope('inst-1');
      final comp = compose(store, FakeBackend(instance('inst-1')));
      addTearDown(comp.dispose);
      final c = comp.container;
      await startup(c);
      expect(c.read(sessionStateProvider), isA<SessionActive>());
      expect(c.read(scopeStateProvider).programId, 'p-1');
      expect(c.read(scopeStateProvider).departmentId, 'd-1');
      expect(c.read(appPhaseProvider), AppPhase.scoped);
      expect(store.values.containsKey(ScopeStore.key), isTrue);
    });

    test('kayıt yok: açılış sessionOpen (kapsam seçimi)', () async {
      final store = await seeded('inst-1');
      final comp = compose(store, FakeBackend(instance('inst-1')));
      addTearDown(comp.dispose);
      final c = comp.container;
      await startup(c);
      expect(c.read(appPhaseProvider), AppPhase.sessionOpen);
      expect(c.read(scopeStateProvider).hasProgram, isFalse);
    });

    test('farklı hesaba ait kayıt: sessionOpen, kayıt silinir', () async {
      final store = await withScope('inst-1', account: 'acc-2');
      final comp = compose(store, FakeBackend(instance('inst-1')));
      addTearDown(comp.dispose);
      final c = comp.container;
      await startup(c);
      expect(c.read(appPhaseProvider), AppPhase.sessionOpen);
      expect(store.values.containsKey(ScopeStore.key), isFalse);
    });

    test('farklı kuruluma ait kayıt: sessionOpen, kayıt silinir', () async {
      final store = await withScope('inst-1', scopeInstance: 'inst-0');
      final comp = compose(store, FakeBackend(instance('inst-1')));
      addTearDown(comp.dispose);
      final c = comp.container;
      await startup(c);
      expect(c.read(appPhaseProvider), AppPhase.sessionOpen);
      expect(store.values.containsKey(ScopeStore.key), isFalse);
    });

    test('bozuk kayıt: sessionOpen, kayıt silinir', () async {
      final store = await seeded('inst-1');
      store.values[ScopeStore.key] = 'not json';
      final comp = compose(store, FakeBackend(instance('inst-1')));
      addTearDown(comp.dispose);
      final c = comp.container;
      await startup(c);
      expect(c.read(appPhaseProvider), AppPhase.sessionOpen);
      expect(store.values.containsKey(ScopeStore.key), isFalse);
    });

    test(
      'sunucu kurulumu değişmiş: oturum yok, kapsam kaydı silinir',
      () async {
        final store = await withScope('inst-1');
        final comp = compose(store, FakeBackend(instance('inst-2')));
        addTearDown(comp.dispose);
        final c = comp.container;
        await startup(c);
        expect(c.read(sessionStateProvider), isA<SessionNone>());
        expect(c.read(scopeStateProvider).hasProgram, isFalse);
        expect(store.values.containsKey(ScopeStore.key), isFalse);
      },
    );

    test('yarım kalmış yenileme işareti (yeniden giriş gerekli): kapsam kaydı silinir', () async {
      final store = await withScope('inst-1');
      await TokenStore(store).markRefreshInFlight();
      final comp = compose(store, FakeBackend(instance('inst-1')));
      addTearDown(comp.dispose);
      final c = comp.container;
      await startup(c);
      expect(c.read(sessionStateProvider), isA<SessionReauthRequired>());
      expect(c.read(scopeStateProvider).hasProgram, isFalse);
      expect(store.values.containsKey(ScopeStore.key), isFalse);
    });
  });
}
