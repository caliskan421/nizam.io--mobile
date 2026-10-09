// CX-Ö-03: taze container açılışı — eski kurulumun belirteçleri yeni kuruluma taşınmaz.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/bootstrap.dart';
import 'package:nizamio/app/di/composition.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/providers.dart';
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
}
