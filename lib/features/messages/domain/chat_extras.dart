import 'package:meta/meta.dart';

import 'chat.dart';

/// Bahsetme hedefinin türü (§10.8).
enum ChatMentionKind { account, department, all }

/// Yapılandırılmış bahsetme (`mentions`): sunucu metni ayrıştırmaz; [targetId] `all`da yok.
@immutable
final class ChatMention {
  const ChatMention.account(String id)
    : kind = ChatMentionKind.account,
      targetId = id;
  const ChatMention.department(String id)
    : kind = ChatMentionKind.department,
      targetId = id;
  const ChatMention.all() : kind = ChatMentionKind.all, targetId = null;

  final ChatMentionKind kind;
  final String? targetId;

  @override
  bool operator ==(Object other) =>
      other is ChatMention && other.kind == kind && other.targetId == targetId;

  @override
  int get hashCode => Object.hash(kind, targetId);
}

/// Sunucunun bahsetme tavanı (tekrar tekilleşir; aşım 422).
const chatMaxMentions = 20;

/// Yazma alanında seçilmiş bahsetme: metindeki görünen etiket (`@Ad`) ve hedef.
typedef MentionPick = ({String label, ChatMention mention});

/// Metnin imleçten önceki son `@sorgu` parçası (boşluk içermez); yoksa null.
String? mentionQuery(String text) {
  final at = text.lastIndexOf('@');
  if (at < 0) return null;
  if (at > 0 && !RegExp(r'\s').hasMatch(text[at - 1])) return null;
  final q = text.substring(at + 1);
  return q.contains(RegExp(r'\s')) ? null : q;
}

/// Son `@sorgu` parçasını seçilen etiketle değiştirir (`@Ad `).
String applyMention(String text, String label) {
  final at = text.lastIndexOf('@');
  return '${at < 0 ? text : text.substring(0, at)}@$label ';
}

/// Gönderilecek bahsetmeler: metinde etiketi hâlâ duran seçimler (tekil, en çok
/// [chatMaxMentions]); metinden silinen seçim gitmez.
List<ChatMention> mentionsIn(String text, Iterable<MentionPick> picks) =>
    <ChatMention>{
      for (final p in picks)
        if (text.contains('@${p.label}')) p.mention,
    }.take(chatMaxMentions).toList();

/// Sohbet içi arama sayfa boyu (dolu sayfa → daha eski sonuç olabilir).
const chatSearchPageSize = 30;

/// Paylaşılan öğenin türü (§10.8 `refs`).
enum ChatRefKind { task, department, file }

/// Yeni mesajın paylaşım girdisi; kalıcı referans kimliğini sunucu üretir.
@immutable
final class ChatRefDraft {
  const ChatRefDraft({required this.kind, required this.targetId});

  final ChatRefKind kind;
  final String targetId;
}

/// Dinamik üyelik kaynağı. Kaynağı kapatmak için açıkça [none] gönderilir.
enum ChatSource { none, department, program }

/// Programlar arası sayaç; bahsetme okunmamış sohbet sayısından ayrı korunur.
@immutable
final class ChatProgramUnread {
  const ChatProgramUnread({
    required this.programId,
    required this.name,
    required this.unreadChats,
    required this.mentioned,
  });

  final String programId;
  final String name;
  final int unreadChats;
  final bool mentioned;
}

/// Mesajdaki paylaşılan öğe (statik; kart [ChatRefCard] tekil okumayla dolar).
@immutable
final class ChatMessageRef {
  const ChatMessageRef({
    required this.refId,
    required this.kind,
    required this.targetId,
  });

  final String refId;
  final ChatRefKind kind;
  final String targetId;
}

/// Referans kartı (`getChatRefSummary`): okuyana sınırlı özet. [available] `false` → "artık yok"
/// (kart alanları boş). Görev: [title], [department], [start]–[end]; dosya: [title] (ad),
/// [sizeBytes]; koordinatörlük: [title] (ad).
@immutable
final class ChatRefCard {
  const ChatRefCard({
    required this.refId,
    required this.kind,
    required this.available,
    this.title,
    this.department,
    this.start,
    this.end,
    this.sizeBytes,
  });

  final String refId;
  final ChatRefKind kind;
  final bool available;
  final String? title;
  final String? department;
  final DateTime? start;
  final DateTime? end;
  final int? sizeBytes;
}

/// Paylaşılanlar satırı (`listChatRefs`; en yeniden eskiye).
@immutable
final class ChatSharedItem {
  const ChatSharedItem({
    required this.refId,
    required this.kind,
    required this.targetId,
    required this.messageId,
    required this.senderId,
    required this.at,
  });

  final String refId;
  final ChatRefKind kind;
  final String targetId;
  final String messageId;
  final String senderId;
  final DateTime at;
}

/// Paylaşılanlar sayfası; [nextCursor] null → son sayfa.
@immutable
final class ChatSharedPage {
  ChatSharedPage({required List<ChatSharedItem> items, this.nextCursor})
    : items = List.unmodifiable(items);

  final List<ChatSharedItem> items;
  final String? nextCursor;
}

/// Sabit mesajların sunucu tavanıyla kesilip kesilmediğini koruyan sayfa.
@immutable
final class ChatPinsPage {
  ChatPinsPage({required List<ChatMessage> items, this.truncated = false})
    : items = List.unmodifiable(items);

  final List<ChatMessage> items;
  final bool truncated;
}

/// Sohbet üyesi (`listChatMembers`). [fromSource]: kaynaktan gelir; çıkarılamaz, ayrılamaz.
@immutable
final class ChatMember {
  const ChatMember({
    required this.accountId,
    required this.name,
    required this.role,
    this.fromSource = false,
  });

  final String accountId;
  final String name;
  final ChatMemberRole role;
  final bool fromSource;
}

/// Üye listesi (en çok 200; [truncated] kırpıldı).
@immutable
final class ChatMembers {
  ChatMembers({required List<ChatMember> items, this.truncated = false})
    : items = List.unmodifiable(items);

  final List<ChatMember> items;
  final bool truncated;

  ChatMember? member(String id) =>
      items.where((m) => m.accountId == id).firstOrNull;

  /// Hesabın adı (yazıyor, bahsetme); listede yoksa null.
  String? name(String id) => member(id)?.name;
}

/// Anket açma girdisi (soru mesaj gövdesidir; yalnız grupta, 2–10 tekil seçenek).
@immutable
final class PollDraft {
  PollDraft({
    required Iterable<String> options,
    this.multi = false,
    this.closesAt,
  }) : options = List.unmodifiable(options);

  final List<String> options;
  final bool multi;
  final DateTime? closesAt;

  static const minOptions = 2;
  static const maxOptions = 10;

  /// Kırpılmış, boş olmayan, tekil seçenekler sınırlar içinde mi.
  static bool valid(Iterable<String> options) {
    final list = [
      for (final o in options)
        if (o.trim().isNotEmpty) o.trim(),
    ];
    return list.length >= minOptions &&
        list.length <= maxOptions &&
        list.toSet().length == list.length;
  }
}

/// Gönderilecek yerel dosya (seçiciden). [contentType] izinli kümeden (bildirilen tür).
@immutable
final class ChatUpload {
  const ChatUpload({
    required this.path,
    required this.name,
    required this.sizeBytes,
    required this.contentType,
  });

  final String path;
  final String name;
  final int sizeBytes;
  final String contentType;
}

/// Mesajdan görevin önceliği (sunucu değeri `data/`'da eşlenir).
enum ChatTaskPriority { low, medium, high, urgent }

/// Mesajdan görev girdisi (`createTaskFromChatMessage`; açıklama mesaj gövdesidir).
@immutable
final class ChatTaskDraft {
  const ChatTaskDraft({
    required this.departmentId,
    required this.start,
    required this.end,
    this.title,
    this.priority,
    this.assigneeIds = const [],
  });

  final String departmentId;
  final DateTime start;
  final DateTime end;
  final String? title;
  final ChatTaskPriority? priority;
  final List<String> assigneeIds;
}

/// Mesajdan açılan görevin sonucu: görev kimliği ve güncel mesaj (`task_ids` dahil).
typedef ChatTaskCreated = ({String workItemId, ChatMessage message});

/// Tepki listesinde benim tepkimi [to] yapar (null → kaldır); sayılar iyimser güncellenir.
List<ChatReactionCount> withMyReaction(
  List<ChatReactionCount> list,
  ChatReaction? to,
) {
  final counts = {for (final r in ChatReaction.values) r: 0};
  ChatReaction? mine;
  for (final r in list) {
    counts[r.kind] = r.count;
    if (r.mine) mine = r.kind;
  }
  if (mine != null) counts[mine] = counts[mine]! - 1;
  if (to != null) counts[to] = counts[to]! + 1;
  return [
    for (final r in ChatReaction.values)
      if (counts[r]! > 0) ChatReactionCount(r, counts[r]!, mine: r == to),
  ];
}

/// Ankette oy veren (sonuçta isimlidir).
typedef ChatPollVoter = ({String accountId, String name});

/// Anket seçeneğinin sonucu.
@immutable
final class ChatPollOption {
  const ChatPollOption(this.label, this.count, {this.voters = const []});

  final String label;
  final int count;

  /// Oy verenler (sunucu `voters`; kendi oyum buradan çıkarılır).
  final List<ChatPollVoter> voters;

  bool votedBy(String? accountId) =>
      voters.any((v) => v.accountId == accountId);
}

/// Anket (soru mesaj gövdesidir). Oy kümesi önceki oyun yerine geçer; bitirme yalnız açanda.
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

  /// Kapandı ya da son tarihi geçti (oy 409 `poll_closed` alır).
  bool isClosed(DateTime now) =>
      closed || (closesAt != null && !closesAt!.isAfter(now));

  /// Benim seçtiğim seçeneklerin sırası.
  Set<int> mine(String? me) => {
    for (var i = 0; i < options.length; i++)
      if (options[i].votedBy(me)) i,
  };

  /// Seçime [i] dokunuşunun yeni oy kümesi: tek seçimde aynı seçenek geri çeker, başkası yerine
  /// geçer; çoklu seçimde açılıp kapanır.
  Set<int> toggled(Set<int> current, int i) => multi
      ? (current.contains(i) ? ({...current}..remove(i)) : {...current, i})
      : (current.contains(i) ? <int>{} : {i});

  /// Benim oyumun [picks] olduğu iyimser görünüm.
  ChatPoll withVotes(ChatPollVoter me, Set<int> picks) {
    final options = [
      for (var i = 0; i < this.options.length; i++)
        _revote(this.options[i], me, picks.contains(i)),
    ];
    return ChatPoll(
      multi: multi,
      options: options,
      voters: {
        for (final o in options)
          for (final v in o.voters) v.accountId,
      }.length,
      closesAt: closesAt,
      closed: closed,
    );
  }

  static ChatPollOption _revote(ChatPollOption o, ChatPollVoter me, bool on) {
    final others = [
      for (final v in o.voters)
        if (v.accountId != me.accountId) v,
    ];
    final had = others.length != o.voters.length;
    final voters = on ? [...others, me] : others;
    return ChatPollOption(
      o.label,
      o.count - (had ? 1 : 0) + (on ? 1 : 0),
      voters: voters,
    );
  }

  ChatPoll asClosed() => ChatPoll(
    multi: multi,
    options: options,
    voters: voters,
    closesAt: closesAt,
    closed: true,
  );
}
