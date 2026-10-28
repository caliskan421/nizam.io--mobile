import 'package:meta/meta.dart';

import '../../tasks/tasks.dart';
import 'chat.dart';

/// Türkçe küçük harf (arama).
String lowerTr(String s) =>
    s.replaceAll('I', 'ı').replaceAll('İ', 'i').toLowerCase();

final _taskToken = RegExp(r'#[A-ZÇĞİÖŞÜ]{2,4}-\d+');

/// Mesaj metninin parçası.
enum ChatTokenKind { text, mention, task }

@immutable
final class ChatToken {
  const ChatToken(this.kind, this.text);

  final ChatTokenKind kind;
  final String text;
}

/// Metinde bahsedilebilen adlar: "herkes", koordinatörlük adları, benim kısa adım (ilk iki
/// sözcük) ve kişilerin tam adları; uzun ad önce eşleşir.
List<String> mentionNames(TaskCatalog catalog, List<String> people) {
  final me = catalog.person(catalog.me)?.name ?? '';
  final short = me.split(' ').take(2).join(' ');
  final names = <String>{
    'herkes',
    for (final c in catalog.coordinatorships) c.name,
    if (short.isNotEmpty) short,
    for (final id in [catalog.me, ...people]) ?catalog.person(id)?.name,
  }.toList()..sort((a, b) => b.length.compareTo(a.length));
  return names;
}

/// Metni düz yazı, `@bahsetme` ve `#GÖREV-n` parçalarına böler.
List<ChatToken> tokenize(String text, List<String> mentions) {
  final alt = mentions.map(RegExp.escape).join('|');
  final re = RegExp(
    '(${alt.isEmpty ? '' : '@(?:$alt)|'}#[A-ZÇĞİÖŞÜ]{2,4}-\\d+)',
  );
  final out = <ChatToken>[];
  var last = 0;
  for (final m in re.allMatches(text)) {
    if (m.start > last) {
      out.add(ChatToken(ChatTokenKind.text, text.substring(last, m.start)));
    }
    final tok = m.group(0)!;
    out.add(
      ChatToken(
        tok.startsWith('#') ? ChatTokenKind.task : ChatTokenKind.mention,
        tok,
      ),
    );
    last = m.end;
  }
  if (last < text.length) {
    out.add(ChatToken(ChatTokenKind.text, text.substring(last)));
  }
  return out;
}

/// Metindeki var olan görev kodları (tekrarsız, sırayla).
List<String> taskCodesIn(String text, TaskCatalog catalog) => [
  ...{
    for (final m in _taskToken.allMatches(text))
      if (catalog.task(m.group(0)!.substring(1)) != null)
        m.group(0)!.substring(1),
  },
];

/// Mesajdaki bütün atıflar: metindeki #görev ve @koordinatörlük, ekli dosya ve eklenenler.
List<ChatRef> refsOf(ChatMessage m, TaskCatalog catalog) {
  final out = <ChatRef>[];
  void add(ChatRef r) {
    if (!out.contains(r)) out.add(r);
  }

  for (final code in taskCodesIn(m.text, catalog)) {
    add(ChatRef(ChatRefKind.task, code));
  }
  for (final c in catalog.coordinatorships) {
    if (m.text.contains('@${c.name}')) {
      add(ChatRef(ChatRefKind.coordinatorship, c.code));
    }
  }
  if (m.file case final f?) {
    add(ChatRef(ChatRefKind.file, f.name, coordinatorship: f.coordinatorship));
  }
  m.refs.forEach(add);
  return out;
}

/// Metinde zaten görünmeyen ek atıflar (balonda satır içi atıf olarak eklenir).
List<ChatRef> extraRefs(ChatMessage m, TaskCatalog catalog) => [
  for (final r in refsOf(m, catalog))
    if (!(r.kind == ChatRefKind.task && m.text.contains('#${r.id}')) &&
        !(r.kind == ChatRefKind.coordinatorship &&
            m.text.contains('@${catalog.coordinatorship(r.id)?.name}')))
      r,
];

/// Sohbetteki bütün atıflar (paylaşılanlar), tekrarsız.
List<ChatRef> sharedRefs(Chat chat, TaskCatalog catalog) {
  final out = <ChatRef>[];
  for (final m in chat.messages) {
    for (final r in refsOf(m, catalog)) {
      if (!out.contains(r)) out.add(r);
    }
  }
  return out;
}

/// Akış öğesi: gün hapı, okunmamış ayırıcısı ya da mesaj.
sealed class ChatItem {
  const ChatItem();
}

final class ChatDayItem extends ChatItem {
  const ChatDayItem(this.day);

  final DateTime day;
}

final class ChatNewItem extends ChatItem {
  const ChatNewItem();
}

final class ChatMessageItem extends ChatItem {
  const ChatMessageItem(
    this.message, {
    required this.first,
    required this.last,
  });

  final ChatMessage message;

  /// Aynı kişinin ardışık mesaj dizisinin ilki (ad gösterilir).
  final bool first;

  /// Dizinin sonuncusu (avatar ve geniş köşe).
  final bool last;
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Sohbet akışı: gün değişiminde hap, okunmamış işaretinde ayırıcı; ardışık mesaj grupları.
List<ChatItem> timeline(Chat chat) {
  final out = <ChatItem>[];
  final msgs = chat.messages;
  DateTime? prevDay;
  String? prevFrom;
  for (var i = 0; i < msgs.length; i++) {
    final m = msgs[i];
    if (prevDay == null || !_sameDay(prevDay, m.at)) {
      out.add(ChatDayItem(DateTime(m.at.year, m.at.month, m.at.day)));
      prevDay = m.at;
      prevFrom = null;
    }
    if (chat.unreadMarker == m.id) {
      out.add(const ChatNewItem());
      prevFrom = null;
    }
    final next = i + 1 < msgs.length ? msgs[i + 1] : null;
    final last =
        next == null ||
        next.from != m.from ||
        !_sameDay(next.at, m.at) ||
        chat.unreadMarker == next.id;
    out.add(ChatMessageItem(m, first: prevFrom != m.from, last: last));
    prevFrom = m.from;
  }
  return out;
}

/// Açılışta "okunmamış mesajlar" ayırıcısının mesajı.
String? unreadMarkerOf(Chat chat) {
  if (chat.unread <= 0 || chat.messages.isEmpty) return null;
  return chat.newBefore ??
      chat
          .messages[(chat.messages.length - chat.unread).clamp(
            0,
            chat.messages.length - 1,
          )]
          .id;
}

/// Mesaj listesi süzgeci.
enum ChatFilter { all, unread, groups, people }

/// Süzgeç + arama (ad ve mesaj metinlerinde).
List<Chat> visibleChats(
  List<Chat> chats, {
  ChatFilter filter = ChatFilter.all,
  String query = '',
}) {
  final q = lowerTr(query.trim());
  bool pass(Chat c) => switch (filter) {
    ChatFilter.all => true,
    ChatFilter.unread => c.isUnread,
    ChatFilter.groups => c.group,
    ChatFilter.people => !c.group,
  };
  return [
    for (final c in chats)
      if (pass(c) &&
          (q.isEmpty ||
              lowerTr('${c.name} ${c.messages.map((m) => m.text).join(' ')}')
                  .contains(q)))
        c,
  ];
}

/// Yazma alanı önerisi: [key] solda mono (görev kodu ya da "@"), [label] satır, [draft]
/// seçilince yazılacak metin.
@immutable
final class ChatSuggestion {
  const ChatSuggestion({
    required this.key,
    required this.label,
    required this.draft,
    this.role,
  });

  final String key;
  final String label;

  /// Kişi önerisinde rol (sunumda "ad · rol").
  final PersonRole? role;
  final String draft;
}

final _hashTail = RegExp(r'#([\wÇĞİÖŞÜçğıöşü-]*)$');
final _atTail = RegExp(r'@([\wçğıöşüÇĞİÖŞÜ]*)$');

/// Taslağın sonundaki `#…` için görev, `@…` için kişi önerileri (en çok 6).
List<ChatSuggestion> suggestions(
  String draft,
  TaskCatalog catalog,
  List<String> people,
) {
  final hash = _hashTail.firstMatch(draft);
  if (hash != null) {
    final k = lowerTr(hash.group(1)!);
    return [
      for (final t in catalog.tasks)
        if (k.isEmpty ||
            lowerTr(t.code).startsWith(k) ||
            lowerTr(t.title).contains(k))
          ChatSuggestion(
            key: t.code,
            label: t.title,
            draft: draft.replaceFirst(RegExp(r'#[^\s#]*$'), '#${t.code} '),
          ),
    ].take(6).toList();
  }
  final at = _atTail.firstMatch(draft);
  if (at != null) {
    final k = lowerTr(at.group(1)!);
    final all = <(String, String, PersonRole?)>[
      ('herkes', 'herkes', null),
      for (final id in people)
        if (catalog.person(id) case final p?) (p.name, p.name, p.role),
    ];
    return [
      for (final (name, label, role) in all)
        if (k.isEmpty || lowerTr(name).startsWith(k))
          ChatSuggestion(
            key: '@',
            label: label,
            role: role,
            draft: draft.replaceFirst(RegExp(r'@[^\s@]*$'), '@$name '),
          ),
    ].take(6).toList();
  }
  return const [];
}
