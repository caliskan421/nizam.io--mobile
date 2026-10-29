// SSE çekirdek yardımcıları: çerçeveleme (bölünmüş parçalar, CRLF, yorum, çok satırlı data),
// JSON nesnesi çözme ve akış isteğinin hata gövdesinden ApiError.
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/http/sse.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';

Stream<List<int>> _chunks(List<List<int>> parts) => Stream.fromIterable(parts);

Future<List<SseEvent>> _decode(String text, {int? every}) {
  final bytes = utf8.encode(text);
  if (every == null) return decodeSse(_chunks([bytes])).toList();
  return decodeSse(
    _chunks([
      for (var i = 0; i < bytes.length; i += every)
        bytes.sublist(i, (i + every).clamp(0, bytes.length)),
    ]),
  ).toList();
}

void main() {
  group('decodeSse', () {
    test('olay adı + data, boş satırla biter; sıra korunur', () async {
      final events = await _decode(
        'event: metin\ndata: {"metin":"a"}\n\n'
        'event: bitti\ndata: {"sohbet_id":"s1"}\n\n',
      );
      expect(events, const [
        SseEvent('metin', '{"metin":"a"}'),
        SseEvent('bitti', '{"sohbet_id":"s1"}'),
      ]);
    });

    test('her baytta bölünmüş parçalar (çok baytlı UTF-8 dahil)', () async {
      const text = 'event: metin\ndata: {"metin":"Üye-1 şunu çözdü ğ"}\n\n';
      expect(await _decode(text, every: 1), await _decode(text));
      expect(
        (await _decode(text, every: 3)).single.data,
        '{"metin":"Üye-1 şunu çözdü ğ"}',
      );
    });

    test('CRLF, yorum, id/retry, boşluksuz alan, çok satırlı data', () async {
      final events = await _decode(
        ': canlı tut\r\nid: 7\r\nretry: 10\r\nevent:arac\r\ndata:a\r\ndata: b\r\n\r\n',
      );
      expect(events, const [SseEvent('arac', 'a\nb')]);
    });

    test('event yoksa "message"; data yoksa olay çıkmaz', () async {
      expect(await _decode('data: x\n\nevent: bos\n\n'), const [
        SseEvent('message', 'x'),
      ]);
    });

    test('boş satırla kapanmayan son olay atılır', () async {
      expect(
        await _decode(
          'event: metin\ndata: {"metin":"a"}\n\nevent: bitti\ndata: {}',
        ),
        const [SseEvent('metin', '{"metin":"a"}')],
      );
    });

    test('geçersiz UTF-8 → FormatException', () async {
      await expectLater(
        decodeSse(
          _chunks([
            [0xff, 0x0a, 0x0a],
          ]),
        ).toList(),
        throwsA(isA<FormatException>()),
      );
    });

    test('toString gövdeyi yazmaz', () {
      expect(
        const SseEvent('metin', 'gizli').toString(),
        isNot(contains('gizli')),
      );
    });
  });

  group('sseJsonObject', () {
    test('nesne çözülür', () {
      expect(sseJsonObject('{"a":1}'), {'a': 1});
    });

    test('nesne olmayan ya da bozuk JSON → invalid_response', () {
      for (final bad in ['[1]', '"x"', '{bozuk']) {
        expect(
          () => sseJsonObject(bad),
          throwsA(
            isA<ApiError>().having(
              (e) => e.code,
              'code',
              ClientErrorCode.invalidResponse,
            ),
          ),
          reason: bad,
        );
      }
    });
  });

  group('streamApiError', () {
    final o = RequestOptions(path: '/v1/assistant/chat');

    DioException streamed(int status, String body, {Headers? headers}) =>
        DioException(
          requestOptions: o,
          type: DioExceptionType.badResponse,
          // Hata halkası akış gövdesini çözemediği için bunu yazar.
          error: ApiError(ClientErrorCode.invalidResponse, status: status),
          response: Response<Object?>(
            requestOptions: o,
            statusCode: status,
            headers: headers ?? Headers(),
            data: ResponseBody(
              Stream.value(Uint8List.fromList(utf8.encode(body))),
              status,
            ),
          ),
        );

    test('akış gövdesindeki zarf okunur (kod, durum, request_id, Retry-After)', () async {
      final e = await streamApiError(
        streamed(
          429,
          '{"code":"assistant.quota_exceeded","message":"x","request_id":"r9"}',
          headers: Headers.fromMap({
            'retry-after': ['30'],
          }),
        ),
      );
      expect(
        (e.code, e.status, e.requestId, e.retryAfter),
        ('assistant.quota_exceeded', 429, 'r9', const Duration(seconds: 30)),
      );
    });

    test('zarf olmayan gövde → invalid_response (durum korunur)', () async {
      final e = await streamApiError(streamed(502, '<html>'));
      expect((e.code, e.status), (ClientErrorCode.invalidResponse, 502));
    });

    test(
      'akış gövdesi olmayan hata → toApiError (kapı reddi, zaman aşımı)',
      () async {
        final rejected = DioException(
          requestOptions: o,
          type: DioExceptionType.cancel,
          error: ApiError(ClientErrorCode.scopeMissing),
        );
        expect(
          (await streamApiError(rejected)).code,
          ClientErrorCode.scopeMissing,
        );
        final timeout = DioException(
          requestOptions: o,
          type: DioExceptionType.receiveTimeout,
        );
        expect((await streamApiError(timeout)).code, ClientErrorCode.timeout);
        expect(
          (await streamApiError(StateError('x'))).code,
          ClientErrorCode.invalidResponse,
        );
      },
    );
  });
}
