// notifications data katmanı: üretilmiş DTO → domain, olay türü enum'u (bilinmeyen →
// unknown), imleç + okunmamış toplamı, push uçları, hata → ApiError.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/notifications/data/notification_api_repository.dart';
import 'package:nizamio/features/notifications/domain/app_notification.dart';

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

(ApiNotificationRepository, _Adapter) _repo(String body, {int status = 200}) {
  final adapter = _Adapter(body, status);
  return (
    ApiNotificationRepository(
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

Map<String, Object?> _n(String id, String type, {bool read = false}) => {
  'id': id,
  'type': type,
  'subject_ref': {'kind': 'work_item', 'id': 'w1'},
  'is_read': read,
  'created_at': '2026-10-20T10:00:00Z',
};

void main() {
  group('list', () {
    test('GET /v1/notifications → feed; tür eşlemesi, imleç', () async {
      final (repo, adapter) = _repo(
        jsonEncode({
          'items': [
            _n('n1', 'work.item.created'),
            _n('n2', 'collaboration.message.sent', read: true),
            _n('n3', 'yeni.olay.turu'),
          ],
          'unread_count': 5,
          'next_cursor': 'c2',
        }),
      );
      final feed = await repo.list(
        page: const PageRequest(limit: 3, cursor: 'c1'),
      );
      final req = adapter.seen.single;
      expect(req.uri.path, '/v1/notifications');
      expect(req.uri.queryParameters, {'limit': '3', 'cursor': 'c1'});
      expect(feed.unreadCount, 5);
      expect(feed.page.nextCursor, 'c2');
      final items = feed.page.items;
      expect(items.map((n) => n.type), [
        NotificationType.workItemCreated,
        NotificationType.collaborationMessageSent,
        NotificationType.unknown,
      ]);
      expect(items[2].rawType, 'yeni.olay.turu');
      expect(items[0].id, 'n1');
      expect(
        items[0].subject,
        const NotificationSubject(kind: 'work_item', id: 'w1'),
      );
      expect(items[0].isRead, isFalse);
      expect(items[1].isRead, isTrue);
      expect(items[0].createdAt, DateTime.utc(2026, 10, 20, 10));
    });

    test('next_cursor yok ya da boş → son sayfa', () async {
      for (final body in [
        '{"items":[],"unread_count":0}',
        '{"items":[],"unread_count":0,"next_cursor":""}',
      ]) {
        final (repo, _) = _repo(body);
        final feed = await repo.list();
        expect(feed.page.items, isEmpty);
        expect(feed.page.hasMore, isFalse, reason: body);
      }
    });

    test('her yayın türü wire adından eşlenir', () {
      for (final t in NotificationType.values) {
        expect(NotificationType.fromWire(t.wire), t);
      }
      expect(NotificationType.fromWire(null), NotificationType.unknown);
    });

    test('notifications.input_invalid → ApiError', () async {
      final (repo, _) = _repo(_env('notifications.input_invalid'), status: 422);
      await expectLater(
        repo.list(page: const PageRequest(limit: 500)),
        _apiError('notifications.input_invalid'),
      );
    });

    test('ayrıştırılamayan yanıt → client.invalid_response', () async {
      final (repo, _) = _repo('{"items":null}');
      await expectLater(
        repo.list(),
        _apiError(ClientErrorCode.invalidResponse),
      );
    });
  });

  test('unreadCount', () async {
    final (repo, adapter) = _repo('{"count":3}');
    expect(await repo.unreadCount(), 3);
    expect(adapter.seen.single.uri.path, '/v1/notifications/unread-count');
  });

  group('markRead', () {
    test('POST /v1/notifications/{id}/read', () async {
      final (repo, adapter) = _repo('', status: 204);
      await repo.markRead('n1');
      expect(adapter.seen.single.method, 'POST');
      expect(adapter.seen.single.uri.path, '/v1/notifications/n1/read');
    });

    test('notifications.notification_not_found → ApiError', () async {
      final (repo, _) = _repo(
        _env('notifications.notification_not_found'),
        status: 404,
      );
      await expectLater(
        repo.markRead('yok'),
        _apiError('notifications.notification_not_found'),
      );
    });
  });

  test('markAllRead → marked_count', () async {
    final (repo, adapter) = _repo('{"marked_count":4}');
    expect(await repo.markAllRead(), 4);
    expect(adapter.seen.single.method, 'POST');
    expect(adapter.seen.single.uri.path, '/v1/notifications/read-all');
  });

  group('registerPushTarget', () {
    test('gövde ve sonuç; bilinmeyen durum → unknown', () async {
      for (final (wire, status) in [
        ('active', PushTargetStatus.active),
        ('dropped', PushTargetStatus.dropped),
        ('yeni', PushTargetStatus.unknown),
      ]) {
        final (repo, adapter) = _repo(
          jsonEncode({'target_id': 't1', 'status': wire}),
        );
        final t = await repo.registerPushTarget(
          endpoint: 'https://push.example/x',
          p256dh: 'pk',
          auth: 'au',
          userAgent: 'ua',
        );
        final req = adapter.seen.single;
        expect(req.method, 'POST');
        expect(req.uri.path, '/v1/notifications/targets');
        expect(req.data, {
          'endpoint': 'https://push.example/x',
          'keys': {'p256dh': 'pk', 'auth': 'au'},
          'user_agent': 'ua',
        });
        expect(t.id, 't1');
        expect(t.status, status);
      }
    });

    test('notifications.target_invalid → ApiError', () async {
      final (repo, _) = _repo(
        _env('notifications.target_invalid'),
        status: 422,
      );
      await expectLater(
        repo.registerPushTarget(endpoint: 'http://x', p256dh: 'p', auth: 'a'),
        _apiError('notifications.target_invalid'),
      );
    });
  });

  group('unregisterPushTarget', () {
    test('DELETE /v1/notifications/targets/{id}', () async {
      final (repo, adapter) = _repo('', status: 204);
      await repo.unregisterPushTarget('t1');
      expect(adapter.seen.single.method, 'DELETE');
      expect(adapter.seen.single.uri.path, '/v1/notifications/targets/t1');
    });

    test('notifications.subscription_not_found → ApiError', () async {
      final (repo, _) = _repo(
        _env('notifications.subscription_not_found'),
        status: 404,
      );
      await expectLater(
        repo.unregisterPushTarget('t1'),
        _apiError('notifications.subscription_not_found'),
      );
    });
  });

  test('pushPublicKey: enabled=false hata değildir', () async {
    final (repo, adapter) = _repo('{"public_key":"","enabled":false}');
    final k = await repo.pushPublicKey();
    expect(k.enabled, isFalse);
    expect(k.publicKey, '');
    expect(adapter.seen.single.uri.path, '/v1/notifications/vapid-public-key');
  });
}
