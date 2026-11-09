// Kapı halkasının işlem çözümü: sabit segmentli yol, yol parametreli şablona üstündür
// (`/v1/chats/candidates` → `listChatCandidates`, `getChat` değil); başka işlemin metaverisiyle
// aynı yola istek yine gönderilmez (CX-Ö-02). Sentetik tabloyla: eşit özgüllükte belirsizlik
// reddi, kayıt sırasından bağımsızlık ve farklı kapsam sınıfı çakışmasında başlık seçimi.
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/api/api_meta.dart';
import 'package:nizamio/core/api/generated/clients/messaging_client.dart';
import 'package:nizamio/core/api/generated/models/purpose.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/http/interceptors.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/server/server_address.dart';

import '../../support/fake_backend.dart';
import '../../support/harness.dart';

/// Gönderilen istekleri kaydeden, her isteğe 200 `{}` dönen bağdaştırıcı.
final class _Recorder implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      '{}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

ApiOperation _op(String id, String path, ScopeClass scope) => ApiOperation(
  operationId: id,
  method: 'GET',
  path: path,
  scope: scope,
  csrf: false,
  programHeader: scope != ScopeClass.s1,
  departmentHeader: scope == ScopeClass.s3,
  auth: false,
);

/// Sentetik tablo: aynı yola birden çok şablon ve farklı kapsam sınıfları.
final _table = [
  _op('itemS1', '/v1/x/{id}', ScopeClass.s1),
  _op('fixedS3', '/v1/x/fixed', ScopeClass.s3),
  _op('kindS2', '/v1/{kind}/y', ScopeClass.s2),
  _op('progS2', '/v1/p/{id}', ScopeClass.s2),
  _op('meS1', '/v1/p/me', ScopeClass.s1),
  _op('deepS3', '/v1/p/{id}/d/{dep}', ScopeClass.s3),
  _op('deepFixedS2', '/v1/p/{id}/d/all', ScopeClass.s2),
  // Az özgül düzeyde belirsiz (iki tek parametreli), en özgülde tek sabit yol.
  _op('aS1', '/v1/a/{id}', ScopeClass.s1),
  _op('kbS1', '/v1/{k}/b', ScopeClass.s1),
  _op('abS3', '/v1/a/b', ScopeClass.s3),
];

/// Tablonun iki kayıt sırası (ileri / ters): çözüm sıradan bağımsız olmalı.
final _orders = {
  'ileri': {for (final o in _table) o.operationId: o},
  'ters': {for (final o in _table.reversed) o.operationId: o},
};

void main() {
  group('sentetik tablo', () {
    for (final MapEntry(key: order, value: ops) in _orders.entries) {
      late _Recorder rec;
      late Dio dio;
      setUp(() {
        rec = _Recorder();
        final scope = ScopeController()
          ..selectProgram('p1')
          ..selectDepartment('d1');
        dio = Dio(BaseOptions(baseUrl: testUrl))
          ..httpClientAdapter = rec
          ..interceptors.add(
            ApiGuardInterceptor(
              server: ServerAddress.parse(testUrl, Flavor.prod),
              flavor: Flavor.prod,
              scope: scope,
              operations: ops,
            ),
          );
      });

      /// [path]'e [id] metaverisiyle istek; gönderildiyse kapsam başlıkları, değilse hata kodu.
      Future<Object> send(String path, String id) async {
        try {
          await dio.get<Object?>(
            path,
            options: Options(
              extra: {
                'openapi': {'operationId': id},
              },
            ),
          );
        } on DioException catch (e) {
          return (e.error! as ApiError).code;
        }
        final h = rec.requests.last.headers;
        return (h['X-Nizamio-Program'], h['X-Nizamio-Department']);
      }

      test('$order: eşit özgüllükte iki şablon belirsiz → istek yok', () async {
        // `/v1/x/y`: `/v1/x/{id}` ve `/v1/{kind}/y` birer parametreli; hangisi verilirse verilsin.
        for (final id in ['itemS1', 'kindS2']) {
          expect(await send('/v1/x/y', id), ClientErrorCode.unknownOperation);
        }
        expect(rec.requests, isEmpty);
      });

      test('$order: sabit segment kazanır; kapsam başlığı kazananın sınıfından', () async {
        // S1 şablonu ile S3 sabit yolu çakışır: sabit yol S3 → program + departman.
        expect(await send('/v1/x/fixed', 'fixedS3'), ('p1', 'd1'));
        // Aynı şablonun başka değeri S1 → kapsam başlığı yok (seçili kapsam olsa da).
        expect(await send('/v1/x/abc', 'itemS1'), (null, null));
        // S2 şablonu ile S1 sabit yolu: sabit yol S1 → başlık yok; şablon S2 → yalnız program.
        expect(await send('/v1/p/me', 'meS1'), (null, null));
        expect(await send('/v1/p/abc', 'progS2'), ('p1', null));
        // İki parametreli S3 ile bir parametreli S2: az parametreli S2 kazanır.
        expect(await send('/v1/p/abc/d/all', 'deepFixedS2'), ('p1', null));
        expect(await send('/v1/p/abc/d/d9', 'deepS3'), ('p1', 'd1'));
        // Alt düzeydeki belirsizlik en özgül tekil eşleşmeyi engellemez (sıradan bağımsız).
        expect(await send('/v1/a/b', 'abS3'), ('p1', 'd1'));
        expect(rec.requests, hasLength(7));
      });

      test(
        '$order: kaybeden işlemin metaverisiyle sınıf düşürülemez/yükseltilemez',
        () async {
          final pairs = [
            ('/v1/x/fixed', 'itemS1'),
            ('/v1/x/abc', 'fixedS3'),
            ('/v1/p/me', 'progS2'),
            ('/v1/p/abc/d/all', 'deepS3'),
          ];
          for (final (path, id) in pairs) {
            expect(
              await send(path, id),
              ClientErrorCode.unknownOperation,
              reason: '$path $id',
            );
          }
          expect(rec.requests, isEmpty);
        },
      );
    }
  });

  test('sabit yol üstün; başka işlem metaverisi reddedilir', () async {
    final h = Harness(
      handler: (r) => switch ('${r.method} ${r.path}') {
        'POST /v1/auth/login' => jsonResponse(200, loginBody('1')),
        'GET /v1/chats/candidates' => jsonResponse(200, {
          'items': <Object>[],
          'truncated': false,
        }),
        _ => discoveryHandler(r),
      },
    );
    addTearDown(h.dispose);
    await h.read(serverBindingProvider).verify(testUrl);
    await h.identity.login(email: 'a@b.test', password: 'p');
    h.read(scopeControllerProvider).selectProgram('prog-7');
    final dio = h.read(apiDioProvider)!;
    await apiCall(
      () => MessagingClient(dio).listChatCandidates(purpose: Purpose.direct),
    );
    expect(h.backend.requests.last.path, '/v1/chats/candidates');
    final before = h.backend.requests.length;
    await expectLater(
      dio.get<Object?>(
        '/v1/chats/candidates',
        options: Options(extra: MessagingClient.getChatOpenapiExtras),
      ),
      throwsA(
        isA<DioException>().having(
          (e) => (e.error! as ApiError).code,
          'code',
          ClientErrorCode.unknownOperation,
        ),
      ),
    );
    expect(h.backend.requests.length, before);
  });
}
