// SampleChatRepository: 8 sohbet, kurmaca kişiler, 5 okunmamış sohbet.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/data/sample/sample_chat_repository.dart';

void main() {
  test('8 sohbet; 5 okunmamış; gerçek ad yok', () async {
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
    final text = box.chats
        .expand((c) => c.messages)
        .map((m) => m.text)
        .join(' ');
    expect(text, isNot(contains('Muhammet')));
    expect(text, contains('@Elif Nur'));
    expect(box.people, isNot(contains('ma')));
  });
}
