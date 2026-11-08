// ChatsController: liste, tümünü okundu (sunucuda), satır okundu, yeni sohbetin eklenmesi,
// akış sinyalleri (açılışta hemen, olaylarda birleşik tek okuma); alt menü alt yazısı.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/application/chats_controller.dart';
import 'package:nizamio/features/messages/application/messages_providers.dart';
import 'package:nizamio/features/messages/domain/chat.dart';
import 'package:nizamio/features/messages/messages.dart';

import '../fake_chat_repository.dart';

void main() {
  test('liste, tümünü okundu, satır okundu, yeni sohbet', () async {
    final repo = FakeChatRepository()
      ..inbox = ChatInbox(chats: [chat('a', unread: 2), chat('b', unread: 1)]);
    final c = chatContainer(repo)
      ..listen(chatsControllerProvider, (_, _) {})
      ..listen(messagesNavBadgeProvider, (_, _) {});
    await c.read(chatsControllerProvider.future);
    expect(c.read(messagesNavBadgeProvider), 2);
    final ctrl = c.read(chatsControllerProvider.notifier)..markedRead('a');
    expect(c.read(messagesNavBadgeProvider), 1);
    await ctrl.markAllRead();
    expect(repo.calls, contains('markAllRead'));
    expect(c.read(messagesNavBadgeProvider), 0);
    ctrl.opened(chat('z'));
    expect(c.read(chatsControllerProvider).requireValue.chats.first.id, 'z');
  });

  test(
    'akış: açılış hemen, olaylar 1 sn birleşip tek okuma; yazıyor okumaz',
    () async {
      final repo = FakeChatRepository();
      final c = chatContainer(repo)..listen(chatsControllerProvider, (_, _) {});
      await c.read(chatsControllerProvider.future);
      int reads() => repo.calls.where((x) => x == 'loadInbox').length;
      final bus = c.read(chatSignalBusProvider)..add(const ChatStreamOpened());
      await pumpEventQueue();
      expect(reads(), 2);
      for (final k in [
        ChatEventKind.messageCreated,
        ChatEventKind.readUpdated,
        ChatEventKind.messageDeleted,
      ]) {
        bus.add(ChatEvent(kind: k, chatId: 'c1', actorId: peer));
      }
      bus.add(
        const ChatEvent(
          kind: ChatEventKind.typing,
          chatId: 'c1',
          actorId: peer,
        ),
      );
      await pumpEventQueue();
      expect(reads(), 2);
      await Future<void>.delayed(const Duration(milliseconds: 1150));
      await pumpEventQueue();
      expect(reads(), 3);
    },
  );
}
