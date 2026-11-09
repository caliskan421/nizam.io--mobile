// Toplantı listesi: imleçli okuma, yöneticiye silinenler, geri yükleme / kalıcı silme, bayat
// liste tazelemesi (satır özeti dahil) ve putSummary; görünüm durumu (arama kapanınca sorgu
// temizlenir).
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/foreground_refresh.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/meetings/application/meetings_controller.dart';
import 'package:nizamio/features/meetings/domain/meeting.dart';
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

  test('bayat tazeleme satır özetini sunucudan yeniler; putSummary sonra yine yazar', () async {
    final s = MeetingsServer(admin: false, seat: 'koordinator')
      ..pages = [
        [meetingWire(summary: summaryWire())],
      ];
    final (h, c) = await openMeetings(s);
    await _board(c);
    final ctl = c.read(meetingsBoardControllerProvider.notifier);
    s.pages = [
      [meetingWire(summary: summaryWire(notes: 4, status: 'live'))],
    ];
    h.backend.requests.clear();
    await ctl.refreshIfStale(maxAge: Duration.zero);
    MeetingSummary row() =>
        c.read(meetingsBoardControllerProvider).value!.visible.single.summary!;
    expect(
      (row().noteCount, row().conferenceStatus),
      (4, SummaryConferenceStatus.live),
    );
    expect(calls(h), ['GET /v1/meetings'], reason: 'kart başına istek yok');

    ctl.putSummary(
      'm1',
      const MeetingSummary(
        agendaTotal: 2,
        agendaChecked: 0,
        noteCount: 5,
        participantCount: 1,
        conferenceStatus: SummaryConferenceStatus.live,
        connectedCount: 0,
      ),
    );
    expect(row().noteCount, 5);
    expect(calls(h), ['GET /v1/meetings'], reason: 'putSummary ağsız');
  });

  test('okuma sürerken putSummary: yükleniyor korunur, geç gelen yanıt yerel '
      'sayacı ezmez', () async {
    final s = MeetingsServer(admin: false, seat: 'koordinator');
    final (h, c) = await openMeetings(s);
    await _board(c);
    final ctl = c.read(meetingsBoardControllerProvider.notifier);
    final gate = Completer<void>();
    h.backend.handler = (r) async {
      if ('${r.method} ${r.path}' == 'GET /v1/meetings') await gate.future;
      return s.handle(r);
    };
    // Okuma bu özetle yanıtlanacak (putSummary'den daha eski).
    s.pages = [
      [meetingWire(summary: summaryWire(notes: 2))],
    ];
    final pending = ctl.refreshIfStale(maxAge: Duration.zero);
    expect(c.read(meetingsBoardControllerProvider).isLoading, isTrue);
    ctl.putSummary('m1', _summary(notes: 5));
    expect(
      c.read(meetingsBoardControllerProvider).isLoading,
      isTrue,
      reason: 'putSummary uçuştaki okumayı gizlemez',
    );
    gate.complete();
    await pending;
    int notes() => c
        .read(meetingsBoardControllerProvider)
        .value!
        .visible
        .single
        .summary!
        .noteCount;
    expect(notes(), 5, reason: 'okuma başladıktan sonraki yerel özet üstün');

    // putSummary'den SONRA başlayan okuma sunucu değerini getirir.
    await ctl.refreshIfStale(maxAge: Duration.zero);
    expect(notes(), 2);
  });

  test('kullanıcı yenilemesi: liste ekrandaysa hata fırlar (kabuk bildirir); '
      'liste yokken fırlamaz (hata görünümü)', () async {
    final s = MeetingsServer(admin: false, seat: 'koordinator')
      ..overrides['GET /v1/meetings'] = () =>
          errorBody(500, 'platform.internal');
    final (_, c) = await openMeetings(s);
    c.listen(meetingsBoardControllerProvider, (_, _) {});
    final ctl = c.read(meetingsBoardControllerProvider.notifier);
    await expectLater(ctl.refresh(), completes);
    expect(c.read(meetingsBoardControllerProvider).hasError, isTrue);

    s.overrides.clear();
    await ctl.refresh();
    s.overrides['GET /v1/meetings'] = () => errorBody(500, 'platform.internal');
    await expectLater(ctl.refresh(), throwsA(isA<ApiError>()));
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

MeetingSummary _summary({required int notes}) => MeetingSummary(
  agendaTotal: 2,
  agendaChecked: 0,
  noteCount: notes,
  participantCount: 1,
  conferenceStatus: SummaryConferenceStatus.none,
  connectedCount: 0,
);
