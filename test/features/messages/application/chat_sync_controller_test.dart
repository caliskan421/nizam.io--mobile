// ChatSyncController: dinleyen varken tek bağlantı; açılış ve olaylar veriyoluna; ağ hatasında
// geri çekilmeyle yeniden bağlanma, yetki hatasında durma, ardışık başarısızlık sınırı; arka
// plana geçince kapanır, ön plana dönünce yeniden açılır.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/messages/application/chat_sync_controller.dart';
import 'package:nizamio/features/messages/application/messages_providers.dart';
import 'package:nizamio/features/messages/domain/chat.dart';
import 'package:nizamio/features/messages/domain/chat_stream_policy.dart';

import '../fake_chat_repository.dart';

void main() {
  test(
    'açılış ve olaylar veriyoluna; dinleyen kalmayınca bağlantı kapanır',
    () async {
      final repo = FakeChatRepository();
      final conn = StreamController<ChatSignal>();
      repo.connections.add(conn);
      final c = chatContainer(repo);
      final seen = <ChatSignal>[];
      c.read(chatSignalBusProvider).stream.listen(seen.add);
      final sub = c.listen(chatSyncControllerProvider, (_, _) {});
      expect(c.read(chatSyncControllerProvider), ChatSyncStatus.connecting);
      conn
        ..add(const ChatStreamOpened())
        ..add(
          const ChatEvent(
            kind: ChatEventKind.messageCreated,
            chatId: 'c1',
            actorId: peer,
          ),
        );
      await pumpEventQueue();
      expect(c.read(chatSyncControllerProvider), ChatSyncStatus.live);
      expect(seen, hasLength(2));
      expect(repo.connects, 1);
      sub.close();
      await pumpEventQueue();
      expect(conn.hasListener, isFalse, reason: 'akış iptal edildi');
    },
  );

  test('ağ hatası yeniden bağlanır; yetki hatası durur', () async {
    final repo = FakeChatRepository();
    final first = StreamController<ChatSignal>();
    final second = StreamController<ChatSignal>();
    addTearDown(first.close);
    addTearDown(second.close);
    repo.connections.addAll([first, second]);
    final failures = <int>[];
    final c = chatContainer(
      repo,
      delay: (f) {
        failures.add(f);
        return Duration.zero;
      },
    )..listen(chatSyncControllerProvider, (_, _) {});
    first.addError(ApiError('client.network_error'));
    await pumpEventQueue();
    expect(repo.connects, 2);
    expect(failures, [1]);
    second.addError(ApiError('messaging.not_authorized', status: 403));
    await pumpEventQueue();
    expect(c.read(chatSyncControllerProvider), ChatSyncStatus.offline);
    expect(repo.connects, 2);
  });

  test('ardışık başarısızlık sınırında durur', () async {
    final repo = FakeChatRepository();
    for (var i = 0; i < 10; i++) {
      repo.connections.add(
        StreamController<ChatSignal>()
          ..addError(ApiError('client.network_error')),
      );
    }
    final c = chatContainer(repo)
      ..listen(chatSyncControllerProvider, (_, _) {});
    await pumpEventQueue(times: 200);
    expect(repo.connects, ChatStreamPolicy.maxFailures + 1);
    expect(c.read(chatSyncControllerProvider), ChatSyncStatus.offline);
  });

  test('429: Retry-After dolmadan yeniden bağlanılmaz', () async {
    final repo = FakeChatRepository();
    repo.connections.add(
      StreamController<ChatSignal>()..addError(
        ApiError(
          'platform.rate_limited',
          status: 429,
          retryAfter: const Duration(hours: 1),
        ),
      ),
    );
    final c = chatContainer(repo)
      ..listen(chatSyncControllerProvider, (_, _) {});
    await pumpEventQueue(times: 50);
    expect(repo.connects, 1);
    expect(c.read(chatSyncControllerProvider), ChatSyncStatus.retrying);
  });

  test('arka plan kapatır, ön plan yeniden açar', () async {
    final repo = FakeChatRepository();
    final first = StreamController<ChatSignal>();
    repo.connections.add(first);
    final c = chatContainer(repo)
      ..listen(chatSyncControllerProvider, (_, _) {});
    await pumpEventQueue();
    expect(first.hasListener, isTrue);
    c.read(chatForegroundProvider.notifier).set(false);
    await pumpEventQueue();
    expect(first.hasListener, isFalse);
    expect(c.read(chatSyncControllerProvider), ChatSyncStatus.idle);
    c.read(chatForegroundProvider.notifier).set(true);
    await pumpEventQueue();
    expect(repo.connects, 2);
  });
}
