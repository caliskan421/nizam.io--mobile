// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_mention.dart';
import 'poll.dart';
import 'refs.dart';

part 'send_chat_message_request.freezed.dart';
part 'send_chat_message_request.g.dart';

@Freezed()
abstract class SendChatMessageRequest with _$SendChatMessageRequest {
  const factory SendChatMessageRequest({
    /// İstemcinin ürettiği tekrar kimliği; 1–100 bayt yazdırılabilir ASCII, boşluksuz; (sohbet, gönderen) başına tekil.
    @JsonKey(name: 'client_message_id') required String clientMessageId,

    /// Düz metin, en çok 5.000 karakter; kontrol karakteri reddedilir.
    required String body,
    @JsonKey(name: 'reply_to_message_id') String? replyToMessageId,

    /// Yapılandırılmış bahsetme listesi; sunucu metni ayrıştırmaz. En çok 20 (tekrar sessizce.
    /// tekilleşir). `account` hedefinin sohbet üyeliği doğrulanmaz (ad çözülmez, rozet yalnız.
    /// görünür sohbette); `department` programa bağlı olmalı; `all` yalnız grupta ve yalnız.
    /// yönetici/kurucu (birebirde 422 `messaging.input_invalid`, yetkisiz 403.
    /// `messaging.not_authorized`). Düzenleme bahsetmeyi değiştirmez.
    ///
    List<ChatMention>? mentions,

    /// Mesajı anket olarak açar (soru = gövde; yalnız grupta, birebirde 422, alan `poll`).
    Poll? poll,

    /// Paylaşılan öğeler (görev, koordinatörlük, arşiv dosyası); en çok 10, tekrar tekilleşir.
    /// Hedef gönderenin bugünkü yetkisiyle görünür ve sohbetin programında olmalı; aksi tek.
    /// 422 `messaging.input_invalid` (`field: refs`) — varlık sızmaz. Denetim gönderim.
    /// transaction'ından önce yapılır; aynı istemci kimliğiyle tekrar, referans artık.
    /// görünmüyorsa 422 alır (ilk mesaj durur).
    ///
    List<Refs>? refs,
  }) = _SendChatMessageRequest;

  factory SendChatMessageRequest.fromJson(Map<String, Object?> json) =>
      _$SendChatMessageRequestFromJson(json);
}
