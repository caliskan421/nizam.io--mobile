// CX-r1-Ö-01: bekleyen (geciken) giriş/yenileme/me yanıtı çıkış ya da yeniden bağlanmadan
// SONRA gelirse oturumu diriltemez, depoya yazılamaz, eski/yeni Bearer yanlış kuruluma gitmez.
// Yanıtlar Completer ile kontrol edilir; gerçek provider bağları + sahte bağdaştırıcı.
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/api/generated/clients/identity_client.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/server/server_binding.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/core/session/token_store.dart';

import '../../support/fake_backend.dart';
import '../../support/harness.dart';

class Gated {
  Gated() {
    h = Harness(handler: handle);
  }

  late final Harness h;
  String instance = 'inst-1';
  var loginN = 0;
  Completer<void>? loginGate;
  Completer<void>? refreshGate;
  bool meUnauthorized = false;
  bool meForce = false;

  Future<ResponseBody> handle(Seen r) async {
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
        final n = '${++loginN}';
        final gate = loginGate;
        if (gate != null) await gate.future;
        return jsonResponse(200, loginBody(n));
      case 'POST /v1/auth/refresh':
        final gate = refreshGate;
        if (gate != null) await gate.future;
        return jsonResponse(200, loginBody('r'));
      case 'POST /v1/auth/logout':
        return ResponseBody.fromString('', 204);
      case 'GET /v1/me':
        if (meForce) {
          return envelope(403, 'identity.force_password_change_required');
        }
        if (meUnauthorized &&
            r.header('Authorization') != 'Bearer access-token-r') {
          return envelope(401, 'platform.unauthenticated');
        }
        return jsonResponse(200, {'account_id': 'acc-1', 'email': 'a@b.test'});
    }
    return discoveryHandler(r);
  }

  int get sent => h.backend.requests.length;
  Iterable<Seen> since(int i) => h.backend.requests.skip(i);

  Future<void> bindAndLogin() async {
    expect(
      await h.read(serverBindingProvider).verify(testUrl),
      isA<BindingVerified>(),
    );
    await h.identity.login(email: 'a@b.test', password: 'p');
  }

  void expectClosedAndEmpty() {
    expect(h.read(sessionStateProvider), isNot(isA<SessionActive>()));
    expect(h.read(sessionControllerProvider).accessToken, isNull);
    expect(
      h.store.values.containsKey(TokenStore.key),
      isFalse,
      reason: 'depoya yazılmadı',
    );
  }
}

Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 20));

void main() {
  late Gated g;
  setUp(() => g = Gated());
  tearDown(() => g.h.dispose());

  test('bekleyen yenileme → clear → yanıt: oturum dirilmez, depo boş, tekrar istek yok', () async {
    await g.bindAndLogin();
    g
      ..meUnauthorized = true
      ..refreshGate = Completer();
    final me = g.h.identity.me();
    await settle();
    expect(g.h.backend.count('POST', '/v1/auth/refresh'), 1);
    await g.h.read(sessionControllerProvider).clear();
    final mark = g.sent;
    g.refreshGate!.complete();
    await expectLater(me, throwsA(isA<ApiError>()));
    g.expectClosedAndEmpty();
    expect(
      g.since(mark).where((r) => r.header('Authorization') != null),
      isEmpty,
      reason: 'temizlikten sonra hiçbir Bearer gönderilmedi',
    );
  });

  test('bekleyen yenileme → farklı kuruluma yeniden bağlanma → yanıt: oturum dirilmez', () async {
    await g.bindAndLogin();
    g
      ..meUnauthorized = true
      ..refreshGate = Completer();
    final me = g.h.identity.me();
    await settle();
    g.instance = 'inst-2';
    expect(
      await g.h.read(serverBindingProvider).verify(testUrl),
      isA<BindingVerified>(),
    );
    final mark = g.sent;
    g.refreshGate!.complete();
    await expectLater(me, throwsA(isA<ApiError>()));
    g.expectClosedAndEmpty();
    expect(
      g.since(mark).where((r) => r.header('Authorization') != null),
      isEmpty,
      reason: 'yeni kuruluma eski oturumun Bearer\'ı gitmedi',
    );
  });

  test('bekleyen giriş → clear → yanıt: oturum açılmaz, depo boş', () async {
    expect(
      await g.h.read(serverBindingProvider).verify(testUrl),
      isA<BindingVerified>(),
    );
    g.loginGate = Completer();
    final login = g.h.identity.login(email: 'a@b.test', password: 'p');
    await settle();
    await g.h.identity.logout();
    g.loginGate!.complete();
    await expectLater(login, throwsA(isA<ApiError>()));
    g.expectClosedAndEmpty();
  });

  test(
    'bekleyen giriş → farklı kuruluma yeniden bağlanma → yanıt: oturum açılmaz',
    () async {
      expect(
        await g.h.read(serverBindingProvider).verify(testUrl),
        isA<BindingVerified>(),
      );
      g.loginGate = Completer();
      final login = g.h.identity.login(email: 'a@b.test', password: 'p');
      await settle();
      g.instance = 'inst-2';
      expect(
        await g.h.read(serverBindingProvider).verify(testUrl),
        isA<BindingVerified>(),
      );
      g.loginGate!.complete();
      await expectLater(login, throwsA(isA<ApiError>()));
      g.expectClosedAndEmpty();
    },
  );

  test(
    'bekleyen giriş → aynı sunucu yeniden doğrulanırken yanıt: oturum açılmaz',
    () async {
      expect(
        await g.h.read(serverBindingProvider).verify(testUrl),
        isA<BindingVerified>(),
      );
      g.loginGate = Completer();
      final login = g.h.identity.login(email: 'a@b.test', password: 'p');
      await settle();
      // Bağ geçişte (doğrulanıyor): yakalanan bağ artık güncel değil.
      final verifying = g.h.read(serverBindingProvider).verify(testUrl);
      g.loginGate!.complete();
      await expectLater(login, throwsA(isA<ApiError>()));
      await verifying;
      g.expectClosedAndEmpty();
    },
  );

  test('bekleyen me (zorunlu parola 403) → çıkış → yeni giriş: yeni oturum bayraklanmaz', () async {
    await g.bindAndLogin();
    g.loginGate = null;
    final gate = Completer<void>();
    g.meForce = true;
    final original = g.handle;
    g.h.backend.handler = (r) async {
      if (r.path == '/v1/me') await gate.future;
      return original(r);
    };
    final me = g.h.identity.me();
    await settle();
    await g.h.identity.logout();
    await g.h.identity.login(email: 'a@b.test', password: 'p');
    gate.complete();
    await expectLater(me, throwsA(isA<ApiError>()));
    final s = g.h.read(sessionStateProvider) as SessionActive;
    expect(
      s.forcePasswordChange,
      isFalse,
      reason: 'eski oturumun yanıtı yeni oturumu etkilemez',
    );
  });

  test('çıkış kapsam seçimini temizler', () async {
    await g.bindAndLogin();
    g.h.read(scopeControllerProvider).selectProgram('p-1');
    await g.h.identity.logout();
    expect(g.h.read(scopeStateProvider).hasProgram, isFalse);
  });

  test('eski bağın dio\'su yeni kurulumun belirtecini taşımaz', () async {
    await g.bindAndLogin();
    final oldDio = g.h.read(apiDioProvider)!;
    g.instance = 'inst-2';
    await g.h.read(serverBindingProvider).verify(testUrl);
    await g.h.identity.login(email: 'a@b.test', password: 'p');
    final mark = g.sent;
    await expectLater(
      apiCall(IdentityClient(oldDio).me),
      throwsA(isA<ApiError>()),
    );
    expect(
      g.since(mark).where((r) => r.header('Authorization') != null),
      isEmpty,
    );
  });

  test('normal akış bozulmadı: bekleyen yenileme tamamlanınca istek bir kez tekrarlanır', () async {
    await g.bindAndLogin();
    g
      ..meUnauthorized = true
      ..refreshGate = Completer();
    final me = g.h.identity.me();
    await settle();
    g.refreshGate!.complete();
    expect((await me).accountId, 'acc-1');
    expect(g.h.read(sessionStateProvider), isA<SessionActive>());
    expect(g.h.store.values[TokenStore.key], contains('refresh-token-r'));
  });

  test('eşzamanlı iki bağ doğrulaması: geç biten ESKİ doğrulama yenisinin üzerine yazmaz', () async {
    final gate = Completer<void>();
    g.h.backend.handler = (r) async {
      if (r.path == '/.well-known/nizamio-instance') {
        if (r.host == 'a.example.test') await gate.future;
        return jsonResponse(200, {
          'product_id': 'nizamio',
          'instance_id': r.host == 'a.example.test' ? 'inst-a' : 'inst-b',
          'company_display_name': 'x',
          'server_version': 'x',
          'api_version': 'v1',
          'minimum_mobile_version': '0.0.0',
          'capabilities': null,
        });
      }
      return discoveryHandler(r);
    };
    final binding = g.h.read(serverBindingProvider);
    final a = binding.verify('https://a.example.test');
    await settle();
    final b = await binding.verify('https://b.example.test');
    expect(b, isA<BindingVerified>());
    gate.complete();
    await a;
    final now = binding.current as BindingVerified;
    expect(now.info.instanceId, 'inst-b');
    expect(
      g.h.store.values[ServerBindingController.storeKey],
      contains('inst-b'),
    );
  });
}
