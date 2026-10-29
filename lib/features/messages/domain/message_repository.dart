import '../../../core/domain/page_slice.dart';
import 'mailbox.dart';

/// Birebir, konulu mesaj kutusu (backend `messaging` modülü; uçların hepsi S2: seçili
/// programın `X-Nizamio-Program` başlığı ara katmandan). Gönderim matrisi, okundu ve silme
/// yetkisi sunucudadır (COLLABORATION-K01/K06/K07); istemci türetmez, ret `ApiError` olarak
/// gelir. Gerçekleştirme `data/message_api_repository.dart`.
abstract interface class MessageRepository {
  /// `GET /v1/messages` — [box] kutusunun bir sayfası (imleçli, en yeni önce).
  Future<PageSlice<MailboxMessage>> list(
    MessageBox box, {
    PageRequest page = const PageRequest(),
  });

  /// `GET /v1/messages/unread-count` — seçili programdaki okunmamış gelen mesaj sayısı.
  Future<int> unreadCount();

  /// `GET /v1/messages/recipients` — alıcı adayları (gruplu). Şirket yöneticisine kapalıdır
  /// (403 `collaboration.not_authorized`).
  Future<List<MessageRecipientGroup>> recipients();

  /// `POST /v1/messages` — mesaj gönderir; konu ve içerik zorunludur (sunucu doğrular).
  Future<MessageReceipt> send({
    required String receiverAccountId,
    required String subject,
    required String content,
  });

  /// `POST /v1/messages/{id}/read` — okundu işaretler (yalnız alıcı; idempotent).
  Future<void> markRead(String id);

  /// `DELETE /v1/messages/{id}` — kalıcı ve iki taraflı siler (alıcı yalnız okuduktan
  /// sonra; aksi 409 `collaboration.message_unread`).
  Future<void> delete(String id);
}
