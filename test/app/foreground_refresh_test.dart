// V10 (F60): uygulama ön plana dönünce okunmuş görev kataloğu bayatsa yeniden okunur; hiç
// okunmamış katalog için okuma başlatılmaz; taze katalog yeniden okunmaz (yoklama yok).
// Kabukta `resumed` geçişi bu işlevi çağırır (widget testi). Zil rozeti yalnız ekrandaysa
// (sağlayıcı yaşıyorsa) yeniden okunur. Mesajlar rozeti liste okunmuşsa ve akış açık değilse
// tek `listChats` ile yenilenir (akış açıkken açılışı zaten tazeler: çift istek yok).
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/foreground_refresh.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/messages/application/chat_sync_controller.dart';
import 'package:nizamio/features/messages/application/chats_controller.dart';
import 'package:nizamio/features/messages/domain/chat.dart';
import 'package:nizamio/features/messages/messages.dart';
import 'package:nizamio/features/notifications/application/notifications_providers.dart';
import 'package:nizamio/features/notifications/notifications.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../features/messages/fake_chat_repository.dart' as chats;
import '../features/notifications/notification_count_stub.dart';
import '../features/pilot_support.dart';
import '../support/fake_backend.dart';
import '../support/harness.dart';

const _list = '/v1/program/work-items';

Future<Harness> _signedIn() async {
  final pilot = PilotBackend();
  final h = await pilotHarness(pilot, signedIn: true);
  h.backend.handler = (r) => switch ('${r.method} ${r.path}') {
    'GET /v1/me' => jsonResponse(200, {
      'account_id': 'acc-1',
      'email': 'a@b.test',
      'full_name': 'Ayşe Yılmaz',
      'company_admin': true,
    }),
    'GET /v1/program/departments' ||
    'GET /v1/me/departments' => jsonResponse(200, {'departments': <Object>[]}),
    'GET $_list' => jsonResponse(200, {'items': <Object>[]}),
    _ => pilot.handle(r),
  };
  h.read(scopeControllerProvider).selectProgram('prog-1');
  return h;
}

void main() {
  test('okunmamış katalog: okuma başlatılmaz', () async {
    final h = await _signedIn();
    h.backend.requests.clear();
    await refreshStaleTasks(h.container, maxAge: Duration.zero);
    expect(h.container.exists(taskCatalogControllerProvider), isFalse);
    expect(h.backend.count('GET', _list), 0);
  });

  test('bayat katalog yeniden okunur; taze katalog okunmaz', () async {
    final h = await _signedIn();
    h.container.listen(taskCatalogControllerProvider, (_, _) {});
    await h.container.read(taskCatalogControllerProvider.future);
    h.backend.requests.clear();
    await refreshStaleTasks(h.container);
    expect(h.backend.count('GET', _list), 0, reason: '30 sn içinde taze');
    await refreshStaleTasks(h.container, maxAge: Duration.zero);
    expect(h.backend.count('GET', _list), 1);
  });

  testWidgets('kabuk: resumed geçişi dinlenir; katalog okunmamışken okuma '
      'başlatmaz', (tester) async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: const ForegroundRefresh(child: SizedBox()),
      ),
    );
    tester.binding
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(c.exists(taskCatalogControllerProvider), isFalse);
  });

  test(
    'zil rozeti: ekranda değilse istek yok; ekrandaysa yeniden okunur',
    () async {
      final repo = NotificationCountStub()..unread = 2;
      final c = ProviderContainer(
        retry: (_, _) => null,
        overrides: [notificationRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(c.dispose);
      await refreshNotificationBadge(c);
      expect(repo.countCalls, 0);

      c.listen(notificationUnreadControllerProvider, (_, _) {});
      await c.read(notificationUnreadControllerProvider.future);
      repo.unread = 5;
      await refreshNotificationBadge(c);
      expect(repo.countCalls, 2);
      expect(c.read(notificationUnreadControllerProvider).value, 5);
    },
  );

  test('Mesajlar rozeti: ön plana dönüşte yenilenir; okunmamış liste ve açık '
      'akışta istek yok', () async {
    final repo = chats.FakeChatRepository();
    final c = chats.chatContainer(repo);
    int reads() => repo.calls.where((x) => x == 'loadInbox').length;
    await refreshMessagesBadge(c);
    expect(reads(), 0, reason: 'liste hiç okunmadı');

    c.listen(messagesNavBadgeProvider, (_, _) {});
    await c.read(chatsControllerProvider.future);
    expect(c.read(messagesNavBadgeProvider), 1);
    repo.inbox = ChatInbox(
      chats: [chats.chat('c1', unread: 2), chats.chat('c2', unread: 1)],
    );
    await refreshMessagesBadge(c);
    expect(reads(), 2);
    expect(c.read(messagesNavBadgeProvider), 2);

    final conn = StreamController<ChatSignal>();
    addTearDown(conn.close);
    repo.connections.add(conn);
    c.listen(chatSyncControllerProvider, (_, _) {});
    await refreshMessagesBadge(c);
    expect(reads(), 2, reason: 'akış açıkken açılış tazeler');
  });
}
