// Toplantı listesi: imleçli okuma, yöneticiye silinenler, geri yükleme / kalıcı silme, bayat
// liste tazelemesi; görünüm durumu (arama kapanınca sorgu temizlenir).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/foreground_refresh.dart';
import 'package:nizamio/features/meetings/application/meetings_controller.dart';
import 'package:nizamio/features/meetings/domain/meeting_board.dart';

import '../../pilot_support.dart';
import '../meetings_server.dart';

Future<MeetingsBoard> _board(ProviderContainer c) {
  c.listen(meetingsBoardControllerProvider, (_, _) {});
  return c.read(meetingsBoardControllerProvider.future);
}

void main() {
  test('yönetici: bütün sayfalar okunur, silinenler ayrıca gelir', () async {
    final s = MeetingsServer()
      ..pages = [
        [meetingWire(id: 'm1')],
        [meetingWire(id: 'm2')],
      ]
      ..deleted = [meetingWire(id: 'mx', deletedAt: '2026-10-18T09:00:00Z')];
    final (h, c) = await openMeetings(s);
    final b = await _board(c);
    expect(b.visible.map((m) => m.id), ['m1', 'm2']);
    expect(b.deleted?.single.id, 'mx');
    expect(b.truncated, isFalse);
    expect(calls(h), [
      'GET /v1/meetings',
      'GET /v1/meetings',
      'GET /v1/admin/deleted/meetings',
    ]);
    expect(h.backend.requests[1].query['cursor'], 'c1');
  });

  test('yönetici değil: silinenler istenmez, sekme yok', () async {
    final s = MeetingsServer(admin: false, seat: 'koordinator');
    final (h, c) = await openMeetings(s);
    final b = await _board(c);
    expect(b.deleted, isNull);
    expect(calls(h), ['GET /v1/meetings']);
  });

  test(
    'geri yükle: istek + liste yeniden okunur; kalıcı sil yerelden düşer',
    () async {
      final s = MeetingsServer()
        ..deleted = [
          meetingWire(id: 'mx', deletedAt: '2026-10-18T09:00:00Z'),
          meetingWire(id: 'my', deletedAt: '2026-10-18T09:00:00Z'),
        ];
      final (h, c) = await openMeetings(s);
      await _board(c);
      final ctl = c.read(meetingsBoardControllerProvider.notifier);
      h.backend.requests.clear();

      expect(await ctl.purge('my'), isNull);
      expect(
        c
            .read(meetingsBoardControllerProvider)
            .value!
            .deleted!
            .map((m) => m.id),
        ['mx'],
      );
      expect(calls(h), ['DELETE /v1/admin/permanent/meetings/my']);

      h.backend.requests.clear();
      s.deleted = [];
      expect(await ctl.restore('mx'), isNull);
      await c.read(meetingsBoardControllerProvider.future);
      expect(calls(h), [
        'PATCH /v1/admin/restore/meetings/mx',
        'GET /v1/meetings',
        'GET /v1/admin/deleted/meetings',
      ]);
    },
  );

  test('geri yükleme hatası kodla döner, liste değişmez', () async {
    final s = MeetingsServer()
      ..deleted = [meetingWire(id: 'mx', deletedAt: '2026-10-18T09:00:00Z')]
      ..overrides['PATCH /v1/admin/restore/meetings/mx'] = () =>
          errorBody(409, 'collaboration.not_deleted');
    final (_, c) = await openMeetings(s);
    await _board(c);
    final e = await c
        .read(meetingsBoardControllerProvider.notifier)
        .restore('mx');
    expect(e?.code, 'collaboration.not_deleted');
    expect(
      c.read(meetingsBoardControllerProvider).value!.deleted,
      hasLength(1),
    );
  });

  test('refreshIfStale: tazeyse istek yok; bayatsa yalnız liste arka planda, hata yutulur', () async {
    final s = MeetingsServer(admin: false, seat: 'koordinator');
    final (h, c) = await openMeetings(s);
    final first = await _board(c);
    final ctl = c.read(meetingsBoardControllerProvider.notifier);
    h.backend.requests.clear();

    await ctl.refreshIfStale();
    expect(calls(h), isEmpty, reason: 'staleAfter içinde');

    final pending = ctl.refreshIfStale(maxAge: Duration.zero);
    expect(c.read(meetingsBoardControllerProvider).value, same(first));
    await pending;
    expect(calls(h), ['GET /v1/meetings'], reason: 'kart ayrıntısı yok');

    s.overrides['GET /v1/meetings'] = () => errorBody(500, 'platform.internal');
    await ctl.refreshIfStale(maxAge: Duration.zero);
    final failed = c.read(meetingsBoardControllerProvider);
    expect((failed.hasError, failed.hasValue), (true, true));
  });

  test(
    'ön plana dönüş: okunmamış liste okunmaz; taze liste okunmaz, bayat okunur',
    () async {
      final s = MeetingsServer(admin: false, seat: 'koordinator');
      final (h, c) = await openMeetings(s);
      await refreshStaleMeetings(c, maxAge: Duration.zero);
      expect(c.exists(meetingsBoardControllerProvider), isFalse);
      expect(calls(h), isEmpty);

      await _board(c);
      h.backend.requests.clear();
      await refreshStaleMeetings(c);
      expect(calls(h), isEmpty, reason: 'staleAfter içinde');
      await refreshStaleMeetings(c, maxAge: Duration.zero);
      expect(calls(h), ['GET /v1/meetings']);
    },
  );

  test('görünüm: arama kapanınca sorgu temizlenir; sekme korunur', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final v = c.read(meetingsViewControllerProvider.notifier)
      ..toggleSearch()
      ..setQuery('enerji')
      ..selectTab(MeetingsTab.past);
    expect(c.read(meetingsViewControllerProvider).query, 'enerji');
    v.toggleSearch();
    final s = c.read(meetingsViewControllerProvider);
    expect((s.searchOpen, s.query, s.tab), (false, '', MeetingsTab.past));
  });
}
