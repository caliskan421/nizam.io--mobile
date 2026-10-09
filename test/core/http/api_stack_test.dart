// HTTP ara katmanı (F14 kapsam 6) + kimlik servisi + log redaksiyonu: gerçek provider bağları,
// sahte bağdaştırıcı.

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/api/api_meta.dart';
import 'package:nizamio/core/api/generated/clients/identity_client.dart';
import 'package:nizamio/core/api/generated/clients/organization_client.dart';
import 'package:nizamio/core/api/generated/clients/program_client.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/http/interceptors.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/logging/log.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/server/server_address.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/core/session/token_store.dart';

import '../../support/fake_backend.dart';
import '../../support/harness.dart';

Matcher apiError(String code) => throwsA(
  anyOf(
    isA<ApiError>().having((e) => e.code, 'code', code),
    isA<DioException>().having(
      (e) => (e.error! as ApiError).code,
      'code',
      code,
    ),
  ),
);

void main() {
  late Harness h;
  late int meStatus;
  late List<String> logs;

  ResponseBody handler(Seen r) {
    switch ('${r.method} ${r.path}') {
      case 'POST /v1/auth/login':
        return jsonResponse(200, loginBody('1'));
      case 'POST /v1/auth/refresh':
        final n = (r.body! as Map)['refresh_token'] == 'refresh-token-1'
            ? '2'
            : '3';
        return jsonResponse(200, loginBody(n)..remove('force_password_change'));
      case 'POST /v1/auth/logout':
        return ResponseBody.fromString('', 204);
      case 'GET /v1/me':
        if (r.header('Authorization') == 'Bearer access-token-1' &&
            meStatus == 401) {
          return envelope(401, 'platform.unauthenticated');
        }
        return jsonResponse(200, {'account_id': 'acc-1', 'email': 'a@b.test'});
      case 'GET /v1/program':
        return jsonResponse(200, {
          'program_id': r.header('X-Nizamio-Program'),
          'name': 'P',
        });
    }
    return discoveryHandler(r);
  }

  setUp(() async {
    logs = [];
    Log.sink = logs.add;
    meStatus = 200;
    h = Harness(handler: handler);
    await h.read(serverBindingProvider).verify(testUrl);
    await h.identity.login(email: 'a@b.test', password: 'Gizli-Parola-1');
  });

  tearDown(() {
    h.dispose();
    Log.resetSink();
  });

  group('başlıklar', () {
    test('giriş: X-Nizamio-Client: mobile + X-Requested-With; belirteçler güvenli depoda', () {
      final login = h.backend.requests.singleWhere(
        (r) => r.path == '/v1/auth/login',
      );
      expect(login.header('X-Nizamio-Client'), 'mobile');
      expect(login.header('X-Requested-With'), isNotEmpty);
      expect(login.header('Authorization'), isNull);
      expect(h.store.values.keys, containsAll([TokenStore.key]));
      expect(h.store.values[TokenStore.key], contains('refresh-token-1'));
    });

    test(
      'S1 GET: Bearer var, X-Requested-With yok; S0 GET: Bearer yok',
      () async {
        await h.identity.me();
        final me = h.backend.requests.last;
        expect(me.header('Authorization'), 'Bearer access-token-1');
        expect(me.header('X-Requested-With'), isNull);
        final discovery = h.backend.requests.first;
        expect(discovery.header('Authorization'), isNull);
        expect(discovery.header('X-Nizamio-Client'), 'mobile');
      },
    );

    test('bütün yazmalarda X-Requested-With (çıkış dahil)', () async {
      await h.identity.logout();
      for (final r in h.backend.requests.where((r) => r.method != 'GET')) {
        expect(r.header('X-Requested-With'), isNotEmpty, reason: r.path);
      }
    });
  });

  group('kapsam (S2/S3)', () {
    test('S2 kapsam yokken istek GÖNDERİLMEZ', () async {
      final before = h.backend.requests.length;
      final client = ProgramClient(h.read(apiDioProvider)!);
      await expectLater(
        apiCall(client.readProgram),
        apiError(ClientErrorCode.scopeMissing),
      );
      expect(h.backend.requests.length, before);
    });

    test('S2 kapsam seçiliyken X-Nizamio-Program taşınır', () async {
      h.read(scopeControllerProvider).selectProgram('prog-7');
      final p = await apiCall(
        ProgramClient(h.read(apiDioProvider)!).readProgram,
      );
      expect(p.programId, 'prog-7');
      expect(h.backend.requests.last.header('X-Nizamio-Department'), isNull);
    });

    test(
      'S3 (sentetik işlem; ilk dilimde S3 uç yok): departman yoksa gönderilmez',
      () async {
        final scope = ScopeController()..selectProgram('p');
        final dio = Dio(BaseOptions(baseUrl: testUrl))
          ..httpClientAdapter = h.backend
          ..interceptors.add(
            ApiGuardInterceptor(
              server: ServerAddress.parse(testUrl, Flavor.prod),
              flavor: Flavor.prod,
              scope: scope,
              operations: const {
                's3op': ApiOperation(
                  operationId: 's3op',
                  method: 'GET',
                  path: '/v1/x',
                  scope: ScopeClass.s3,
                  csrf: false,
                  programHeader: true,
                  departmentHeader: true,
                  auth: false,
                ),
              },
            ),
          );
        final opts = Options(
          extra: {
            'openapi': {'operationId': 's3op'},
          },
        );
        final before = h.backend.requests.length;
        await expectLater(
          dio.get<Object?>('/v1/x', options: opts),
          apiError(ClientErrorCode.scopeMissing),
        );
        expect(h.backend.requests.length, before);
        scope.selectDepartment('d');
        try {
          await dio.get<Object?>('/v1/x', options: opts);
        } on DioException {
          // Sahte sunucu bu yolu tanımaz (404); yalnız başlıklar denetlenir.
        }
        expect(h.backend.requests.last.header('X-Nizamio-Program'), 'p');
        expect(h.backend.requests.last.header('X-Nizamio-Department'), 'd');
      },
    );
  });

  group('sözleşme kapısı', () {
    test('spec dışı (operationId taşımayan) istek gönderilmez', () async {
      final before = h.backend.requests.length;
      await expectLater(
        h.read(apiDioProvider)!.get<Object?>('/v1/me'),
        apiError(ClientErrorCode.unknownOperation),
      );
      expect(h.backend.requests.length, before);
    });

    test('bağ dışı adrese istek gönderilmez', () async {
      final before = h.backend.requests.length;
      await expectLater(
        h
            .read(apiDioProvider)!
            .get<Object?>(
              'https://baska.example.test/v1/me',
              options: Options(
                extra: {
                  'openapi': {'operationId': 'me'},
                },
              ),
            ),
        apiError(ClientErrorCode.insecureServer),
      );
      expect(h.backend.requests.length, before);
    });
  });

  group('CX-Ö-02: kapı gerçek yolu operasyonun yol şablonuyla eşleştirir', () {
    test('S2 yoluna S1 operationId (extras ile) → gönderilmez', () async {
      final before = h.backend.requests.length;
      await expectLater(
        h
            .read(apiDioProvider)!
            .get<Object?>(
              '/v1/program',
              options: Options(
                extra: {
                  'openapi': {'operationId': 'me'},
                },
              ),
            ),
        apiError(ClientErrorCode.unknownOperation),
      );
      expect(h.backend.requests.length, before);
    });

    test(
      'üretilmiş istemciye başka işlemin extras\'ı verilirse gönderilmez',
      () async {
        final before = h.backend.requests.length;
        await expectLater(
          apiCall(
            () =>
                ProgramClient(h.read(apiDioProvider)!)
                    .readProgram(extras: IdentityClient.meOpenapiExtras),
          ),
          apiError(ClientErrorCode.unknownOperation),
        );
        expect(h.backend.requests.length, before);
      },
    );

    test('operationId taşımayan ama bilinen yol → gönderilmez', () async {
      final before = h.backend.requests.length;
      await expectLater(
        h.read(apiDioProvider)!.get<Object?>('/v1/program'),
        apiError(ClientErrorCode.unknownOperation),
      );
      expect(h.backend.requests.length, before);
    });

    test('yol parametreli şablon eşleşir; fazladan segment eşleşmez', () async {
      h.backend.handler = (r) => jsonResponse(200, {'members': null});
      final client = OrganizationClient(h.read(apiDioProvider)!);
      await apiCall(() => client.listMembers(id: 'dep-1'));
      expect(h.backend.requests.last.path, '/v1/departments/dep-1/members');
      final before = h.backend.requests.length;
      await expectLater(
        h
            .read(apiDioProvider)!
            .get<Object?>(
              '/v1/departments/dep-1/members/x',
              options: Options(
                extra: {
                  'openapi': {'operationId': 'listMembers'},
                },
              ),
            ),
        apiError(ClientErrorCode.unknownOperation),
      );
      expect(h.backend.requests.length, before);
    });
  });

  group('CX-Ö-01: 200 gövdesi DTO\'ya ayrıştırılamazsa', () {
    test(
      'yenileme: belirsiz → yeniden giriş, ikinci yenileme isteği yok',
      () async {
        h.backend.handler = (r) => switch (r.path) {
          '/v1/me' => envelope(401, 'platform.unauthenticated'),
          '/v1/auth/refresh' => jsonResponse(200, {'account_id': 5}),
          _ => handler(r),
        };
        await expectLater(
          h.identity.me(),
          apiError(ClientErrorCode.reauthRequired),
        );
        expect(
          (h.read(sessionStateProvider) as SessionReauthRequired).reason,
          ReauthReason.refreshAmbiguous,
        );
        await expectLater(
          h.identity.me(),
          apiError(ClientErrorCode.notSignedIn),
        );
        expect(h.backend.count('POST', '/v1/auth/refresh'), 1);
        expect(h.store.values.containsKey(TokenStore.key), isFalse);
      },
    );

    test('diğer uçlar: client.invalid_response (TypeError sızmaz)', () async {
      h.backend.handler = (r) => jsonResponse(200, {'account_id': 1});
      await expectLater(
        h.identity.me(),
        apiError(ClientErrorCode.invalidResponse),
      );
      h.backend.handler = (r) => jsonResponse(200, ['liste']);
      await expectLater(
        h.identity.me(),
        apiError(ClientErrorCode.invalidResponse),
      );
    });
  });

  group('401 → tek yenileme → bir kez tekrar', () {
    test(
      'erişim belirteci düşünce yenilenir ve istek bir kez tekrarlanır',
      () async {
        meStatus = 401;
        final me = await h.identity.me();
        expect(me.accountId, 'acc-1');
        expect(h.backend.count('POST', '/v1/auth/refresh'), 1);
        expect(h.backend.count('GET', '/v1/me'), 2);
        expect(
          h.backend.requests.last.header('Authorization'),
          'Bearer access-token-2',
        );
        expect(h.store.values[TokenStore.key], contains('refresh-token-2'));
        expect(
          h.store.values[TokenStore.key],
          isNot(contains('refresh-token-1')),
        );
      },
    );

    test('eşzamanlı üç 401 → tek yenileme', () async {
      meStatus = 401;
      final results = await Future.wait([
        h.identity.me(),
        h.identity.me(),
        h.identity.me(),
      ]);
      expect(results, hasLength(3));
      expect(h.backend.count('POST', '/v1/auth/refresh'), 1);
    });

    test('tekrar da 401 alırsa döngü yok: hata döner', () async {
      h.backend.handler = (r) => r.path == '/v1/me'
          ? envelope(401, 'platform.unauthenticated')
          : handler(r);
      await expectLater(h.identity.me(), apiError('platform.unauthenticated'));
      expect(h.backend.count('POST', '/v1/auth/refresh'), 1);
      expect(h.backend.count('GET', '/v1/me'), 2);
    });

    test('K-05 (zincirde): yenileme zaman aşımı → yeniden giriş gerekli, ikinci yenileme yok', () async {
      h.backend.handler = (r) => switch (r.path) {
        '/v1/me' => envelope(401, 'platform.unauthenticated'),
        '/v1/auth/refresh' => timeout(null),
        _ => handler(r),
      };
      await expectLater(
        h.identity.me(),
        apiError(ClientErrorCode.reauthRequired),
      );
      expect(h.read(sessionStateProvider), isA<SessionReauthRequired>());
      await expectLater(h.identity.me(), apiError(ClientErrorCode.notSignedIn));
      expect(h.backend.count('POST', '/v1/auth/refresh'), 1);
      expect(h.store.values.containsKey(TokenStore.key), isFalse);
    });
  });

  group('hata zarfı', () {
    test('{code, messageKey, requestId, fields[]}', () async {
      h.backend.handler = (r) => jsonResponse(422, {
        'code': 'organization.input_invalid',
        'message': 'iç ileti',
        'request_id': 'req-9',
        'fields': [
          {
            'field': 'name',
            'code': 'organization.name_required',
            'message': 'x',
          },
        ],
      });
      try {
        await apiCall(
          OrganizationClient(h.read(apiDioProvider)!).listDepartments,
        );
        fail('hata bekleniyordu');
      } on ApiError catch (e) {
        expect(e.code, 'organization.input_invalid');
        expect(e.messageKey, 'errors.organization.input_invalid');
        expect(e.requestId, 'req-9');
        expect(e.fields.single.code, 'organization.name_required');
        expect(e.status, 422);
        expect(e.toString(), isNot(contains('iç ileti')));
      }
    });

    test('429 Retry-After okunur; otomatik tekrar yok', () async {
      h.backend.handler = (r) => envelope(
        429,
        'platform.rate_limited',
        headers: {
          'retry-after': ['12'],
        },
      );
      try {
        await h.identity.me();
        fail('hata bekleniyordu');
      } on ApiError catch (e) {
        expect(e.retryAfter, const Duration(seconds: 12));
      }
      expect(h.backend.count('GET', '/v1/me'), 1);
    });

    test('zarf olmayan yanıt → client.invalid_response', () async {
      h.backend.handler = (r) => ResponseBody.fromString('<html>', 502);
      await expectLater(
        h.identity.me(),
        apiError(ClientErrorCode.invalidResponse),
      );
    });

    test('yönlendirme izlenmez (3xx → geçersiz yanıt)', () async {
      h.backend.handler = (r) => ResponseBody.fromString(
        '',
        302,
        headers: {
          'location': ['http://nizam.example.test/v1/me'],
        },
      );
      await expectLater(
        h.identity.me(),
        apiError(ClientErrorCode.invalidResponse),
      );
      expect(h.backend.count('GET', '/v1/me'), 1);
    });
  });

  group('log redaksiyonu', () {
    test(
      'giriş, yenileme, çıkış boyunca hiçbir belirteç/parola log\'a yazılmaz',
      () async {
        meStatus = 401;
        await h.identity.me();
        await h.identity.logout();
        Log.info(
          'elle: Authorization: Bearer access-token-2 {"refresh_token":"refresh-token-2"} password=Gizli-Parola-1',
        );
        final all = logs.join('\n');
        expect(logs, isNotEmpty);
        for (final secret in [
          'access-token-1',
          'refresh-token-1',
          'access-token-2',
          'refresh-token-2',
          'Gizli-Parola-1',
        ]) {
          expect(all, isNot(contains(secret)), reason: secret);
        }
      },
    );

    test('redact örüntüleri', () {
      expect(Log.redact('Bearer abc.def-ghi'), 'Bearer ***');
      expect(Log.redact('{"access_token": "zzz"}'), '{"access_token":"***"}');
      expect(Log.redact('eyJhbGciOi.eyJzdWIiOi.c2ln'), '***');
      expect(Log.redact('refresh_token=abcdef'), 'refresh_token=***');
    });
  });

  test('çıkış: sunucu hatası olsa da yerel belirteçler silinir', () async {
    h.backend.handler = (r) => r.path == '/v1/auth/logout'
        ? envelope(500, 'platform.internal')
        : handler(r);
    await h.identity.logout();
    expect(h.store.values.containsKey(TokenStore.key), isFalse);
    expect(h.read(sessionStateProvider), isA<SessionNone>());
  });

  test(
    'me 403 force_password_change_required → bayrak oturum durumunda',
    () async {
      h.backend.handler = (r) => r.path == '/v1/me'
          ? envelope(403, 'identity.force_password_change_required')
          : handler(r);
      await expectLater(
        h.identity.me(),
        apiError('identity.force_password_change_required'),
      );
      expect(
        (h.read(sessionStateProvider) as SessionActive).forcePasswordChange,
        isTrue,
      );
    },
  );
}
