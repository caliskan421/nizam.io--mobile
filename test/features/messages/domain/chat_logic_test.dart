// Akış öğeleri (gün hapı, ayırıcı, ardışık grup) ve liste süzgeci/araması.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/domain/chat.dart';
import 'package:nizamio/features/messages/domain/chat_logic.dart';

import '../fake_chat_repository.dart';

void main() {
  test('timeline: gün hapı, ayırıcı ve ardışık mesaj grupları', () {
    final items = timeline([
      msg(1),
      msg(2),
      msg(3, sender: me),
    ], unreadMarker: 'm2');
    expect(items.map((i) => i.runtimeType.toString()), [
      'ChatDayItem',
      'ChatMessageItem',
      'ChatNewItem',
      'ChatMessageItem',
      'ChatMessageItem',
    ]);
    final m1 = items[1] as ChatMessageItem;
    final m2 = items[3] as ChatMessageItem;
    expect((m1.first, m1.last), (true, true), reason: 'ayırıcı diziyi böler');
    expect((m2.first, m2.last), (true, true));
  });

  test('süzgeç ve arama (ad ve son mesaj)', () {
    final chats = [
      chat('a', unread: 1),
      chat('b', group: true, name: 'Genel'),
      Chat(
        id: 'c',
        name: 'Reha',
        lastActivity: at(0),
        last: ChatPreview(
          senderId: peer,
          senderName: 'Reha',
          at: at(1),
          text: 'Trafo onayı',
        ),
      ),
    ];
    expect(visibleChats(chats, filter: ChatFilter.unread).map((c) => c.id), [
      'a',
    ]);
    expect(visibleChats(chats, filter: ChatFilter.groups).map((c) => c.id), [
      'b',
    ]);
    expect(visibleChats(chats, filter: ChatFilter.people).length, 2);
    expect(visibleChats(chats, query: 'trafo').map((c) => c.id), ['c']);
  });
}
