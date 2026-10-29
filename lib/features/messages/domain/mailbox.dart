import 'package:meta/meta.dart';

import 'chat.dart';

/// Mesaj kutusu yönü (`GET /v1/messages?filter=`). Yalnız istekte kullanılır; sunucu
/// mesajda kutu alanı döndürmez, kutu isteğin kendisidir. Bu yüzden `unknown` üyesi yoktur
/// (sunucudan ayrıştırılmaz).
enum MessageBox {
  /// Gelen kutusu (sunucu varsayılanı).
  inbox,

  /// Gönderilenler.
  sent,
}

/// Konulu mesaj kutusu satırı: sunucunun birebir mesajı (`Message`). Sohbetle örtüşen alanlar
/// [message]'dadır (gönderen, alıcı, gövde, zaman, okunma); sohbet modelinde olmayan sunucu
/// kavramları (konu, kutu yönü, program, görünen adlar) bu sarmalayıcıdadır.
@immutable
final class MailboxMessage {
  const MailboxMessage({
    required this.message,
    required this.box,
    required this.subject,
    required this.programId,
    required this.senderName,
    required this.receiverName,
  });

  /// Örtüşen alanlar: `id`, `from`, `to`, `at`, `text`, `read`, `readAt`.
  final ChatMessage message;

  /// Satırın geldiği kutu (isteğin `filter` değeri).
  final MessageBox box;

  /// Konu (sunucuda zorunlu; sohbet modelinde yok).
  final String subject;

  /// Mesajın bağlı olduğu program (S2 kapsamı).
  final String programId;
  final String senderName;
  final String receiverName;

  String get id => message.id;

  /// Karşı tarafın hesap kimliği: gelen kutusunda gönderen, gönderilenlerde alıcı. Sohbet
  /// görünümünde mesajları gruplamak içindir (yetki kuralı değildir).
  String get counterpartId => switch (box) {
    MessageBox.inbox => message.from,
    MessageBox.sent => message.to ?? '',
  };

  /// Karşı tarafın görünen adı (bkz. [counterpartId]).
  String get counterpartName => switch (box) {
    MessageBox.inbox => senderName,
    MessageBox.sent => receiverName,
  };
}

/// Gönderim sonucu (`SentMessage`): sunucunun yazdığı kayıt; içerik ve adlar dönmez.
@immutable
final class MessageReceipt {
  const MessageReceipt({
    required this.id,
    required this.programId,
    required this.receiverAccountId,
    required this.subject,
    required this.createdAt,
  });

  final String id;
  final String programId;
  final String receiverAccountId;
  final String subject;
  final DateTime createdAt;
}

/// Alıcı adayı (`Recipient`).
@immutable
final class MessageRecipient {
  const MessageRecipient({required this.accountId, required this.fullName});

  final String accountId;
  final String fullName;

  @override
  bool operator ==(Object other) =>
      other is MessageRecipient &&
      other.accountId == accountId &&
      other.fullName == fullName;

  @override
  int get hashCode => Object.hash(accountId, fullName);
}

/// Alıcı grubu anahtarı (`RecipientGroup.key`; sunucu sırası admin → coordinator → member).
enum RecipientGroupKind {
  /// Şirket yöneticileri.
  admin,

  /// Seçili programdaki koordinatörler.
  coordinator,

  /// Çağıranın kendi koordinatörlüğündeki üyeler.
  member,

  /// Bilinmeyen anahtar (yeni backend etiketi).
  unknown,
}

/// Alıcı adayları grubu (`RecipientGroup`). [truncated]: grup sunucu tavanında (200) kırpıldı.
@immutable
final class MessageRecipientGroup {
  MessageRecipientGroup({
    required this.kind,
    required List<MessageRecipient> recipients,
    required this.truncated,
  }) : recipients = List.unmodifiable(recipients);

  final RecipientGroupKind kind;
  final List<MessageRecipient> recipients;
  final bool truncated;
}
