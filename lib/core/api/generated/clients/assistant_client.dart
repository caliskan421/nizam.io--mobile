// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/assistant_chat_request.dart';
import '../models/assistant_conversation_detail.dart';
import '../models/assistant_conversation_list.dart';

part 'assistant_client.g.dart';

@RestApi()
abstract class AssistantClient {
  factory AssistantClient(Dio dio, {String? baseUrl}) = _AssistantClient;

  static const Map<String, dynamic> assistantChatOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["assistant"],
          'operationId': "assistantChat",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> assistantConversationsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["assistant"],
          'operationId': "assistantConversations",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> assistantConversationOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["assistant"],
          'operationId': "assistantConversation",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> deleteAssistantConversationOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["assistant"],
          'operationId': "deleteAssistantConversation",
          'externalDocsUrl': null,
        },
      };

  /// YZ asistanına soru sorar; cevap SSE akışıdır (salt okunur araçlar, kapsam çağırandan).
  ///
  /// Yalnız `NIZAMIO_ASSISTANT_ENABLED=true` iken kayıtlıdır; bayrak kapalıyken yol tanımsızdır ve `404 platform.route_not_found` döner.
  ///
  /// Cevap `text/event-stream` akışıdır; her olay `event: <ad>` ve tek satır.
  /// `data: <JSON>` taşır (şemalar `AssistantEvent*`). Olay sırası: `metin` parçaları.
  /// ve `arac`/`gorunum` olayları dönüşümlü; başarıda kapanış `adlar` (varsa),.
  /// `kaynaklar`, `kullanim`, `bitti`.
  ///
  /// Akış BAŞLAMADAN doğan hata (kapsam, kota, kapasite, sohbet sahipliği, ilk.
  /// model çağrısının arızası) normal hata zarfıyla döner. Akış başladıktan.
  /// SONRA doğan hata durum kodunu değiştiremez: yanıt HTTP 200 kalır ve akış.
  /// tek bir `hata` olayıyla (`AssistantEventError`; kod `assistant.limit_exceeded`,.
  /// `assistant.refused`, `assistant.provider_unavailable` ya da `platform.internal`).
  /// biter, `bitti` gelmez. Hiçbir olay araç sonucunun ham verisini taşımaz;.
  /// kişiler modele ve akışa `Üye-N` takma adıyla girer, `adlar` olayı yalnız.
  /// o soruda görülen takma adların görünen adını taşır.
  @POST('/v1/assistant/chat')
  Future<String> assistantChat({
    @Body() required AssistantChatRequest body,
    @Extras()
    Map<String, dynamic>? extras = AssistantClient.assistantChatOpenapiExtras,
  });

  /// Çağıranın seçili programdaki sohbetleri (en yeni önce, en çok 200).
  ///
  /// Yalnız `NIZAMIO_ASSISTANT_ENABLED=true` iken kayıtlıdır; bayrak kapalıyken yol tanımsızdır ve `404 platform.route_not_found` döner. Yalnız çağıranın kendi sohbetleri listelenir.
  @GET('/v1/assistant/conversations')
  Future<HttpResponse<AssistantConversationList>> assistantConversations({
    @Extras()
    Map<String, dynamic>? extras =
        AssistantClient.assistantConversationsOpenapiExtras,
  });

  /// Sohbet ve görünür mesajları (kullanıcı soruları ve asistan cevapları).
  ///
  /// Yalnız `NIZAMIO_ASSISTANT_ENABLED=true` iken kayıtlıdır; bayrak kapalıyken yol tanımsızdır ve `404 platform.route_not_found` döner. Başkasının ya da başka programın sohbeti `assistant.not_found` alır.
  /// (varlık sızmaz). Araç sonuçları ve takma ad tablosu dönmez.
  @GET('/v1/assistant/conversations/{id}')
  Future<AssistantConversationDetail> assistantConversation({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        AssistantClient.assistantConversationOpenapiExtras,
  });

  /// Çağıranın sohbetini mesajlarıyla kalıcı siler.
  ///
  /// Yalnız `NIZAMIO_ASSISTANT_ENABLED=true` iken kayıtlıdır; bayrak kapalıyken yol tanımsızdır ve `404 platform.route_not_found` döner. Başkasının ya da başka programın sohbeti `assistant.not_found` alır.
  @DELETE('/v1/assistant/conversations/{id}')
  Future<void> deleteAssistantConversation({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        AssistantClient.deleteAssistantConversationOpenapiExtras,
  });
}
