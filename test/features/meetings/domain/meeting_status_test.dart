// Toplantı durumu (canlı, bekliyor, yapılmadı, bitti) sunucu özetinden; ayrıntıdan türetilen
// özet (sayaçlar, açık/son konferans, bağlı kişi).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/features/meetings/domain/meeting.dart';
import 'package:nizamio/features/meetings/domain/meeting_status.dart';

final _now = DateTime(2026, 10, 14, 14, 27);

Meeting _m(DateTime at, {MeetingSummary? summary}) => Meeting(
  id: 'm',
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
  summary: summary,
);

MeetingSummary _s(
  SummaryConferenceStatus st, {
  DateTime? start,
  DateTime? end,
}) => MeetingSummary(
  agendaTotal: 0,
  agendaChecked: 0,
  noteCount: 0,
  participantCount: 0,
  conferenceStatus: st,
  conferenceStartedAt: start,
  conferenceEndedAt: end,
  connectedCount: 0,
);

MeetingStatus? _status(DateTime at, MeetingSummary? s) =>
    meetingStatus(_m(at, summary: s), now: _now);

void main() {
  final today14 = DateTime(2026, 10, 14, 14);
  final yesterday = DateTime(2026, 10, 13, 10);
  final tomorrow = DateTime(2026, 10, 15, 10);

  test('özet yoksa durum yok (silinenler, kuruluş yanıtı)', () {
    expect(_status(yesterday, null), isNull);
  });

  test('açılan ve süren konferans canlı', () {
    for (final st in [
      SummaryConferenceStatus.starting,
      SummaryConferenceStatus.live,
    ]) {
      expect(
        _status(tomorrow, _s(st, start: _now)),
        const MeetingStatus(MeetingPhase.live),
      );
    }
  });

  test('biten konferans: süre başlangıç–bitişten, dakikaya yuvarlanır', () {
    final start = DateTime.utc(2026, 10, 13, 7);
    expect(
      _status(
        yesterday,
        _s(
          SummaryConferenceStatus.ended,
          start: start,
          end: start.add(const Duration(minutes: 41, seconds: 40)),
        ),
      ),
      const MeetingStatus(MeetingPhase.finished, minutes: 42),
    );
    // Kapanmakta olan konferansın kapanma anı biliniyorsa da bitti.
    expect(
      _status(
        today14,
        _s(
          SummaryConferenceStatus.ending,
          start: start,
          end: start.add(const Duration(minutes: 5)),
        ),
      ),
      const MeetingStatus(MeetingPhase.finished, minutes: 5),
    );
  });

  test('anı eksik bitti/kapanıyor ve bilinmeyen durum: durum yok', () {
    expect(_status(yesterday, _s(SummaryConferenceStatus.ending)), isNull);
    expect(_status(yesterday, _s(SummaryConferenceStatus.unknown)), isNull);
  });

  test('hiç açılmadı: geçmiş gün yapılmadı, bugün saati geçtiyse bekliyor', () {
    final none = _s(SummaryConferenceStatus.none);
    expect(_status(yesterday, none), const MeetingStatus(MeetingPhase.notHeld));
    expect(_status(today14, none), const MeetingStatus(MeetingPhase.waiting));
    expect(_status(DateTime(2026, 10, 14, 15), none), isNull, reason: 'sonra');
    expect(_status(tomorrow, none), isNull);
  });

  group('ayrıntıdan özet', () {
    AgendaItem a(String id, {bool done = false}) => AgendaItem(
      id: id,
      meetingId: 'm',
      title: id,
      sortOrder: 1,
      isChecked: done,
      createdAt: _now,
    );
    MeetingDetail d({MeetingConference? conference, PastConference? last}) =>
        MeetingDetail(
          meeting: _m(_now),
          viewerRole: MeetingRole.admin,
          participants: const [
            MeetingParticipant(accountId: 'x', fullName: 'X'),
          ],
          agenda: [a('1', done: true), a('2')],
          notes: PageSlice(items: const [], nextCursor: 'n2'),
          conference: conference,
          lastConference: last,
        );

    test('sayaçlar: işaretli gündem, okunan not sayısı, katılımcı', () {
      final s = MeetingSummary.of(d(), notes: 23);
      expect(
        (s.agendaChecked, s.agendaTotal, s.noteCount, s.participantCount),
        (1, 2, 23, 1),
      );
      expect(s.conferenceStatus, SummaryConferenceStatus.none);
      expect(s.connectedCount, 0);
    });

    test('açık konferans: durumu, başlangıcı ve bağlı kişi sayısı', () {
      final s = MeetingSummary.of(
        d(
          conference: MeetingConference(
            id: 'c',
            status: ConferenceStatus.live,
            startedAt: _now,
            startedByAccountId: 'a',
            connected: ConferenceConnected(
              count: 2,
              accountIds: const ['x', 'y'],
              observedAt: _now,
            ),
          ),
          last: PastConference(startedAt: _now, endedAt: _now),
        ),
        notes: 0,
      );
      expect(s.conferenceStatus, SummaryConferenceStatus.live);
      expect(s.conferenceStartedAt, _now);
      expect(s.conferenceEndedAt, isNull);
      expect(s.connectedCount, 2);
    });

    test('yalnız son konferans: bitti ve anları', () {
      final end = _now.add(const Duration(minutes: 30));
      final s = MeetingSummary.of(
        d(
          last: PastConference(startedAt: _now, endedAt: end),
        ),
        notes: 0,
      );
      expect(s.conferenceStatus, SummaryConferenceStatus.ended);
      expect((s.conferenceStartedAt, s.conferenceEndedAt), (_now, end));
    });
  });
}
