import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/features/messages/application/chat_actions_controller.dart';
import 'package:nizamio/features/messages/application/chat_room_controller.dart';
import 'package:nizamio/features/messages/application/chat_search_controller.dart';
import 'package:nizamio/features/messages/application/chat_shared_controller.dart';
import 'package:nizamio/features/messages/application/chats_controller.dart';
import 'package:nizamio/features/messages/application/messages_providers.dart';
import 'package:nizamio/features/messages/application/new_chat_controller.dart';
import 'package:nizamio/features/messages/domain/chat.dart';

import '../fake_chat_repository.dart';

class _Search extends FakeChatRepository {
  final replies = <Completer<ChatHistoryPage>>[];
  @override
  Future<ChatHistoryPage> search(String chatId, String query, {int? before}) =>
      replies.removeAt(0).future;
}

class _Shared extends FakeChatRepository {
  final gate = Completer<ChatSharedPage>();
  var pages = 0;
  @override
  Future<ChatSharedPage> shared(
    String chatId, {
    String? cursor,
    ChatRefKind? kind,
  }) {
    pages++;
    if (cursor != null) return gate.future;
    return Future.value(ChatSharedPage(items: [_item('r2')], nextCursor: 'r2'));
  }
}

ChatSharedItem _item(String id) => ChatSharedItem(
  refId: id,
  kind: ChatRefKind.file,
  targetId: id,
  messageId: 'm1',
  senderId: me,
  at: at(1),
);

class _Direct extends FakeChatRepository {
  final gate = Completer<Chat>();
  @override
  Future<Chat> openDirect(String accountId) => gate.future;
}

class _CapturedInbox extends FakeChatRepository {
  final guards = <bool Function()?>[];
  @override
  Future<ChatInbox> loadInbox({String? query, bool Function()? isCurrent}) {
    guards.add(isCurrent);
    return super.loadInbox(query: query, isCurrent: isCurrent);
  }
}

class _MarkAllRead extends FakeChatRepository {
  final gate = Completer<void>();
  @override
  Future<void> markAllRead() {
    calls.add('markAllRead');
    return gate.future;
  }
}

ProviderContainer _scopeContainer(
  FakeChatRepository repo,
  String Function() program, {
  int Function()? session,
}) {
  final c = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      chatRepositoryProvider.overrideWithValue(repo),
      sessionGenerationProvider.overrideWith((ref) => session?.call() ?? 1),
      sessionStateProvider.overrideWithValue(
        const SessionActive(accountId: me, forcePasswordChange: false),
      ),
      scopeStateProvider.overrideWith(
        (ref) => ScopeSelection(programId: program()),
      ),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  for (final changeSession in [false, true]) {
    test(
      'geç tümünü okundu yanıtı yeni ${changeSession ? 'oturumun' : 'programın'} sayacını sıfırlamaz',
      () async {
        final repo = _MarkAllRead();
        var program = 'prog-1';
        var session = 1;
        final c = _scopeContainer(repo, () => program, session: () => session)
          ..listen(chatsControllerProvider, (_, _) {});
        await c.read(chatsControllerProvider.future);
        final clearing = c.read(chatsControllerProvider.notifier).markAllRead();
        repo.inbox = ChatInbox(chats: [chat('new', unread: 7)]);
        if (changeSession) {
          session++;
          c.invalidate(sessionGenerationProvider);
        } else {
          program = 'prog-2';
          c.invalidate(scopeStateProvider);
        }
        await c.read(chatsControllerProvider.future);
        repo.gate.complete();
        await clearing;
        expect(repo.calls.where((x) => x == 'markAllRead').length, 1);
        expect(
          c.read(chatsControllerProvider).requireValue.chats.single.unread,
          7,
        );
      },
    );
  }

  for (final search in [false, true]) {
    for (final changeSession in [false, true]) {
      test(
        '${search ? 'arama' : 'kutu'} sayfa guardı ${changeSession ? 'oturum' : 'program'} değişimini yeniden kurulumdan önce görür',
        () async {
          final repo = _CapturedInbox();
          var program = 'prog-1';
          var session = 1;
          final c = _scopeContainer(
            repo,
            () => program,
            session: () => session,
          );
          final provider = search
              ? chatInboxSearchProvider('aranan')
              : chatsControllerProvider;
          c.listen(provider, (_, _) {});
          await c.read(provider.future);
          final oldGuard = repo.guards.single!;
          expect(oldGuard(), isTrue);
          if (changeSession) {
            session++;
            c.invalidate(sessionGenerationProvider);
          } else {
            program = 'prog-2';
            c.invalidate(scopeStateProvider);
          }
          expect(oldGuard(), isFalse);
          await c.read(provider.future);
          expect(repo.guards.last!(), isTrue);
        },
      );
    }
  }

  test(
    'aynı sorgunun geç yanıtı yeni aramayı ezmez; eski sayfa hatası da ezmez',
    () async {
      final repo = _Search();
      final c = chatContainer(repo)
        ..listen(chatSearchControllerProvider('c1'), (_, _) {});
      final ctl = c.read(chatSearchControllerProvider('c1').notifier);
      final old = Completer<ChatHistoryPage>();
      final fresh = Completer<ChatHistoryPage>();
      repo.replies.addAll([old, fresh]);
      final a = ctl.search('aynı');
      final b = ctl.search('aynı');
      fresh.complete(ChatHistoryPage(messages: [msg(9)]));
      await b;
      old.complete(ChatHistoryPage(messages: [msg(1)]));
      await a;
      expect(c.read(chatSearchControllerProvider('c1')).results.single.seq, 9);

      final first = Completer<ChatHistoryPage>()
        ..complete(
          ChatHistoryPage(
            messages: [for (var i = 1; i <= chatSearchPageSize; i++) msg(i)],
          ),
        );
      final page = Completer<ChatHistoryPage>();
      final next = Completer<ChatHistoryPage>();
      repo.replies.addAll([first, page, next]);
      await ctl.search('ilk');
      final more = ctl.more();
      final expectedError = expectLater(more, throwsA(isA<ApiError>()));
      final newer = ctl.search('yeni');
      next.complete(ChatHistoryPage(messages: [msg(77)]));
      await newer;
      page.completeError(ApiError('client.timeout'));
      await expectedError;
      expect(c.read(chatSearchControllerProvider('c1')).query, 'yeni');
      expect(c.read(chatSearchControllerProvider('c1')).results.single.seq, 77);
    },
  );

  test(
    'paylaşılanlar aynı imleci tek uçuşta okur ve tekrar satırı tekilleştirir',
    () async {
      final repo = _Shared();
      final c = chatContainer(repo)
        ..listen(chatSharedControllerProvider('c1'), (_, _) {});
      await c.read(chatSharedControllerProvider('c1').future);
      final ctl = c.read(chatSharedControllerProvider('c1').notifier);
      final a = ctl.more();
      await ctl.more();
      expect(repo.pages, 2, reason: 'ilk sayfa + tek sonraki sayfa');
      repo.gate.complete(
        ChatSharedPage(items: [_item('r2'), _item('r1')], nextCursor: 'r2'),
      );
      await a;
      final result = c.read(chatSharedControllerProvider('c1')).requireValue;
      expect(result.items.map((x) => x.refId), ['r2', 'r1']);
      expect(
        result.nextCursor,
        isNull,
        reason: 'ilerlemeyen imleç döngüye girmez',
      );
    },
  );

  test('geç birebir yanıtı yeni programda sohbet açmaz', () async {
    final repo = _Direct();
    var program = 'prog-1';
    final c = _scopeContainer(repo, () => program);
    const purpose = ChatCandidatePurpose.direct;
    c.listen(newChatControllerProvider(purpose), (_, _) {});
    await c.read(newChatControllerProvider(purpose).future);
    final result = c
        .read(newChatControllerProvider(purpose).notifier)
        .openDirect(peer);
    final rejection = expectLater(
      result,
      throwsA(
        isA<ApiError>().having((e) => e.code, 'code', 'client.session_ended'),
      ),
    );
    program = 'prog-2';
    c.invalidate(scopeStateProvider);
    // Yeniden kurulumu beklemeden eski istek tamamlanır.
    repo.gate.complete(chat('old'));
    await rejection;
  });

  test('bekleyen tepki yeni programda istek göndermez', () async {
    final repo = FakeChatRepository()..server['c1'] = [msg(1)];
    var program = 'prog-1';
    final c = _scopeContainer(repo, () => program)
      ..listen(chatRoomControllerProvider('c1'), (_, _) {})
      ..listen(chatActionsControllerProvider('c1'), (_, _) {});
    await c.read(chatRoomControllerProvider('c1').future);
    final pending = c
        .read(chatActionsControllerProvider('c1').notifier)
        .react('m1', ChatReaction.like);
    program = 'prog-2';
    c.invalidate(scopeStateProvider);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    await pending;
    expect(
      repo.calls
          .where((x) => x.startsWith('react ') || x.startsWith('unreact '))
          .length,
      0,
    );
  });

  test('kapsam yeniden kurulunca iptal edilmiş birleştirme zamanlayıcısı yeni akışı durdurmaz', () async {
    final repo = FakeChatRepository()..server['c1'] = [msg(1)];
    var program = 'prog-1';
    final c = _scopeContainer(repo, () => program)
      ..listen(chatRoomControllerProvider('c1'), (_, _) {});
    await c.read(chatRoomControllerProvider('c1').future);
    await pumpEventQueue();
    final bus = c.read(chatSignalBusProvider);
    bus.add(
      const ChatEvent(
        kind: ChatEventKind.messageCreated,
        chatId: 'c1',
        actorId: peer,
      ),
    );
    await pumpEventQueue();
    program = 'prog-2';
    repo.server['c1'] = [msg(88)];
    c.invalidate(scopeStateProvider);
    await c.read(chatRoomControllerProvider('c1').future);
    await pumpEventQueue();
    repo.server['c1']!.add(msg(89));
    bus.add(
      const ChatEvent(
        kind: ChatEventKind.messageCreated,
        chatId: 'c1',
        actorId: peer,
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 1150));
    await pumpEventQueue();
    expect(repo.calls.where((x) => x == 'list c1 after=88').length, 1);
    expect(
      c.read(chatRoomControllerProvider('c1')).requireValue.messages.last.seq,
      89,
    );
  });

  for (final changeSession in [false, true]) {
    test(
      'geç gönderim yanıtı yeni ${changeSession ? 'oturumun' : 'programın'} açık sohbetine eklenmez',
      () async {
        final repo = FakeChatRepository()..server['c1'] = [msg(1)];
        var program = 'prog-1';
        var session = 1;
        final c = _scopeContainer(repo, () => program, session: () => session)
          ..listen(chatRoomControllerProvider('c1'), (_, _) {});
        await c.read(chatRoomControllerProvider('c1').future);
        final gate = Completer<void>();
        repo.sendGate = gate;
        final sending = c
            .read(chatRoomControllerProvider('c1').notifier)
            .send('eski programa');
        if (changeSession) {
          session++;
        } else {
          program = 'prog-2';
        }
        repo.server['c1'] = [msg(88)];
        c.invalidate(
          changeSession ? sessionGenerationProvider : scopeStateProvider,
        );
        await c.read(chatRoomControllerProvider('c1').future);
        // Notifier yeniden kuruldu; eski HTTP zinciri eski epoch'unu taşır.
        gate.complete();
        await sending;
        final current = c.read(chatRoomControllerProvider('c1')).requireValue;
        expect(current.messages.map((m) => m.seq), [88]);
        expect(current.messages.any((m) => m.text == 'eski programa'), isFalse);
      },
    );
  }

  test(
    'kapsam değişince eski uzlaştırma zinciri ikinci HTTP adımına devam etmez',
    () async {
      final repo = FakeChatRepository()..server['c1'] = [msg(1)];
      var program = 'prog-1';
      final c = _scopeContainer(repo, () => program)
        ..listen(chatRoomControllerProvider('c1'), (_, _) {});
      await c.read(chatRoomControllerProvider('c1').future);
      await pumpEventQueue();
      final gate = Completer<void>();
      repo.listGate = gate;
      c.read(chatSignalBusProvider).add(const ChatStreamOpened());
      await pumpEventQueue();
      expect(repo.calls.where((x) => x == 'list c1 after=1'), hasLength(1));
      repo.listGate = null;
      program = 'prog-2';
      c.invalidate(scopeStateProvider);
      await c.read(chatRoomControllerProvider('c1').future);
      final count = repo.calls.length;
      gate.complete();
      await pumpEventQueue();
      expect(
        repo.calls
            .skip(count)
            .where((x) => x.startsWith('list ') || x.startsWith('pins ')),
        isEmpty,
      );
    },
  );

  test(
    'gönderim retry refs bahsetme anket ve açıklama snapshotını korur',
    () async {
      final repo = FakeChatRepository()..server['c1'] = [msg(1)];
      final c = chatContainer(repo)
        ..listen(chatRoomControllerProvider('c1'), (_, _) {});
      await c.read(chatRoomControllerProvider('c1').future);
      final ctl = c.read(chatRoomControllerProvider('c1').notifier);
      final mentions = [const ChatMention.account(peer)];
      final refs = [const ChatRefDraft(kind: ChatRefKind.file, targetId: 'f1')];
      final closes = DateTime(2030);
      repo.sendError = ApiError('client.timeout');
      await ctl.send(
        'metin',
        mentions: mentions,
        refs: refs,
        poll: PollDraft(options: const ['A', 'B'], closesAt: closes),
      );
      final first = repo.sent.single;
      mentions.clear();
      refs.clear();
      await ctl.retry(first.clientId);
      expect(identical(repo.sent.last, first), isTrue);
      expect(first.mentions, hasLength(1));
      expect(first.refs, hasLength(1));
      expect(first.poll!.closesAt, closes);
      const file = ChatUpload(
        path: '/tmp/a.pdf',
        name: 'a.pdf',
        sizeBytes: 1,
        contentType: 'application/pdf',
      );
      await ctl.sendAttachment(file, replyTo: 'm1', caption: 'açıklama');
      expect(repo.uploadCaptions.single, 'açıklama');
      expect(repo.uploadReplies.single, 'm1');
    },
  );

  test('sabit liste kesilmesi açık sohbet durumuna taşınır', () async {
    final repo = FakeChatRepository()..pinsTruncated = true;
    final c = chatContainer(repo)
      ..listen(chatRoomControllerProvider('c1'), (_, _) {});
    expect(
      (await c.read(chatRoomControllerProvider('c1').future)).pinsTruncated,
      isTrue,
    );
  });

  test(
    'sunucu kutu araması ve program özeti UI olmadan çağrılabilir',
    () async {
      final repo = FakeChatRepository()
        ..unreadPrograms = [
          const ChatProgramUnread(
            programId: 'p2',
            name: 'İkinci',
            unreadChats: 3,
            mentioned: true,
          ),
        ];
      final c = chatContainer(repo)
        ..listen(chatInboxSearchProvider('  eski mesaj  '), (_, _) {})
        ..listen(chatUnreadOverviewProvider, (_, _) {});
      await c.read(chatInboxSearchProvider('  eski mesaj  ').future);
      expect(repo.inboxQueries.single, 'eski mesaj');
      expect(
        (await c.read(chatUnreadOverviewProvider.future)).single.mentioned,
        isTrue,
      );
    },
  );
}
