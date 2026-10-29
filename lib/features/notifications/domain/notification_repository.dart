import '../../../core/domain/page_slice.dart';
import 'app_notification.dart';

/// Uygulama içi bildirimler ve (web) push aboneliği (backend `notifications` modülü; bütün
/// uçlar S1: kapsam başlığı gönderilmez). Gerçekleştirme
/// `data/notification_api_repository.dart`.
///
/// v1 mobilde push yok (mobil `CLAUDE.md`): [registerPushTarget], [unregisterPushTarget] ve
/// [pushPublicKey] yalnız sözleşme karşılığıdır; sunucu yalnız web push (VAPID) aboneliğini
/// kabul eder, FCM/APNs hedefi yoktur.
abstract interface class NotificationRepository {
  /// `GET /v1/notifications` — en yeni önce, imleçli. [page] `limit` 1–200 dışı sunucuda
  /// 422 `notifications.input_invalid`.
  Future<NotificationFeed> list({PageRequest page = const PageRequest()});

  /// `GET /v1/notifications/unread-count`.
  Future<int> unreadCount();

  /// `POST /v1/notifications/{id}/read` — idempotent; başkasının/olmayanın kaydı 404.
  Future<void> markRead(String id);

  /// `POST /v1/notifications/read-all` — işaretlenen kayıt sayısı (ikinci çağrı 0).
  Future<int> markAllRead();

  /// `POST /v1/notifications/targets` — web push aboneliği (kendi hesabına idempotent).
  Future<PushTarget> registerPushTarget({
    required String endpoint,
    required String p256dh,
    required String auth,
    String? userAgent,
  });

  /// `DELETE /v1/notifications/targets/{target_id}` — kendi aboneliğini kapatır.
  Future<void> unregisterPushTarget(String targetId);

  /// `GET /v1/notifications/vapid-public-key`.
  Future<PushPublicKeyInfo> pushPublicKey();
}
