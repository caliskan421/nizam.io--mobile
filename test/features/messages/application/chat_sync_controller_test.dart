// ChatSyncController: dinleyen varken tek bağlantı; açılış ve olaylar veriyoluna; ağ hatasında
// geri çekilmeyle yeniden bağlanma, yetki hatasında durma, ardışık başarısızlık sınırı; arka
// plana geçince kapanır, ön plana dönünce yeniden açılır; 429 beklemesi yaşam döngüsünü ve
// ekranın yeniden açılışını da bağlar.
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

  test(
    '429: arka plan/ön plan ve ekranın yeniden açılışı beklemeyi kısaltmaz',
    () async {
      final repo = FakeChatRepository();
      _rateLimited(repo, const Duration(hours: 1));
      final c = chatContainer(repo);
      var sub = c.listen(chatSyncControllerProvider, (_, _) {});
      await pumpEventQueue(times: 50);
      expect(repo.connects, 1);
      c.read(chatForegroundProvider.notifier).set(false);
      await pumpEventQueue();
      c.read(chatForegroundProvider.notifier).set(true);
      await pumpEventQueue();
      expect(repo.connects, 1, reason: 'ön plana dönüş beklemeye uyar');
      expect(c.read(chatSyncControllerProvider), ChatSyncStatus.retrying);
      sub.close();
      await pumpEventQueue();
      sub = c.listen(chatSyncControllerProvider, (_, _) {});
      await pumpEventQueue();
      expect(repo.connects, 1, reason: 'ekranın yeniden açılışı uyar');
      expect(c.read(chatSyncControllerProvider), ChatSyncStatus.retrying);
    },
  );

  // Sahte zamanlayıcı + sahte saat birlikte ilerler (gerçek saat/bekleme yok): bekleme 299 ms'de
  // sürer, 300 ms'de biter ve akış yalnız o zaman açılır.
  testWidgets('429: bekleme bitince ön plan döngüsünden sonra akış açılır', (
    tester,
  ) async {
    final repo = FakeChatRepository();
    _rateLimited(repo, const Duration(milliseconds: 300));
    var elapsed = Duration.zero;
    final base = DateTime.utc(2026, 11, 12);
    final c = chatContainer(
      repo,
      extra: [chatClockProvider.overrideWithValue(() => base.add(elapsed))],
    )..listen(chatSyncControllerProvider, (_, _) {});
    await tester.pump();
    c.read(chatForegroundProvider.notifier).set(false);
    await tester.pump();
    c.read(chatForegroundProvider.notifier).set(true);
    await tester.pump();
    expect(repo.connects, 1);
    Future<void> advance(Duration d) async {
      elapsed += d;
      await tester.pump(d);
    }

    await advance(const Duration(milliseconds: 299));
    expect(repo.connects, 1, reason: '299 ms: bekleme sürüyor');
    expect(c.read(chatSyncControllerProvider), ChatSyncStatus.retrying);
    await advance(const Duration(milliseconds: 1));
    await tester.pump();
    expect(repo.connects, 2, reason: '300 ms: bekleme bitti, akış açıldı');
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

void _rateLimited(FakeChatRepository repo, Duration wait) =>
    repo.connections.add(
      StreamController<ChatSignal>()..addError(
        ApiError('platform.rate_limited', status: 429, retryAfter: wait),
      ),
    );
