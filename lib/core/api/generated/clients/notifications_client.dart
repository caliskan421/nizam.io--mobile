// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/count_result.dart';
import '../models/marked_count.dart';
import '../models/notification_list.dart';
import '../models/notification_preferences.dart';
import '../models/push_public_key.dart';
import '../models/register_device_token_request.dart';
import '../models/register_target_request.dart';
import '../models/target_result.dart';

part 'notifications_client.g.dart';

@RestApi()
abstract class NotificationsClient {
  factory NotificationsClient(Dio dio, {String? baseUrl}) =
      _NotificationsClient;

  static const Map<String, dynamic> listNotificationsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["notifications"],
          'operationId': "listNotifications",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> countUnreadNotificationsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["notifications"],
          'operationId': "countUnreadNotifications",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> markNotificationReadOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["notifications"],
          'operationId': "markNotificationRead",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> markAllNotificationsReadOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["notifications"],
          'operationId': "markAllNotificationsRead",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> registerDeviceTokenOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["notifications"],
          'operationId': "registerDeviceToken",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> getNotificationPreferencesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["notifications"],
          'operationId': "getNotificationPreferences",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> updateNotificationPreferencesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["notifications"],
          'operationId': "updateNotificationPreferences",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> registerPushTargetOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["notifications"],
          'operationId': "registerPushTarget",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> unregisterPushTargetOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["notifications"],
          'operationId': "unregisterPushTarget",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> pushPublicKeyOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["notifications"],
          'operationId': "pushPublicKey",
          'externalDocsUrl': null,
        },
      };

  /// Çağıranın uygulama içi bildirimleri (imleçli; metin taşımaz).
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder; audit de 1–200 dışını ve sayı olmayanı 422 `audit.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/notifications')
  Future<NotificationList> listNotifications({
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras =
        NotificationsClient.listNotificationsOpenapiExtras,
  });

  /// Okunmamış bildirim sayısı.
  @GET('/v1/notifications/unread-count')
  Future<CountResult> countUnreadNotifications({
    @Extras()
    Map<String, dynamic>? extras =
        NotificationsClient.countUnreadNotificationsOpenapiExtras,
  });

  /// Tek bildirimi okundu işaretler (yalnız kendi kaydı).
  @POST('/v1/notifications/{id}/read')
  Future<void> markNotificationRead({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        NotificationsClient.markNotificationReadOpenapiExtras,
  });

  /// Bütün bildirimleri okundu işaretler.
  @POST('/v1/notifications/read-all')
  Future<MarkedCount> markAllNotificationsRead({
    @Extras()
    Map<String, dynamic>? extras =
        NotificationsClient.markAllNotificationsReadOpenapiExtras,
  });

  /// FCM cihaz belirtecini kaydeder (ADR-0042; NOTIFICATIONS-K35). İdempotent; aynı belirteç başka hesaba kayıtlıysa sahiplik çağırana geçer. Cevap belirteci taşımaz; silme `DELETE /v1/notifications/targets/{target_id}`. FCM kapalı kurulumda da kabul edilir.
  @POST('/v1/notifications/device-tokens')
  Future<TargetResult> registerDeviceToken({
    @Body() required RegisterDeviceTokenRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        NotificationsClient.registerDeviceTokenOpenapiExtras,
  });

  /// Çağıranın push tercihleri: dört grup (`gorev`, `mesaj`, `toplanti`, `sistem`) için `push_muted` (NOTIFICATIONS-K36).
  @GET('/v1/notifications/preferences')
  Future<NotificationPreferences> getNotificationPreferences({
    @Extras()
    Map<String, dynamic>? extras =
        NotificationsClient.getNotificationPreferencesOpenapiExtras,
  });

  /// Çağıranın verilen grup tercihlerini yazar; verilmeyen grup değişmez. Sessize alınan grubun olayı dış kanala (web push, FCM) gitmez, uygulama içi kayıt yine yazılır (NOTIFICATIONS-K36).
  @PUT('/v1/notifications/preferences')
  Future<NotificationPreferences> updateNotificationPreferences({
    @Body() required NotificationPreferences body,
    @Extras()
    Map<String, dynamic>? extras =
        NotificationsClient.updateNotificationPreferencesOpenapiExtras,
  });

  /// Cihaz (web push) aboneliği kaydı; kendi hesabına idempotent.
  @POST('/v1/notifications/targets')
  Future<TargetResult> registerPushTarget({
    @Body() required RegisterTargetRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        NotificationsClient.registerPushTargetOpenapiExtras,
  });

  /// Kendi cihaz aboneliğini kapatır (başkasının/olmayanın cevabı aynı 404).
  @DELETE('/v1/notifications/targets/{target_id}')
  Future<void> unregisterPushTarget({
    @Path('target_id') required String targetId,
    @Extras()
    Map<String, dynamic>? extras =
        NotificationsClient.unregisterPushTargetOpenapiExtras,
  });

  /// Web push açık anahtarı ve açıklık bilgisi (`enabled=false` hata değildir).
  @GET('/v1/notifications/vapid-public-key')
  Future<PushPublicKey> pushPublicKey({
    @Extras()
    Map<String, dynamic>? extras =
        NotificationsClient.pushPublicKeyOpenapiExtras,
  });
}
