import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/notifications_client.dart';
import '../../../core/api/generated/models/keys.dart';
import '../../../core/api/generated/models/notification.dart';
import '../../../core/api/generated/models/register_target_request.dart';
import '../../../core/domain/enum_parse.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../domain/app_notification.dart';
import '../domain/notification_repository.dart';

/// notifications uçlarına üretilmiş istemciyle erişim. Üretilmiş DTO'lar bu katmanda kalır;
/// dışarıya domain varlıkları döner (sınır kuralı A1). Bütün hatalar [ApiError] olarak fırlar.
class ApiNotificationRepository implements NotificationRepository {
  /// [dio]: doğrulanmış bağın API istemcisi (S1: kapsam başlığı gerekmez).
  ApiNotificationRepository(Dio dio) : _client = NotificationsClient(dio);

  final NotificationsClient _client;

  @override
  Future<NotificationFeed> list({
    PageRequest page = const PageRequest(),
  }) async {
    final r = await apiCall(
      () => _client.listNotifications(limit: page.limit, cursor: page.cursor),
    );
    final cursor = r.nextCursor;
    return NotificationFeed(
      page: PageSlice(
        items: [for (final n in r.items) _notification(n)],
        nextCursor: cursor == null || cursor.isEmpty ? null : cursor,
      ),
      unreadCount: r.unreadCount,
    );
  }

  @override
  Future<int> unreadCount() async =>
      (await apiCall(_client.countUnreadNotifications)).count;

  @override
  Future<void> markRead(String id) =>
      apiCall(() => _client.markNotificationRead(id: id));

  @override
  Future<int> markAllRead() async =>
      (await apiCall(_client.markAllNotificationsRead)).markedCount;

  @override
  Future<PushTarget> registerPushTarget({
    required String endpoint,
    required String p256dh,
    required String auth,
    String? userAgent,
  }) async {
    final r = await apiCall(
      () => _client.registerPushTarget(
        body: RegisterTargetRequest(
          endpoint: endpoint,
          keys: Keys(p256dh: p256dh, auth: auth),
          userAgent: userAgent,
        ),
      ),
    );
    return PushTarget(
      id: r.targetId,
      status: enumFromWire(
        PushTargetStatus.values,
        r.status,
        PushTargetStatus.unknown,
      ),
    );
  }

  @override
  Future<void> unregisterPushTarget(String targetId) =>
      apiCall(() => _client.unregisterPushTarget(targetId: targetId));

  @override
  Future<PushPublicKeyInfo> pushPublicKey() async {
    final r = await apiCall(_client.pushPublicKey);
    return PushPublicKeyInfo(publicKey: r.publicKey, enabled: r.enabled);
  }

  static AppNotification _notification(Notification n) => AppNotification(
    id: n.id,
    type: NotificationType.fromWire(n.type),
    rawType: n.type,
    subject: NotificationSubject(kind: n.subjectRef.kind, id: n.subjectRef.id),
    isRead: n.isRead,
    createdAt: n.createdAt,
  );
}
