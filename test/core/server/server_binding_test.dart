// Sunucu bağı durum makinesi (F14 kapsam 4) + giriş akışının bağ olmadan başlamadığı.
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/server/semver.dart';
import 'package:nizamio/core/server/server_address.dart';
import 'package:nizamio/core/server/server_binding.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/core/session/token_store.dart';

import '../../support/fake_backend.dart';
import '../../support/harness.dart';

Matcher failedWith(String code) =>
    isA<BindingFailed>().having((s) => s.error.code, 'code', code);

Future<void> expectLoginBlocked(Harness h, String code) async {
  await expectLater(
    h.identity.login(email: 'a@b.test', password: 'Gizli-Parola-1'),
    throwsA(isA<ApiError>().having((e) => e.code, 'code', code)),
  );
  expect(
    h.backend.requests.where((r) => r.path == '/v1/auth/login'),
    isEmpty,
    reason: 'giriş isteği oluşmadı — parola gönderilmedi',
  );
  for (final r in h.backend.requests) {
    expect(r.body.toString(), isNot(contains('Gizli-Parola-1')));
  }
}

void main() {
  group('ServerAddress', () {
    test('prod: yalnız https (localhost dahil http reddedilir)', () {
      for (final url in [
        'http://nizam.example.test',
        'http://localhost:8080',
        'http://10.0.2.2',
      ]) {
        expect(
          () => ServerAddress.parse(url, Flavor.prod),
          throwsA(
            isA<ApiError>().having(
              (e) => e.code,
              'code',
              ClientErrorCode.insecureServer,
            ),
          ),
          reason: url,
        );
      }
      expect(
        ServerAddress.parse(
          ' https://Nizam.Example.test/ ',
          Flavor.prod,
        ).toString(),
        'https://nizam.example.test',
      );
    });
    test('dev: http yalnız yerel adreslere', () {
      expect(
        ServerAddress.parse('http://localhost:18140', Flavor.dev).isHttps,
        isFalse,
      );
      expect(
        ServerAddress.parse('http://10.0.2.2:8080', Flavor.dev).origin.port,
        8080,
      );
      expect(
        () => ServerAddress.parse('http://nizam.example.test', Flavor.dev),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            ClientErrorCode.insecureServer,
          ),
        ),
      );
    });
    test('geçersiz biçimler', () {
      for (final url in [
        'nizam.example.test',
        'ftp://nizam.example.test',
        'https://user:pw@nizam.example.test',
        'https://nizam.example.test/api',
        'https://nizam.example.test?x=1',
        'https://nizam.example.test#x',
        '',
      ]) {
        expect(
          () => ServerAddress.parse(url, Flavor.prod),
          throwsA(
            isA<ApiError>().having(
              (e) => e.code,
              'code',
              ClientErrorCode.invalidServerAddress,
            ),
          ),
          reason: url,
        );
      }
    });
  });

  test('SemVer', () {
    expect(SemVer.tryParse('0.1.0')! < SemVer.tryParse('0.10.0')!, isTrue);
    expect(SemVer.tryParse('1.0.0')! < SemVer.tryParse('0.9.9')!, isFalse);
    expect(SemVer.tryParse('1.0'), isNull);
    expect(SemVer.tryParse('1.0.0-beta'), isNull);
  });

  group('doğrulama', () {
    late Harness h;
    tearDown(() => h.dispose());

    test('doğrulandı → bağ güvenli depoda, giriş açılabilir', () async {
      h = Harness();
      final s = await h.read(serverBindingProvider).verify(testUrl);
      expect(s, isA<BindingVerified>());
      expect((s as BindingVerified).info.instanceId, 'inst-1');
      expect(
        h.store.values[ServerBindingController.storeKey],
        contains('inst-1'),
      );
      expect(h.read(appPhaseProvider).name, 'serverVerified');
    });

    test('prod + http adres: hiçbir istek yok, giriş başlamaz', () async {
      h = Harness();
      final s = await h
          .read(serverBindingProvider)
          .verify('http://nizam.example.test');
      expect(s, failedWith(ClientErrorCode.insecureServer));
      expect(h.backend.requests, isEmpty);
      await expectLoginBlocked(h, ClientErrorCode.serverNotVerified);
      expect(h.backend.requests, isEmpty);
    });

    test(
      'NIZAM.IO olmayan sunucu (404 HTML) → reddedilir, giriş başlamaz',
      () async {
        h = Harness(
          handler: (r) => ResponseBody.fromString('<html>yok</html>', 404),
        );
        final s = await h.read(serverBindingProvider).verify(testUrl);
        expect(s, failedWith(ClientErrorCode.serverUnrecognized));
        await expectLoginBlocked(h, ClientErrorCode.serverNotVerified);
      },
    );

    test('product_id farklı → reddedilir', () async {
      h = Harness(
        handler: (r) => jsonResponse(200, {
          'product_id': 'baska',
          'instance_id': 'x',
          'company_display_name': 'x',
          'server_version': 'x',
          'api_version': 'v1',
          'minimum_mobile_version': '0.0.0',
          'capabilities': null,
        }),
      );
      expect(
        await h.read(serverBindingProvider).verify(testUrl),
        failedWith(ClientErrorCode.serverUnrecognized),
      );
    });

    test('api_version uyumsuz → reddedilir', () async {
      h = Harness(handler: (r) => discoveryHandler(r, api: 'v2'));
      expect(
        await h.read(serverBindingProvider).verify(testUrl),
        failedWith(ClientErrorCode.unsupportedApiVersion),
      );
    });

    test('minimum_mobile_version > uygulama → güncelleme gerekli DURUMU; giriş başlamaz', () async {
      h = Harness(handler: (r) => discoveryHandler(r, minimum: '99.0.0'));
      final s = await h.read(serverBindingProvider).verify(testUrl);
      expect(s, isA<BindingUpdateRequired>());
      expect((s as BindingUpdateRequired).minimumVersion, '99.0.0');
      expect(h.read(appPhaseProvider).name, 'updateRequired');
      await expectLoginBlocked(h, ClientErrorCode.updateRequired);
    });

    test('minimum_mobile_version = uygulama sürümü → kabul', () async {
      h = Harness(handler: (r) => discoveryHandler(r, minimum: '0.1.0'));
      expect(
        await h.read(serverBindingProvider).verify(testUrl),
        isA<BindingVerified>(),
      );
    });

    test('TLS hatası yutulmaz: client.tls_error, giriş başlamaz', () async {
      h = Harness(
        handler: (r) =>
            throw const HandshakeException('CERTIFICATE_VERIFY_FAILED'),
      );
      final s = await h.read(serverBindingProvider).verify(testUrl);
      expect(s, failedWith(ClientErrorCode.tlsError));
      await expectLoginBlocked(h, ClientErrorCode.serverNotVerified);
    });

    test('farklı kuruluma yeniden bağlanma yerel oturumu temizler', () async {
      var instance = 'inst-1';
      h = Harness(
        handler: (r) {
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
          if (r.path == '/v1/auth/login') {
            return jsonResponse(200, loginBody('1'));
          }
          return discoveryHandler(r);
        },
      );
      await h.read(serverBindingProvider).verify(testUrl);
      await h.identity.login(email: 'a@b.test', password: 'p');
      expect(h.store.values.containsKey(TokenStore.key), isTrue);
      instance = 'inst-2';
      await h.read(serverBindingProvider).verify(testUrl);
      expect(h.store.values.containsKey(TokenStore.key), isFalse);
      expect(h.read(sessionStateProvider), isA<SessionNone>());
    });

    test('bağ kaydı güvenli depoya yazılamazsa doğrulanmış sayılmaz (ham hata sızmaz)', () async {
      h = Harness();
      h.store.failWrites = true;
      expect(
        await h.read(serverBindingProvider).verify(testUrl),
        failedWith(ClientErrorCode.secureStorageError),
      );
    });

    test(
      'keşif 200 gövdesi ayrıştırılamazsa tanınmayan sunucu (TypeError sızmaz)',
      () async {
        h = Harness(handler: (r) => jsonResponse(200, {'product_id': 7}));
        expect(
          await h.read(serverBindingProvider).verify(testUrl),
          failedWith(ClientErrorCode.serverUnrecognized),
        );
      },
    );

    test('açılış: kayıtlı bağ yeniden doğrulanır (sürüm yükseldiyse güncelleme gerekli)', () async {
      var minimum = '0.0.0';
      h = Harness(handler: (r) => discoveryHandler(r, minimum: minimum));
      await h.read(serverBindingProvider).verify(testUrl);
      minimum = '5.0.0';
      expect(
        await h.read(serverBindingProvider).restore(),
        isA<BindingUpdateRequired>(),
      );
    });
  });
}
