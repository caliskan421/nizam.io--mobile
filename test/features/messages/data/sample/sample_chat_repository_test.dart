// SampleChatRepository: 8 sohbet, prototip kişileri, 5 okunmamış sohbet (koord 1 okunmamış + anma).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/data/sample/sample_chat_repository.dart';

void main() {
  test(
    '8 sohbet; 5 okunmamış (koord 1 okunmamış + anma); prototip içeriği',
    () async {
      final box = await const SampleChatRepository().load();
      expect(box.chats.map((c) => c.id), [
        'gen',
        'koord',
        'sis',
        'hid',
        'kadir',
        'bahar',
        'fuar',
        'reha',
      ]);
      expect(box.unreadChats, 5);
      final koord = box.chats.firstWhere((c) => c.id == 'koord');
      expect((koord.isUnread, koord.mention), (true, true));
      final text = box.chats
          .expand((c) => c.messages)
          .map((m) => m.text)
          .join(' ');
      expect(text, contains('@Muhammet Ali'));
      expect(box.people, isNot(contains('ma')));
    },
  );
}
