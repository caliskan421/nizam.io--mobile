// ApiChatRepository: istek parametreleri (imleçli liste sayfaları, geçmiş imleçleri, aday
// amacı), gövdeler (`client_message_id`, `expected_revision`, okundu), `Idempotency-Key`,
// 409 eşlemesi, DTO → domain eşlemesi ve SSE akış okuyucusu (olay ayrıştırma, yorum/ping ve
// bilinmeyen olay yok sayılır, açılış hatası zarfla).
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/messages/data/chat_api_repository.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

import 'chat_http.dart';

Map<String, Object?> _summary(String id, {String kind = 'direct'}) => {
  'chat_id': id,
  'kind': kind,
  'name': kind == 'group' ? 'Genel' : null,
  'source': 'manual',
  'source_department_id': null,
  'auto_kind': kind == 'group' ? 'general' : null,
  'created_by_account_id': null,
  'counterpart_account_id': kind == 'group' ? null : 'acc-2',
  'counterpart_name': kind == 'group' ? null : 'Kadir Özbek',
  'last_seq': 7,
  'last_message_at': '2026-11-09T07:30:00Z',
  'created_at': '2026-11-01T07:00:00Z',
  'unread_count': 2,
  'mentioned': true,
  'last_message': {
    'message_id': 'm7',
    'seq': 7,
    'sender_account_id': 'acc-2',
    'sender_name': 'Kadir Özbek',
    'body': null,
    'deleted': true,
    'created_at': '2026-11-09T07:30:00Z',
  },
  'peer_online': kind == 'group' ? null : true,
  'peer_last_seen_at': null,
};

Map<String, Object?> _message(int seq, {String sender = 'acc-2'}) => {
  'message_id': 'm$seq',
  'chat_id': 'c1',
  'seq': seq,
  'sender_account_id': sender,
  'sender_name': 'Kadir Özbek',
  'client_message_id': 'cid-$seq',
  'body': 'metin $seq',
  'reply_to_message_id': seq > 1 ? 'm1' : null,
  'reply_to': seq > 1
      ? {
          'message_id': 'm1',
          'sender_account_id': null,
          'sender_name': null,
          'body': null,
          'deleted': true,
        }
      : null,
  'edited': seq == 2,
  'edited_at': null,
  'created_at': '2026-11-09T07:0$seq:00Z',
  'mentions': <Object>[],
  'refs': <Object>[],
  'task_ids': <Object>[],
  'reactions': [
    {'kind': 'heart', 'count': 2, 'mine': true},
    {'kind': 'yeni-tur', 'count': 1, 'mine': false},
  ],
  'pinned_at': null,
  'poll': null,
  'attachments': [
    {
      'attachment_id': 'a1',
      'file_name': 'Rapor.pdf',
      'content_type': 'application/pdf',
      'size_bytes': 1200,
    },
  ],
  'edit_revision': 4,
};

Map<String, Object?> _detail(String id) => {
  for (final e in _summary(id).entries)
    if (!{'unread_count', 'mentioned', 'last_message'}.contains(e.key))
      e.key: e.value,
  'role': 'admin',
};

Stream<Uint8List> _sse(List<String> chunks) => Stream.fromIterable([
  for (final c in chunks) Uint8List.fromList(utf8.encode(c)),
]);

void main() {
  test('liste: imleçli sayfalar birleşir; satır eşlemesi', () async {
    var page = 0;
    // İlk sayfa imleç verir, ikinci boş imleçle biter.
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = _Paged(() => page++);
    final inbox = await ApiChatRepository(() => dio).loadInbox();
    expect(inbox.chats.map((c) => c.id), ['c1', 'c2']);
    expect(inbox.truncated, isFalse);
    final c1 = inbox.chats.first;
    expect(
      (c1.name, c1.group, c1.unread, c1.mention),
      ('Kadir Özbek', false, 2, true),
    );
    expect(
      (c1.last!.deleted, c1.last!.text, c1.peerOnline),
      (true, null, true),
    );
    final g = inbox.chats.last;
    expect((g.name, g.group, g.general), ('Genel', true, true));
  });

  test('geçmiş: imleç parametreleri ve mesaj eşlemesi', () async {
    final (repo, a) = chatRepo({
      'GET /v1/chats/c1/messages': (
        200,
        {
          'items': [_message(2), _message(1)],
          'peer_read_seq': 2,
        },
      ),
    });
    final page = await repo.listMessages('c1', before: 9, limit: 50);
    expect(a.seen.single.queryParameters, {'before': 9, 'limit': 50});
    expect(page.peerReadSeq, 2);
    expect(page.messages.map((m) => m.seq), [1, 2], reason: 'artan sıra');
    final m = page.messages.last;
    expect((m.clientId, m.revision, m.edited), ('cid-2', 4, true));
    expect(m.replyTo!.deleted, isTrue);
    expect(m.reactions.single.kind, ChatReaction.heart);
    expect(m.reactions.single.mine, isTrue);
    expect(m.attachments.single.fileName, 'Rapor.pdf');
    await repo.listMessages('c1', after: 3);
    await repo.listMessages('c1', around: 5, limit: 5);
    expect(a.seen[1].queryParameters, {'after': 3});
    expect(a.seen[2].queryParameters, {'around': 5, 'limit': 5});
  });

  test(
    'gönderim client_message_id; düzenleme expected_revision; okundu; 409',
    () async {
      final (repo, a) = chatRepo({
        'POST /v1/chats/c1/messages': (201, _message(3, sender: 'acc-1')),
        'PATCH /v1/chats/c1/messages/m3': (
          409,
          {
            'code': 'messaging.edit_conflict',
            'message': 'x',
            'request_id': 'r1',
          },
        ),
        'POST /v1/chats/c1/read': (204, null),
        'DELETE /v1/chats/c1/messages/m3': (204, null),
        'POST /v1/chats/c1/typing': (204, null),
      });
      final m = await repo.send(
        'c1',
        const OutgoingMessage(clientId: 'k-1', text: 'selam', replyTo: 'm1'),
      );
      expect(m.id, 'm3');
      expect(sentJson(a.only('POST', '/v1/chats/c1/messages')), {
        'client_message_id': 'k-1',
        'body': 'selam',
        'reply_to_message_id': 'm1',
      });
      await expectLater(
        repo.edit('c1', 'm3', text: 'yeni', expectedRevision: 4),
        throwsA(
          isA<ApiError>()
              .having((e) => e.code, 'code', 'messaging.edit_conflict')
              .having((e) => e.status, 'status', 409),
        ),
      );
      expect(sentJson(a.only('PATCH', '/v1/chats/c1/messages/m3')), {
        'body': 'yeni',
        'expected_revision': 4,
      });
      await repo.markRead('c1', 'm3');
      expect(sentJson(a.only('POST', '/v1/chats/c1/read')), {
        'message_id': 'm3',
      });
      await repo.delete('c1', 'm3');
      await repo.typing('c1');
      expect(a.seen.last.path, '/v1/chats/c1/typing');
    },
  );

  test('adaylar purpose ile; birebir; grup Idempotency-Key ile', () async {
    final (repo, a) = chatRepo({
      'GET /v1/chats/candidates': (
        200,
        {
          'items': [
            {
              'account_id': 'acc-2',
              'full_name': 'Kadir',
              'role': 'coordinator',
            },
          ],
          'truncated': true,
        },
      ),
      'POST /v1/chats/direct': (200, _detail('d1')),
      'POST /v1/chats/groups': (201, _detail('g1')),
      'POST /v1/chats/read-all': (204, null),
    });
    final list = await repo.candidates(ChatCandidatePurpose.group);
    expect(a.seen.single.uri.queryParameters, {'purpose': 'group'});
    expect(list.truncated, isTrue);
    expect(list.items.single.role, ChatCandidateRole.coordinator);
    final d = await repo.openDirect('acc-2');
    expect(d.role, ChatMemberRole.admin);
    expect(sentJson(a.only('POST', '/v1/chats/direct')), {
      'account_id': 'acc-2',
    });
    await repo.createGroup(
      GroupDraft(name: ' Saha ', memberIds: const ['b', 'a', 'b']),
      requestKey: 'anahtar-anahtar-anahtar-1',
    );
    final g = a.only('POST', '/v1/chats/groups');
    expect(g.headers['Idempotency-Key'], 'anahtar-anahtar-anahtar-1');
    expect(sentJson(g), {
      'name': 'Saha',
      'member_account_ids': ['a', 'b'],
    });
    await repo.markAllRead();
    expect(a.seen.last.path, '/v1/chats/read-all');
  });

  group('akış (SSE)', () {
    test(
      'açılış sinyali, olaylar; yorum, ping ve bilinmeyen olay yok sayılır',
      () async {
        final (repo, a) = chatRepo({
          'GET /v1/chats/stream': _sse([
            ': ok\n\n',
            'event: message.created\ndata: {"chat_id":"c1","message_id":"m9",',
            '"actor_account_id":"acc-2","affected_account_ids":[]}\n\n',
            ': ping\n\n',
            'event: presence\ndata: {}\n\n',
            'event: typing\ndata: {"chat_id":"c1","message_id":null,'
                '"actor_account_id":"acc-2","affected_account_ids":[]}\n\n',
          ]),
        });
        final got = await repo.events().toList();
        expect(got.first, isA<ChatStreamOpened>());
        final events = got.whereType<ChatEvent>().toList();
        expect(events.map((e) => e.kind), [
          ChatEventKind.messageCreated,
          ChatEventKind.typing,
        ]);
        expect((events.first.chatId, events.first.messageId), ('c1', 'm9'));
        final req = a.seen.single;
        expect(req.responseType, ResponseType.stream);
        expect(req.headers['Accept'], 'text/event-stream');
        expect(req.extra['openapi'], isNotNull, reason: 'kapı metaverisi');
      },
    );

    test('şemaya uymayan olay yükü invalid_response', () async {
      final (repo, _) = chatRepo({
        'GET /v1/chats/stream': _sse([
          'event: message.deleted\ndata: {"x":1}\n\n',
        ]),
      });
      await expectLater(
        repo.events().toList(),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            'client.invalid_response',
          ),
        ),
      );
    });

    test('açılış hatası zarfla eşlenir', () async {
      final (repo, _) = chatRepo({
        'GET /v1/chats/stream': (
          403,
          {
            'code': 'messaging.not_authorized',
            'message': 'x',
            'request_id': 'r',
          },
        ),
      });
      await expectLater(
        repo.events().toList(),
        throwsA(
          isA<ApiError>()
              .having((e) => e.code, 'code', 'messaging.not_authorized')
              .having((e) => e.status, 'status', 403),
        ),
      );
    });
  });
}

/// `listChats` sayfalayan bağdaştırıcı: 0 → c1 + imleç, 1 → c2 + boş imleç.
class _Paged implements HttpClientAdapter {
  _Paged(this.next);
  final int Function() next;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final page = next();
    expect(options.queryParameters['limit'], 200);
    expect(options.queryParameters['cursor'], page == 0 ? null : 'p2');
    return ResponseBody.fromString(
      jsonEncode({
        'items': [page == 0 ? _summary('c1') : _summary('c2', kind: 'group')],
        'next_cursor': page == 0 ? 'p2' : '',
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
