// ChatSharedController: ilk sayfa, imleçle sonraki sayfa; bilinmeyen imleç (boş sayfa + null)
// listeyi baştan okur; referans kartı tekil okuma.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/application/chat_shared_controller.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

import '../fake_chat_repository.dart';

ChatSharedItem _item(String id) => ChatSharedItem(
  refId: id,
  kind: ChatRefKind.file,
  targetId: 't-$id',
  messageId: 'm1',
  senderId: peer,
  at: at(1),
);

void main() {
  test('sayfalar imleçle birleşir; bilinmeyen imleç baştan okur', () async {
    final repo = FakeChatRepository();
    repo.sharedPages[null] = ChatSharedPage(
      items: [_item('r2')],
      nextCursor: 'r2',
    );
    repo.sharedPages['r2'] = ChatSharedPage(
      items: [_item('r1')],
      nextCursor: 'r1',
    );
    final c = chatContainer(repo)
      ..listen(chatSharedControllerProvider('c1'), (_, _) {});
    final first = await c.read(chatSharedControllerProvider('c1').future);
    expect(first.items.map((x) => x.refId), ['r2']);
    final ctl = c.read(chatSharedControllerProvider('c1').notifier);
    await ctl.more();
    final s = c.read(chatSharedControllerProvider('c1')).requireValue;
    expect(s.items.map((x) => x.refId), ['r2', 'r1']);
    expect(s.nextCursor, 'r1');
    // 'r1' imleci bilinmiyor (sayfa yok): boş + null → baştan.
    await ctl.more();
    await c.read(chatSharedControllerProvider('c1').future);
    expect(repo.calls, ['shared -', 'shared r2', 'shared r1', 'shared -']);
    expect(
      c
          .read(chatSharedControllerProvider('c1'))
          .requireValue
          .items
          .single
          .refId,
      'r2',
    );
  });

  test('referans kartı', () async {
    final repo = FakeChatRepository();
    final c = chatContainer(repo)..listen(chatRefCardProvider('x'), (_, _) {});
    final card = await c.read(chatRefCardProvider('x').future);
    expect((card.available, card.title), (true, 'Rapor.pdf'));
    expect(repo.calls, ['card x']);
  });
}
