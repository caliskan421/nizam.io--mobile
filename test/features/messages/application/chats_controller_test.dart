// ChatsController: açılış (okunmamış ayırıcısı), tümünü okundu, tepki, oy, sabitleme,
// düzenleme, silme, gönderme ve teslim durumları; alt menü alt yazısı.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/application/chats_controller.dart';
import 'package:nizamio/features/messages/domain/chat.dart';
import 'package:nizamio/features/messages/messages.dart';

import '../../pilot_support.dart';

void main() {
  test('örnek kaynak + komutlar', () async {
    final h = await pilotHarness(PilotBackend());
    final c = h.container;
    c
      ..listen(chatsControllerProvider, (_, _) {})
      ..listen(messagesNavCaptionProvider, (_, _) {});
    await c.read(chatsControllerProvider.future);
    expect(c.read(messagesNavCaptionProvider), '5 okunmamış');
    final ctrl = c.read(chatsControllerProvider.notifier);
    ChatInbox box() => c.read(chatsControllerProvider).requireValue;

    ctrl.open('gen');
    expect(box().chat('gen')!.unreadMarker, 'm3');
    expect(box().chat('gen')!.unread, 0);
    expect(c.read(messagesNavCaptionProvider), '4 okunmamış');
    ctrl.open('hid');
    expect(box().chat('hid')!.unreadMarker, 'h2');

    ctrl.react('gen', 'm1', ChatReaction.like);
    expect(box().chat('gen')!.message('m1')!.reactions[ChatReaction.like], 9);
    ctrl.react('gen', 'm1', ChatReaction.star);
    final m1 = box().chat('gen')!.message('m1')!;
    expect(m1.reactions[ChatReaction.like], 8);
    expect(m1.myReaction, ChatReaction.star);

    ctrl.vote('gen', 'm6', 1);
    final poll = box().chat('gen')!.message('m6')!.poll!;
    expect(poll.options[1].votes, 4);
    expect(poll.voters, 10);
    ctrl.endPoll('gen', 'm6');
    expect(box().chat('gen')!.message('m6')!.poll!.ended, isTrue);

    expect(ctrl.togglePin('gen', 'm4'), isTrue);
    expect(box().chat('gen')!.pins.first, 'm4');
    expect(ctrl.togglePin('gen', 'm4'), isFalse);

    ctrl.edit('gen', 'm1', 'Yeni metin');
    expect(box().chat('gen')!.message('m1')!.edited, isTrue);
    final id = ctrl.send(
      'gen',
      from: 'ma',
      at: DateTime(2026, 10, 21, 10, 15),
      text: 'Merhaba',
    );
    var sent = box().chat('gen')!.message(id)!;
    expect(sent.sent, isFalse);
    expect(box().chat('gen')!.unreadMarker, isNull);
    ctrl
      ..markSent('gen', id)
      ..markRead('gen', id);
    sent = box().chat('gen')!.message(id)!;
    expect(sent.sent && sent.read, isTrue);
    ctrl.delete('gen', id);
    expect(box().chat('gen')!.message(id), isNull);

    ctrl.markAllRead();
    expect(box().unreadChats, 0);
    expect(c.read(messagesNavCaptionProvider), '0 okunmamış');
    ctrl.mute('sis');
    expect(box().chat('sis')!.muted, isTrue);
  });
}
