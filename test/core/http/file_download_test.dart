// Akışlı dosya indirme (F57 D2, Fable B3): gerçek HTTP yığını, sahte bağdaştırıcı. İstek
// sözleşme kapısından geçer (operationId, kapsam başlıkları), yanıt `ResponseType.stream`
// ile parça parça gelir (belleğe toplanmaz); hata zarfı akış gövdesinden çözülür; 401'de
// yenileme + tek tekrar akış isteğinde de çalışır.
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/api/generated/clients/records_client.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/http/file_download.dart';
import 'package:nizamio/core/http/interceptors.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';

import '../../support/fake_backend.dart';
import '../../support/harness.dart';

ResponseBody _chunks(int status) => ResponseBody(
  Stream.fromIterable([
    Uint8List.fromList([1, 2]),
    Uint8List.fromList([3]),
  ]),
  status,
);

void main() {
  late Harness h;
  var expired = false;

  ResponseBody handler(Seen r) {
    switch ('${r.method} ${r.path}') {
      case 'POST /v1/auth/login':
        return jsonResponse(200, loginBody('1'));
      case 'POST /v1/auth/refresh':
        return jsonResponse(
          200,
          loginBody('2')..remove('force_password_change'),
        );
      case 'GET /v1/files/f1/download':
        if (expired && r.header('Authorization') == 'Bearer access-token-1') {
          return envelope(401, 'platform.unauthenticated');
        }
        return _chunks(200);
      case 'GET /v1/files/f404/download':
        return envelope(404, 'records.file_not_found');
    }
    return discoveryHandler(r);
  }

  setUp(() async {
    expired = false;
    h = Harness(handler: handler);
    await h.read(serverBindingProvider).verify(testUrl);
    await h.identity.login(email: 'a@b.test', password: 'Gizli-Parola-1');
    h.read(scopeControllerProvider).selectProgram('prog-1');
  });

  tearDown(() => h.dispose());

  Map<String, dynamic> scope() =>
      withScope(RecordsClient.downloadFileOpenapiExtras, 'prog-9', 'd9');

  test(
    'akış parçaları sırayla gelir; kapı ve kapsam başlıkları uygulanır',
    () async {
      final stream = await getFileStream(
        h.read(apiDioProvider)!,
        fileId: 'f1',
        extras: scope(),
      );
      final chunks = await stream.toList();
      expect(chunks, [
        [1, 2],
        [3],
      ]);
      final req = h.backend.requests.last;
      expect(req.path, '/v1/files/f1/download');
      expect(req.header('X-Nizamio-Program'), 'prog-9');
      expect(req.header('X-Nizamio-Department'), 'd9');
      expect(req.header('Authorization'), 'Bearer access-token-1');
    },
  );

  test('boş kapsam kapıda reddedilir; istek gönderilmez', () async {
    final before = h.backend.requests.length;
    await expectLater(
      getFileStream(
        h.read(apiDioProvider)!,
        fileId: 'f1',
        extras: withScope(RecordsClient.downloadFileOpenapiExtras, '', 'd9'),
      ),
      throwsA(
        isA<ApiError>().having(
          (e) => e.code,
          'code',
          ClientErrorCode.scopeMissing,
        ),
      ),
    );
    expect(h.backend.requests.length, before);
  });

  test('hata zarfı akış gövdesinden çözülür', () async {
    await expectLater(
      getFileStream(h.read(apiDioProvider)!, fileId: 'f404', extras: scope()),
      throwsA(
        isA<ApiError>()
            .having((e) => e.code, 'code', 'records.file_not_found')
            .having((e) => e.status, 'status', 404),
      ),
    );
  });

  test('401 → yenileme 1, indirme bir kez tekrarlanır', () async {
    expired = true;
    final stream = await getFileStream(
      h.read(apiDioProvider)!,
      fileId: 'f1',
      extras: scope(),
    );
    expect([for (final c in await stream.toList()) ...c], [1, 2, 3]);
    expect(h.backend.count('POST', '/v1/auth/refresh'), 1);
    expect(h.backend.count('GET', '/v1/files/f1/download'), 2);
  });
}
