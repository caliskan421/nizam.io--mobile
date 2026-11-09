// ApiChatRepository (K5b uçları): tepki/sabit/oy/bitirme yolları ve gövdeleri, sabit şeridi,
// bahsetme ve anket gönderim gövdesi, ek multipart'ı (`client_message_id` sorguda, `body`
// dosyadan önce, parça türü), indirmeler (akış, kapı metaverisi), üye ve grup uçları, paylaşılanlar
// ve kart eşlemesi, mesajdan görev (`Idempotency-Key`, öncelik değeri), arama (`q`, `before`),
// 409 eşlemesi; mesajda bahsetme/referans/görev ve anket oy verenleri. Ek dosyasının içerik
// akışı gönderimde okunamazsa `client.file_unreadable` (Codex tur 5 / N11).
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

import 'chat_http.dart';

Map<String, Object?> _msg({bool poll = false}) => {
  'message_id': 'm1',
  'chat_id': 'c1',
  'seq': 1,
  'sender_account_id': 'acc-2',
  'client_message_id': 'k1',
  'body': 'Hangisi?',
  'reply_to_message_id': null,
  'edited': false,
  'edited_at': null,
  'created_at': '2026-11-09T07:00:00Z',
  'mentions': [
    {'kind': 'account', 'target_id': 'acc-3'},
    {'kind': 'all'},
    {'kind': 'yeni'},
  ],
  'refs': [
    {'ref_id': 'r1', 'kind': 'file', 'target_id': 'f1'},
    {'ref_id': 'r2', 'kind': 'yeni', 'target_id': 'x'},
  ],
  'task_ids': ['w1'],
  'reactions': <Object>[],
  'pinned_at': '2026-11-09T08:00:00Z',
  'poll': poll
      ? {
          'multi': false,
          'closes_at': null,
          'closed_at': null,
          'results': [
            {
              'option_index': 1,
              'label': 'B',
              'count': 1,
              'voters': [
                {'account_id': 'acc-1', 'full_name': 'Ayşe'},
              ],
            },
            {'option_index': 0, 'label': 'A', 'count': 0, 'voters': <Object>[]},
          ],
        }
      : null,
  'attachments': <Object>[],
  'edit_revision': 0,
};

Map<String, Object?> _chat(String name) => {
  'chat_id': 'c1',
  'kind': 'group',
  'name': name,
  'source': 'none',
  'source_department_id': null,
  'auto_kind': null,
  'created_by_account_id': null,
  'counterpart_account_id': null,
  'counterpart_name': null,
  'last_seq': 1,
  'last_message_at': null,
  'created_at': '2026-11-01T07:00:00Z',
  'role': 'founder',
};

Stream<Uint8List> _bytes() => Stream.value(Uint8List.fromList([1, 2, 3]));

void main() {
  test(
    'tepki, sabit, oy, bitirme: yollar ve gövdeler; 409 poll_closed',
    () async {
      final (repo, a) = chatRepo({
        'PUT /v1/chats/c1/messages/m1/reaction': (204, null),
        'DELETE /v1/chats/c1/messages/m1/reaction': (204, null),
        'PUT /v1/chats/c1/messages/m1/pin': (204, null),
        'DELETE /v1/chats/c1/messages/m1/pin': (204, null),
        'GET /v1/chats/c1/pins': (
          200,
          {
            'items': [_msg()],
            'truncated': false,
          },
        ),
        'PUT /v1/chats/c1/messages/m1/vote': (
          409,
          {'code': 'messaging.poll_closed', 'message': 'x', 'request_id': 'r'},
        ),
        'POST /v1/chats/c1/messages/m1/poll/close': (204, null),
      });
      await repo.setReaction('c1', 'm1', ChatReaction.check);
      expect(sentJson(a.seen.last), {'kind': 'check'});
      await repo.clearReaction('c1', 'm1');
      await repo.pin('c1', 'm1');
      await repo.unpin('c1', 'm1');
      final pins = await repo.pins('c1');
      expect(pins.single.pinned, isTrue);
      await expectLater(
        repo.vote('c1', 'm1', {2, 0}),
        throwsA(
          isA<ApiError>()
              .having((e) => e.code, 'code', 'messaging.poll_closed')
              .having((e) => e.status, 'status', 409),
        ),
      );
      expect(sentJson(a.only('PUT', '/v1/chats/c1/messages/m1/vote')), {
        'option_indexes': [0, 2],
      });
      await repo.closePoll('c1', 'm1');
      expect(
        [for (final o in a.seen) '${o.method} ${o.path}'],
        containsAll([
          'DELETE /v1/chats/c1/messages/m1/reaction',
          'PUT /v1/chats/c1/messages/m1/pin',
          'DELETE /v1/chats/c1/messages/m1/pin',
          'POST /v1/chats/c1/messages/m1/poll/close',
        ]),
      );
      expect(
        a.seen.first.extra['openapi'],
        isNotNull,
        reason: 'kapı metaverisi',
      );
    },
  );

  test(
    'mesaj eşlemesi: bahsetme, referans, görev, anket oy verenleri',
    () async {
      final (repo, a) = chatRepo({
        'POST /v1/chats/c1/messages': (201, _msg(poll: true)),
      });
      final m = await repo.send(
        'c1',
        OutgoingMessage(
          clientId: 'k1',
          text: 'Hangisi?',
          mentions: const [ChatMention.account('acc-3'), ChatMention.all()],
          poll: PollDraft(options: const [' A ', 'B'], multi: true),
        ),
      );
      expect(sentJson(a.seen.single), {
        'client_message_id': 'k1',
        'body': 'Hangisi?',
        'mentions': [
          {'kind': 'account', 'target_id': 'acc-3'},
          {'kind': 'all'},
        ],
        'poll': {
          'options': ['A', 'B'],
          'multi': true,
        },
      });
      expect(m.mentions, [
        const ChatMention.account('acc-3'),
        const ChatMention.all(),
      ]);
      expect(m.refs.single.refId, 'r1', reason: 'bilinmeyen tür atlanır');
      expect(m.taskIds, ['w1']);
      expect(m.poll!.options.map((o) => o.label), ['A', 'B']);
      expect(m.poll!.mine('acc-1'), {1});
      expect(m.poll!.options[1].voters.single.name, 'Ayşe');
    },
  );

  test(
    'ek: multipart sırası ve türü, sorguda istemci kimliği; indirmeler akış',
    () async {
      final dir = await Directory.systemTemp.createTemp('k5b');
      addTearDown(() => dir.delete(recursive: true));
      final f = File('${dir.path}/r.pdf')..writeAsBytesSync([1, 2, 3]);
      final (repo, a) = chatRepo({
        'POST /v1/chats/c1/attachments': (201, _msg()),
        'GET /v1/chat-attachments/a%201': _bytes(),
        'GET /v1/chat-file-refs/r1': _bytes(),
      });
      await repo.sendAttachment(
        'c1',
        'k-9',
        ChatUpload(
          path: f.path,
          name: 'r.pdf',
          sizeBytes: 3,
          contentType: 'application/pdf',
        ),
        replyTo: 'm0',
      );
      final o = a.seen.single;
      expect(o.queryParameters, {
        'client_message_id': 'k-9',
        'reply_to_message_id': 'm0',
      });
      final form = o.data as FormData;
      expect(form.fields, isEmpty);
      expect(form.files.single.key, 'file');
      expect(form.files.single.value.contentType.toString(), 'application/pdf');
      expect(o.extra['openapi'], isNotNull);
      final got = await (await repo.downloadAttachment('a 1'))
          .expand((b) => b)
          .toList();
      expect(got, [1, 2, 3]);
      await (await repo.downloadSharedFile('r1')).drain<void>();
      expect(a.seen.last.responseType, ResponseType.stream);
      expect(a.seen.last.extra['openapi'], isNotNull);
    },
  );

  test('ek: boyut okunur, içerik akışı gönderimde okunamaz → client.file_unreadable', () async {
    final dir = await Directory.systemTemp.createTemp('k5b');
    addTearDown(() => dir.delete(recursive: true));
    final f = File('${dir.path}/r.pdf')..writeAsBytesSync([1, 2, 3]);
    final (repo, a) = chatRepo({
      'POST /v1/chats/c1/attachments': (201, _msg()),
    });
    a.beforeBody = f.deleteSync;
    await expectLater(
      repo.sendAttachment(
        'c1',
        'k-9',
        ChatUpload(
          path: f.path,
          name: 'r.pdf',
          sizeBytes: 3,
          contentType: 'application/pdf',
        ),
      ),
      throwsA(
        isA<ApiError>().having(
          (e) => e.code,
          'code',
          ClientErrorCode.fileUnreadable,
        ),
      ),
    );
  });

  test('üyeler ve grup ayarları', () async {
    final (repo, a) = chatRepo({
      'GET /v1/chats/c1/members': (
        200,
        {
          'items': [
            {
              'account_id': 'acc-1',
              'full_name': 'Ayşe',
              'role': 'founder',
              'founder': true,
              'from_source': false,
            },
            {
              'account_id': 'acc-2',
              'full_name': 'Kadir',
              'role': 'yeni',
              'founder': false,
              'from_source': true,
            },
          ],
          'truncated': true,
        },
      ),
      'POST /v1/chats/c1/members': (204, null),
      'DELETE /v1/chats/c1/members/acc-2': (
        409,
        {
          'code': 'messaging.member_source_managed',
          'message': 'x',
          'request_id': 'r',
        },
      ),
      'PUT /v1/chats/c1/admins/acc-2': (204, null),
      'DELETE /v1/chats/c1/admins/acc-2': (204, null),
      'PATCH /v1/chats/c1': (200, _chat('Yeni')),
      'DELETE /v1/chats/c1': (204, null),
      'GET /v1/chats/candidates': (
        200,
        {'items': <Object>[], 'truncated': false},
      ),
    });
    final members = await repo.members('c1');
    expect(members.truncated, isTrue);
    expect(members.member('acc-1')!.role, ChatMemberRole.founder);
    expect(
      (members.member('acc-2')!.role, members.member('acc-2')!.fromSource),
      (ChatMemberRole.member, true),
    );
    await repo.addMembers('c1', ['acc-3']);
    expect(sentJson(a.seen.last), {
      'account_ids': ['acc-3'],
    });
    await expectLater(
      repo.removeMember('c1', 'acc-2'),
      throwsA(
        isA<ApiError>().having(
          (e) => e.code,
          'code',
          'messaging.member_source_managed',
        ),
      ),
    );
    await repo.setAdmin('c1', 'acc-2', admin: true);
    await repo.setAdmin('c1', 'acc-2', admin: false);
    final c = await repo.rename('c1', ' Yeni ');
    expect(sentJson(a.only('PATCH', '/v1/chats/c1')), {'name': 'Yeni'});
    expect((c.name, c.canManage), ('Yeni', true));
    await repo.deleteChat('c1');
    await repo.candidates(ChatCandidatePurpose.group, chatId: 'c1');
    expect(a.seen.last.uri.queryParameters, {
      'purpose': 'group',
      'chat_id': 'c1',
    });
  });

  test('paylaşılanlar, kart, mesajdan görev, arama', () async {
    final (repo, a) = chatRepo({
      'GET /v1/chats/c1/refs': (
        200,
        {
          'items': [
            {
              'ref_id': 'r1',
              'kind': 'task',
              'target_id': 'w1',
              'message_id': 'm1',
              'sender_account_id': 'acc-2',
              'created_at': '2026-11-09T07:00:00Z',
            },
            {
              'ref_id': 'r0',
              'kind': 'yeni',
              'target_id': 'x',
              'message_id': 'm1',
              'sender_account_id': 'acc-2',
              'created_at': '2026-11-09T07:00:00Z',
            },
          ],
          'next_cursor': 'r1',
        },
      ),
      'GET /v1/chat-refs/r1': (
        200,
        {
          'ref_id': 'r1',
          'kind': 'task',
          'target_id': 'w1',
          'chat_id': 'c1',
          'message_id': 'm1',
          'available': true,
          'task': {
            'title': 'Trafo',
            'status': 'devam_ediyor',
            'department_id': 'd1',
            'department_name': 'Altyapı',
            'assignees': <Object>[],
            'start_on': '2026-11-01',
            'end_on': '2026-11-10',
            'description': 'x',
          },
        },
      ),
      'GET /v1/chat-refs/r2': (
        200,
        {
          'ref_id': 'r2',
          'kind': 'file',
          'target_id': 'f1',
          'chat_id': 'c1',
          'message_id': 'm1',
          'available': false,
        },
      ),
      'POST /v1/chats/c1/messages/m1/tasks': (
        201,
        {'work_item_id': 'w9', 'message': _msg()},
      ),
      'GET /v1/chats/c1/messages': (
        200,
        {
          'items': [_msg()],
          'peer_read_seq': null,
        },
      ),
    });
    final page = await repo.shared('c1', cursor: 'r5');
    expect(a.seen.last.queryParameters, {'cursor': 'r5', 'limit': 50});
    expect(page.items.single.kind, ChatRefKind.task);
    expect(page.nextCursor, 'r1');
    final card = await repo.refCard('r1');
    expect(
      (card.title, card.department, card.end),
      ('Trafo', 'Altyapı', DateTime(2026, 11, 10)),
    );
    expect((await repo.refCard('r2')).available, isFalse);
    final created = await repo.createTask(
      'c1',
      'm1',
      ChatTaskDraft(
        departmentId: 'd1',
        start: DateTime(2026, 11, 10),
        end: DateTime(2026, 11, 12),
        priority: ChatTaskPriority.high,
      ),
      requestKey: 'anahtar-anahtar-anahtar-1',
    );
    final t = a.only('POST', '/v1/chats/c1/messages/m1/tasks');
    expect(t.headers['Idempotency-Key'], 'anahtar-anahtar-anahtar-1');
    expect(sentJson(t), {
      'department_id': 'd1',
      'start_date': '2026-11-10',
      'end_date': '2026-11-12',
      'priority': 'yuksek',
    });
    expect(created.workItemId, 'w9');
    await repo.search('c1', ' trafo ', before: 40);
    expect(a.seen.last.queryParameters, {
      'q': 'trafo',
      'before': 40,
      'limit': chatSearchPageSize,
    });
    expect(jsonEncode(a.seen.last.queryParameters), isNot(contains('after')));
  });
}
