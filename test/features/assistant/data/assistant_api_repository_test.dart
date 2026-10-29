// assistant data katmanı: SSE sohbet akışı → AssistantEvent (olay sırası, akış sonrası `hata`,
// bölünmüş parçalar, iptal), sohbet listesi/okuma/silme eşlemesi, akış öncesi hata zarfı →
// ApiError, uç bayrağı kapalı (404 platform.route_not_found) → AssistantDisabled. Son grup
// gerçek ara katman zinciriyle (kapı + kimlik + hata halkası) başlık ve metaveri taşımayı sınar.
import 'dart:async';
import 'dart:convert';
import 'dart:io' show HttpException;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/assistant/data/assistant_api_repository.dart';
import 'package:nizamio/features/assistant/domain/assistant.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.respond);

  ResponseBody Function(RequestOptions o) respond;
  final List<RequestOptions> seen = [];
  final List<Object?> bodies = [];
  bool cancelled = false;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    unawaited(cancelFuture?.then((_) => cancelled = true));
    if (requestStream == null) {
      bodies.add(null);
    } else {
      final text = utf8.decode(await requestStream.expand((c) => c).toList());
      bodies.add(text.isEmpty ? null : jsonDecode(text));
    }
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(
  Object body, [
  int status = 200,
  Map<String, List<String>>? h,
]) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
    ...?h,
  },
);

ResponseBody _err(int status, String code) =>
    _json({'code': code, 'message': 'x', 'request_id': 'req-1'}, status);

/// SSE gövdesi; [every] verilirse bayt bayt (ya da [every] baytlık) parçalara bölünür.
ResponseBody _sse(String text, {int? every, Exception? errorAtEnd}) {
  final bytes = utf8.encode(text);
  final step = every ?? bytes.length;
  Stream<Uint8List> stream() async* {
    for (var i = 0; i < bytes.length; i += step) {
      yield Uint8List.fromList(
        bytes.sublist(i, (i + step).clamp(0, bytes.length)),
      );
    }
    if (errorAtEnd != null) throw errorAtEnd;
  }

  return ResponseBody(
    stream(),
    200,
    headers: {
      Headers.contentTypeHeader: ['text/event-stream'],
    },
  );
}

String _ev(String name, Object data) =>
    'event: $name\ndata: ${jsonEncode(data)}\n\n';

(ApiAssistantRepository, _Adapter) _repo(
  ResponseBody Function(RequestOptions o) respond,
) {
  final adapter = _Adapter(respond);
  return (
    ApiAssistantRepository(
      Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter,
    ),
    adapter,
  );
}

const _t = '2026-11-03T07:00:00Z';
const _q = AssistantQuestion(text: 'Bu hafta kaç görev bitti?');

final _success =
    _ev('metin', {'metin': 'Bu hafta '}) +
    _ev('arac', {'arac': 'gorev_dagilimi', 'etiket': 'Görev dağılımı'}) +
    _ev('metin', {'metin': 'Üye-1 iki görev bitirdi.'}) +
    _ev('gorunum', {
      'gorunum': 'gorevler',
      'filtre': {'durum': 'tamamlandi'},
    }) +
    _ev('adlar', {
      'adlar': {'Üye-1': 'Ayşe Yılmaz'},
    }) +
    _ev('kaynaklar', {
      'kaynaklar': ['gorev_dagilimi'],
    }) +
    _ev('kullanim', {'giris_token': 120, 'cikis_token': 40}) +
    _ev('bitti', {'sohbet_id': 's1'});

Matcher _apiError(String code, [int? status]) => throwsA(
  isA<ApiError>()
      .having((e) => e.code, 'code', code)
      .having((e) => e.status, 'status', status ?? anything),
);

void main() {
  group('chat', () {
    test(
      'istek: POST yolu, gövde, Accept, akış yanıtı, operationId metaverisi',
      () async {
        final (repo, a) = _repo((_) => _sse(_ev('bitti', {'sohbet_id': 's1'})));
        await repo.chat(_q).toList();
        final o = a.seen.single;
        expect((o.method, o.uri.path), ('POST', '/v1/assistant/chat'));
        expect(o.responseType, ResponseType.stream);
        expect(o.headers[Headers.acceptHeader], 'text/event-stream');
        expect((o.extra['openapi'] as Map)['operationId'], 'assistantChat');
        expect(a.bodies.single, {'soru': 'Bu hafta kaç görev bitti?'});

        final (repo2, a2) = _repo(
          (_) => _sse(_ev('bitti', {'sohbet_id': 's1'})),
        );
        await repo2
            .chat(const AssistantQuestion(text: 'devam', conversationId: 's1'))
            .toList();
        expect(a2.bodies.single, {'soru': 'devam', 'sohbet_id': 's1'});
      },
    );

    test('başarılı akış: olay sırası ve eşleme', () async {
      final (repo, _) = _repo((_) => _sse(_success));
      final events = await repo.chat(_q).toList();
      expect(events.map((e) => e.runtimeType).toList(), [
        AssistantTextChunk,
        AssistantToolUse,
        AssistantTextChunk,
        AssistantViewRequest,
        AssistantNames,
        AssistantSources,
        AssistantUsage,
        AssistantDone,
      ]);
      expect((events[0] as AssistantTextChunk).text, 'Bu hafta ');
      final tool = events[1] as AssistantToolUse;
      expect(
        (tool.tool, tool.label),
        (AssistantTool.taskDistribution, 'Görev dağılımı'),
      );
      final view = events[3] as AssistantViewRequest;
      expect(view.view, 'gorevler');
      expect(view.filter, {'durum': 'tamamlandi'});
      final alias = (events[4] as AssistantNames).aliases.single;
      expect((alias.alias, alias.displayName), ('Üye-1', 'Ayşe Yılmaz'));
      expect((events[5] as AssistantSources).tools, ['gorev_dagilimi']);
      final usage = events[6] as AssistantUsage;
      expect((usage.inputTokens, usage.outputTokens), (120, 40));
      expect((events[7] as AssistantDone).conversationId, 's1');
    });

    test(
      'bölünmüş parçalar (bayt bayt, 7 baytlık) aynı olayları verir',
      () async {
        final (whole, _) = _repo((_) => _sse(_success));
        final expected = (await whole.chat(_q).toList())
            .map((e) => e.runtimeType)
            .toList();
        for (final every in [1, 7]) {
          final (repo, _) = _repo((_) => _sse(_success, every: every));
          final events = await repo.chat(_q).toList();
          expect(events.map((e) => e.runtimeType).toList(), expected);
          expect(
            events.whereType<AssistantTextChunk>().map((e) => e.text).join(),
            'Bu hafta Üye-1 iki görev bitirdi.',
            reason: 'every=$every',
          );
        }
      },
    );

    test('akış başladıktan sonra hata: tek AssistantFailure, bitti yok, istisna yok', () async {
      final (repo, _) = _repo(
        (_) => _sse(
          _ev('metin', {'metin': 'Yarım'}) +
              _ev('hata', {
                'kod': 'assistant.limit_exceeded',
                'mesaj': 'Soru sınırı aşıldı.',
              }) +
              // Sözleşme dışı: hata sonrası olay okunmaz.
              _ev('bitti', {'sohbet_id': 's1'}),
        ),
      );
      final events = await repo.chat(_q).toList();
      expect(events, hasLength(2));
      expect(events.first, isA<AssistantTextChunk>());
      final f = events.last as AssistantFailure;
      expect(
        (f.code, f.message),
        ('assistant.limit_exceeded', 'Soru sınırı aşıldı.'),
      );
    });

    test('hata olayının dört sözleşme kodu korunur; bilinmeyen kod → platform.internal', () async {
      for (final (wire, code) in [
        ('assistant.refused', 'assistant.refused'),
        ('assistant.provider_unavailable', 'assistant.provider_unavailable'),
        ('platform.internal', 'platform.internal'),
        ('assistant.yeni_kod', 'platform.internal'),
      ]) {
        final (repo, _) = _repo(
          (_) => _sse(_ev('hata', {'kod': wire, 'mesaj': 'm'})),
        );
        final f = (await repo.chat(_q).single) as AssistantFailure;
        expect(f.code, code, reason: wire);
      }
    });

    test('bilinmeyen olay yok sayılır; bilinmeyen araç → unknown', () async {
      final (repo, _) = _repo(
        (_) => _sse(
          ': yorum\n\n'
          '${_ev('yeni_olay', {'x': 1})}'
          '${_ev('arac', {'arac': 'yeni_arac', 'etiket': 'E'})}'
          '${_ev('bitti', {'sohbet_id': 's2'})}',
        ),
      );
      final events = await repo.chat(_q).toList();
      expect((events.first as AssistantToolUse).tool, AssistantTool.unknown);
      expect((events.last as AssistantDone).conversationId, 's2');
      expect(events, hasLength(2));
    });

    test(
      'akış bitti/hata olmadan kapanırsa olaylardan sonra invalid_response',
      () async {
        final (repo, _) = _repo((_) => _sse(_ev('metin', {'metin': 'a'})));
        final got = <AssistantEvent>[];
        await expectLater(
          repo.chat(_q).forEach(got.add),
          _apiError(ClientErrorCode.invalidResponse),
        );
        expect(got.single, isA<AssistantTextChunk>());
      },
    );

    test('bilinen olayın gövdesi şemaya uymazsa invalid_response', () async {
      for (final body in [
        'event: metin\ndata: {bozuk\n\n',
        _ev('metin', {'yanlis': 'a'}),
        _ev('bitti', ['s1']),
      ]) {
        final (repo, _) = _repo((_) => _sse(body));
        await expectLater(
          repo.chat(_q).toList(),
          _apiError(ClientErrorCode.invalidResponse),
          reason: body,
        );
      }
    });

    test('akış ortasında zaman aşımı → client.timeout; başka akış hatası → network_error', () async {
      final (repo, _) = _repo(
        (o) => _sse(
          _ev('metin', {'metin': 'a'}),
          errorAtEnd: DioException(
            requestOptions: o,
            type: DioExceptionType.receiveTimeout,
          ),
        ),
      );
      await expectLater(
        repo.chat(_q).toList(),
        _apiError(ClientErrorCode.timeout),
      );
      final (repo2, _) = _repo(
        (_) => _sse(
          _ev('metin', {'metin': 'a'}),
          errorAtEnd: const HttpException('koptu'),
        ),
      );
      await expectLater(
        repo2.chat(_q).toList(),
        _apiError(ClientErrorCode.networkError),
      );
    });

    test(
      'akış başlamadan doğan hata: zarf → ApiError (kod, durum, request_id)',
      () async {
        for (final (status, code) in [
          (429, 'assistant.quota_exceeded'),
          (409, 'assistant.busy'),
          (404, 'assistant.not_found'),
          (422, 'assistant.input_invalid'),
        ]) {
          final (repo, _) = _repo((_) => _err(status, code));
          await expectLater(
            repo.chat(_q).toList(),
            throwsA(
              isA<ApiError>()
                  .having((e) => e.code, 'code', code)
                  .having((e) => e.status, 'status', status)
                  .having((e) => e.requestId, 'request_id', 'req-1'),
            ),
          );
        }
      },
    );

    test(
      'uç bayrağı kapalı: 404 platform.route_not_found → AssistantDisabled',
      () async {
        final (repo, _) = _repo((_) => _err(404, 'platform.route_not_found'));
        await expectLater(
          repo.chat(_q).toList(),
          throwsA(
            isA<AssistantDisabled>().having((e) => e.requestId, 'id', 'req-1'),
          ),
        );
      },
    );

    test(
      'dinleyici bırakınca istek iptal edilir; kalan olay okunmaz',
      () async {
        final gate = StreamController<Uint8List>();
        final (repo, a) = _repo(
          (_) => ResponseBody(
            gate.stream,
            200,
            headers: {
              Headers.contentTypeHeader: ['text/event-stream'],
            },
          ),
        );
        final first = Completer<AssistantEvent>();
        final sub = repo.chat(_q).listen(first.complete);
        gate.add(Uint8List.fromList(utf8.encode(_ev('metin', {'metin': 'a'}))));
        expect(await first.future, isA<AssistantTextChunk>());
        await sub.cancel();
        await pumpEventQueue();
        expect(a.cancelled, isTrue);
        await gate.close();
      },
    );
  });

  group('listConversations', () {
    Map<String, Object?> conv(String id) => {
      'id': id,
      'baslik': 'Görevler',
      'created_at': _t,
      'updated_at': _t,
    };

    test('GET, eşleme, kesilme başlığı', () async {
      final (repo, a) = _repo(
        (_) => _json(
          {
            'conversations': [conv('s1'), conv('s2')],
          },
          200,
          {
            'X-Result-Truncated': ['true'],
          },
        ),
      );
      final r = await repo.listConversations();
      final o = a.seen.single;
      expect((o.method, o.uri.path), ('GET', '/v1/assistant/conversations'));
      expect(r.items.map((c) => c.id), ['s1', 's2']);
      final c = r.items.first;
      expect(
        (c.title, c.createdAt),
        ('Görevler', DateTime.utc(2026, 11, 3, 7)),
      );
      expect(r.truncated, isTrue);
      expect(r.hasMore, isFalse);
    });

    test('başlık yoksa kesilme yok', () async {
      final (repo, _) = _repo((_) => _json({'conversations': <Object?>[]}));
      final r = await repo.listConversations();
      expect(r.items, isEmpty);
      expect(r.truncated, isFalse);
    });

    test('kapalı → AssistantDisabled; diğer hata → ApiError', () async {
      final (repo, _) = _repo((_) => _err(404, 'platform.route_not_found'));
      await expectLater(
        repo.listConversations(),
        throwsA(isA<AssistantDisabled>()),
      );
      final (repo2, _) = _repo((_) => _err(404, 'program.not_found'));
      await expectLater(
        repo2.listConversations(),
        _apiError('program.not_found', 404),
      );
    });
  });

  group('getConversation', () {
    test('GET, sohbet + mesajlar (rol eşleme, bilinmeyen rol)', () async {
      final (repo, a) = _repo(
        (_) => _json({
          'conversation': {
            'id': 's1',
            'baslik': 'B',
            'created_at': _t,
            'updated_at': _t,
          },
          'messages': [
            {'sira': 1, 'rol': 'kullanici', 'icerik': 'Soru', 'created_at': _t},
            {'sira': 2, 'rol': 'asistan', 'icerik': 'Cevap', 'created_at': _t},
            {'sira': 3, 'rol': 'arac', 'icerik': '?', 'created_at': _t},
          ],
        }),
      );
      final d = await repo.getConversation('s1');
      expect(a.seen.single.uri.path, '/v1/assistant/conversations/s1');
      expect(d.conversation.id, 's1');
      expect(d.messages.map((m) => (m.order, m.role, m.content)), [
        (1, AssistantMessageRole.user, 'Soru'),
        (2, AssistantMessageRole.assistant, 'Cevap'),
        (3, AssistantMessageRole.unknown, '?'),
      ]);
    });

    test('assistant.not_found → ApiError; kapalı → AssistantDisabled; bozuk → invalid_response', () async {
      final (repo, _) = _repo((_) => _err(404, 'assistant.not_found'));
      await expectLater(
        repo.getConversation('x'),
        _apiError('assistant.not_found', 404),
      );
      final (repo2, _) = _repo((_) => _err(404, 'platform.route_not_found'));
      await expectLater(
        repo2.getConversation('x'),
        throwsA(isA<AssistantDisabled>()),
      );
      final (repo3, _) = _repo((_) => _json({'conversation': 1}));
      await expectLater(
        repo3.getConversation('x'),
        _apiError(ClientErrorCode.invalidResponse),
      );
    });
  });

  group('deleteConversation', () {
    test('DELETE 204', () async {
      final (repo, a) = _repo((_) => ResponseBody.fromString('', 204));
      await repo.deleteConversation('s1');
      final o = a.seen.single;
      expect(
        (o.method, o.uri.path),
        ('DELETE', '/v1/assistant/conversations/s1'),
      );
    });

    test(
      'assistant.not_found → ApiError; kapalı → AssistantDisabled',
      () async {
        final (repo, _) = _repo((_) => _err(404, 'assistant.not_found'));
        await expectLater(
          repo.deleteConversation('x'),
          _apiError('assistant.not_found'),
        );
        final (repo2, _) = _repo((_) => _err(404, 'platform.route_not_found'));
        await expectLater(
          repo2.deleteConversation('x'),
          throwsA(isA<AssistantDisabled>()),
        );
      },
    );
  });

  test('AssistantDisabled.matches yalnız 404 + platform.route_not_found', () {
    expect(
      AssistantDisabled.matches(status: 404, code: 'platform.route_not_found'),
      isTrue,
    );
    expect(
      AssistantDisabled.matches(status: 404, code: 'assistant.not_found'),
      isFalse,
    );
    expect(
      AssistantDisabled.matches(status: null, code: 'platform.route_not_found'),
      isFalse,
    );
    expect(
      AssistantDisabled.matches(status: 400, code: 'platform.route_not_found'),
      isFalse,
    );
  });

  group('gerçek ara katman zinciri', () {
    late Harness h;
    late ResponseBody Function(Seen r) chat;

    setUp(() async {
      chat = (_) => _sse(
        _ev('metin', {'metin': 'a'}) + _ev('bitti', {'sohbet_id': 's1'}),
      );
      h = Harness(
        handler: (r) => switch ('${r.method} ${r.path}') {
          'POST /v1/auth/login' => jsonResponse(200, loginBody('1')),
          'POST /v1/assistant/chat' => chat(r),
          _ => discoveryHandler(r),
        },
      );
      await h.read(serverBindingProvider).verify(testUrl);
      await h.identity.login(email: 'a@b.test', password: 'Gizli-Parola-1');
      h.read(scopeControllerProvider).selectProgram('prog-7');
    });

    tearDown(() => h.dispose());

    ApiAssistantRepository repo() =>
        ApiAssistantRepository(h.read(apiDioProvider)!);

    test(
      'kapı işlemi tanır: Bearer, program, CSRF başlığı; akış olayları gelir',
      () async {
        final events = await repo().chat(_q).toList();
        expect(events.last, isA<AssistantDone>());
        final r = h.backend.requests.last;
        expect(r.path, '/v1/assistant/chat');
        expect(r.header('Authorization'), 'Bearer access-token-1');
        expect(r.header('X-Nizamio-Program'), 'prog-7');
        expect(r.header('X-Requested-With'), isNotEmpty);
        expect(r.body, {'soru': 'Bu hafta kaç görev bitti?'});
      },
    );

    test('hata halkasından geçen akış hatası zarfı okunur; kapalı uç → AssistantDisabled', () async {
      chat = (_) => envelope(429, 'assistant.quota_exceeded');
      await expectLater(
        repo().chat(_q).toList(),
        _apiError('assistant.quota_exceeded', 429),
      );
      chat = (_) => envelope(404, 'platform.route_not_found');
      await expectLater(
        repo().chat(_q).toList(),
        throwsA(isA<AssistantDisabled>()),
      );
    });

    test('BİLİNEN SINIR: akış isteğinde 401 yenileme tetiklemez (gövde akış; envanter-v030)', () async {
      chat = (_) => envelope(401, 'platform.unauthenticated');
      await expectLater(
        repo().chat(_q).toList(),
        _apiError('platform.unauthenticated', 401),
      );
      expect(h.backend.count('POST', '/v1/auth/refresh'), 0);
      expect(h.backend.count('POST', '/v1/assistant/chat'), 1);
    });
  });
}
