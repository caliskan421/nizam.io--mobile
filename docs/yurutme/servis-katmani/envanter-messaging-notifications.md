# Servis envanteri: messaging + notifications

Pin `v0.2.0-api`. Kapsam: `collaboration_client.dart` içindeki 6 mesaj işlemi (toplantı işlemleri records-meetings parçasında) ve `notifications_client.dart` içindeki 7 işlem. Toplam **13 işlem, 13'ü karşılandı**.

Uygulama: `lib/features/messages/data/message_api_repository.dart` (`ApiMessageRepository implements MessageRepository`), `lib/features/notifications/data/notification_api_repository.dart` (`ApiNotificationRepository implements NotificationRepository`). Testler `test/features/{messages,notifications}/data/*_api_repository_test.dart`. UI, controller, modül ve DI bağlaması değişmedi. Örnek `ChatRepository` ve sohbet ekranları olduğu gibi çalışıyor.

## İşlem tablosu

| operationId | yöntem yol | kapsam | Flutter karşılığı | domain tipi | not |
|---|---|---|---|---|---|
| `sendMessage` | POST `/v1/messages` | S2 | `MessageRepository.send` | `MessageReceipt` | Gövde: `SendMessageRequest(receiver_account_id, subject, content)`. Konu zorunlu; sohbet ekranında konu girişi yok, entegrasyonda karar verilecek. Gönderim matrisi (K01) sunucuda; istemcide türetilmez, 403 `ApiError` olarak gelir. Yanıtta içerik ve ad yok, bu yüzden `ChatMessage` yerine makbuz dönüyor. |
| `listMessages` | GET `/v1/messages?filter=` | S2 | `MessageRepository.list(MessageBox, {PageRequest})` | `PageSlice<MailboxMessage>` | İmleçli. Zorunlu `next_cursor` alanının boş dizesi `null`'a (son sayfa) eşlenir. Örtüşen alanlar `ChatMessage`'a girer (`message_id→id`, `sender_account_id→from`, `receiver_account_id→to`, `created_at→at`, `content→text`, `is_read→read`, `read_at→readAt`). Sohbet modelinde olmayanlar `MailboxMessage`'a girer (`subject`, `box`, `program_id`, `sender_name`, `receiver_name`). Konuşma kavramı sunucuda yok: sohbet görünümü iki kutunun `counterpartId`'ye göre istemcide birleştirilmesiyle kurulacak (konuşma başına imleç yok). |
| `countUnreadMessages` | GET `/v1/messages/unread-count` | S2 | `MessageRepository.unreadCount` | `int` | Sayılan şey okunmamış mesajlardır, sohbetler değil. `ChatInbox.unreadChats` farklı bir anlam taşıyor. |
| `listMessageRecipients` | GET `/v1/messages/recipients` | S2 | `MessageRepository.recipients` | `List<MessageRecipientGroup>` | `key` değerleri `admin`/`coordinator`/`member` (backend `messaging/usecase/reads.go`). Spec'te bunlar düz `string`; domain'de `RecipientGroupKind` (bilinmeyen değer `unknown`). Grup başına `truncated` taşınıyor. ŞY 403 alır (K09); ŞY'nin alıcı listesi bu uçtan gelmez. `ChatInbox.people` (yalnız kimlik listesi) ile eşleme entegrasyonda yapılacak. |
| `markMessageRead` | POST `/v1/messages/{id}/read` | S2 | `MessageRepository.markRead` | `void` | Yalnız alıcı çağırabilir, idempotent. Toplu okundu ucu yok: `chats_controller` `markAllRead` N istek demek. |
| `deleteMessage` | DELETE `/v1/messages/{id}` | S2 | `MessageRepository.delete` | `void` | Silme kalıcıdır ve iki tarafta birden olur. Alıcı yalnız okuduktan sonra silebilir (409 `collaboration.message_unread`). "Yalnız benden gizle" seçeneği yok. |
| `listNotifications` | GET `/v1/notifications` | S1 | `NotificationRepository.list({PageRequest})` | `NotificationFeed` (`PageSlice<AppNotification>` + `unreadCount`) | `next_cursor` isteğe bağlı; yoksa ya da boşsa son sayfa. `type` → `NotificationType` (events.md'de bildirim üreten 13 tür + `unknown`); ham değer `rawType`'ta korunuyor. `subject_ref.kind` değer kümesi spec'te tanımsız, opak `String` olarak taşınıyor. Metin, aktör ve `program_id` yok. `limit` 1–200 dışına çıkarsa 422 döner; istemci kırpmıyor. |
| `countUnreadNotifications` | GET `/v1/notifications/unread-count` | S1 | `NotificationRepository.unreadCount` | `int` | |
| `markNotificationRead` | POST `/v1/notifications/{id}/read` | S1 | `NotificationRepository.markRead` | `void` | Başkasının ya da olmayan bir kaydın cevabı aynı 404'tür. |
| `markAllNotificationsRead` | POST `/v1/notifications/read-all` | S1 | `NotificationRepository.markAllRead` | `int` (`marked_count`) | |
| `registerPushTarget` | POST `/v1/notifications/targets` | S1 | `NotificationRepository.registerPushTarget` | `PushTarget` | **v1 mobilde push yok.** Karşılık yalnız sözleşme tamlığı için var. Sunucu yalnız web push (VAPID) aboneliği alır (`endpoint` + `keys.p256dh/auth`); FCM/APNs hedefi yok. `status` → `PushTargetStatus` (`active`/`dropped`/`unknown`; değerler backend domain'inden, spec'te düz `string`). |
| `unregisterPushTarget` | DELETE `/v1/notifications/targets/{target_id}` | S1 | `NotificationRepository.unregisterPushTarget` | `void` | v1 mobilde push yok (yukarıya bakın). |
| `pushPublicKey` | GET `/v1/notifications/vapid-public-key` | S1 | `NotificationRepository.pushPublicKey` | `PushPublicKeyInfo` | v1 mobilde push yok. `enabled=false` hata sayılmaz. |

## UI'da olup sunucuda olmayanlar (silinmedi)

`chat.dart` içinde "Sunucuda yok — entegrasyonda karar" diye işaretlendi:

- `ChatMessage`: `reactions`, `myReaction`, `replyTo`, `file` (`ChatFile`), `edited`, `poll` (`ChatPoll`), `refs` (`ChatRef`). `sent` bir istemci durumu (gönderim kuyruğu).
- `Chat`: konuşma kimliği (`id`), `group`, `members`, `mention`, `pins`, `newBefore`, `typing`, `online`, `lastSeen`, `muted`.
- `ChatInbox.unreadChats` (sunucu toplamı mesaj sayısıdır) ve `ChatFilter {all, unread, groups, people}` (sunucu süzgeci yalnız kutu seçer: `inbox`/`sent`).
- Sunucuda karşılığı olmayan işlemler: toplu okundu, düzenleme, tepki, anket, sabitleme, sessize alma, yanıt, dosya eki, referans, anlık iletim (yoklama gerekir).

## Spec belirsizlikleri

- `RecipientGroup.key`, `TargetResult.status` ve `NotificationSubject.kind` spec'te enum değil. İlk ikisi backend kaynağından enum'a çevrildi (`unknown` üyeli). `kind` için tanımlı bir küme yok.
- `Notification.type` spec'te `string`; değerler `docs/api/events.md`'de yazıyor. Yeni bir tür eklenirse istemcide `unknown` olur.
- `MessageList.next_cursor` zorunlu (boşsa son sayfa), `NotificationList.next_cursor` ise isteğe bağlı. İkisi de `PageSlice.nextCursor == null`'a normalize edildi.

## Domain değişiklikleri

- `lib/features/messages/domain/chat.dart`: `ChatMessage`'a isteğe bağlı `to` (alıcı hesap kimliği) ve `readAt` eklendi; `copyWith` ikisini koruyor. `from` ve `read` doc yorumları sunucu anlamına göre güncellendi. Sunucuda olmayan alan ve tiplere "Sunucuda yok — entegrasyonda karar" yazıldı. Alan silinmedi, var olan imzalar değişmedi.
- `lib/features/messages/domain/mailbox.dart` (yeni): `MessageBox {inbox, sent}` (yalnız istekte kullanılıyor, sunucudan ayrıştırılmadığı için `unknown` üyesi yok), `MailboxMessage` (`ChatMessage` + konu, kutu, program, adlar; `counterpartId`/`counterpartName`), `MessageReceipt`, `MessageRecipient`, `RecipientGroupKind` (+`unknown`), `MessageRecipientGroup`.
- `lib/features/messages/domain/message_repository.dart` (yeni): `MessageRepository` arayüzü (6 metot).
- `lib/features/notifications/` (yeni feature, yalnız `domain/` + `data/`): `domain/app_notification.dart` içinde `NotificationType` (wire adlı, +`unknown`, `fromWire`), `NotificationSubject`, `AppNotification` (Flutter'ın `Notification` sınıfıyla çakışmasın diye bu ad seçildi), `NotificationFeed`, `PushPublicKeyInfo`, `PushTargetStatus` (+`unknown`), `PushTarget`. `domain/notification_repository.dart`: `NotificationRepository` arayüzü (7 metot). Açık yüz (`notifications.dart`) ve modül eklenmedi; ekran entegrasyonuyla gelecek.
- `messages.dart` açık yüzü değişmedi; yeni tipler henüz dışa açılmadı.

## Ortaklaştırma adayları

- Test sahte bağdaştırıcısı `_Adapter` (tek yanıt, isteği kaydeder) iki test dosyasına ve `scope`'taki emsale kopyalandı. `test/support/` altında ortak bir yardımcıya taşınabilir.
- Boş `next_cursor` → `null` normalizasyonu iki repository'de tekrar ediyor. `PageSlice` yanında bir yardımcı (ör. `cursorOrNull`) `core/domain`'e taşınabilir.
- `ChatMessage`/`Chat` ile `MailboxMessage` arasındaki sohbet birleştirmesi (iki kutu → konuşma) entegrasyon adımında `application/` katmanında yazılmalı.
