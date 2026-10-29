// SampleChatRepository: 8 sohbet, prototip kişileri, 4 okunmamış sohbet (koord başlangıçta okunmuş).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/data/sample/sample_chat_repository.dart';

void main() {
  test(
    '8 sohbet; 4 okunmamış (koord başlangıçta okunmuş); prototip içeriği',
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
      expect(box.unreadChats, 4);
      expect(box.chats.firstWhere((c) => c.id == 'koord').isUnread, isFalse);
      final text = box.chats
          .expand((c) => c.messages)
          .map((m) => m.text)
          .join(' ');
      expect(text, contains('@Muhammet Ali'));
      expect(box.people, isNot(contains('ma')));
    },
  );
}
