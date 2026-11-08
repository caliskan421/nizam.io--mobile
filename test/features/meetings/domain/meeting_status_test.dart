// Toplantı durumu (canlı, bekliyor, yapılmadı, bitti) ve kart sayaçları; dev örnek olguları
// kimlikten kararlı ve üretimde boş.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/features/meetings/data/sample/sample_meeting_extras.dart';
import 'package:nizamio/features/meetings/domain/meeting.dart';
import 'package:nizamio/features/meetings/domain/meeting_status.dart';

final _now = DateTime(2026, 10, 14, 14, 27);

Meeting _m(DateTime at, {String id = 'm', DateTime? deletedAt}) => Meeting(
  id: id,
  programId: 'p',
  ownerDepartmentId: 'd',
  title: 't',
  meetingDate: at,
  membersIncluded: false,
  createdByAccountId: 'a',
  createdByRole: MeetingRole.admin,
  createdAt: at,
  updatedAt: at,
  departments: const [MeetingDepartment(id: 'd', name: 'D')],
  deletedAt: deletedAt,
);

MeetingConference _conf(ConferenceStatus s) => MeetingConference(
  id: 'c',
  status: s,
  startedAt: _now,
  startedByAccountId: 'a',
);

void main() {
  test('canlı konferans her şeyden önce; kapanan konferans canlı sayılmaz', () {
    final m = _m(DateTime(2026, 10, 14, 14));
    expect(
      meetingStatus(m, now: _now, conference: _conf(ConferenceStatus.live)),
      const MeetingStatus(MeetingPhase.live),
    );
    expect(
      meetingStatus(m, now: _now, conference: _conf(ConferenceStatus.starting)),
      const MeetingStatus(MeetingPhase.live),
    );
    expect(
      meetingStatus(
        m,
        now: _now,
        conference: _conf(ConferenceStatus.ending),
        conferenceKnown: true,
      ),
      const MeetingStatus(MeetingPhase.waiting),
    );
  });

  test('bekliyor: bugün, saati geçmiş, konferans bilgisi okunmuş ve yok', () {
    final past = _m(DateTime(2026, 10, 14, 14));
    final later = _m(DateTime(2026, 10, 14, 16, 30));
    expect(meetingStatus(past, now: _now), isNull, reason: 'bilinmiyor');
    expect(
      meetingStatus(past, now: _now, conferenceKnown: true),
      const MeetingStatus(MeetingPhase.waiting),
    );
    expect(meetingStatus(later, now: _now, conferenceKnown: true), isNull);
  });

  test('bitti ve yapılmadı yalnız olgudan gelir', () {
    final m = _m(DateTime(2026, 10, 12, 10));
    expect(meetingStatus(m, now: _now, conferenceKnown: true), isNull);
    expect(
      meetingStatus(
        m,
        now: _now,
        extras: const MeetingExtras(finishedMinutes: 42),
      ),
      const MeetingStatus(MeetingPhase.finished, minutes: 42),
    );
    expect(
      meetingStatus(m, now: _now, extras: const MeetingExtras(notHeld: true)),
      const MeetingStatus(MeetingPhase.notHeld),
    );
  });

  test('sayaçlar: işaretli gündem, ilk not sayfası (+ devamı), katılımcı', () {
    AgendaItem a(String id, {bool done = false}) => AgendaItem(
      id: id,
      meetingId: 'm',
      title: id,
      sortOrder: 1,
      isChecked: done,
      createdAt: _now,
    );
    final d = MeetingDetail(
      meeting: _m(_now),
      viewerRole: MeetingRole.admin,
      participants: const [MeetingParticipant(accountId: 'x', fullName: 'X')],
      agenda: [a('1', done: true), a('2')],
      notes: PageSlice(items: const [], nextCursor: 'n2'),
    );
    final s = MeetingSummary.of(d);
    expect(
      (s.agendaDone, s.agendaTotal, s.notes, s.moreNotes, s.people),
      (1, 2, 0, true, 1),
    );
    final all = MeetingSummary.of(d, notes: 23);
    expect((all.notes, all.moreNotes), (23, false));
  });

  test(
    'dev örnek olguları kimlikten kararlı; geleceğe geçmiş olgusu yazılmaz',
    () {
      const x = SampleMeetingExtras();
      final today = DateTime(2026, 10, 14);
      final future = x.of(_m(DateTime(2026, 10, 20), id: 'a'), today);
      expect(
        (future.finishedMinutes, future.notHeld, future.deletedBy),
        (null, false, null),
      );
      final pasts = [
        for (var i = 0; i < 12; i++)
          x.of(_m(DateTime(2026, 10, 1), id: 'm$i'), today),
      ];
      expect(pasts.any((e) => e.notHeld), isTrue);
      expect(pasts.any((e) => e.finishedMinutes != null), isTrue);
      expect(
        pasts.every((e) => e.notHeld != (e.finishedMinutes != null)),
        isTrue,
        reason: 'geçmiş toplantı ya bitti ya yapılmadı',
      );
      expect(
        x.of(_m(DateTime(2026, 10, 1), id: 'm1'), today).finishedMinutes,
        x.of(_m(DateTime(2026, 10, 1), id: 'm1'), today).finishedMinutes,
      );
      final del = x.of(_m(DateTime(2026, 10, 1), deletedAt: _now), today);
      expect(del.deletedBy, isNotNull);
      expect(
        const NoMeetingExtras().of(_m(DateTime(2026, 10, 1)), today),
        same(MeetingExtras.none),
      );
    },
  );
}
