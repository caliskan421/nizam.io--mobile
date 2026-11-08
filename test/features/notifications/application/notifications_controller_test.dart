// Bildirim çanı: liste (imleçli sayfa, yenileme), zil rozeti (okunmamış sayısı) ve yazmalar
// (tek okundu, tümü okundu) sonrası satır/sayaç tutarlılığı; rozet yaşamıyorsa kurulmaz.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/notifications/application/notifications_controller.dart';
import 'package:nizamio/features/notifications/application/notifications_providers.dart';
import 'package:nizamio/features/notifications/domain/app_notification.dart';
import 'package:nizamio/features/notifications/domain/notification_repository.dart';

AppNotification _n(String id, {bool read = false, String kind = 'work_item'}) =>
    AppNotification(
      id: id,
      type: NotificationType.workItemCreated,
      rawType: 'work.item.created',
      subject: NotificationSubject(kind: kind, id: 'w-$id'),
      isRead: read,
      createdAt: DateTime.utc(2026, 11, 1),
    );

NotificationFeed _feed(
  List<AppNotification> items, {
  String? next,
  int unread = 0,
}) => NotificationFeed(
  page: PageSlice(items: items, nextCursor: next),
  unreadCount: unread,
);

/// Bellek içi sahte kaynak: imleç → sayfa; çağrıları kaydeder.
class _Repo implements NotificationRepository {
  final pages = <String?, NotificationFeed>{};
  int unread = 0;
  final calls = <String>[];
  ApiError? listError;
  ApiError? writeError;
  Completer<void>? gate;

  @override
  Future<NotificationFeed> list({
    PageRequest page = const PageRequest(),
  }) async {
    calls.add('list ${page.cursor}');
    if (listError case final e?) throw e;
    return pages[page.cursor]!;
  }

  @override
  Future<int> unreadCount() async {
    calls.add('count');
    return unread;
  }

  @override
  Future<void> markRead(String id) async {
    calls.add('read $id');
    await gate?.future;
    if (writeError case final e?) throw e;
  }

  @override
  Future<int> markAllRead() async {
    calls.add('readAll');
    if (writeError case final e?) throw e;
    return 1;
  }

  @override
  Never registerPushTarget({
    required String endpoint,
    required String p256dh,
    required String auth,
    String? userAgent,
  }) => throw UnimplementedError();

  @override
  Never unregisterPushTarget(String targetId) => throw UnimplementedError();

  @override
  Never pushPublicKey() => throw UnimplementedError();
}

ProviderContainer _container(_Repo repo) {
  final c = ProviderContainer(
    retry: (_, _) => null,
    overrides: [notificationRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(c.dispose);
  return c;
}

/// Zil ekranda: rozet dinlenir ve ilk sayısı okunur.
Future<void> _bell(ProviderContainer c) async {
  c.listen(notificationUnreadControllerProvider, (_, _) {});
  await c.read(notificationUnreadControllerProvider.future);
}

Future<NotificationsView> _open(ProviderContainer c) {
  c.listen(notificationsControllerProvider, (_, _) {});
  return c.read(notificationsControllerProvider.future);
}

int? _badge(ProviderContainer c) =>
    c.read(notificationUnreadControllerProvider).value;

NotificationsView _view(ProviderContainer c) =>
    c.read(notificationsControllerProvider).requireValue;

final _err = ApiError('notifications.notification_not_found');

void main() {
  test(
    'rozet unreadCount\'tan; liste açılınca ilk sayfa ve sayaç eşitlenir',
    () async {
      final repo = _Repo()
        ..unread = 1
        ..pages[null] = _feed(
          [_n('a'), _n('b', read: true)],
          next: 'c2',
          unread: 4,
        );
      final c = _container(repo);
      await _bell(c);
      expect(_badge(c), 1);

      final v = await _open(c);
      expect(v.items.map((n) => n.id), ['a', 'b']);
      expect(v.hasMore, isTrue);
      expect(
        _badge(c),
        4,
        reason: 'liste yanıtının unread_count\'u rozete yansır',
      );
      expect(repo.calls, ['count', 'list null']);
    },
  );

  test(
    'rozet ekranda değilse liste onu kurmaz (ek sayaç isteği yok)',
    () async {
      final repo = _Repo()..pages[null] = _feed([_n('a')], unread: 1);
      final c = _container(repo);
      await _open(c);
      expect(c.exists(notificationUnreadControllerProvider), isFalse);
      expect(repo.calls, ['list null']);
    },
  );

  group('sayfalama', () {
    test(
      'imleçle sonraki sayfa eklenir; kayan kayıt iki kez gösterilmez',
      () async {
        final repo = _Repo()
          ..pages[null] = _feed([_n('a'), _n('b')], next: 'c2', unread: 3)
          ..pages['c2'] = _feed([_n('b'), _n('c')], unread: 2);
        final c = _container(repo);
        await _bell(c);
        await _open(c);
        await c.read(notificationsControllerProvider.notifier).loadMore();
        final v = _view(c);
        expect(v.items.map((n) => n.id), ['a', 'b', 'c']);
        expect(v.hasMore, isFalse);
        expect(_badge(c), 2);

        // Son sayfada istek yok.
        await c.read(notificationsControllerProvider.notifier).loadMore();
        expect(repo.calls.where((s) => s.startsWith('list')), [
          'list null',
          'list c2',
        ]);
      },
    );

    test(
      'sonraki sayfa hatası satırları korur; yeniden deneme dokunuşla',
      () async {
        final repo = _Repo()
          ..pages[null] = _feed([_n('a')], next: 'c2')
          ..pages['c2'] = _feed([_n('b')]);
        final c = _container(repo);
        await _open(c);
        final ctl = c.read(notificationsControllerProvider.notifier);
        repo.listError = _err;
        await ctl.loadMore();
        expect(_view(c).items.map((n) => n.id), ['a']);
        expect(_view(c).moreError?.code, _err.code);
        expect(_view(c).hasMore, isTrue);

        repo.listError = null;
        await ctl.loadMore();
        expect(_view(c).items.map((n) => n.id), ['a', 'b']);
        expect(_view(c).moreError, isNull);
      },
    );

    test('yenileme ilk sayfayı yeniden okur, imleç sıfırlanır', () async {
      final repo = _Repo()
        ..pages[null] = _feed([_n('a')], next: 'c2')
        ..pages['c2'] = _feed([_n('b')]);
      final c = _container(repo);
      await _open(c);
      final ctl = c.read(notificationsControllerProvider.notifier);
      await ctl.loadMore();
      repo.pages[null] = _feed([_n('z'), _n('a')], next: 'c2');
      await ctl.refresh();
      expect(_view(c).items.map((n) => n.id), ['z', 'a']);
      expect(_view(c).hasMore, isTrue);
    });
  });

  group('tek okundu', () {
    test('okunmamış satır: istek, satır okundu, rozet bir azalır', () async {
      final repo = _Repo()
        ..unread = 2
        ..pages[null] = _feed([_n('a'), _n('b')], unread: 2);
      final c = _container(repo);
      await _bell(c);
      await _open(c);
      final ctl = c.read(notificationsControllerProvider.notifier);
      expect(await ctl.markRead('a'), isNull);
      expect(_view(c).items.map((n) => n.isRead), [true, false]);
      expect(_badge(c), 1);
      expect(repo.calls.last, 'read a');
    });

    test('okunmuş ya da bilinmeyen satır: istek yok, rozet değişmez', () async {
      final repo = _Repo()
        ..unread = 1
        ..pages[null] = _feed([_n('a', read: true)], unread: 1);
      final c = _container(repo);
      await _bell(c);
      await _open(c);
      repo.calls.clear();
      final ctl = c.read(notificationsControllerProvider.notifier);
      expect(await ctl.markRead('a'), isNull);
      expect(await ctl.markRead('yok'), isNull);
      expect(repo.calls, isEmpty);
      expect(_badge(c), 1);
    });

    test('çift dokunuş tek istek, rozet bir kez düşer', () async {
      final repo = _Repo()
        ..unread = 3
        ..pages[null] = _feed([_n('a')], unread: 3)
        ..gate = Completer<void>();
      final c = _container(repo);
      await _bell(c);
      await _open(c);
      final ctl = c.read(notificationsControllerProvider.notifier);
      final first = ctl.markRead('a');
      final second = ctl.markRead('a');
      repo.gate!.complete();
      await Future.wait([first, second]);
      expect(repo.calls.where((s) => s == 'read a'), hasLength(1));
      expect(_badge(c), 2);
    });

    test('hata döner; satır ve rozet değişmez', () async {
      final repo = _Repo()
        ..unread = 1
        ..pages[null] = _feed([_n('a')], unread: 1)
        ..writeError = _err;
      final c = _container(repo);
      await _bell(c);
      await _open(c);
      final error = await c
          .read(notificationsControllerProvider.notifier)
          .markRead('a');
      expect(error?.code, _err.code);
      expect(_view(c).items.single.isRead, isFalse);
      expect(_badge(c), 1);
    });
  });

  group('tümü okundu', () {
    test('bütün satırlar okundu, rozet 0', () async {
      final repo = _Repo()
        ..unread = 5
        ..pages[null] = _feed(
          [_n('a'), _n('b', read: true)],
          next: 'c2',
          unread: 5,
        );
      final c = _container(repo);
      await _bell(c);
      await _open(c);
      expect(
        await c.read(notificationsControllerProvider.notifier).markAllRead(),
        isNull,
      );
      expect(_view(c).items.every((n) => n.isRead), isTrue);
      expect(_view(c).hasMore, isTrue, reason: 'imleç korunur');
      expect(_badge(c), 0);
    });

    test('hata döner; satırlar ve rozet değişmez', () async {
      final repo = _Repo()
        ..unread = 1
        ..pages[null] = _feed([_n('a')], unread: 1)
        ..writeError = _err;
      final c = _container(repo);
      await _bell(c);
      await _open(c);
      final error = await c
          .read(notificationsControllerProvider.notifier)
          .markAllRead();
      expect(error?.code, _err.code);
      expect(_view(c).items.single.isRead, isFalse);
      expect(_badge(c), 1);
    });
  });

  test('rozet yenilemesi sayıyı yeniden okur', () async {
    final repo = _Repo()..unread = 2;
    final c = _container(repo);
    await _bell(c);
    final ctl = c.read(notificationUnreadControllerProvider.notifier);
    repo.unread = 7;
    await ctl.refresh();
    expect(_badge(c), 7);
    expect(repo.calls, ['count', 'count']);
  });
}
