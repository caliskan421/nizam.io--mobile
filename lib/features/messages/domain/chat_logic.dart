import 'package:meta/meta.dart';

import '../../../core/domain/turkish_collation.dart';
import 'chat.dart';

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

@immutable
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

/// Sohbet akışı: gün değişiminde hap, [unreadMarker] mesajından önce ayırıcı; ardışık mesaj
/// grupları.
List<ChatItem> timeline(List<ChatMessage> msgs, {String? unreadMarker}) {
  final out = <ChatItem>[];
  DateTime? prevDay;
  String? prevFrom;
  for (var i = 0; i < msgs.length; i++) {
    final m = msgs[i];
    if (prevDay == null || !_sameDay(prevDay, m.at)) {
      out.add(ChatDayItem(DateTime(m.at.year, m.at.month, m.at.day)));
      prevDay = m.at;
      prevFrom = null;
    }
    if (unreadMarker == m.id) {
      out.add(const ChatNewItem());
      prevFrom = null;
    }
    final next = i + 1 < msgs.length ? msgs[i + 1] : null;
    final last =
        next == null ||
        next.senderId != m.senderId ||
        !_sameDay(next.at, m.at) ||
        unreadMarker == next.id;
    out.add(ChatMessageItem(m, first: prevFrom != m.senderId, last: last));
    prevFrom = m.senderId;
  }
  return out;
}

/// Mesaj listesi süzgeci.
enum ChatFilter { all, unread, groups, people }

/// Süzgeç + yerel arama (sohbet adı ve son mesaj metni; yüklü liste içinde).
List<Chat> visibleChats(
  List<Chat> chats, {
  ChatFilter filter = ChatFilter.all,
  String query = '',
}) {
  final q = trLower(query.trim());
  bool pass(Chat c) => switch (filter) {
    ChatFilter.all => true,
    ChatFilter.unread => c.isUnread,
    ChatFilter.groups => c.group,
    ChatFilter.people => !c.group,
  };
  return [
    for (final c in chats)
      if (pass(c) &&
          (q.isEmpty || trLower('${c.name} ${c.last?.text ?? ''}').contains(q)))
        c,
  ];
}
