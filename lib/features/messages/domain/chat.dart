import 'package:meta/meta.dart';

/// Mesaj tepkisi (sunucu `like|heart|check|star`; kişi başına bir tane).
enum ChatReaction { like, heart, check, star }

/// Mesajdaki tepki özeti (sunucu `reactions: [{kind, count, mine}]`; tepki edenler gösterilmez).
@immutable
final class ChatReactionCount {
  const ChatReactionCount(this.kind, this.count, {this.mine = false});

  final ChatReaction kind;
  final int count;

  /// Benim tepkim.
  final bool mine;
}

/// Yanıtlanan mesajın alıntısı (sunucu `reply_to`). Silinmiş mesajın alıntısında [deleted]
/// `true`, gönderen ve metin boştur ("silinmiş mesaj").
@immutable
final class ChatQuote {
  const ChatQuote({
    required this.messageId,
    this.senderId,
    this.senderName,
    this.text,
    this.deleted = false,
  });

  final String messageId;
  final String? senderId;
  final String? senderName;
  final String? text;
  final bool deleted;
}

/// Mesaj eki (yalnız gösterim; ek gönderme/indirme sonraki pakette).
@immutable
final class ChatAttachment {
  const ChatAttachment({
    required this.id,
    required this.fileName,
    required this.sizeBytes,
  });

  final String id;
  final String fileName;
  final int sizeBytes;
}

/// Anket seçeneğinin sonucu.
@immutable
final class ChatPollOption {
  const ChatPollOption(this.label, this.count, {this.voterIds = const {}});

  final String label;
  final int count;

  /// Oy verenlerin hesap kimlikleri (sunucu `voters`; kendi oyum buradan çıkarılır).
  final Set<String> voterIds;
}

/// Anket (soru mesaj gövdesidir). Yalnız gösterim: oy ve bitirme sonraki pakette.
@immutable
final class ChatPoll {
  const ChatPoll({
    required this.multi,
    required this.options,
    required this.voters,
    this.closesAt,
    this.closed = false,
  });

  final bool multi;
  final List<ChatPollOption> options;

  /// Oy veren tekil kişi sayısı.
  final int voters;
  final DateTime? closesAt;
  final bool closed;

  int get totalVotes => options.fold(0, (t, o) => t + o.count);

  /// Seçeneğin yüzdesi (yuvarlanmış).
  int percent(int i) =>
      totalVotes == 0 ? 0 : (options[i].count / totalVotes * 100).round();
}

/// Kendi mesajımın istemci durumu: gönderiliyor, gönderilemedi (sonuç bilinmiyor ya da
/// reddedildi) ya da sunucuda.
enum ChatSendState { sending, failed, sent }

/// Sohbet mesajı. Sunucudan gelen mesajda [seq] sohbet içi sıra numarasıdır; gönderilmekte olan
/// (henüz sunucu kimliği olmayan) kendi mesajımda [seq] `null`, [id] yerel kimliktir.
@immutable
final class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.clientId,
    required this.senderId,
    required this.at,
    required this.text,
    this.seq,
    this.senderName,
    this.edited = false,
    this.revision = 0,
    this.replyTo,
    this.reactions = const [],
    this.pinnedAt,
    this.poll,
    this.attachments = const [],
    this.state = ChatSendState.sent,
    this.failure,
  });

  final String id;

  /// İstemci kimliği (`client_message_id`); ağ tekrarında AYNI kimlik ve AYNI gövde gider.
  final String clientId;
  final int? seq;
  final String senderId;
  final String? senderName;
  final DateTime at;
  final String text;
  final bool edited;

  /// Düzenleme sürümü (`edit_revision`); düzenlemede `expected_revision` olarak gider.
  final int revision;
  final ChatQuote? replyTo;
  final List<ChatReactionCount> reactions;
  final DateTime? pinnedAt;
  final ChatPoll? poll;
  final List<ChatAttachment> attachments;
  final ChatSendState state;

  /// [ChatSendState.failed] iken hata kodu (sunucu ya da `client.*`).
  final String? failure;

  bool get pinned => pinnedAt != null;
  bool get onServer => seq != null;

  ChatMessage copyWith({ChatSendState? state, String? Function()? failure}) =>
      ChatMessage(
        id: id,
        clientId: clientId,
        seq: seq,
        senderId: senderId,
        senderName: senderName,
        at: at,
        text: text,
        edited: edited,
        revision: revision,
        replyTo: replyTo,
        reactions: reactions,
        pinnedAt: pinnedAt,
        poll: poll,
        attachments: attachments,
        state: state ?? this.state,
        failure: failure == null ? this.failure : failure(),
      );
}

/// Listedeki son mesaj özeti (silinmişse [text] `null`, [deleted] `true`).
@immutable
final class ChatPreview {
  const ChatPreview({
    required this.senderId,
    required this.senderName,
    required this.at,
    this.text,
    this.deleted = false,
  });

  final String senderId;
  final String senderName;
  final DateTime at;
  final String? text;
  final bool deleted;
}

/// Çağıranın sohbetteki rolü (`getChat`; eylem görünürlüğü bu rolden).
enum ChatMemberRole { admin, founder, member }

/// Sohbet (grup ya da birebir). Satır alanları `listChats`'ten, [role] `getChat`'ten gelir.
/// Çevrimiçi bilgisi yalnız birebirde ve sunucu sağlıyorsa doludur (§10.10).
@immutable
final class Chat {
  const Chat({
    required this.id,
    required this.name,
    required this.lastActivity,
    this.group = false,
    this.general = false,
    this.counterpartId,
    this.unread = 0,
    this.mention = false,
    this.last,
    this.lastSeq = 0,
    this.role,
    this.peerOnline,
    this.peerLastSeen,
  });

  final String id;

  /// Grup adı ya da birebirde karşı tarafın adı.
  final String name;
  final DateTime lastActivity;
  final bool group;

  /// Programın kendiliğinden kurulan "Genel" grubu (bütün kullanıcılar).
  final bool general;

  /// Birebirde karşı kişinin hesap kimliği.
  final String? counterpartId;
  final int unread;

  /// Okunmamışlardan biri beni (ya da koordinatörlüğümü / herkesi) anıyor.
  final bool mention;
  final ChatPreview? last;
  final int lastSeq;
  final ChatMemberRole? role;
  final bool? peerOnline;
  final DateTime? peerLastSeen;

  bool get isUnread => unread > 0 || mention;

  /// Grupta yönetici: gruptaki her mesajı silebilir (§10.7 M-10).
  bool get canModerate => group && role == ChatMemberRole.admin;

  Chat copyWith({int? unread, bool? mention, ChatMemberRole? role}) => Chat(
    id: id,
    name: name,
    lastActivity: lastActivity,
    group: group,
    general: general,
    counterpartId: counterpartId,
    unread: unread ?? this.unread,
    mention: mention ?? this.mention,
    last: last,
    lastSeq: lastSeq,
    role: role ?? this.role,
    peerOnline: peerOnline,
    peerLastSeen: peerLastSeen,
  );
}

/// Mesajlar kutusu: seçili programın sohbetleri (son etkinliğe göre). [truncated]: sayfa
/// tavanında kesildi (daha eski sohbetler listede yok).
@immutable
final class ChatInbox {
  ChatInbox({required List<Chat> chats, this.truncated = false})
    : chats = List.unmodifiable(chats);

  final List<Chat> chats;
  final bool truncated;

  Chat? chat(String id) => chats.where((c) => c.id == id).firstOrNull;

  int get unreadChats => chats.where((c) => c.isUnread).length;

  ChatInbox replace(String id, Chat Function(Chat) f) => ChatInbox(
    chats: [for (final c in chats) c.id == id ? f(c) : c],
    truncated: truncated,
  );

  ChatInbox mapChats(Chat Function(Chat) f) =>
      ChatInbox(chats: [for (final c in chats) f(c)], truncated: truncated);

  /// Sohbet listede yoksa başa ekler (yeni açılan sohbet).
  ChatInbox withChat(Chat chat) => this.chat(chat.id) != null
      ? this
      : ChatInbox(chats: [chat, ...chats], truncated: truncated);
}

/// `listChatMessages` sayfası: artan sırada mesajlar ve birebirde karşı tarafın okundu imleci.
@immutable
final class ChatHistoryPage {
  ChatHistoryPage({required List<ChatMessage> messages, this.peerReadSeq})
    : messages = List.unmodifiable(messages);

  final List<ChatMessage> messages;

  /// Birebirde karşı tarafın okundu imleci; grupta `null`.
  final int? peerReadSeq;
}

/// Gönderilecek mesaj. [clientId] mesaj başına bir kez üretilir; tekrar AYNI kimlik ve gövdeyle.
@immutable
final class OutgoingMessage {
  const OutgoingMessage({
    required this.clientId,
    required this.text,
    this.replyTo,
  });

  final String clientId;
  final String text;
  final String? replyTo;
}

/// Aday listesinin amacı (`purpose`).
enum ChatCandidatePurpose { direct, group }

/// Adayın seçili programdaki rolü.
enum ChatCandidateRole { companyAdmin, coordinator, member }

@immutable
final class ChatCandidate {
  const ChatCandidate({required this.accountId, required this.name, this.role});

  final String accountId;
  final String name;
  final ChatCandidateRole? role;
}

/// Aday listesi; [truncated]: ilk 200 kişiyle kırpıldı (bu sürümde aday araması yok).
@immutable
final class ChatCandidates {
  ChatCandidates({required List<ChatCandidate> items, this.truncated = false})
    : items = List.unmodifiable(items);

  final List<ChatCandidate> items;
  final bool truncated;
}

/// Grup kurma taslağı. [signature] işlem anahtarının gövde imzasıdır (aynı gövde aynı anahtar).
@immutable
final class GroupDraft {
  GroupDraft({required this.name, required Iterable<String> memberIds})
    : memberIds = List.unmodifiable(memberIds.toSet().toList()..sort());

  final String name;
  final List<String> memberIds;

  String get signature => '${name.trim()}\u0000${memberIds.join(',')}';
}

/// Anlık akış sinyali: bağlantı açıldı (uzlaştırma zamanı) ya da içeriksiz olay.
sealed class ChatSignal {
  const ChatSignal();
}

/// Akış açıldı: istemci listeyi ve açık sohbeti uzlaştırır (§10.5 yeniden bağlanma protokolü).
final class ChatStreamOpened extends ChatSignal {
  const ChatStreamOpened();
}

enum ChatEventKind {
  messageCreated,
  messageUpdated,
  messageDeleted,
  readUpdated,
  memberChanged,
  chatChanged,
  typing,
}

/// İçeriksiz sohbet olayı (yalnız kimlikler; içerik HTTP'den okunur).
@immutable
final class ChatEvent extends ChatSignal {
  const ChatEvent({
    required this.kind,
    required this.chatId,
    required this.actorId,
    this.messageId,
    this.affected = const [],
  });

  final ChatEventKind kind;
  final String chatId;
  final String actorId;
  final String? messageId;
  final List<String> affected;
}

/// Mesajlaşma uçlarının domain portu (gerçekleştirme `data/`). Hatalar `ApiError`.
abstract interface class ChatRepository {
  /// Seçili programın sohbetleri (imleçli sayfalar birleştirilir; tavanda [ChatInbox.truncated]).
  Future<ChatInbox> loadInbox();

  /// Görünür bütün sohbetleri okundu sayar.
  Future<void> markAllRead();

  Future<Chat> getChat(String chatId);

  /// Geçmiş: [before] daha eskiler, [after] daha yeniler, [around] bir mesajın çevresi (en çok
  /// biri); hiçbiri yoksa son sayfa.
  Future<ChatHistoryPage> listMessages(
    String chatId, {
    int? before,
    int? after,
    int? around,
    int? limit,
  });

  Future<ChatMessage> send(String chatId, OutgoingMessage message);

  /// Düzenleme; [expectedRevision] okunan `edit_revision`. Bayat sürüm 409
  /// `messaging.edit_conflict`.
  Future<ChatMessage> edit(
    String chatId,
    String messageId, {
    required String text,
    required int expectedRevision,
  });

  Future<void> delete(String chatId, String messageId);

  Future<void> markRead(String chatId, String messageId);

  Future<void> typing(String chatId);

  Future<ChatCandidates> candidates(ChatCandidatePurpose purpose);

  /// Birebir sohbeti açar ya da mevcut olanı döndürür.
  Future<Chat> openDirect(String accountId);

  Future<Chat> createGroup(GroupDraft draft, {required String requestKey});

  /// Tek akış bağlantısı: açılınca [ChatStreamOpened], sonra olaylar; sunucu kapatınca biter,
  /// açılış ya da okuma hatasında `ApiError` fırlatır. Dinleyici bırakınca bağlantı kapanır.
  Stream<ChatSignal> events();
}
