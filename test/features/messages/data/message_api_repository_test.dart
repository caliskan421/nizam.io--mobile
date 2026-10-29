// messages data katmanı: üretilmiş DTO → domain (MailboxMessage/ChatMessage), imleç, alıcı
// grupları, gönderim gövdesi, hata → ApiError.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/messages/data/message_api_repository.dart';
import 'package:nizamio/features/messages/domain/mailbox.dart';

/// Tek yanıtlı sahte bağdaştırıcı; isteği kaydeder.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.body, [this.status = 200]);

  final String body;
  final int status;
  final List<RequestOptions> seen = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiMessageRepository, _Adapter) _repo(String body, {int status = 200}) {
  final adapter = _Adapter(body, status);
  return (
    ApiMessageRepository(
      Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter,
    ),
    adapter,
  );
}

String _env(String code) =>
    jsonEncode({'code': code, 'message': 'x', 'request_id': 'r'});

Matcher _apiError(String code) =>
    throwsA(isA<ApiError>().having((e) => e.code, 'code', code));

Map<String, Object?> _msg({
  String id = 'm1',
  bool read = false,
  String? readAt,
}) => {
  'message_id': id,
  'program_id': 'p1',
  'sender_account_id': 'a-sender',
  'sender_name': 'Ayşe',
  'receiver_account_id': 'a-receiver',
  'receiver_name': 'Bora',
  'subject': 'Konu',
  'content': 'Merhaba',
  'is_read': read,
  'read_at': readAt,
  'created_at': '2026-10-20T10:00:00Z',
};

void main() {
  group('list', () {
    test('inbox → MailboxMessage; örtüşen alanlar ChatMessage\'da', () async {
      final (repo, adapter) = _repo(
        jsonEncode({
          'items': [_msg()],
          'next_cursor': 'c2',
        }),
      );
      final slice = await repo.list(
        MessageBox.inbox,
        page: const PageRequest(limit: 20, cursor: 'c1'),
      );
      final req = adapter.seen.single;
      expect(req.method, 'GET');
      expect(req.uri.path, '/v1/messages');
      expect(req.uri.queryParameters, {
        'filter': 'inbox',
        'limit': '20',
        'cursor': 'c1',
      });
      expect(slice.nextCursor, 'c2');
      expect(slice.hasMore, isTrue);
      final m = slice.items.single;
      expect(m.id, 'm1');
      expect(m.box, MessageBox.inbox);
      expect(m.subject, 'Konu');
      expect(m.programId, 'p1');
      expect(m.senderName, 'Ayşe');
      expect(m.receiverName, 'Bora');
      expect(m.message.from, 'a-sender');
      expect(m.message.to, 'a-receiver');
      expect(m.message.text, 'Merhaba');
      expect(m.message.at, DateTime.utc(2026, 10, 20, 10));
      expect(m.message.read, isFalse);
      expect(m.message.readAt, isNull);
      expect(m.counterpartId, 'a-sender');
      expect(m.counterpartName, 'Ayşe');
    });

    test('sent: filter=sent, karşı taraf alıcı, okunma anı eşlenir', () async {
      final (repo, adapter) = _repo(
        jsonEncode({
          'items': [_msg(read: true, readAt: '2026-10-21T08:00:00Z')],
          'next_cursor': '',
        }),
      );
      final slice = await repo.list(MessageBox.sent);
      expect(adapter.seen.single.uri.queryParameters, {'filter': 'sent'});
      final m = slice.items.single;
      expect(m.box, MessageBox.sent);
      expect(m.message.read, isTrue);
      expect(m.message.readAt, DateTime.utc(2026, 10, 21, 8));
      expect(m.counterpartId, 'a-receiver');
      expect(m.counterpartName, 'Bora');
    });

    test('boş next_cursor → son sayfa', () async {
      final (repo, _) = _repo('{"items":[],"next_cursor":""}');
      final slice = await repo.list(MessageBox.inbox);
      expect(slice.items, isEmpty);
      expect(slice.nextCursor, isNull);
      expect(slice.hasMore, isFalse);
    });

    test('collaboration.invalid_cursor → ApiError', () async {
      final (repo, _) = _repo(
        _env('collaboration.invalid_cursor'),
        status: 422,
      );
      await expectLater(
        repo.list(MessageBox.inbox, page: const PageRequest(cursor: 'bozuk')),
        _apiError('collaboration.invalid_cursor'),
      );
    });

    test('ayrıştırılamayan yanıt → client.invalid_response', () async {
      final (repo, _) = _repo('{"items":null}');
      await expectLater(
        repo.list(MessageBox.inbox),
        _apiError(ClientErrorCode.invalidResponse),
      );
    });
  });

  group('unreadCount', () {
    test('GET /v1/messages/unread-count → sayı', () async {
      final (repo, adapter) = _repo('{"count":7}');
      expect(await repo.unreadCount(), 7);
      expect(adapter.seen.single.uri.path, '/v1/messages/unread-count');
    });

    test('collaboration.not_authorized → ApiError', () async {
      final (repo, _) = _repo(
        _env('collaboration.not_authorized'),
        status: 403,
      );
      await expectLater(
        repo.unreadCount(),
        _apiError('collaboration.not_authorized'),
      );
    });
  });

  group('recipients', () {
    test('gruplar ve anahtar eşlemesi; bilinmeyen anahtar → unknown', () async {
      final (repo, adapter) = _repo(
        jsonEncode({
          'groups': [
            {
              'key': 'admin',
              'recipients': [
                {'account_id': 'a1', 'full_name': 'Yönetici'},
              ],
              'truncated': false,
            },
            {
              'key': 'coordinator',
              'recipients': <Object>[],
              'truncated': false,
            },
            {
              'key': 'member',
              'recipients': [
                {'account_id': 'a2', 'full_name': 'Üye'},
              ],
              'truncated': true,
            },
            {'key': 'yeni_grup', 'recipients': <Object>[], 'truncated': false},
          ],
        }),
      );
      final groups = await repo.recipients();
      expect(adapter.seen.single.uri.path, '/v1/messages/recipients');
      expect(groups.map((g) => g.kind), [
        RecipientGroupKind.admin,
        RecipientGroupKind.coordinator,
        RecipientGroupKind.member,
        RecipientGroupKind.unknown,
      ]);
      expect(groups[0].recipients, const [
        MessageRecipient(accountId: 'a1', fullName: 'Yönetici'),
      ]);
      expect(groups[0].truncated, isFalse);
      expect(groups[2].truncated, isTrue);
    });

    test('yönetici 403 → ApiError', () async {
      final (repo, _) = _repo(
        _env('collaboration.not_authorized'),
        status: 403,
      );
      await expectLater(
        repo.recipients(),
        _apiError('collaboration.not_authorized'),
      );
    });
  });

  group('send', () {
    test('POST /v1/messages gövdesi ve makbuz', () async {
      final (repo, adapter) = _repo(
        jsonEncode({
          'message_id': 'm9',
          'program_id': 'p1',
          'receiver_account_id': 'a2',
          'subject': 'Konu',
          'created_at': '2026-10-22T09:30:00Z',
        }),
      );
      final r = await repo.send(
        receiverAccountId: 'a2',
        subject: 'Konu',
        content: 'Gövde',
      );
      final req = adapter.seen.single;
      expect(req.method, 'POST');
      expect(req.uri.path, '/v1/messages');
      expect(req.data, {
        'receiver_account_id': 'a2',
        'subject': 'Konu',
        'content': 'Gövde',
      });
      expect(r.id, 'm9');
      expect(r.programId, 'p1');
      expect(r.receiverAccountId, 'a2');
      expect(r.subject, 'Konu');
      expect(r.createdAt, DateTime.utc(2026, 10, 22, 9, 30));
    });

    test('matris dışı → ApiError', () async {
      final (repo, _) = _repo(
        _env('collaboration.not_authorized'),
        status: 403,
      );
      await expectLater(
        repo.send(receiverAccountId: 'a2', subject: 's', content: 'c'),
        _apiError('collaboration.not_authorized'),
      );
    });
  });

  group('markRead', () {
    test('POST /v1/messages/{id}/read', () async {
      final (repo, adapter) = _repo('', status: 204);
      await repo.markRead('m1');
      expect(adapter.seen.single.method, 'POST');
      expect(adapter.seen.single.uri.path, '/v1/messages/m1/read');
    });

    test('collaboration.message_not_found → ApiError', () async {
      final (repo, _) = _repo(
        _env('collaboration.message_not_found'),
        status: 404,
      );
      await expectLater(
        repo.markRead('yok'),
        _apiError('collaboration.message_not_found'),
      );
    });
  });

  group('delete', () {
    test('DELETE /v1/messages/{id}', () async {
      final (repo, adapter) = _repo('', status: 204);
      await repo.delete('m1');
      expect(adapter.seen.single.method, 'DELETE');
      expect(adapter.seen.single.uri.path, '/v1/messages/m1');
    });

    test('okunmamışı alıcı silemez: collaboration.message_unread', () async {
      final (repo, _) = _repo(
        _env('collaboration.message_unread'),
        status: 409,
      );
      await expectLater(
        repo.delete('m1'),
        _apiError('collaboration.message_unread'),
      );
    });
  });
}
