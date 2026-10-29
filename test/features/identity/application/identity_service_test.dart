// IdentityService doğrudan testi: bağ kapısı (fail-closed), giriş/çıkış, nesil koruması,
// zorunlu parola değişikliği bayrağı. Gerçek bileşim kökü, sahte bağdaştırıcı.
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/core/session/token_store.dart';
import 'package:nizamio/features/identity/domain/current_account.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';

Matcher apiCode(String code) =>
    isA<ApiError>().having((e) => e.code, 'code', code);

Future<ResponseBody> _ok(Seen r) async {
  switch ('${r.method} ${r.path}') {
    case 'POST /v1/auth/login':
      return jsonResponse(200, loginBody('1'));
    case 'POST /v1/auth/logout':
      return ResponseBody.fromString('', 204);
    case 'GET /v1/me':
      return jsonResponse(200, {
        'account_id': 'acc-1',
        'email': 'a@b.test',
        'full_name': 'Ayşe Yılmaz',
        'company_admin': true,
      });
  }
  return discoveryHandler(r);
}

Future<Harness> _verified([FakeHandler handler = _ok]) async {
  final h = Harness(handler: handler);
  addTearDown(h.dispose);
  await h.read(serverBindingProvider).verify(testUrl);
  return h;
}

void main() {
  group('login', () {
    test('bağ yok → serverNotVerified, ağa istek çıkmaz', () async {
      final h = Harness(handler: _ok);
      addTearDown(h.dispose);
      await expectLater(
        h.identity.login(email: 'a@b.test', password: 'gizli'),
        throwsA(apiCode(ClientErrorCode.serverNotVerified)),
      );
      expect(h.backend.requests, isEmpty);
    });

    test('güncelleme gerekli → updateRequired, giriş isteği çıkmaz', () async {
      final h = Harness(handler: (r) => discoveryHandler(r, minimum: '99.0.0'));
      addTearDown(h.dispose);
      await h.read(serverBindingProvider).verify(testUrl);
      final before = h.backend.requests.length;
      await expectLater(
        h.identity.login(email: 'a@b.test', password: 'gizli'),
        throwsA(apiCode(ClientErrorCode.updateRequired)),
      );
      expect(h.backend.requests.length, before);
    });

    test(
      'başarılı giriş: oturum etkinleşir, belirteç güvenli depoya yazılır',
      () async {
        final h = await _verified();
        await h.identity.login(email: 'a@b.test', password: 'p');
        expect(h.read(sessionStateProvider), isA<SessionActive>());
        expect(h.store.values.containsKey(TokenStore.key), isTrue);
        expect(h.backend.count('POST', '/v1/auth/login'), 1);
      },
    );

    test(
      'belirteçsiz (web sınıfı) yanıt → invalidResponse, oturum açılmaz',
      () async {
        final h = await _verified((r) {
          if (r.path == '/v1/auth/login') {
            return jsonResponse(200, {
              'account_id': 'acc-1',
              'expires_at': 4102444800,
              'force_password_change': false,
            });
          }
          return _ok(r);
        });
        await expectLater(
          h.identity.login(email: 'a@b.test', password: 'p'),
          throwsA(apiCode(ClientErrorCode.invalidResponse)),
        );
        expect(h.read(sessionStateProvider), isA<SessionNone>());
        expect(h.store.values.containsKey(TokenStore.key), isFalse);
      },
    );

    test('sunucu hatası ApiError olarak yükselir, oturum açılmaz', () async {
      final h = await _verified((r) {
        if (r.path == '/v1/auth/login') {
          return envelope(401, 'identity.credentials_invalid');
        }
        return _ok(r);
      });
      await expectLater(
        h.identity.login(email: 'a@b.test', password: 'p'),
        throwsA(apiCode('identity.credentials_invalid')),
      );
      expect(h.read(sessionStateProvider), isA<SessionNone>());
    });

    test(
      'yanıt beklenirken çıkış olursa sonuç atılır (sessionEnded)',
      () async {
        final gate = Completer<void>();
        final h = await _verified((r) async {
          if (r.path == '/v1/auth/login') {
            await gate.future;
          }
          return _ok(r);
        });
        final pending = h.identity.login(email: 'a@b.test', password: 'p');
        final expectation = expectLater(
          pending,
          throwsA(apiCode(ClientErrorCode.sessionEnded)),
        );
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await h.read(sessionControllerProvider).clear();
        gate.complete();
        await expectation;
        expect(h.read(sessionStateProvider), isA<SessionNone>());
        expect(h.store.values.containsKey(TokenStore.key), isFalse);
      },
    );

    test('yanıt beklenirken bağ başka kuruluma geçerse sonuç atılır', () async {
      final gate = Completer<void>();
      var instance = 'inst-1';
      final h = await _verified((r) async {
        if (r.path == '/v1/auth/login') {
          await gate.future;
        }
        if (r.path == '/.well-known/nizamio-instance') {
          return jsonResponse(200, {
            'product_id': 'nizamio',
            'instance_id': instance,
            'company_display_name': 'x',
            'server_version': 'x',
            'api_version': 'v1',
            'minimum_mobile_version': '0.0.0',
            'capabilities': null,
          });
        }
        return _ok(r);
      });
      final pending = h.identity.login(email: 'a@b.test', password: 'p');
      final expectation = expectLater(pending, throwsA(isA<ApiError>()));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      instance = 'inst-2';
      await h.read(serverBindingProvider).verify(testUrl);
      gate.complete();
      await expectation;
      expect(h.read(sessionStateProvider), isA<SessionNone>());
      expect(h.store.values.containsKey(TokenStore.key), isFalse);
    });
  });

  group('me', () {
    test('bağ yok → serverNotVerified', () async {
      final h = Harness(handler: _ok);
      addTearDown(h.dispose);
      await expectLater(
        h.identity.me(),
        throwsA(apiCode(ClientErrorCode.serverNotVerified)),
      );
      expect(h.backend.requests, isEmpty);
    });

    test('oturumdaki hesabı döner', () async {
      final h = await _verified();
      await h.identity.login(email: 'a@b.test', password: 'p');
      expect(
        await h.identity.me(),
        const CurrentAccount(
          accountId: 'acc-1',
          email: 'a@b.test',
          fullName: 'Ayşe Yılmaz',
          companyAdmin: true,
        ),
      );
    });

    test(
      'force_password_change_required bayrağı oturum durumuna taşınır',
      () async {
        final h = await _verified((r) {
          if (r.path == '/v1/me') {
            return envelope(403, 'identity.force_password_change_required');
          }
          return _ok(r);
        });
        await h.identity.login(email: 'a@b.test', password: 'p');
        expect(
          (h.read(sessionStateProvider) as SessionActive).forcePasswordChange,
          isFalse,
        );
        await expectLater(
          h.identity.me(),
          throwsA(apiCode('identity.force_password_change_required')),
        );
        expect(
          (h.read(sessionStateProvider) as SessionActive).forcePasswordChange,
          isTrue,
        );
      },
    );

    test('başka hata bayrağı değiştirmez, yeniden fırlatılır', () async {
      final h = await _verified((r) {
        if (r.path == '/v1/me') return envelope(404, 'platform.not_found');
        return _ok(r);
      });
      await h.identity.login(email: 'a@b.test', password: 'p');
      await expectLater(h.identity.me(), throwsA(isA<ApiError>()));
      expect(
        (h.read(sessionStateProvider) as SessionActive).forcePasswordChange,
        isFalse,
      );
    });
  });

  group('logout', () {
    test('sunucu çıkışı çağrılır, yerel oturum silinir', () async {
      final h = await _verified();
      await h.identity.login(email: 'a@b.test', password: 'p');
      await h.identity.logout();
      expect(h.backend.count('POST', '/v1/auth/logout'), 1);
      expect(h.read(sessionStateProvider), isA<SessionNone>());
      expect(h.store.values.containsKey(TokenStore.key), isFalse);
    });

    test('sunucu çıkışı başarısız olsa da yerel belirteçler silinir', () async {
      final h = await _verified((r) {
        if (r.path == '/v1/auth/logout') {
          return envelope(500, 'platform.internal');
        }
        return _ok(r);
      });
      await h.identity.login(email: 'a@b.test', password: 'p');
      await h.identity.logout();
      expect(h.read(sessionStateProvider), isA<SessionNone>());
      expect(h.store.values.containsKey(TokenStore.key), isFalse);
    });

    test(
      'oturum yoksa sunucuya çıkış isteği gitmez, yine de temizlenir',
      () async {
        final h = await _verified();
        await h.identity.logout();
        expect(h.backend.count('POST', '/v1/auth/logout'), 0);
        expect(h.read(sessionStateProvider), isA<SessionNone>());
      },
    );

    test('bağ yokken (depo yok) çıkış hata atmaz', () async {
      final h = Harness(handler: _ok);
      addTearDown(h.dispose);
      await h.identity.logout();
      expect(h.backend.requests, isEmpty);
    });
  });

  group('changePassword', () {
    Future<ResponseBody> forced(Seen r) async {
      switch ('${r.method} ${r.path}') {
        case 'POST /v1/auth/login':
          return jsonResponse(200, loginBody('1', force: true));
        case 'POST /v1/auth/password':
          return jsonResponse(200, {'revoked_sessions': 2});
      }
      return _ok(r);
    }

    test('oturum yok → notSignedIn, ağa istek çıkmaz', () async {
      final h = await _verified(forced);
      final before = h.backend.requests.length;
      await expectLater(
        h.identity.changePassword(currentPassword: 'a', newPassword: 'b'),
        throwsA(apiCode(ClientErrorCode.notSignedIn)),
      );
      expect(h.backend.requests.length, before);
    });

    test('yeniden giriş gerekli → reauthRequired, istek çıkmaz', () async {
      final h = await _verified(forced);
      await h.identity.login(email: 'a@b.test', password: 'p');
      // Yarım kalmış yenileme işareti: açılışta çift geri yüklenmez → yeniden giriş gerekli.
      await h.store.write(TokenStore.inflightKey, '1');
      await h.read(sessionControllerProvider).restore(instanceId: 'inst-1');
      expect(h.read(sessionStateProvider), isA<SessionReauthRequired>());
      final before = h.backend.requests.length;
      await expectLater(
        h.identity.changePassword(currentPassword: 'a', newPassword: 'b'),
        throwsA(apiCode(ClientErrorCode.reauthRequired)),
      );
      expect(h.backend.requests.length, before);
    });

    test('başarı: bayrak düşer (passwordChangeRequired → sessionOpen), belirteçler AYNEN kalır', () async {
      final h = await _verified(forced);
      await h.identity.login(email: 'a@b.test', password: 'p');
      expect(h.read(appPhaseProvider), AppPhase.passwordChangeRequired);
      final session = h.read(sessionControllerProvider);
      final before = session.debugPair!;
      final storedBefore = h.store.values[TokenStore.key];

      final revoked = await h.identity.changePassword(
        currentPassword: 'eski',
        newPassword: 'yeni',
      );

      expect(revoked, 2);
      expect(h.read(appPhaseProvider), AppPhase.sessionOpen);
      final after = session.debugPair!;
      expect(after.accessToken, before.accessToken);
      expect(after.refreshToken, before.refreshToken);
      expect(after.forcePasswordChange, isFalse);
      // Depodaki çift de aynı belirteçleri taşır (yalnız bayrak değişti).
      final stored = await TokenStore(h.store).load();
      expect(stored!.accessToken, before.accessToken);
      expect(stored.refreshToken, before.refreshToken);
      expect(storedBefore, isNotNull);
      expect(h.backend.count('POST', '/v1/auth/refresh'), 0);
      final req = h.backend.requests.last;
      expect(req.path, '/v1/auth/password');
      expect(req.header('Authorization'), 'Bearer ${before.accessToken}');
      expect(req.body, {'current_password': 'eski', 'new_password': 'yeni'});
    });

    test('sunucu hatası: ApiError, bayrak ve belirteçler değişmez', () async {
      final h = await _verified((r) {
        if (r.path == '/v1/auth/password') {
          return envelope(422, 'identity.input_invalid');
        }
        return forced(r);
      });
      await h.identity.login(email: 'a@b.test', password: 'p');
      final before = h.read(sessionControllerProvider).debugPair!;
      await expectLater(
        h.identity.changePassword(currentPassword: 'a', newPassword: 'b'),
        throwsA(apiCode('identity.input_invalid')),
      );
      expect(h.read(appPhaseProvider), AppPhase.passwordChangeRequired);
      expect(
        h.read(sessionControllerProvider).debugPair!.accessToken,
        before.accessToken,
      );
    });

    test('yanıt beklenirken çıkış olursa sonuç oturuma uygulanmaz', () async {
      final gate = Completer<void>();
      final h = await _verified((r) async {
        if (r.path == '/v1/auth/password') await gate.future;
        return forced(r);
      });
      await h.identity.login(email: 'a@b.test', password: 'p');
      final pending = h.identity.changePassword(
        currentPassword: 'a',
        newPassword: 'b',
      );
      final expectation = expectLater(
        pending,
        throwsA(apiCode(ClientErrorCode.sessionEnded)),
      );
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await h.read(sessionControllerProvider).clear();
      gate.complete();
      await expectation;
      expect(h.read(sessionStateProvider), isA<SessionNone>());
      expect(h.store.values.containsKey(TokenStore.key), isFalse);
    });

    test(
      'bağ yok → serverNotVerified (oturum açıksa bile istek yok)',
      () async {
        final h = await _verified(forced);
        await h.identity.login(email: 'a@b.test', password: 'p');
        // Bağ yeniden doğrulanıyor: doğrulanmış sayılmaz.
        final gate = Completer<void>();
        h.backend.handler = (r) async {
          await gate.future;
          return forced(r);
        };
        final verifying = h.read(serverBindingProvider).verify(testUrl);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        final before = h.backend.requests.length;
        await expectLater(
          h.identity.changePassword(currentPassword: 'a', newPassword: 'b'),
          throwsA(apiCode(ClientErrorCode.serverNotVerified)),
        );
        expect(h.backend.requests.length, before);
        gate.complete();
        await verifying;
      },
    );
  });
}
