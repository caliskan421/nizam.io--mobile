// ChatRoomController: açılış (bilgi + son sayfa, ayırıcı, okundu imleci), gönderim durumu ve
// istemci kimliği kararlılığı, 409 eşlemeleri, düzenleme çakışması, akıştan gelen olayların
// yerleşmesi (çift mesaj yok, silme okumasız), yeniden bağlanma uzlaştırması, yazıyor sınırı;
// düzenleme tabanı, açılış sırasında gelen olaylar ve uzlaştırma tavanı (Codex tur 1); kova
// dolunca okundu devamı (Codex tur 2).
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/messages/application/chat_members_controller.dart';
import 'package:nizamio/features/messages/application/chat_room_controller.dart';
import 'package:nizamio/features/messages/application/chats_controller.dart';
import 'package:nizamio/features/messages/application/messages_providers.dart';
import 'package:nizamio/features/messages/domain/chat.dart';
import 'package:nizamio/features/messages/domain/chat_room.dart';
import 'package:nizamio/features/messages/domain/chat_stream_policy.dart';

import '../fake_chat_repository.dart';

const _coalesce = Duration(milliseconds: 1150);

Future<(ProviderContainer, FakeChatRepository)> _open({
  List<ChatMessage>? history,
  bool group = false,
  SignalBudget? budget,
}) async {
  final repo = FakeChatRepository()
    ..server['c1'] = history ?? [msg(1), msg(2, sender: me), msg(3), msg(4)]
    ..getChatResult = (id) => chat(id, group: group);
  final c = chatContainer(
    repo,
    extra: [
      if (budget != null) chatSignalBudgetProvider.overrideWithValue(budget),
    ],
  );
  c
    ..listen(chatsControllerProvider, (_, _) {})
    ..listen(chatRoomControllerProvider('c1'), (_, _) {});
  await c.read(chatsControllerProvider.future);
  await c.read(chatRoomControllerProvider('c1').future);
  await pumpEventQueue();
  return (c, repo);
}

ChatRoom _room(ProviderContainer c) =>
    c.read(chatRoomControllerProvider('c1')).requireValue;

ChatRoomController _ctrl(ProviderContainer c) =>
    c.read(chatRoomControllerProvider('c1').notifier);

List<String> _ids(ProviderContainer c) => [
  for (final m in _room(c).messages) m.id,
];

void main() {
  group('K5b', k5b);
  group('Codex tur 1', codexRound1);
  group('Codex tur 2', codexRound2);
  test(
    'açılış: bilgi + son sayfa; ayırıcı listedeki okunmamıştan; okundu imleci',
    () async {
      final (c, repo) = await _open();
      expect(repo.calls, containsAll(['getChat c1', 'list c1']));
      expect(_ids(c), ['m1', 'm2', 'm3', 'm4']);
      expect(_room(c).unreadMarker, 'm3', reason: 'listede 2 okunmamış');
      expect(repo.calls, contains('read c1 m4'));
      expect(
        c.read(chatsControllerProvider).requireValue.chat('c1')!.unread,
        0,
        reason: 'satır sayacı düşer',
      );
      _ctrl(c).reopen();
      expect(_room(c).unreadMarker, isNull);
    },
  );

  test('gönderim: gönderiliyor → sunucu kaydı; tek balon', () async {
    final (c, repo) = await _open();
    final f = _ctrl(c).send('merhaba', replyTo: 'm3');
    final pending = _room(c).messages.last;
    expect((pending.state, pending.onServer), (ChatSendState.sending, false));
    expect(pending.replyTo?.messageId, 'm3');
    expect(await f, ChatSendOutcome.sent);
    expect(_ids(c), ['m1', 'm2', 'm3', 'm4', 'm5']);
    expect(repo.sent.single.replyTo, 'm3');
    expect(repo.sent.single.clientId, pending.clientId);
    expect(_room(c).messages.last.state, ChatSendState.sent);
  });

  test(
    'sonuç bilinmiyor → gönderilemedi; tekrar AYNI istemci kimliğiyle',
    () async {
      final (c, repo) = await _open();
      repo.sendError = ApiError('client.timeout');
      expect(await _ctrl(c).send('a'), ChatSendOutcome.failed);
      final failed = _room(c).messages.last;
      expect(failed.state, ChatSendState.failed);
      expect(await _ctrl(c).retry(failed.clientId), ChatSendOutcome.sent);
      expect(repo.sent.map((m) => (m.clientId, m.text)).toSet(), {
        (failed.clientId, 'a'),
      }, reason: 'aynı kimlik, aynı gövde');
      expect(_ids(c).where((id) => id.startsWith('local:')), isEmpty);
    },
  );

  test(
    '409 idempotency_key_reused: reddedildi, kendiliğinden tekrar yok',
    () async {
      final (c, repo) = await _open();
      repo.sendError = ApiError(
        'messaging.idempotency_key_reused',
        status: 409,
      );
      expect(await _ctrl(c).send('a'), ChatSendOutcome.rejected);
      final m = _room(c).messages.last;
      expect(
        (m.state, m.failure),
        (ChatSendState.failed, 'messaging.idempotency_key_reused'),
      );
      expect(repo.sent, hasLength(1));
    },
  );

  test(
    '409 message_deleted: balon kalkar; 403 birebirde yazma kapanır',
    () async {
      final (c, repo) = await _open();
      repo.sendError = ApiError('messaging.message_deleted', status: 409);
      expect(await _ctrl(c).send('a'), ChatSendOutcome.deleted);
      expect(_ids(c), ['m1', 'm2', 'm3', 'm4']);
      repo.sendError = ApiError('messaging.not_authorized', status: 403);
      expect(await _ctrl(c).send('b'), ChatSendOutcome.blocked);
      expect(_room(c).blocked, isTrue);
    },
  );

  test(
    'düzenleme: okunan sürüm gider; 409 edit_conflict mesajı yeniden okur',
    () async {
      final (c, repo) = await _open(
        history: [
          msg(1),
          msg(2, sender: me, revision: 3),
        ],
      );
      await _ctrl(c).edit('m2', 'yeni', expectedRevision: 3);
      expect(repo.calls, contains('edit m2 rev=3'));
      expect(_room(c).message('m2')!.text, 'yeni');
      repo.editError = ApiError('messaging.edit_conflict', status: 409);
      await expectLater(
        _ctrl(c).edit('m2', 'daha yeni', expectedRevision: 4),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            'messaging.edit_conflict',
          ),
        ),
      );
      expect(repo.calls.last, 'list c1 around=2');
    },
  );

  test('silme: yerelden kalkar', () async {
    final (c, repo) = await _open();
    await _ctrl(c).delete('m2');
    expect(repo.calls, contains('delete m2'));
    expect(_ids(c), ['m1', 'm3', 'm4']);
  });

  test('akış: oluşturma olayları birleşip tek after okuması; kendi kopyam çift olmaz', () async {
    final (c, repo) = await _open();
    final bus = c.read(chatSignalBusProvider);
    // Gönderim yanıtı gelmeden akış kopyası düşer: sunucuda kayıt var, yanıt geç.
    final gate = repo.sendGate = Completer<void>();
    final pendingSend = _ctrl(c).send('x');
    for (var i = 0; i < 3; i++) {
      bus.add(
        const ChatEvent(
          kind: ChatEventKind.messageCreated,
          chatId: 'c1',
          actorId: peer,
        ),
      );
    }
    bus.add(
      const ChatEvent(
        kind: ChatEventKind.messageCreated,
        chatId: 'baska',
        actorId: peer,
      ),
    );
    repo.server['c1']!.add(msg(6));
    await Future<void>.delayed(_coalesce);
    await pumpEventQueue();
    expect(
      repo.calls.where((x) => x.startsWith('list c1 after=')),
      hasLength(1),
    );
    expect(_ids(c), ['m1', 'm2', 'm3', 'm4', 'm5', 'm6']);
    gate.complete();
    await pendingSend;
    expect(_ids(c), ['m1', 'm2', 'm3', 'm4', 'm5', 'm6']);
  });

  test(
    'akış: silme olayı okumasız uygulanır; düzenleme around ile okunur',
    () async {
      final (c, repo) = await _open();
      final bus = c.read(chatSignalBusProvider);
      final before = repo.calls.length;
      bus.add(
        const ChatEvent(
          kind: ChatEventKind.messageDeleted,
          chatId: 'c1',
          actorId: peer,
          messageId: 'm3',
        ),
      );
      await pumpEventQueue();
      expect(_ids(c), ['m1', 'm2', 'm4']);
      expect(repo.calls.length, before);
      repo.server['c1']![0] = msg(1, text: 'güncel');
      bus.add(
        const ChatEvent(
          kind: ChatEventKind.messageUpdated,
          chatId: 'c1',
          actorId: peer,
          messageId: 'm1',
        ),
      );
      await Future<void>.delayed(_coalesce);
      await pumpEventQueue();
      expect(repo.calls, contains('list c1 around=1'));
      expect(_room(c).message('m1')!.text, 'güncel');
    },
  );

  test('yeniden bağlanma: pencere baştan okunur, sunucuda silinmiş yerel kayıt kalkar', () async {
    final (c, repo) = await _open();
    repo.server['c1']!
      ..removeWhere((m) => m.id == 'm2')
      ..add(msg(5));
    c.read(chatSignalBusProvider).add(const ChatStreamOpened());
    await pumpEventQueue(times: 50);
    expect(repo.calls, contains('list c1 after=4'));
    expect(repo.calls, contains('list c1 before=5'));
    expect(_ids(c), ['m1', 'm3', 'm4', 'm5']);
  });

  test(
    'yazıyor: en az 3 sn aralıkla; karşı tarafın olayı adıyla görünür',
    () async {
      final (c, repo) = await _open();
      _ctrl(c)
        ..typing()
        ..typing()
        ..typing();
      await pumpEventQueue();
      expect(repo.typings, ['c1']);
      c
          .read(chatSignalBusProvider)
          .add(
            const ChatEvent(
              kind: ChatEventKind.typing,
              chatId: 'c1',
              actorId: peer,
            ),
          );
      await pumpEventQueue();
      expect(_room(c).typing, 'Kadir Özbek');
      c
          .read(chatSignalBusProvider)
          .add(
            const ChatEvent(
              kind: ChatEventKind.typing,
              chatId: 'c1',
              actorId: me,
            ),
          );
      await pumpEventQueue();
      expect(
        _room(c).typing,
        'Kadir Özbek',
        reason: 'kendi olayım yok sayılır',
      );
    },
  );

  test('eski sayfa: before=<en küçük seq>, başa eklenir', () async {
    final (c, repo) = await _open(
      history: [for (var s = 1; s <= 60; s++) msg(s)],
    );
    expect(_room(c).hasOlder, isTrue);
    expect(_room(c).lowSeq, 11);
    await _ctrl(c).loadOlder();
    expect(repo.calls, contains('list c1 before=11'));
    expect(_room(c).lowSeq, 1);
    expect(_room(c).hasOlder, isFalse);
  });
}

void k5b() {
  test(
    'sabit şeridi açılışta; pencere dışı sabit olayı şeridi yeniden okur',
    () async {
      final repo = FakeChatRepository()
        ..server['c1'] = [msg(1), msg(2)]
        ..pinned = [msg(1)];
      final c = chatContainer(repo)
        ..listen(chatsControllerProvider, (_, _) {})
        ..listen(chatRoomControllerProvider('c1'), (_, _) {});
      await c.read(chatRoomControllerProvider('c1').future);
      expect(_room(c).pins.single.id, 'm1');
      repo.pinned = [];
      c
          .read(chatSignalBusProvider)
          .add(
            const ChatEvent(
              kind: ChatEventKind.messageUpdated,
              chatId: 'c1',
              actorId: peer,
              messageId: 'eski',
            ),
          );
      await Future<void>.delayed(_coalesce);
      await pumpEventQueue();
      expect(repo.calls.where((x) => x == 'pins c1'), hasLength(2));
      expect(repo.calls.where((x) => x.contains('around')), isEmpty);
      expect(_room(c).pins, isEmpty);
    },
  );

  test('bahsetme ve anket gönderimde; tekrar aynı gövdeyle', () async {
    final (c, repo) = await _open(group: true);
    repo.sendError = ApiError('client.timeout');
    final poll = PollDraft(options: const ['A', 'B'], multi: true);
    expect(
      await _ctrl(c)
          .send('Hangisi?', mentions: const [ChatMention.all()], poll: poll),
      ChatSendOutcome.failed,
    );
    final failed = _room(c).messages.last;
    expect(failed.poll!.options.map((o) => o.label), ['A', 'B']);
    await _ctrl(c).retry(failed.clientId);
    expect(repo.sent, hasLength(2));
    expect(identical(repo.sent.first, repo.sent.last), isTrue);
    expect(repo.sent.last.mentions, [const ChatMention.all()]);
    expect(repo.sent.last.poll, same(poll));
  });

  test(
    'ek: gönderiliyor balonu; tekrar aynı kimlik; reddedilen ya da okunamayan '
    'dosya nedeniyle gönderilemedi kalır',
    () async {
      final (c, repo) = await _open();
      const file = ChatUpload(
        path: '/tmp/r.pdf',
        name: 'r.pdf',
        sizeBytes: 10,
        contentType: 'application/pdf',
      );
      repo.writeError = ApiError('client.timeout');
      expect(await _ctrl(c).sendAttachment(file), ChatSendOutcome.failed);
      final pending = _room(c).messages.last;
      expect(pending.attachments.single.fileName, 'r.pdf');
      expect(await _ctrl(c).retry(pending.clientId), ChatSendOutcome.sent);
      expect(repo.uploads.map((u) => u.$1).toSet(), {pending.clientId});
      expect(_room(c).messages.last.onServer, isTrue);
      for (final code in [
        'messaging.file_rejected',
        ClientErrorCode.fileUnreadable,
      ]) {
        repo.writeError = ApiError(code);
        expect(await _ctrl(c).sendAttachment(file), ChatSendOutcome.failed);
        final failed = _room(c).messages.last;
        expect((failed.state, failed.failure), (ChatSendState.failed, code));
        _ctrl(c).discard(failed.clientId);
        expect(_room(c).messages.where((m) => !m.onServer), isEmpty);
      }
    },
  );

  test('reveal: pencere dışındaki mesaja kadar eskiye iner', () async {
    final (c, repo) = await _open(
      history: [for (var s = 1; s <= 120; s++) msg(s)],
    );
    expect(_room(c).lowSeq, 71);
    expect(await _ctrl(c).reveal('m5', 5), isTrue);
    expect(_room(c).message('m5'), isNotNull);
    expect(
      repo.calls,
      containsAllInOrder(['list c1 before=71', 'list c1 before=21']),
    );
    expect(await _ctrl(c).reveal('yok', 0), isFalse);
  });

  test(
    'grupta yazıyor adı üye listesinden; ad değişimi ve dışarıdan yerleşim',
    () async {
      final (c, repo) = await _open(group: true);
      repo.memberList = ChatMembers(
        items: const [
          ChatMember(
            accountId: 'acc-x',
            name: 'Yeni Üye',
            role: ChatMemberRole.member,
          ),
        ],
      );
      c.listen(chatMembersControllerProvider('c1'), (_, _) {});
      await c.read(chatMembersControllerProvider('c1').future);
      c
          .read(chatSignalBusProvider)
          .add(
            const ChatEvent(
              kind: ChatEventKind.typing,
              chatId: 'c1',
              actorId: 'acc-x',
            ),
          );
      await pumpEventQueue();
      expect(_room(c).typing, 'Yeni Üye');
      _ctrl(c).setChat(chat('c1', group: true, name: 'Yeni ad'));
      expect(_room(c).chat.name, 'Yeni ad');
      _ctrl(c).apply(msg(4, text: 'güncel'));
      expect(_room(c).message('m4')!.text, 'güncel');
    },
  );
}

void codexRound1() {
  test(
    'düzenleme tabanı: taslak açıkken akıştan gelen düzenleme ezilmez (409)',
    () async {
      final (c, repo) = await _open(
        history: [
          msg(1),
          msg(2, sender: me, text: 'ilk', revision: 3),
        ],
      );
      // Taslak açılır: taban okunan sürümdür.
      final base = _room(c).message('m2')!.revision;
      // Başka cihaz düzenler; akış olayı yerel mesajı yeni sürüme taşır.
      repo.server['c1']![1] = msg(2, sender: me, text: 'öteki', revision: 4);
      c
          .read(chatSignalBusProvider)
          .add(
            const ChatEvent(
              kind: ChatEventKind.messageUpdated,
              chatId: 'c1',
              actorId: me,
              messageId: 'm2',
            ),
          );
      await Future<void>.delayed(_coalesce);
      await pumpEventQueue();
      expect(_room(c).message('m2')!.revision, 4);
      await expectLater(
        _ctrl(c).edit('m2', 'taslağım', expectedRevision: base),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            'messaging.edit_conflict',
          ),
        ),
      );
      expect(repo.calls, contains('edit m2 rev=3'), reason: 'taslağın sürümü');
      expect(repo.server['c1']![1].text, 'öteki', reason: 'ezilmedi');
      expect(_room(c).message('m2')!.text, 'öteki');
    },
  );

  test(
    'açılış okumaları sürerken gelen oluşturma ve silme kaybolmaz',
    () async {
      final repo = FakeChatRepository()
        ..server['c1'] = [msg(1), msg(2), msg(3)];
      final gate = repo.listGate = Completer<void>();
      final c = chatContainer(repo)
        ..listen(chatsControllerProvider, (_, _) {})
        ..listen(chatRoomControllerProvider('c1'), (_, _) {});
      await pumpEventQueue();
      expect(repo.calls, contains('list c1'), reason: 'geçmiş yanıtı hazır');
      repo.server['c1']!
        ..removeWhere((m) => m.id == 'm2')
        ..add(msg(4));
      c.read(chatSignalBusProvider)
        ..add(
          const ChatEvent(
            kind: ChatEventKind.messageCreated,
            chatId: 'c1',
            actorId: peer,
          ),
        )
        ..add(
          const ChatEvent(
            kind: ChatEventKind.messageDeleted,
            chatId: 'c1',
            actorId: peer,
            messageId: 'm2',
          ),
        );
      repo.listGate = null;
      gate.complete();
      await c.read(chatRoomControllerProvider('c1').future);
      await pumpEventQueue(times: 50);
      expect(_ids(c), ['m1', 'm3', 'm4']);
      expect(
        repo.calls.where((x) => x.startsWith('list c1 after=')),
        hasLength(1),
        reason: 'uzlaştırma bir kez',
      );
    },
  );

  test(
    'uzlaştırma tavanı: yeni mesajlar bitmezse pencere en yeniden kurulur',
    () async {
      final (c, repo) = await _open(
        history: [for (var s = 1; s <= 50; s++) msg(s)],
      );
      repo.server['c1']!.addAll([for (var s = 51; s <= 1100; s++) msg(s)]);
      c.read(chatSignalBusProvider).add(const ChatStreamOpened());
      await pumpEventQueue(times: 50);
      expect(
        repo.calls.where((x) => x.startsWith('list c1 after=')),
        hasLength(ChatRoomController.maxPages),
      );
      final r = _room(c);
      expect((r.lowSeq, r.highSeq, r.hasOlder), (1051, 1100, true));
      expect(r.messages, hasLength(50), reason: 'arada boşluk yok');
    },
  );

  test(
    'uzlaştırma tavanı: tavandan geniş pencere en yeniden kurulur',
    () async {
      final (c, repo) = await _open(
        history: [for (var s = 1; s <= 1200; s++) msg(s)],
      );
      for (var i = 0; i < 21; i++) {
        await _ctrl(c).loadOlder();
      }
      expect(_room(c).lowSeq, 101);
      c.read(chatSignalBusProvider).add(const ChatStreamOpened());
      await pumpEventQueue(times: 50);
      final r = _room(c);
      expect((r.lowSeq, r.highSeq, r.hasOlder), (1151, 1200, true));
      await _ctrl(c).loadOlder();
      expect(_room(c).lowSeq, 1101, reason: 'eski geçmiş yeniden okunur');
    },
  );
}

void codexRound2() {
  /// Tek yerli kova; yeri ~300 ms sonra açılır.
  SignalBudget full() => SignalBudget(limit: 1)
    ..take(
      DateTime.now().subtract(const Duration(seconds: 59, milliseconds: 700)),
    );
  Iterable<String> reads(FakeChatRepository r) =>
      r.calls.where((x) => x.startsWith('read c1'));

  test('kova dolu → başka olay yok → yer açılınca tek okundu gider', () async {
    final (c, repo) = await _open(budget: full());
    expect(reads(repo), isEmpty, reason: 'kova dolu');
    await Future<void>.delayed(const Duration(milliseconds: 600));
    expect(reads(repo), ['read c1 m4']);
    expect(c.read(chatsControllerProvider).value!.chat('c1')!.unread, 0);
  });

  test('kova dolu: sohbet kapanınca ya da arka planda okundu gitmez', () async {
    final (c, repo) = await _open(budget: full());
    c.read(chatForegroundProvider.notifier).set(false);
    final (c2, repo2) = await _open(budget: full());
    c2.dispose();
    await Future<void>.delayed(const Duration(milliseconds: 600));
    expect([...reads(repo), ...reads(repo2)], isEmpty);
    expect(c.exists(chatRoomControllerProvider('c1')), isTrue);
  });
}
