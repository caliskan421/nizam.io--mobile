// Kart sayaçları: kart başına `getMeeting` (önbellekli), açık ayrıntı yazdıkça ağ isteği olmadan
// güncellenir; liste yenilemesi önbelleği düşürür. Alt menü alt yazısı yaklaşan sayısıdır.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/meetings/application/meeting_room_controller.dart';
import 'package:nizamio/features/meetings/application/meeting_summary_controller.dart';
import 'package:nizamio/features/meetings/application/meetings_controller.dart';
import 'package:nizamio/features/meetings/meetings.dart';

import '../meetings_server.dart';

final _summary = meetingSummaryControllerProvider('m1');

void main() {
  test('ayrıntıdan sayaç; açık ayrıntının yazması karta yansır', () async {
    final s = MeetingsServer()
      ..conference = {
        'id': 'c1',
        'status': 'live',
        'started_at': '2026-11-03T07:00:00Z',
        'started_by_account_id': 'acc-1',
      };
    final (h, c) = await openMeetings(s);
    c.listen(_summary, (_, _) {});
    final first = await c.read(_summary.future);
    expect(
      (first.agendaDone, first.agendaTotal, first.notes, first.people),
      (0, 2, 1, 1),
    );
    expect(first.conference, isNotNull);
    expect(calls(h), ['GET /v1/meetings/m1']);

    final room = meetingRoomControllerProvider('m1');
    c.listen(room, (_, _) {});
    await c.read(room.future);
    await c
        .read(room.notifier)
        .toggleAgenda(c.read(room).value!.detail.agenda.first);
    expect(c.read(_summary).value!.agendaDone, 1);
    expect(
      calls(h).where((x) => x == 'GET /v1/meetings/m1'),
      hasLength(2),
      reason: 'kart için tek, ayrıntı için tek okuma; sayaç güncellemesi istek değil',
    );
  });

  test(
    'liste yenilemesi sayaç önbelleğini düşürür; alt yazı yaklaşan sayısı',
    () async {
      final s = MeetingsServer()
        ..pages = [
          [
            meetingWire(id: 'm1'),
            meetingWire(id: 'm2', date: '2020-01-01T08:00:00Z'),
          ],
        ];
      final (h, c) = await openMeetings(s);
      c
        ..listen(_summary, (_, _) {})
        ..listen(meetingsNavCaptionProvider, (_, _) {})
        ..listen(meetingsBoardControllerProvider, (_, _) {});
      await c.read(_summary.future);
      await c.read(meetingsBoardControllerProvider.future);
      expect(c.read(meetingsNavCaptionProvider), '1 yaklaşan');
      h.backend.requests.clear();
      await c.read(meetingsBoardControllerProvider.notifier).refresh();
      await c.read(_summary.future);
      expect(calls(h), contains('GET /v1/meetings/m1'));
    },
  );
}
