// Kapsamın oturum/bağ ömrüne bağlılığı (ADR-0003 karar 20, MOB-UI-0 W62). Bu davranışlar
// kalıcılık eklenmeden ÖNCE de geçerlidir ve sonra da aynen geçmelidir: oturum etkin
// olmaktan çıkınca (çıkış, yeniden giriş gerekli) ya da sunucu yeniden bağlanınca kapsam
// temizlenir; çıkıştan sonra yeni bir açılış eski seçimi taşımaz.
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/bootstrap.dart';
import 'package:nizamio/app/di/composition.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/core/storage/secure_store.dart';

import '../../support/fake_backend.dart';
import '../../support/harness.dart';

String instance = 'inst-1';
bool refreshRejected = false;

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
    case 'POST /v1/auth/refresh':
      return refreshRejected
          ? envelope(401, 'identity.invalid_refresh_token')
          : jsonResponse(200, loginBody('2'));
  }
  return discoveryHandler(r);
}

Future<Harness> loggedIn({MemorySecureStore? store}) async {
  final h = Harness(handler: handler, store: store);
  await h.read(serverBindingProvider).verify(testUrl);
  await h.identity.login(email: 'a@b.test', password: 'p');
  h.read(scopeControllerProvider).selectProgram('p-1');
  expect(h.read(scopeStateProvider).hasProgram, isTrue);
  return h;
}

void main() {
  setUp(() {
    instance = 'inst-1';
    refreshRejected = false;
  });

  test('çıkış kapsamı temizler; yeniden girişte önceki seçim gelmez', () async {
    final h = await loggedIn();
    addTearDown(h.dispose);
    await h.identity.logout();
    expect(h.read(scopeStateProvider).hasProgram, isFalse);
    await h.identity.login(email: 'a@b.test', password: 'p');
    expect(h.read(sessionStateProvider), isA<SessionActive>());
    expect(h.read(scopeStateProvider).hasProgram, isFalse);
  });

  test('yeniden giriş gerekli (yenileme reddi) kapsamı temizler', () async {
    final h = await loggedIn();
    addTearDown(h.dispose);
    refreshRejected = true;
    await expectLater(
      h.read(sessionControllerProvider).refresh(),
      throwsA(anything),
    );
    expect(h.read(sessionStateProvider), isA<SessionReauthRequired>());
    expect(h.read(scopeStateProvider).hasProgram, isFalse);
  });

  test('farklı kuruluma yeniden bağlanma kapsamı temizler', () async {
    final h = await loggedIn();
    addTearDown(h.dispose);
    instance = 'inst-2';
    await h.read(serverBindingProvider).verify(testUrl);
    expect(h.read(sessionStateProvider), isA<SessionNone>());
    expect(h.read(scopeStateProvider).hasProgram, isFalse);
  });

  test('çıkıştan sonra taze açılış: oturum yok, kapsam yok', () async {
    final h = await loggedIn();
    await h.identity.logout();
    final store = h.store;
    await h.dispose();
    final comp = Composition.create(
      flavor: Flavor.prod,
      secureStore: store,
      httpAdapter: FakeBackend(handler),
    );
    addTearDown(comp.dispose);
    await startup(comp.container);
    expect(comp.container.read(sessionStateProvider), isA<SessionNone>());
    expect(comp.container.read(scopeStateProvider).hasProgram, isFalse);
  });
}
