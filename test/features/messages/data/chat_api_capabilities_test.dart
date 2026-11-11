import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/messages/data/chat_api_repository.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

import 'chat_http.dart';

Map<String, Object?> _chat({String source = 'department'}) => {
  'chat_id': 'c1',
  'kind': 'group',
  'name': 'Saha',
  'source': source,
  'source_department_id': source == 'department' ? 'd1' : null,
  'auto_kind': null,
  'created_by_account_id': 'a1',
  'counterpart_account_id': null,
  'counterpart_name': null,
  'last_seq': 1,
  'last_message_at': null,
  'created_at': '2026-11-01T07:00:00Z',
  'role': 'admin',
};

Map<String, Object?> _message() => {
  'message_id': 'm1',
  'chat_id': 'c1',
  'seq': 1,
  'sender_account_id': 'a1',
  'client_message_id': 'k1',
  'body': 'Paylaşım',
  'reply_to_message_id': null,
  'edited': false,
  'edited_at': null,
  'created_at': '2026-11-09T07:00:00Z',
  'mentions': <Object>[],
  'refs': <Object>[],
  'task_ids': <Object>[],
  'reactions': <Object>[],
  'pinned_at': null,
  'poll': null,
  'attachments': <Object>[],
  'edit_revision': 1,
};

void main() {
  test('referanslar ve anket son tarihi gönderimde aynen korunur', () async {
    final (repo, adapter) = chatRepo({
      'POST /v1/chats/c1/messages': (201, _message()),
    });
    final closes = DateTime.parse('2026-12-01T12:30:00+03:00');
    final out = OutgoingMessage(
      clientId: 'once',
      text: 'Paylaşım',
      mentions: const [ChatMention.department('d1')],
      refs: const [
        ChatRefDraft(kind: ChatRefKind.task, targetId: 't1'),
        ChatRefDraft(kind: ChatRefKind.department, targetId: 'd1'),
        ChatRefDraft(kind: ChatRefKind.file, targetId: 'f1'),
      ],
      poll: PollDraft(options: const [' A ', 'B'], closesAt: closes),
    );
    await repo.send('c1', out);
    await repo.send('c1', out);
    expect(
      adapter.seen,
      hasLength(2),
      reason: 'iki açık çağrı, otomatik tekrar yok',
    );
    final body = sentJson(adapter.seen.first) as Map;
    expect(sentJson(adapter.seen.last), body, reason: 'aynı kimlik ve gövde');
    expect(body['client_message_id'], 'once');
    expect(body['refs'], [
      {'kind': 'task', 'target_id': 't1'},
      {'kind': 'department', 'target_id': 'd1'},
      {'kind': 'file', 'target_id': 'f1'},
    ]);
    expect(body['mentions'], [
      {'kind': 'department', 'target_id': 'd1'},
    ]);
    expect(body['poll'], {
      'options': ['A', 'B'],
      'multi': false,
      'closes_at': '2026-12-01T09:30:00.000Z',
    });
  });

  test(
    'kaynaklı grup ve açık none PATCH; ad değiştirme kaynağı değiştirmez',
    () async {
      final (repo, adapter) = chatRepo({
        'POST /v1/chats/groups': (201, _chat()),
        'PATCH /v1/chats/c1': (200, _chat(source: 'none')),
        'GET /v1/chats/c1': (200, _chat()),
      });
      final draft = GroupDraft(
        name: ' Saha ',
        memberIds: const ['b', 'a', 'b'],
        source: ChatSource.department,
        sourceDepartmentId: 'd1',
      );
      final created = await repo.createGroup(draft, requestKey: 'same-key');
      expect(
        (created.source, created.sourceDepartmentId),
        (ChatSource.department, 'd1'),
      );
      expect(sentJson(adapter.seen.single), {
        'name': 'Saha',
        'member_account_ids': ['a', 'b'],
        'source': 'department',
        'source_department_id': 'd1',
      });
      expect(adapter.seen.single.headers['Idempotency-Key'], 'same-key');
      await repo.updateSource('c1', ChatSource.none);
      expect(sentJson(adapter.seen.last), {'source': 'none'});
      await repo.updateSource('c1', ChatSource.program);
      expect(sentJson(adapter.seen.last), {'source': 'program'});
      await repo.updateSource('c1', ChatSource.department, departmentId: 'd2');
      expect(sentJson(adapter.seen.last), {
        'source': 'department',
        'source_department_id': 'd2',
      });
      await repo.rename('c1', 'Yeni');
      expect(sentJson(adapter.seen.last), {'name': 'Yeni'});
      final detail = await repo.getChat('c1');
      expect(detail.copyWith(unread: 2).sourceDepartmentId, 'd1');
    },
  );

  test(
    'ek açıklaması ve yanıt sorgusu aynı multipart gönderimde korunur',
    () async {
      final dir = await Directory.systemTemp.createTemp('chat-caption');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/report.pdf')..writeAsBytesSync([1, 2]);
      final (repo, adapter) = chatRepo({
        'POST /v1/chats/c1/attachments': (201, _message()),
      });
      await repo.sendAttachment(
        'c1',
        'same-client-id',
        ChatUpload(
          path: file.path,
          name: 'report.pdf',
          sizeBytes: 2,
          contentType: 'application/pdf',
        ),
        caption: 'Açıklama',
        replyTo: 'm0',
      );
      final request = adapter.seen.single;
      final form = request.data as FormData;
      expect(Map.fromEntries(form.fields), {'body': 'Açıklama'});
      expect(form.files.single.value.contentType.toString(), 'application/pdf');
      expect(request.queryParameters, {
        'client_message_id': 'same-client-id',
        'reply_to_message_id': 'm0',
      });
    },
  );

  test(
    'liste sorgusu bütün sayfalarda taşınır; tekrar imleci sınırlı kesilir',
    () async {
      final adapter = _SearchPages();
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter;
      final inbox = await ApiChatRepository(() => dio)
          .loadInbox(query: ' eski içerik ', isCurrent: () => true);
      expect(adapter.seen, hasLength(2));
      expect(
        adapter.seen.map((r) => r.queryParameters['q']),
        everyElement('eski içerik'),
      );
      expect(inbox.truncated, isTrue);
      expect(inbox.chats.first.source, ChatSource.department);
      expect(inbox.chats.first.sourceDepartmentId, 'd1');
    },
  );

  test(
    'ilk sayfa uçuşunda kapsam değişirse ikinci istek gönderilmez',
    () async {
      final adapter = _SearchPages()..firstPageGate = Completer<void>();
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter;
      var current = true;
      final inbox = ApiChatRepository(() => dio)
          .loadInbox(query: 'önceki program', isCurrent: () => current);
      final rejected = expectLater(
        inbox,
        throwsA(
          isA<ApiError>().having(
            (error) => error.code,
            'code',
            ClientErrorCode.sessionEnded,
          ),
        ),
      );
      await adapter.firstPageStarted.future;
      current = false;
      adapter.firstPageGate!.complete();
      await rejected;
      expect(adapter.seen, hasLength(1));
      expect(
        adapter.seen.where((r) => r.queryParameters['cursor'] != null),
        isEmpty,
        reason: 'eski cursor ile yeni kapsamda gönderilen istek sayısı sıfır',
      );
    },
  );

  test('okuma öncesi geçersiz kapsamda hiç istek gönderilmez', () async {
    final adapter = _SearchPages();
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = adapter;
    await expectLater(
      ApiChatRepository(() => dio).loadInbox(isCurrent: () => false),
      throwsA(
        isA<ApiError>().having(
          (error) => error.code,
          'code',
          ClientErrorCode.sessionEnded,
        ),
      ),
    );
    expect(adapter.seen, isEmpty);
  });

  test('paylaşılan tür filtresi, bütün programların özeti ve sabit kesilmesi korunur', () async {
    final (repo, adapter) = chatRepo({
      'GET /v1/chats/c1/refs': (
        200,
        {'items': <Object>[], 'next_cursor': null},
      ),
      'GET /v1/me/chat-unread': (
        200,
        {
          'items': [
            {
              'program_id': 'p1',
              'program_name': 'Bir',
              'unread_chats': 3,
              'mentioned': true,
            },
            {
              'program_id': 'p2',
              'program_name': 'İki',
              'unread_chats': 0,
              'mentioned': false,
            },
          ],
        },
      ),
      'GET /v1/chats/c1/pins': (
        200,
        {
          'items': [_message()],
          'truncated': true,
        },
      ),
    });
    await repo.shared('c1', cursor: 'r5', kind: ChatRefKind.file);
    expect(adapter.seen.single.uri.queryParameters, {
      'kind': 'file',
      'cursor': 'r5',
      'limit': '50',
    });
    final overview = await repo.unreadOverview();
    expect(
      overview.map((p) => (p.programId, p.name, p.unreadChats, p.mentioned)),
      [('p1', 'Bir', 3, true), ('p2', 'İki', 0, false)],
    );
    final page = await repo.pinnedPage('c1');
    expect(page.truncated, isTrue);
    expect(page.items.single.id, 'm1');
    expect(adapter.seen, hasLength(3));
  });
}

class _SearchPages implements HttpClientAdapter {
  final seen = <RequestOptions>[];
  Completer<void>? firstPageGate;
  final firstPageStarted = Completer<void>();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    if (seen.length == 1) {
      firstPageStarted.complete();
      await firstPageGate?.future;
    }
    expect(
      options.queryParameters['cursor'],
      seen.length == 1 ? null : 'repeat',
    );
    return ResponseBody.fromString(
      jsonEncode({
        'items': [
          {
            ..._chat(),
            'unread_count': 0,
            'mentioned': false,
            'last_message': null,
          },
        ],
        'next_cursor': 'repeat',
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
