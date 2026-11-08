// ChatMembersController: liste okunur; üye olayları birleşip tek okuma (başka sohbet yok sayılır);
// ekleme/çıkarma/yöneticilik sonrası yeniden okuma; ayrılma ve silme satırı listeden düşürür;
// ad değişimi açık sohbete yansır; eklenebilecek adaylar sohbet kimliğiyle.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/messages/application/chat_members_controller.dart';
import 'package:nizamio/features/messages/application/chat_room_controller.dart';
import 'package:nizamio/features/messages/application/chats_controller.dart';
import 'package:nizamio/features/messages/application/messages_providers.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

import '../fake_chat_repository.dart';

Future<(ProviderContainer, FakeChatRepository)> _open() async {
  final repo = FakeChatRepository()
    ..inbox = ChatInbox(chats: [chat('g1', group: true, name: 'Saha')])
    ..server['g1'] = [msg(1)]
    ..getChatResult = (id) => chat(id, group: true, name: 'Saha');
  final c = chatContainer(repo)
    ..listen(chatsControllerProvider, (_, _) {})
    ..listen(chatRoomControllerProvider('g1'), (_, _) {})
    ..listen(chatMembersControllerProvider('g1'), (_, _) {});
  await c.read(chatsControllerProvider.future);
  await c.read(chatRoomControllerProvider('g1').future);
  await c.read(chatMembersControllerProvider('g1').future);
  return (c, repo);
}

ChatMembersController _ctl(ProviderContainer c) =>
    c.read(chatMembersControllerProvider('g1').notifier);

int _reads(FakeChatRepository r) =>
    r.calls.where((x) => x == 'members g1').length;

void main() {
  test('liste ve ad çözümü; üye olayları birleşir', () async {
    final (c, repo) = await _open();
    final members = c.read(chatMembersControllerProvider('g1')).requireValue;
    expect(members.name(peer), 'Kadir Özbek');
    expect(members.name('yok'), isNull);
    final before = _reads(repo);
    final bus = c.read(chatSignalBusProvider);
    for (final id in ['g1', 'g1', 'baska']) {
      bus.add(
        ChatEvent(kind: ChatEventKind.memberChanged, chatId: id, actorId: peer),
      );
    }
    bus.add(
      const ChatEvent(
        kind: ChatEventKind.messageCreated,
        chatId: 'g1',
        actorId: peer,
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 1150));
    expect(_reads(repo), before + 1);
    bus.add(const ChatStreamOpened());
    await pumpEventQueue();
    expect(_reads(repo), before + 2);
  });

  test('ekleme, çıkarma, yöneticilik: yazma + yeniden okuma', () async {
    final (c, repo) = await _open();
    await _ctl(c).add(['a', 'b', 'a']);
    await _ctl(c).add(const []);
    await _ctl(c).remove(peer);
    await _ctl(c).setAdmin(peer, admin: true);
    expect(
      repo.calls,
      containsAllInOrder([
        'add a,b',
        'members g1',
        'remove $peer',
        'members g1',
        'admin $peer true',
        'members g1',
      ]),
    );
    expect(repo.calls.where((x) => x.startsWith('add')), hasLength(1));
    repo.writeError = ApiError('messaging.member_source_managed', status: 409);
    await expectLater(_ctl(c).remove(peer), throwsA(isA<ApiError>()));
  });

  test(
    'ad değişimi açık sohbete yansır; ayrılma ve silme satırı düşürür',
    () async {
      final (c, repo) = await _open();
      await _ctl(c).rename('Saha Ekibi');
      expect(repo.calls, contains('rename Saha Ekibi'));
      expect(
        c.read(chatRoomControllerProvider('g1')).requireValue.chat.name,
        'Saha Ekibi',
      );
      await _ctl(c).leave();
      expect(repo.calls, contains('remove $me'));
      expect(c.read(chatsControllerProvider).requireValue.chat('g1'), isNull);
      await _ctl(c).deleteChat();
      expect(repo.calls, contains('deleteChat g1'));
    },
  );

  test('eklenebilecek adaylar sohbet kimliğiyle', () async {
    final (c, repo) = await _open();
    c.listen(chatAddCandidatesProvider('g1'), (_, _) {});
    final list = await c.read(chatAddCandidatesProvider('g1').future);
    expect(list.items, isNotEmpty);
    expect(repo.calls, contains('candidates group g1'));
  });
}
