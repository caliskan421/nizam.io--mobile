// Son seçili kapsamın kalıcılığı: bileşim kökü kablosu (ADR-0003 karar 20, W62). Seçim güvenli
// depoya hesap + kurulum adına yazılır; oturum etkin olmaktan çıkınca ya da sunucu yeniden
// bağlanınca silinir; çıkıştan sonra depoya eski seçim geri yazılamaz.
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/bootstrap.dart';
import 'package:nizamio/app/di/composition.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/scope/scope_store.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/core/session/token_store.dart';
import 'package:nizamio/features/identity/identity.dart';

import '../../core/scope/gated_secure_store.dart';
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

Future<Harness> loggedIn(GatedSecureStore store) async {
  final h = Harness(handler: handler, store: store);
  await h.read(serverBindingProvider).verify(testUrl);
  await h.identity.login(email: 'a@b.test', password: 'p');
  return h;
}

ScopeController scopeOf(Harness h) => h.read(scopeControllerProvider);

void main() {
  late GatedSecureStore store;

  setUp(() {
    instance = 'inst-1';
    refreshRejected = false;
    store = GatedSecureStore();
  });

  test('seçim hesap + kurulum adına YALNIZ güvenli depoya yazılır', () async {
    final h = await loggedIn(store);
    addTearDown(h.dispose);
    scopeOf(h).selectProgram('p-1');
    await scopeOf(h).settled;
    final saved = await ScopeStore(store).load();
    expect(saved!.owner.accountId, 'acc-1');
    expect(saved.owner.instanceId, 'inst-1');
    expect(saved.selection.programId, 'p-1');
    expect(h.prefs.values.values.join(), isNot(contains('p-1')));
  });

  test('oturum yokken (giriş öncesi) seçim kalıcılaştırılmaz', () async {
    final h = Harness(handler: handler, store: store);
    addTearDown(h.dispose);
    await h.read(serverBindingProvider).verify(testUrl);
    scopeOf(h).selectProgram('p-1');
    await scopeOf(h).settled;
    expect(store.values.containsKey(ScopeStore.key), isFalse);
  });

  test('çıkış kayıtlı seçimi siler', () async {
    final h = await loggedIn(store);
    addTearDown(h.dispose);
    scopeOf(h).selectProgram('p-1');
    await scopeOf(h).settled;
    await h.identity.logout();
    await scopeOf(h).settled;
    expect(store.values.containsKey(ScopeStore.key), isFalse);
  });

  test('yeniden giriş gerekli kayıtlı seçimi siler', () async {
    final h = await loggedIn(store);
    addTearDown(h.dispose);
    scopeOf(h).selectProgram('p-1');
    await scopeOf(h).settled;
    refreshRejected = true;
    await expectLater(
      h.read(sessionControllerProvider).refresh(),
      throwsA(anything),
    );
    expect(h.read(sessionStateProvider), isA<SessionReauthRequired>());
    await scopeOf(h).settled;
    expect(store.values.containsKey(ScopeStore.key), isFalse);
  });

  test('farklı kuruluma yeniden bağlanma kayıtlı seçimi siler', () async {
    final h = await loggedIn(store);
    addTearDown(h.dispose);
    scopeOf(h).selectProgram('p-1');
    await scopeOf(h).settled;
    instance = 'inst-2';
    await h.read(serverBindingProvider).verify(testUrl);
    await scopeOf(h).settled;
    expect(store.values.containsKey(ScopeStore.key), isFalse);
    expect(store.values.containsKey(TokenStore.key), isFalse);
  });

  test('yarış: seçim yazımı sürerken çıkış → depoda kayıt kalmaz', () async {
    final h = await loggedIn(store);
    addTearDown(h.dispose);
    store.holdWrites(ScopeStore.key);
    scopeOf(h).selectProgram('p-1');
    await Future<void>.delayed(Duration.zero);
    await h.identity.logout();
    store.release();
    await scopeOf(h).settled;
    expect(store.values.containsKey(ScopeStore.key), isFalse);
    expect(h.read(scopeStateProvider).hasProgram, isFalse);
  });

  test('seçim → kapat → aç: aynı hesap + kurulumda geri yüklenir; çıkıştan sonra yüklenmez', () async {
    final h = await loggedIn(store);
    scopeOf(h).selectProgram('p-1');
    await scopeOf(h).settled;
    await h.dispose();

    Composition open() => Composition.create(
      flavor: Flavor.prod,
      secureStore: store,
      httpAdapter: FakeBackend(handler),
    );
    final c1 = open();
    await startup(c1.container);
    expect(c1.container.read(scopeStateProvider).programId, 'p-1');
    await c1.container.read(identityServiceProvider).logout();
    await c1.container.read(scopeControllerProvider).settled;
    await c1.dispose();

    final c2 = open();
    addTearDown(c2.dispose);
    await startup(c2.container);
    expect(c2.container.read(sessionStateProvider), isA<SessionNone>());
    expect(c2.container.read(scopeStateProvider).hasProgram, isFalse);
    expect(store.values.containsKey(ScopeStore.key), isFalse);
  });

  test('depo yazma hatası: seçim bellekte çalışır', () async {
    final h = await loggedIn(store);
    addTearDown(h.dispose);
    store.failWritesFor.add(ScopeStore.key);
    scopeOf(h).selectProgram('p-1');
    await scopeOf(h).settled;
    expect(h.read(scopeStateProvider).programId, 'p-1');
    expect(h.read(sessionStateProvider), isA<SessionActive>());
  });
}
