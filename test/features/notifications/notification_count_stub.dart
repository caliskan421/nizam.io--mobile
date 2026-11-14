// Yalnız okunmamış sayısını yanıtlayan sahte bildirim kaynağı (rozet testleri).
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/features/notifications/domain/app_notification.dart';
import 'package:nizamio/features/notifications/domain/notification_preferences.dart';
import 'package:nizamio/features/notifications/domain/notification_repository.dart';

class NotificationCountStub implements NotificationRepository {
  int unread = 0;
  int countCalls = 0;

  @override
  Future<int> unreadCount() async {
    countCalls++;
    return unread;
  }

  @override
  Future<NotificationFeed> list({PageRequest page = const PageRequest()}) =>
      throw UnimplementedError();

  @override
  Future<void> markRead(String id) => throw UnimplementedError();

  @override
  Future<int> markAllRead() => throw UnimplementedError();

  @override
  Future<PushTarget> registerPushTarget({
    required String endpoint,
    required String p256dh,
    required String auth,
    String? userAgent,
  }) => throw UnimplementedError();

  @override
  Future<void> unregisterPushTarget(String targetId) =>
      throw UnimplementedError();

  @override
  Future<PushPublicKeyInfo> pushPublicKey() => throw UnimplementedError();

  @override
  Future<NotificationPreferences> preferences() => throw UnimplementedError();

  @override
  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences changes,
  ) => throw UnimplementedError();
}
