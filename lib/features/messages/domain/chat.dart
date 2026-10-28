import 'package:meta/meta.dart';

/// Mesaj tepkisi (mesaj başına bir tane).
enum ChatReaction { like, heart, check, star }

/// Mesaj atfının türü: portal görevi, koordinatörlük, arşiv dosyası ya da cihazdan eklenen
/// fotoğraf/belge.
enum ChatRefKind { task, coordinatorship, file, photo, document }

/// Mesajdaki atıf. [id] görev/koordinatörlük kodu ya da dosya adıdır.
@immutable
final class ChatRef {
  const ChatRef(this.kind, this.id, {this.coordinatorship, this.size});

  final ChatRefKind kind;
  final String id;

  /// Arşiv dosyasının klasörü (koordinatörlük kodu).
  final String? coordinatorship;

  /// Cihaz dosyasının boyutu ("2,4 MB").
  final String? size;

  @override
  bool operator ==(Object other) =>
      other is ChatRef && other.kind == kind && other.id == id;

  @override
  int get hashCode => Object.hash(kind, id);
}

/// Mesaja eklenmiş arşiv dosyası.
@immutable
final class ChatFile {
  const ChatFile({
    required this.kind,
    required this.name,
    required this.size,
    required this.coordinatorship,
  });

  /// Tür etiketi ("XLSX").
  final String kind;
  final String name;
  final String size;
  final String coordinatorship;
}

/// Anket seçeneği.
@immutable
final class ChatPollOption {
  const ChatPollOption(this.label, this.votes);

  final String label;
  final int votes;
}

/// Anket (çoklu seçim). [meta] "Çoklu seçim · isimli" ve [deadline] "son 25 Ekim 18:00" örnek
/// veridir (sunucu metni).
@immutable
final class ChatPoll {
  const ChatPoll({
    required this.question,
    required this.meta,
    required this.deadline,
    required this.options,
    this.mine = const {},
    this.ended = false,
    this.baseVoters = 9,
  });

  final String question;
  final String meta;
  final String deadline;
  final List<ChatPollOption> options;

  /// Benim seçtiğim seçenek sıraları.
  final Set<int> mine;
  final bool ended;

  /// Benim dışımda oy veren kişi sayısı.
  final int baseVoters;

  int get voters => baseVoters + (mine.isEmpty ? 0 : 1);

  int get totalVotes => options.fold(0, (t, o) => t + o.votes);

  /// Seçeneğin yüzdesi (yuvarlanmış).
  int percent(int i) =>
      totalVotes == 0 ? 0 : (options[i].votes / totalVotes * 100).round();

  /// Oy ver / geri al.
  ChatPoll toggle(int i) {
    final on = mine.contains(i);
    return ChatPoll(
      question: question,
      meta: meta,
      deadline: deadline,
      options: [
        for (var k = 0; k < options.length; k++)
          k == i
              ? ChatPollOption(
                  options[k].label,
                  options[k].votes + (on ? -1 : 1),
                )
              : options[k],
      ],
      mine: on ? ({...mine}..remove(i)) : {...mine, i},
      ended: ended,
      baseVoters: baseVoters,
    );
  }

  ChatPoll end() => ChatPoll(
    question: question,
    meta: meta,
    deadline: deadline,
    options: options,
    mine: mine,
    ended: true,
    baseVoters: baseVoters,
  );
}

/// Sohbet mesajı. [from] görev kataloğundaki kişi kimliğidir.
@immutable
final class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.from,
    required this.at,
    required this.text,
    this.reactions = const {},
    this.myReaction,
    this.read = false,
    this.sent = true,
    this.replyTo,
    this.file,
    this.edited = false,
    this.poll,
    this.refs = const [],
  });

  final String id;
  final String from;
  final DateTime at;
  final String text;
  final Map<ChatReaction, int> reactions;
  final ChatReaction? myReaction;

  /// Kendi mesajında: karşı taraf okudu.
  final bool read;

  /// Kendi mesajında: sunucuya ulaştı (gönderilirken false).
  final bool sent;
  final String? replyTo;
  final ChatFile? file;
  final bool edited;
  final ChatPoll? poll;

  /// Yazma alanında eklenen atıflar.
  final List<ChatRef> refs;

  /// Önizleme/alıntı metni: anket sorusu ya da metin.
  String get summary => poll?.question ?? text;

  ChatMessage copyWith({
    String? text,
    Map<ChatReaction, int>? reactions,
    ChatReaction? Function()? myReaction,
    bool? read,
    bool? sent,
    bool? edited,
    ChatPoll? poll,
  }) => ChatMessage(
    id: id,
    from: from,
    at: at,
    text: text ?? this.text,
    reactions: reactions ?? this.reactions,
    myReaction: myReaction == null ? this.myReaction : myReaction(),
    read: read ?? this.read,
    sent: sent ?? this.sent,
    replyTo: replyTo,
    file: file,
    edited: edited ?? this.edited,
    poll: poll ?? this.poll,
    refs: refs,
  );

  /// Tepki ekler/kaldırır (mesaj başına bir tepki: yenisi eskisini kaldırır).
  ChatMessage react(ChatReaction r) {
    final counts = {...reactions};
    void off(ChatReaction k) {
      final n = (counts[k] ?? 1) - 1;
      if (n <= 0) {
        counts.remove(k);
      } else {
        counts[k] = n;
      }
    }

    final current = myReaction;
    if (current == r) {
      off(r);
      return copyWith(reactions: counts, myReaction: () => null);
    }
    if (current != null) off(current);
    counts[r] = (counts[r] ?? 0) + 1;
    return copyWith(reactions: counts, myReaction: () => r);
  }
}

/// Sohbet (grup ya da birebir).
@immutable
final class Chat {
  const Chat({
    required this.id,
    required this.name,
    required this.messages,
    this.group = false,
    this.members = 2,
    this.unread = 0,
    this.mention = false,
    this.pins = const [],
    this.newBefore,
    this.typing,
    this.person,
    this.online = false,
    this.lastSeen,
    this.unreadMarker,
    this.muted = false,
  });

  final String id;
  final String name;
  final List<ChatMessage> messages;
  final bool group;
  final int members;
  final int unread;

  /// Benden bahsedildi (okunmamış sayılır).
  final bool mention;

  /// Sabitlenen mesaj kimlikleri (en yeni başta).
  final List<String> pins;

  /// Okunmamışların başladığı mesaj (sunucu işareti; yoksa son [unread] mesaj).
  final String? newBefore;

  /// Şu an yazan kişi kimliği (açılışta kısa süre görünür).
  final String? typing;

  /// Birebir sohbette karşı kişi kimliği.
  final String? person;
  final bool online;
  final DateTime? lastSeen;

  /// Açılışta hesaplanan "okunmamış mesajlar" ayırıcısının mesajı.
  final String? unreadMarker;
  final bool muted;

  bool get isUnread => unread > 0 || mention;

  ChatMessage? message(String id) =>
      messages.where((m) => m.id == id).firstOrNull;

  ChatMessage get last => messages.last;

  Chat copyWith({
    List<ChatMessage>? messages,
    int? unread,
    bool? mention,
    List<String>? pins,
    String? Function()? unreadMarker,
    bool? muted,
  }) => Chat(
    id: id,
    name: name,
    messages: messages ?? this.messages,
    group: group,
    members: members,
    unread: unread ?? this.unread,
    mention: mention ?? this.mention,
    pins: pins ?? this.pins,
    newBefore: newBefore,
    typing: typing,
    person: person,
    online: online,
    lastSeen: lastSeen,
    unreadMarker: unreadMarker == null ? this.unreadMarker : unreadMarker(),
    muted: muted ?? this.muted,
  );

  /// Mesajı değiştirir.
  Chat mapMessage(String id, ChatMessage Function(ChatMessage) f) =>
      copyWith(messages: [for (final m in messages) m.id == id ? f(m) : m]);
}

/// Mesajlar kutusu: sohbetler (liste sırasıyla) ve bahsedilebilir kişiler.
@immutable
final class ChatInbox {
  ChatInbox({required List<Chat> chats, required List<String> people})
    : chats = List.unmodifiable(chats),
      people = List.unmodifiable(people);

  final List<Chat> chats;

  /// Sohbetlerde bahsedilebilen/önerilen kişi kimlikleri (ben dahil değil).
  final List<String> people;

  Chat? chat(String id) => chats.where((c) => c.id == id).firstOrNull;

  int get unreadChats => chats.where((c) => c.isUnread).length;

  ChatInbox replace(String id, Chat Function(Chat) f) => ChatInbox(
    chats: [for (final c in chats) c.id == id ? f(c) : c],
    people: people,
  );

  ChatInbox mapChats(Chat Function(Chat) f) =>
      ChatInbox(chats: [for (final c in chats) f(c)], people: people);
}

/// Mesajlar kutusunun kaynağı (domain portu; gerçekleştirmeler `data/`).
abstract interface class ChatRepository {
  Future<ChatInbox> load();
}
