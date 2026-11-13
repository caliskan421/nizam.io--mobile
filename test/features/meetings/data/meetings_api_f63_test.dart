// meetings data katmanı, v0.12.0-api (F63) alanları: liste satırı özeti, yer, davet kipi, silen,
// son konferans, bağlı kişiler, katılımcı ekip satırları; null durumları ve istek gövdeleri.
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/meetings/data/meetings_api_repository.dart';
import 'package:nizamio/features/meetings/domain/meeting.dart';

const _t = '2026-11-03T07:00:00Z';
final _at = DateTime.utc(2026, 11, 3, 7);

class _Adapter implements HttpClientAdapter {
  _Adapter(this.body);

  final Object body;
  final List<(String, String, Object?)> seen = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final text = requestStream == null
        ? ''
        : utf8.decode(await requestStream.expand((c) => c).toList());
    seen.add((
      options.method,
      options.uri.path,
      text.isEmpty ? null : jsonDecode(text),
    ));
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiMeetingsRepository, _Adapter) _repo(Object body) {
  final a = _Adapter(body);
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = a;
  return (ApiMeetingsRepository(() => dio), a);
}

Map<String, Object?> _meeting({
  String mode = 'coordinatorship',
  String? place,
}) => {
  'meeting_id': 'm1',
  'program_id': 'p1',
  'owner_department_id': 'd1',
  'title': 'Haftalık',
  'meeting_date': _t,
  'place': place,
  'members_included': false,
  'invite_mode': mode,
  'created_by_account_id': 'a1',
  'created_by_role': 'coordinator',
  'created_at': _t,
  'updated_at': _t,
  'departments': [
    {'department_id': 'd1', 'department_name': 'Mekanik', 'deleted': false},
  ],
};

Map<String, Object?> _detail({
  Object? conference,
  Object? last,
  List<Object?> participants = const [],
}) => {
  ..._meeting(mode: 'person', place: 'Salon'),
  'viewer_role': 'coordinator',
  'participants': participants,
  'agenda': <Object?>[],
  'notes': {
    'items': <Object?>[],
    'next_cursor': '',
    'total': 0,
    'counts': {'all': 0, 'converted': 0, 'mine': 0},
  },
  'conference': conference,
  'last_conference': last,
  'conference_available': true,
};

void main() {
  test('liste satırı: özet, yer, davet kipi eşlenir', () async {
    final (repo, _) = _repo({
      'items': [
        {
          ..._meeting(place: 'B blok'),
          'summary': {
            'agenda_total': 3,
            'agenda_checked': 1,
            'note_count': 4,
            'participant_count': 5,
            'conference_status': 'ended',
            'conference_started_at': _t,
            'conference_ended_at': '2026-11-03T07:40:00Z',
            'connected_count': 0,
          },
        },
        {..._meeting(mode: 'yeni_kip')},
      ],
      'next_cursor': '',
    });
    final [m, other] = (await repo.listMeetings()).items;
    final s = m.summary!;
    expect(
      (s.agendaTotal, s.agendaChecked, s.noteCount, s.participantCount),
      (3, 1, 4, 5),
    );
    expect(s.conferenceStatus, SummaryConferenceStatus.ended);
    expect(s.conferenceStartedAt, _at);
    expect(s.conferenceEndedAt, DateTime.utc(2026, 11, 3, 7, 40));
    expect(
      (m.place, m.inviteMode),
      ('B blok', MeetingInviteMode.coordinatorship),
    );
    expect(other.inviteMode, MeetingInviteMode.unknown);
    expect((other.place, other.summary), (null, null));
  });

  test('silinenler: silen adı; null ya da boş ad → null', () async {
    final (repo, _) = _repo({
      'items': [
        {
          ..._meeting(),
          'deleted_at': _t,
          'deleted_by': {'account_id': 'a2', 'full_name': 'Reha Koçak'},
        },
        {
          ..._meeting(),
          'deleted_at': _t,
          'deleted_by': {'account_id': 'a3', 'full_name': ' '},
        },
        {..._meeting(), 'deleted_at': _t, 'deleted_by': null},
      ],
      'next_cursor': '',
    });
    final items = (await repo.adminListDeletedMeetings()).items;
    expect(items.map((m) => m.deletedByName), ['Reha Koçak', null, null]);
  });

  test(
    'ayrıntı: kişi kipi, son konferans, bağlı kişiler, ekip satırları',
    () async {
      final (repo, _) = _repo(
        _detail(
          conference: {
            'id': 'c2',
            'status': 'live',
            'started_at': _t,
            'started_by_account_id': 'a1',
            'connected': {
              'count': 2,
              'account_ids': ['a1', 'u1'],
              'observed_at': _t,
            },
          },
          last: {
            'id': 'c1',
            'started_at': '2026-11-02T07:00:00Z',
            'ended_at': '2026-11-02T07:30:00Z',
            'end_reason': 'provider_finished',
          },
          participants: [
            {
              'account_id': 'u1',
              'full_name': 'Ali Veli',
              'teams': [
                {
                  'department_id': 'd1',
                  'department_name': 'Mekanik',
                  'role': 'coordinator',
                },
                {
                  'department_id': 'd9',
                  'department_name': 'Yazılım',
                  'role': 'member',
                },
              ],
            },
            {'account_id': 'a0', 'full_name': 'Yönetici', 'teams': <Object>[]},
          ],
        ),
      );
      final d = await repo.getMeeting('m1');
      expect(d.meeting.byPerson, isTrue);
      expect(d.meeting.place, 'Salon');
      final c = d.conference!.connected;
      expect((c.count, c.observedAt), (2, _at));
      expect(c.accountIds, ['a1', 'u1']);
      expect(d.lastConference!.startedAt, DateTime.utc(2026, 11, 2, 7));
      expect(d.lastConference!.endedAt, DateTime.utc(2026, 11, 2, 7, 30));
      final [ali, admin] = d.participants;
      expect(
        [
          for (final t in ali.teams)
            (t.departmentId, t.departmentName, t.coordinator),
        ],
        [('d1', 'Mekanik', true), ('d9', 'Yazılım', false)],
      );
      expect(admin.teams, isEmpty);
    },
  );

  test(
    'ayrıntı: hiç açılmadı (iki konferans null), gözlenmemiş bağlı kişi',
    () async {
      final (repo, _) = _repo(_detail());
      final d = await repo.getMeeting('m1');
      expect((d.conference, d.lastConference), (null, null));
      final (r2, _) = _repo(
        _detail(
          conference: {
            'id': 'c2',
            'status': 'starting',
            'started_at': _t,
            'started_by_account_id': 'a1',
            'connected': {
              'count': 0,
              'account_ids': <String>[],
              'observed_at': null,
            },
          },
        ),
      );
      final c = (await r2.getMeeting('m1')).conference!.connected;
      expect((c.count, c.observedAt), (0, null));
      expect(c.accountIds, isEmpty);
    },
  );

  test('kuruluş: kip ve yer gövdede; güncelleme: yer ve boş yer', () async {
    final (repo, a) = _repo({
      'meeting': _meeting(mode: 'person'),
      'failed_participants': null,
      'side_effects': {'failed_messages': 0, 'event_failed': false},
    });
    await repo.createMeeting(
      MeetingDraft(
        title: 'Saha',
        meetingDate: DateTime.utc(2030),
        departmentIds: const ['d1'],
        participantIds: const ['u1'],
        place: 'Depo',
        inviteMode: MeetingInviteMode.person,
      ),
    );
    final body = a.seen.single.$3! as Map<String, Object?>;
    expect((body['invite_mode'], body['place']), ('person', 'Depo'));

    final (r2, a2) = _repo({
      ..._meeting(),
      'side_effects': {'failed_messages': 0, 'event_failed': false},
    });
    final r = await r2.updateMeeting('m1', const MeetingChanges(place: ''));
    expect(a2.seen.single.$3, {'place': ''});
    expect(r.meeting.place, isNull);
  });
}
