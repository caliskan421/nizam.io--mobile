// Gerçek backend'e karşı entegrasyon (F14 kapsam 10; adım 4). Backend etiket imajından
// test_integration/backend/up.sh ile kalkar; bu dosya mobil core yığınını (lib/core/providers.dart
// bağları, gerçek dio/dart:io HTTP, bellek içi güvenli depo) cihazsız, host VM'de koşturur.
//
// Ortam: NIZAMIO_IT_BACKEND (varsayılan http://127.0.0.1:18140), NIZAMIO_IT_BACKEND_MINVER
// (asgari mobil sürümü 99.0.0 olan ikinci server; varsayılan :18141), NIZAMIO_IT_ADMIN_EMAIL /
// NIZAMIO_IT_ADMIN_PASSWORD (up.sh ile aynı varsayılanlar). Testler SIRALIDIR (tek dosya).
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/di/composition.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/logging/log.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/server/server_binding.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/core/session/token_pair.dart';
import 'package:nizamio/core/session/token_store.dart';
import 'package:nizamio/core/storage/secure_store.dart';
import 'package:nizamio/features/identity/identity.dart';

import 'support/proxy.dart';
import 'support/raw_http.dart';

final _env = Platform.environment;
final backend = Uri.parse(
  _env['NIZAMIO_IT_BACKEND'] ?? 'http://127.0.0.1:18140',
);
final backendMinVer = Uri.parse(
  _env['NIZAMIO_IT_BACKEND_MINVER'] ?? 'http://127.0.0.1:18141',
);
final adminEmail =
    _env['NIZAMIO_IT_ADMIN_EMAIL'] ?? 'yonetici@f14.nizamio.test';
final adminPassword =
    _env['NIZAMIO_IT_ADMIN_PASSWORD'] ?? 'F14-Yonetici-Parola-2026';

/// Mobil core yığını: gerçek provider bağları, gerçek HTTP, bellek içi güvenli depo.
class Mobile {
  Mobile(Flavor flavor) : store = MemorySecureStore() {
    // Gerçek bileşim kökü; HTTP gerçek (bağdaştırıcı verilmez), yalnız depo bellek içi.
    composition = Composition.create(flavor: flavor, secureStore: store);
  }

  final MemorySecureStore store;
  late final Composition composition;
  ProviderContainer get container => composition.container;

  ServerBindingController get binding => container.read(serverBindingProvider);
  IdentityService get identity => container.read(identityServiceProvider);
  SessionState get session => container.read(sessionStateProvider);
  AppPhase get phase => container.read(appPhaseProvider);
  Future<TokenPair?> stored() => TokenStore(store).load();

  Future<void> dispose() => composition.dispose();
}

Matcher apiError(String code) =>
    throwsA(isA<ApiError>().having((e) => e.code, 'code', code));

void main() {
  final logs = <String>[];
  setUpAll(() async {
    Log.sink = logs.add;
    final ready = await rawRequest(
      'GET',
      backend.replace(path: '/healthz/ready'),
    );
    expect(
      ready.status,
      200,
      reason: 'backend hazır değil: $backend (make integration)',
    );
  });
  tearDownAll(Log.resetSink);

  test(
    'sunucu doğrulama: well-known + profile + sürüm uyumu → doğrulandı',
    () async {
      final m = Mobile(Flavor.dev);
      addTearDown(m.dispose);
      final s = await m.binding.verify(backend.toString());
      expect(s, isA<BindingVerified>());
      final info = (s as BindingVerified).info;
      expect(info.instanceId, 'f14-mobile');
      expect(info.apiVersion, 'v1');
      expect(m.phase, AppPhase.serverVerified);
    },
  );

  group('prod flavor: https olmayan / yanlış sunucuya parola gitmez', () {
    test('http adres (gerçek backend önünde sayan vekil) → reddedilir; vekile hiç istek yok', () async {
      final proxy = await CountingProxy.start(backend);
      addTearDown(proxy.close);
      final m = Mobile(Flavor.prod);
      addTearDown(m.dispose);
      final s = await m.binding.verify(proxy.url.toString());
      expect(s, isA<BindingFailed>());
      expect((s as BindingFailed).error.code, ClientErrorCode.insecureServer);
      await expectLater(
        m.identity.login(email: adminEmail, password: adminPassword),
        apiError(ClientErrorCode.serverNotVerified),
      );
      expect(
        proxy.seen,
        isEmpty,
        reason: 'hiçbir istek, dolayısıyla parola, sunucuya ulaşmadı',
      );
    });

    test(
      'NIZAM.IO olmayan sunucu → reddedilir; giriş isteği oluşmaz',
      () async {
        final other = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
        final seen = <String>[];
        other.listen((req) async {
          seen.add('${req.method} ${req.uri.path}');
          req.response
            ..statusCode = 404
            ..headers.contentType = ContentType.html
            ..write('<html>baska sunucu</html>');
          await req.response.close();
        });
        addTearDown(() => other.close(force: true));
        final m = Mobile(Flavor.dev);
        addTearDown(m.dispose);
        final s = await m.binding.verify('http://127.0.0.1:${other.port}');
        expect(
          (s as BindingFailed).error.code,
          ClientErrorCode.serverUnrecognized,
        );
        await expectLater(
          m.identity.login(email: adminEmail, password: adminPassword),
          apiError(ClientErrorCode.serverNotVerified),
        );
        expect(seen, ['GET /.well-known/nizamio-instance']);
      },
    );

    test('yanlış (güvenilmeyen) sertifikalı https → client.tls_error; istek ulaşmaz', () async {
      final dir = await Directory.systemTemp.createTemp('nizamio-it-tls-');
      addTearDown(() => dir.delete(recursive: true));
      final gen = await Process.run('openssl', [
        'req',
        '-x509',
        '-newkey',
        'rsa:2048',
        '-nodes',
        '-days',
        '1',
        '-subj',
        '/CN=localhost',
        '-addext',
        'subjectAltName=DNS:localhost,IP:127.0.0.1',
        '-keyout',
        '${dir.path}/k.pem',
        '-out',
        '${dir.path}/c.pem',
      ]);
      expect(gen.exitCode, 0, reason: '${gen.stderr}');
      final tls = await HttpServer.bindSecure(
        InternetAddress.loopbackIPv4,
        0,
        SecurityContext()
          ..useCertificateChain('${dir.path}/c.pem')
          ..usePrivateKey('${dir.path}/k.pem'),
      );
      final seen = <String>[];
      tls.listen((req) async {
        seen.add(req.uri.path);
        await req.response.close();
      }, onError: (Object _) {});
      addTearDown(() => tls.close(force: true));
      final m = Mobile(Flavor.prod);
      addTearDown(m.dispose);
      final s = await m.binding.verify('https://localhost:${tls.port}');
      expect((s as BindingFailed).error.code, ClientErrorCode.tlsError);
      await expectLater(
        m.identity.login(email: adminEmail, password: adminPassword),
        apiError(ClientErrorCode.serverNotVerified),
      );
      expect(seen, isEmpty);
    });
  });

  test('sürüm uyumsuzluğu (minimum_mobile_version 99.0.0) → güncelleme gerekli; giriş başlamaz', () async {
    final proxy = await CountingProxy.start(backendMinVer);
    addTearDown(proxy.close);
    final m = Mobile(Flavor.dev);
    addTearDown(m.dispose);
    final s = await m.binding.verify(proxy.url.toString());
    expect(s, isA<BindingUpdateRequired>());
    expect((s as BindingUpdateRequired).minimumVersion, '99.0.0');
    expect(m.phase, AppPhase.updateRequired);
    await expectLater(
      m.identity.login(email: adminEmail, password: adminPassword),
      apiError(ClientErrorCode.updateRequired),
    );
    expect(proxy.seen, [
      'GET /.well-known/nizamio-instance',
      'GET /v1/instance/profile',
    ]);
    expect(proxy.bodies.join(), isNot(contains(adminPassword)));
  });

  test('giriş → /v1/me → yenileme (rotasyon) → /v1/me → çıkış', () async {
    final proxy = await CountingProxy.start(backend);
    addTearDown(proxy.close);
    final m = Mobile(Flavor.dev);
    addTearDown(m.dispose);
    expect(
      await m.binding.verify(proxy.url.toString()),
      isA<BindingVerified>(),
    );

    await m.identity.login(email: adminEmail, password: adminPassword);
    final first = (await m.stored())!;
    expect(m.session, isA<SessionActive>());
    expect(first.refreshToken, isNotEmpty);

    final me = await m.identity.me();
    expect(me.accountId, first.accountId);
    expect(me.email, adminEmail);

    final newAccess = await m.container
        .read(sessionControllerProvider)
        .refresh();
    final second = (await m.stored())!;
    expect(newAccess, second.accessToken);
    expect(second.refreshToken, isNot(first.refreshToken), reason: 'rotasyon');
    expect(proxy.count('POST', '/v1/auth/refresh'), 1);
    expect((await m.identity.me()).accountId, first.accountId);

    await m.identity.logout();
    expect(proxy.count('POST', '/v1/auth/logout'), 1);
    expect(await m.stored(), isNull);
    expect(m.session, isA<SessionNone>());
    expect(
      await meStatus(backend, second.accessToken),
      401,
      reason: 'çıkış sunucuda oturumu kapattı',
    );

    final all = logs.join('\n');
    for (final secret in [
      first.accessToken,
      first.refreshToken,
      second.accessToken,
      second.refreshToken,
      adminPassword,
    ]) {
      expect(all, isNot(contains(secret)), reason: 'log redaksiyonu');
    }
  });

  test('K-05: yenileme yanıtı kaybolur → yeniden giriş gerekli, tekrar yok; web oturumu düşmez', () async {
    // Aynı hesapla web oturumu (ayrı istemci sınıfı).
    final webToken = await webLogin(backend, adminEmail, adminPassword);
    expect(await meStatus(backend, webToken), 200);

    final proxy = await CountingProxy.start(backend);
    addTearDown(proxy.close);
    final m = Mobile(Flavor.dev);
    addTearDown(m.dispose);
    await m.binding.verify(proxy.url.toString());
    await m.identity.login(email: adminEmail, password: adminPassword);
    final before = (await m.stored())!;

    // Backend yenilemeyi İŞLER (rotasyon), istemci yanıtı alamaz.
    proxy.dropResponseFor.add('/v1/auth/refresh');
    await expectLater(
      m.container.read(sessionControllerProvider).refresh(),
      apiError(ClientErrorCode.reauthRequired),
    );
    expect(m.session, isA<SessionReauthRequired>());
    expect(
      (m.session as SessionReauthRequired).reason,
      ReauthReason.refreshAmbiguous,
    );
    expect(m.phase, AppPhase.reauthRequired);
    expect(
      await m.stored(),
      isNull,
      reason: 'belirsiz belirteç cihazda kalmaz',
    );

    // Sonraki her deneme ağa ÇIKMAZ: aynı belirteçle ikinci yenileme yok.
    proxy.dropResponseFor.clear();
    await expectLater(
      m.container.read(sessionControllerProvider).refresh(),
      apiError(ClientErrorCode.reauthRequired),
    );
    await expectLater(m.identity.me(), apiError(ClientErrorCode.notSignedIn));
    expect(proxy.count('POST', '/v1/auth/refresh'), 1);

    // Mobil yenileme kaybı web oturumunu DÜŞÜRMEDİ.
    expect(await meStatus(backend, webToken), 200);

    // Yeniden giriş çalışır.
    await m.identity.login(email: adminEmail, password: adminPassword);
    expect((await m.identity.me()).email, adminEmail);
    await m.identity.logout();

    // Kayıp yanıtın eski belirtecini (K-05 kontrol testi için) sakla.
    _lostRefreshToken = before.refreshToken;
    _webToken = webToken;
  });

  test('kontrol: aynı belirteçle yeniden denemek hesabın BÜTÜN oturumlarını düşürür (K-05 gerekçesi)', () async {
    expect(_lostRefreshToken, isNotNull);
    expect(await meStatus(backend, _webToken!), 200);
    final reuse = await rawRequest(
      'POST',
      backend.replace(path: '/v1/auth/refresh'),
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-Nizamio-Client': 'mobile',
      },
      body: {'refresh_token': _lostRefreshToken},
    );
    expect(reuse.status, 401);
    expect(
      await meStatus(backend, _webToken!),
      401,
      reason: 'tekrar kullanım (TB-16) web oturumunu da düşürdü — istemci kuralı bu yüzden var',
    );
    // Hesap kilitlenmez; sonraki koşumlar için giriş hâlâ mümkün.
    expect(
      await meStatus(
        backend,
        await webLogin(backend, adminEmail, adminPassword),
      ),
      200,
    );
  });
}

String? _lostRefreshToken;
String? _webToken;
