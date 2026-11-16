import 'package:meta/meta.dart';

import 'chat.dart';

/// Açık sohbetin durumu: başlık bilgisi, yüklü mesaj penceresi (artan `seq`; gönderilmekte olan
/// kendi mesajlarım sonda), birebirde karşı tarafın okundu imleci, yazan kişi.
@immutable
final class ChatRoom {
  ChatRoom({
    required this.chat,
    required List<ChatMessage> messages,
    this.peerReadSeq,
    this.hasOlder = false,
    this.unreadMarker,
    this.typing,
    this.blocked = false,
    this.gone = false,
    List<ChatMessage> pins = const [],
    this.pinsTruncated = false,
  }) : messages = List.unmodifiable(messages),
       pins = List.unmodifiable(pins);

  final Chat chat;
  final List<ChatMessage> messages;
  final int? peerReadSeq;

  /// Pencerenin altında sunucuda daha eski mesaj olabilir.
  final bool hasOlder;

  /// Açılışta "okunmamış mesajlar" ayırıcısının duracağı mesaj.
  final String? unreadMarker;

  /// Şu an yazan kişinin adı (akıştaki `typing` olayından; süresi dolunca `null`).
  final String? typing;

  /// Gönderim kapalı (birebirde karşı taraf programdan çıktı: 403 `messaging.not_authorized`).
  final bool blocked;

  /// Sohbete artık erişim yok (çıkarıldım ya da sohbet silindi).
  final bool gone;

  /// Sabit şeridi (`listChatPins`; en yeni sabit başta). Pencere dışındaki mesajı da taşır.
  final List<ChatMessage> pins;
  final bool pinsTruncated;

  ChatMessage? message(String id) =>
      messages.where((m) => m.id == id).firstOrNull;

  /// Sunucudaki en küçük / en büyük `seq` (yüklü pencere sınırları).
  int? get lowSeq => messages.where((m) => m.onServer).firstOrNull?.seq;
  int? get highSeq => messages.where((m) => m.onServer).lastOrNull?.seq;

  /// Sunucudaki son mesaj (okundu imleci bunu işaret eder).
  ChatMessage? get lastOnServer => messages.where((m) => m.onServer).lastOrNull;

  ChatRoom copyWith({
    Chat? chat,
    List<ChatMessage>? messages,
    int? Function()? peerReadSeq,
    bool? hasOlder,
    String? Function()? unreadMarker,
    String? Function()? typing,
    bool? blocked,
    bool? gone,
    List<ChatMessage>? pins,
    bool? pinsTruncated,
  }) => ChatRoom(
    chat: chat ?? this.chat,
    messages: messages ?? this.messages,
    peerReadSeq: peerReadSeq == null ? this.peerReadSeq : peerReadSeq(),
    hasOlder: hasOlder ?? this.hasOlder,
    unreadMarker: unreadMarker == null ? this.unreadMarker : unreadMarker(),
    typing: typing == null ? this.typing : typing(),
    blocked: blocked ?? this.blocked,
    gone: gone ?? this.gone,
    pins: pins ?? this.pins,
    pinsTruncated: pinsTruncated ?? this.pinsTruncated,
  );

  /// Mesajı yerinde değiştirir (iyimser güncelleme); sabit şeridindeki kopyası da.
  ChatRoom patch(String id, ChatMessage Function(ChatMessage) f) => copyWith(
    messages: [for (final m in messages) m.id == id ? f(m) : m],
    pins: [for (final m in pins) m.id == id ? f(m) : m],
  );
}

/// Gelen sunucu mesajlarını yerel pencereye yerleştirir: aynı kimlik güncellenir; istemci
/// kimliği bekleyen bir kendi mesajımla eşleşen kayıt onun YERİNE geçer (akıştan gelen kopya ile
/// gönderim yanıtı çift mesaj üretmez). Sonuç `seq`'e göre artan; bekleyenler sonda kalır.
List<ChatMessage> mergeMessages(
  List<ChatMessage> local,
  Iterable<ChatMessage> incoming,
) {
  final byId = {
    for (final m in local)
      if (m.onServer) m.id: m,
  };
  final pending = [
    for (final m in local)
      if (!m.onServer) m,
  ];
  for (final m in incoming) {
    if (!m.onServer) continue;
    byId[m.id] = m;
    pending.removeWhere(
      (p) => p.clientId == m.clientId && p.senderId == m.senderId,
    );
  }
  final server = byId.values.toList()..sort((a, b) => a.seq!.compareTo(b.seq!));
  return [...server, ...pending];
}

/// Pencerenin yeniden okunmasında bir `before=<cursor>&limit=<limit>` sayfasını uygular
/// (§10.5): sayfanın kapsadığı aralıkta (en küçük dönen `seq` ile `cursor − 1` arası; sayfa
/// [limit]'ten az döndüyse aralığın altı açıktır) olup dönmeyen yerel kayıt silinmiş sayılır.
/// Boş sayfa imlecin altındaki bütün yerel kayıtların silindiğini söyler.
List<ChatMessage> applyWindowPage(
  List<ChatMessage> local,
  List<ChatMessage> page, {
  required int cursor,
  required int limit,
}) {
  final returned = {for (final m in page) m.id};
  final open = page.length < limit;
  final low = open
      ? null
      : page.map((m) => m.seq!).reduce((a, b) => a < b ? a : b);
  bool covered(int seq) => seq < cursor && (low == null || seq >= low);
  final kept = [
    for (final m in local)
      if (!m.onServer || !covered(m.seq!) || returned.contains(m.id)) m,
  ];
  return mergeMessages(kept, page);
}

/// Pencere okuması bitti mi: sayfa boş ya da [limit]'ten az döndü ya da en küçük `seq` pencerenin
/// altına ([windowLow]) indi.
bool windowDone(List<ChatMessage> page, {required int limit, int? windowLow}) {
  if (page.length < limit || windowLow == null) return true;
  final low = page.map((m) => m.seq!).reduce((a, b) => a < b ? a : b);
  return low <= windowLow;
}

/// Kendi mesajımın tiki.
enum ChatTick { none, sending, sent, read, failed }

/// Tik kuralı (§10.4): yalnız kendi mesajımda; birebirde `seq ≤ peer_read_seq` okundu, grupta
/// renkli tik yok.
ChatTick tickOf(ChatMessage m, {required String? me, required ChatRoom room}) {
  if (m.senderId != me) return ChatTick.none;
  switch (m.state) {
    case ChatSendState.sending:
      return ChatTick.sending;
    case ChatSendState.failed:
      return ChatTick.failed;
    case ChatSendState.sent:
      final peer = room.peerReadSeq;
      final seq = m.seq;
      return !room.chat.group && peer != null && seq != null && seq <= peer
          ? ChatTick.read
          : ChatTick.sent;
  }
}

/// Açılışta "okunmamış mesajlar" ayırıcısının mesajı: listenin okunmamış sayısı kadar sondan
/// (yalnız başkalarının sunucudaki mesajları).
String? unreadMarkerOf(List<ChatMessage> messages, int unread, String? me) {
  if (unread <= 0) return null;
  final others = [
    for (final m in messages)
      if (m.onServer && m.senderId != me) m,
  ];
  if (others.isEmpty) return null;
  return others[(others.length - unread).clamp(0, others.length - 1)].id;
}

/// Gönderilmekte olan kendi mesajımın yerel balonu (kimlik `local:<istemci kimliği>`): yanıt
/// alıntısı penceredeki [quoted]'tan, anket ve ek taslaktan.
ChatMessage pendingMessage(
  OutgoingMessage out, {
  required String me,
  ChatMessage? quoted,
  ChatUpload? upload,
}) {
  final poll = out.poll;
  final replyTo = out.replyTo;
  return ChatMessage(
    id: 'local:${out.clientId}',
    clientId: out.clientId,
    senderId: me,
    at: DateTime.now(),
    text: out.text,
    mentions: out.mentions,
    poll: poll == null
        ? null
        : ChatPoll(
            multi: poll.multi,
            voters: 0,
            closesAt: poll.closesAt,
            options: [for (final o in poll.options) ChatPollOption(o, 0)],
          ),
    attachments: [
      if (upload != null)
        ChatAttachment(
          id: 'local:${out.clientId}',
          fileName: upload.name,
          sizeBytes: upload.sizeBytes,
          contentType: upload.contentType,
          localPath: upload.path,
        ),
    ],
    replyTo: replyTo == null
        ? null
        : ChatQuote(
            messageId: replyTo,
            senderId: quoted?.senderId,
            senderName: quoted?.senderName,
            text: quoted?.text,
          ),
    state: ChatSendState.sending,
  );
}
