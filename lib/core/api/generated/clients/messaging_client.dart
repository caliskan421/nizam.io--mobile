// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/add_chat_members_request.dart';
import '../models/chat.dart';
import '../models/chat_candidate_list.dart';
import '../models/chat_history.dart';
import '../models/chat_list.dart';
import '../models/chat_member_list.dart';
import '../models/chat_message.dart';
import '../models/chat_message_task_created.dart';
import '../models/chat_pins.dart';
import '../models/chat_ref_list.dart';
import '../models/chat_ref_summary.dart';
import '../models/chat_unread_overview.dart';
import '../models/create_group_chat_request.dart';
import '../models/create_task_from_chat_message_request.dart';
import '../models/edit_chat_message_request.dart';
import '../models/kind.dart';
import '../models/mark_chat_read_request.dart';
import '../models/open_direct_chat_request.dart';
import '../models/purpose.dart';
import '../models/send_chat_message_request.dart';
import '../models/set_chat_reaction_request.dart';
import '../models/update_chat_request.dart';
import '../models/vote_chat_poll_request.dart';

part 'messaging_client.g.dart';

@RestApi()
abstract class MessagingClient {
  factory MessagingClient(Dio dio, {String? baseUrl}) = _MessagingClient;

  static const Map<String, dynamic> listChatsOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["messaging"],
      'operationId': "listChats",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> openDirectChatOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "openDirectChat",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> createGroupChatOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "createGroupChat",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> markAllChatsReadOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "markAllChatsRead",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listChatCandidatesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "listChatCandidates",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> streamChatEventsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "streamChatEvents",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> getChatOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["messaging"],
      'operationId': "getChat",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> updateChatOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["messaging"],
      'operationId': "updateChat",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> deleteChatOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["messaging"],
      'operationId': "deleteChat",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> listChatMembersOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "listChatMembers",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> addChatMembersOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "addChatMembers",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> removeChatMemberOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "removeChatMember",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> grantChatAdminOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "grantChatAdmin",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> revokeChatAdminOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "revokeChatAdmin",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listChatMessagesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "listChatMessages",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> sendChatMessageOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "sendChatMessage",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> editChatMessageOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "editChatMessage",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> deleteChatMessageOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "deleteChatMessage",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> markChatReadOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "markChatRead",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listChatRefsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "listChatRefs",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> createTaskFromChatMessageOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "createTaskFromChatMessage",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> getChatRefSummaryOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "getChatRefSummary",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> downloadChatSharedFileOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "downloadChatSharedFile",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> setChatReactionOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "setChatReaction",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> deleteChatReactionOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "deleteChatReaction",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> pinChatMessageOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "pinChatMessage",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> unpinChatMessageOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "unpinChatMessage",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listChatPinsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "listChatPins",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> voteChatPollOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "voteChatPoll",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> closeChatPollOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "closeChatPoll",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> sendChatTypingOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "sendChatTyping",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> sendChatAttachmentOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "sendChatAttachment",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> downloadChatAttachmentOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "downloadChatAttachment",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> getChatUnreadOverviewOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["messaging"],
          'operationId': "getChatUnreadOverview",
          'externalDocsUrl': null,
        },
      };

  /// Seçili programdaki sohbetler (son etkinliğe göre, imleçli).
  ///
  /// İlk sayfada (imleç boş) ve yazma izni açıkken programın kendiliğinden grupları.
  /// (bağlı her koordinatörlük ve "Genel") tembel ve idempotent kurulur; salt okunur.
  /// modda liste onlarsız döner. Satırda çağıranın grup rolü yoktur (`role` alanı.
  /// yalnız `GET /v1/chats/{chatId}` cevabındadır).
  ///
  /// [q] - Arama: grup adı, silinmemiş mesaj metni (ILIKE) ya da birebirde karşı tarafın adı (Türkçe duyarlı katlamayla). Mesaj metninde Türkçe katlama yoktur (GAP-213). En çok 100 karakter.
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/chats')
  Future<ChatList> listChats({
    @Query('q') String? q,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.listChatsOpenapiExtras,
  });

  /// Birebir sohbet açar ya da mevcut olanı döndürür (201 yeni, 200 mevcut).
  ///
  /// Birebir kuralı (iki yönlü; roller seçili programdan) yalnız YENİ sohbet açılırken.
  /// uygulanır: rolü sonradan değişen çift mevcut sohbetini 200 ile açar. Karşı taraf.
  /// silinmiş hesapsa ya da kural izin vermiyorsa 403 `messaging.not_authorized`.
  @POST('/v1/chats/direct')
  Future<Chat> openDirectChat({
    @Body() required OpenDirectChatRequest body,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.openDirectChatOpenapiExtras,
  });

  /// Grup sohbeti kurar (kurucu + ilk üyeler; kaynak ayarı yalnız ŞY/koordinatör kurucuda).
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @POST('/v1/chats/groups')
  Future<Chat> createGroupChat({
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required CreateGroupChatRequest body,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.createGroupChatOpenapiExtras,
  });

  /// Görünür bütün sohbetlerde okundu imlecini son mesaja çeker.
  @POST('/v1/chats/read-all')
  Future<void> markAllChatsRead({
    @Extras()
    Map<String, dynamic>? extras =
        MessagingClient.markAllChatsReadOpenapiExtras,
  });

  /// Birebir ya da gruba ekleme için aday kişiler (en çok 200; `truncated`).
  ///
  /// Silinmiş hesap ve çağıranın kendisi listeye girmez. Listede olmayan kişiyle.
  /// birebir açılamaz ya da gruba eklenemez (istemci "neden yazamıyorum" metnini.
  /// birebir kuralından gösterir).
  ///
  /// [purpose] - `direct` (birebir kuralına uyanlar) ya da `group` (ekleme kuralına uyanlar).
  ///
  /// [chatId] - `purpose=group` iken mevcut grubun kimliği: üyeler adaylardan düşer.
  @GET('/v1/chats/candidates')
  Future<ChatCandidateList> listChatCandidates({
    @Query('purpose') required Purpose purpose,
    @Query('chat_id') String? chatId,
    @Extras()
    Map<String, dynamic>? extras =
        MessagingClient.listChatCandidatesOpenapiExtras,
  });

  /// Sohbet olaylarının anlık akışı (SSE; içeriksiz olaylar).
  ///
  /// Olaylar kalıcı değildir ve outbox olayı değildir; yük içeriksizdir (yalnız.
  /// kimlikler). İstemci içeriği güncel yetkiyle HTTP okumasından alır.
  ///
  /// Kimlik, program yetkisi ve abonelik akış başlığından ÖNCE verilir; hata normal.
  /// hata zarfıyla döner. Akış başladıktan sonra hata zarfı yazılmaz, bağlantı kapanır.
  /// Sunucu ilk çerçevede `: ok`, sonra 25 sn'de bir `: ping` yorum satırı yazar.
  /// Akış `NIZAMIO_HTTP_STREAM_TIMEOUT` bütçesiyle sınırlıdır; bütçe dolunca, bağlantı.
  /// kuyruğu taşınca ya da sunucu kapanırken bağlantı kapanır.
  ///
  /// Yeniden bağlanma protokolü: istemci ÖNCE aboneliği kurar, SONRA sohbet listesini.
  /// ve açık sohbetin görünen penceresini `after` imleciyle uzlaştırır. Olayları ≥ 1 sn.
  /// birleştirip toplu okur. Belirteç yalnız `Authorization` başlığında taşındığı için.
  /// tarayıcı `EventSource` kullanamaz; fetch akışıyla okur.
  @GET('/v1/chats/stream')
  Future<String> streamChatEvents({
    @Extras()
    Map<String, dynamic>? extras =
        MessagingClient.streamChatEventsOpenapiExtras,
  });

  /// Sohbet bilgisi (çağıranın grup rolü dahil).
  @GET('/v1/chats/{chatId}')
  Future<Chat> getChat({
    @Path('chatId') required String chatId,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.getChatOpenapiExtras,
  });

  /// Grup adını (yönetici/kurucu) ya da kaynağını (yönetici) değiştirir.
  ///
  /// Kaynak değişimi "kapat + aç"tır: eski kaynağın o anki üyeleri başlangıçlarıyla elle.
  /// üyeliğe yazılır, yeni kaynak `source_since` ile başlar.
  @PATCH('/v1/chats/{chatId}')
  Future<Chat> updateChat({
    @Path('chatId') required String chatId,
    @Body() required UpdateChatRequest body,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.updateChatOpenapiExtras,
  });

  /// Grubu siler (yönetici ya da kurucu; iz satırı kalır).
  @DELETE('/v1/chats/{chatId}')
  Future<void> deleteChat({
    @Path('chatId') required String chatId,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.deleteChatOpenapiExtras,
  });

  /// Sohbetin güncel üyeleri (elle + kaynaklı; en çok 200, `truncated`).
  @GET('/v1/chats/{chatId}/members')
  Future<ChatMemberList> listChatMembers({
    @Path('chatId') required String chatId,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.listChatMembersOpenapiExtras,
  });

  /// Gruba elle üye ekler (ekleme kuralı; tek istekte en çok 200).
  @POST('/v1/chats/{chatId}/members')
  Future<void> addChatMembers({
    @Path('chatId') required String chatId,
    @Body() required AddChatMembersRequest body,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.addChatMembersOpenapiExtras,
  });

  /// Üyeyi çıkarır; hedef çağıranın kendisiyse gruptan ayrılmadır.
  @DELETE('/v1/chats/{chatId}/members/{accountId}')
  Future<void> removeChatMember({
    @Path('chatId') required String chatId,
    @Path('accountId') required String accountId,
    @Extras()
    Map<String, dynamic>? extras =
        MessagingClient.removeChatMemberOpenapiExtras,
  });

  /// Üyeyi grup yöneticisi yapar (hedef ŞY ya da koordinatör).
  @PUT('/v1/chats/{chatId}/admins/{accountId}')
  Future<void> grantChatAdmin({
    @Path('chatId') required String chatId,
    @Path('accountId') required String accountId,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.grantChatAdminOpenapiExtras,
  });

  /// Grup yöneticiliğini alır.
  @DELETE('/v1/chats/{chatId}/admins/{accountId}')
  Future<void> revokeChatAdmin({
    @Path('chatId') required String chatId,
    @Path('accountId') required String accountId,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.revokeChatAdminOpenapiExtras,
  });

  /// Sohbet geçmişi (`seq` imleçli; tombstone dönmez).
  ///
  /// `before`, `after`, `around` en çok biri verilir; hiçbiri yoksa son sayfa. İmleç.
  /// sohbet içi sıra numarasıdır (`seq`), zaman damgasına indirgenmez.
  ///
  /// [before] - Bu seq'den önceki mesajlar.
  ///
  /// [after] - Bu seq'den sonraki mesajlar (uzlaştırma).
  ///
  /// [around] - Bu seq çevresindeki pencere.
  ///
  /// [q] - Sohbet içi metin araması (ILIKE; Türkçe katlama yok); yalnız `before` ile birleşir, `after`/`around` ile 422 `messaging.invalid_cursor`.
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
  @GET('/v1/chats/{chatId}/messages')
  Future<ChatHistory> listChatMessages({
    @Path('chatId') required String chatId,
    @Query('before') int? before,
    @Query('after') int? after,
    @Query('around') int? around,
    @Query('q') String? q,
    @Query('limit') int? limit,
    @Extras()
    Map<String, dynamic>? extras =
        MessagingClient.listChatMessagesOpenapiExtras,
  });

  /// Mesaj gönderir ya da yanıtlar (201 yeni, 200 aynı istemci kimliğinin tekrarı).
  ///
  /// Tekrar yetkiyi atlamaz: erişimini kaybetmiş çağıran 404 alır. Aynı istemci.
  /// kimliğiyle gönderilmiş mesaj silinmişse 409 `messaging.message_deleted`; aynı istemci.
  /// kimliğiyle farklı gönderim (gövde, yanıtlanan mesaj, bahsetme, referans ya da anket) 409 `messaging.idempotency_key_reused`.
  /// Yanıtlanan mesaj yoksa 404 `messaging.message_not_found`. Tekrar çocuk.
  /// yazmaz; ilk mesajın bahsetme ve referanslarını döndürür. Yeni olay yoktur:.
  /// bahsetme ve referans `message.created` ile duyurulur.
  @POST('/v1/chats/{chatId}/messages')
  Future<ChatMessage> sendChatMessage({
    @Path('chatId') required String chatId,
    @Body() required SendChatMessageRequest body,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.sendChatMessageOpenapiExtras,
  });

  /// Mesajı düzenler (yalnız gönderen; düzenlendi işareti).
  @PATCH('/v1/chats/{chatId}/messages/{messageId}')
  Future<ChatMessage> editChatMessage({
    @Path('chatId') required String chatId,
    @Path('messageId') required String messageId,
    @Body() required EditChatMessageRequest body,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.editChatMessageOpenapiExtras,
  });

  /// Mesajı siler (gönderen ya da grup yöneticisi; tombstone).
  @DELETE('/v1/chats/{chatId}/messages/{messageId}')
  Future<void> deleteChatMessage({
    @Path('chatId') required String chatId,
    @Path('messageId') required String messageId,
    @Extras()
    Map<String, dynamic>? extras =
        MessagingClient.deleteChatMessageOpenapiExtras,
  });

  /// Okundu imlecini verilen mesaja ilerletir (geri gitmez).
  @POST('/v1/chats/{chatId}/read')
  Future<void> markChatRead({
    @Path('chatId') required String chatId,
    @Body() required MarkChatReadRequest body,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.markChatReadOpenapiExtras,
  });

  /// Sohbetin paylaşılanları (görev, koordinatörlük, dosya; en yeniden eskiye, statik satır).
  ///
  /// Satır statiktir; kart `GET /v1/chat-refs/{refId}` ile okunur. Silinmiş mesajın.
  /// referansı listede yoktur. `cursor` önceki sayfanın son `ref_id`'sidir.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
  @GET('/v1/chats/{chatId}/refs')
  Future<ChatRefList> listChatRefs({
    @Path('chatId') required String chatId,
    @Query('kind') Kind? kind,
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.listChatRefsOpenapiExtras,
  });

  /// Mesajdan görev açar (şirket yöneticisi ya da hedef departmanın koordinatörü).
  ///
  /// Açıklama mesaj gövdesidir; `title` boşsa gövdenin ilk 100 karakteri. Başlangıç bugünden,.
  /// bitiş başlangıçtan önce olamaz. Aynı mesajdan ikinci görev serbesttir (uyarı istemcide,.
  /// mesajın `task_ids` alanı). Görev ve mesaj bağı tek transaction'dadır; commit sonrası.
  /// `message.updated` yayılır.
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @POST('/v1/chats/{chatId}/messages/{messageId}/tasks')
  Future<ChatMessageTaskCreated> createTaskFromChatMessage({
    @Path('chatId') required String chatId,
    @Path('messageId') required String messageId,
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required CreateTaskFromChatMessageRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        MessagingClient.createTaskFromChatMessageOpenapiExtras,
  });

  /// Paylaşılan öğenin okuyana sınırlı özeti (sohbet üyesi).
  ///
  /// Referans yok, mesajı silinmiş ya da çağıran sohbet üyesi değilse 404 `messaging.ref_not_found`.
  /// Hedef canlı okunur: görev/dosya yoksa ya da başka programdaysa, koordinatörlüğün bağı.
  /// kalktıysa 200 `available: false` ve kart alanları yok. Görev kartı kod alanı taşımaz.
  @GET('/v1/chat-refs/{refId}')
  Future<ChatRefSummary> getChatRefSummary({
    @Path('refId') required String refId,
    @Extras()
    Map<String, dynamic>? extras =
        MessagingClient.getChatRefSummaryOpenapiExtras,
  });

  /// Sohbette paylaşılan dosyayı indirir (sohbet üyesi; indirme bileti hedefi).
  ///
  /// Erişim mesaja bağlıdır: mesaj silindiyse ya da çağıran sohbetten çıktıysa (bilet tüketiminde.
  /// dahil) 404 `messaging.ref_not_found`. Dosya türünde olmayan referans, yok olan ya da başka.
  /// programa taşınan dosya aynı cevabı alır. Genel dosya indirme ucunun yetkisi değişmez.
  /// Belirteç taşıyamayan istemci (tarayıcı gezintisi, indirme yöneticisi) `POST /v1/download-tickets`.
  /// ile bu yola bilet alır (ADR-0013); tüketimde aynı denetimler tüketim anındaki durumla koşar.
  @GET('/v1/chat-file-refs/{refId}')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> downloadChatSharedFile({
    @Path('refId') required String refId,
    @Extras()
    Map<String, dynamic>? extras =
        MessagingClient.downloadChatSharedFileOpenapiExtras,
  });

  /// Mesaja tepki koyar (kişi başına tek tepki; yenisi eskinin yerine).
  @PUT('/v1/chats/{chatId}/messages/{messageId}/reaction')
  Future<void> setChatReaction({
    @Path('chatId') required String chatId,
    @Path('messageId') required String messageId,
    @Body() required SetChatReactionRequest body,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.setChatReactionOpenapiExtras,
  });

  /// Tepkiyi kaldırır (yoksa da 204).
  @DELETE('/v1/chats/{chatId}/messages/{messageId}/reaction')
  Future<void> deleteChatReaction({
    @Path('chatId') required String chatId,
    @Path('messageId') required String messageId,
    @Extras()
    Map<String, dynamic>? extras =
        MessagingClient.deleteChatReactionOpenapiExtras,
  });

  /// Mesajı sabitler (birebirde iki taraf; grupta yönetici ya da kurucu).
  ///
  /// Tekrar sabitleme sabitlenme anını değiştirmez. Silinen mesaj sabitten düşer.
  @PUT('/v1/chats/{chatId}/messages/{messageId}/pin')
  Future<void> pinChatMessage({
    @Path('chatId') required String chatId,
    @Path('messageId') required String messageId,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.pinChatMessageOpenapiExtras,
  });

  /// Mesajı sabitten kaldırır.
  @DELETE('/v1/chats/{chatId}/messages/{messageId}/pin')
  Future<void> unpinChatMessage({
    @Path('chatId') required String chatId,
    @Path('messageId') required String messageId,
    @Extras()
    Map<String, dynamic>? extras =
        MessagingClient.unpinChatMessageOpenapiExtras,
  });

  /// Sabit mesajlar (pinned_at DESC; imleçsiz, tavanlı truncated).
  @GET('/v1/chats/{chatId}/pins')
  Future<ChatPins> listChatPins({
    @Path('chatId') required String chatId,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.listChatPinsOpenapiExtras,
  });

  /// Ankete oy verir (küme önceki oyun yerine geçer; boş küme oyu geri çeker).
  ///
  /// Tek seçimli ankette en çok bir seçenek. Kapanmış ya da son tarihi geçmiş ankete 409 `messaging.poll_closed`. Anket olmayan mesaj 404 `messaging.message_not_found`.
  @PUT('/v1/chats/{chatId}/messages/{messageId}/vote')
  Future<void> voteChatPoll({
    @Path('chatId') required String chatId,
    @Path('messageId') required String messageId,
    @Body() required VoteChatPollRequest body,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.voteChatPollOpenapiExtras,
  });

  /// Anketi bitirir (yalnız açan).
  @POST('/v1/chats/{chatId}/messages/{messageId}/poll/close')
  Future<void> closeChatPoll({
    @Path('chatId') required String chatId,
    @Path('messageId') required String messageId,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.closeChatPollOpenapiExtras,
  });

  /// Yazıyor olayını yayar (her zaman 204; DB okuması yok).
  ///
  /// Yetki abonelik kümesindendir: çağıranın bu programda sohbeti tutan açık akışı yoksa olay sessizce düşer. İstemci ≥ 3 sn aralıkla gönderir.
  @POST('/v1/chats/{chatId}/typing')
  Future<void> sendChatTyping({
    @Path('chatId') required String chatId,
    @Extras()
    Map<String, dynamic>? extras = MessagingClient.sendChatTypingOpenapiExtras,
  });

  /// Ek mesajı gönderir (multipart, tek dosya; 201 yeni, 200 aynı istemci kimliğinin tekrarı).
  ///
  /// İzinli 11 tür (records ile aynı: pdf, png, jpg, csv, doc/docx, xls/xlsx, ppt/pptx, pages); tavan.
  /// `NIZAMIO_MESSAGING_ATTACHMENT_MAX_BYTES` (varsayılan 25 MB). Açıklama isteğe bağlıdır; ek mesajında.
  /// `body` boş olabilir. Tek istek tek dosyadır.
  /// Aynı `client_message_id` ile farklı gönderim (açıklama, yanıtlanan mesaj ya da ekin adı, MIME.
  /// türü veya boyutu) 409 `messaging.idempotency_key_reused` alır; aynı gönderimin tekrarı 200 döner.
  ///
  /// [body] - İsteğe bağlı açıklama; dosya parçasından ÖNCE gönderilir.
  @MultiPart()
  @POST('/v1/chats/{chatId}/attachments')
  Future<ChatMessage> sendChatAttachment({
    @Path('chatId') required String chatId,
    @Query('client_message_id') required String clientMessageId,
    @Part(name: 'file') required File file,
    @Query('reply_to_message_id') String? replyToMessageId,
    @Part(name: 'body') String? body,
    @Extras()
    Map<String, dynamic>? extras =
        MessagingClient.sendChatAttachmentOpenapiExtras,
  });

  /// Sohbet ekini indirir (sohbet üyesi; indirme bileti hedefi).
  ///
  /// Mesaj silinmiş, ek yok ya da sohbete erişim yoksa 404 `messaging.message_not_found`. Tarayıcı ve.
  /// indirme yöneticisi `POST /v1/download-tickets` ile bilet alır (ADR-0013).
  @GET('/v1/chat-attachments/{attachmentId}')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> downloadChatAttachment({
    @Path('attachmentId') required String attachmentId,
    @Extras()
    Map<String, dynamic>? extras =
        MessagingClient.downloadChatAttachmentOpenapiExtras,
  });

  /// Programlar arası okunmamış sohbet özeti (program seçici rozeti).
  ///
  /// Ekip satırı olan programlar; şirket yöneticisine bütün programlar. `mentioned`.
  /// programdaki herhangi bir sohbetin bahsetme rozetidir (`GET /v1/chats` `mentioned`).
  @GET('/v1/me/chat-unread')
  Future<ChatUnreadOverview> getChatUnreadOverview({
    @Extras()
    Map<String, dynamic>? extras =
        MessagingClient.getChatUnreadOverviewOpenapiExtras,
  });
}
