// meetings data katmanı: collaboration toplantı uçları → domain (Meeting, MeetingDetail, AgendaItem,
// MeetingNote …), bilinmeyen/boş rol → unknown, imleç ("" = son sayfa), hata zarfı → ApiError.
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/meetings/data/meetings_api_repository.dart';
import 'package:nizamio/features/meetings/domain/meeting.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.respond);

  ResponseBody Function(RequestOptions o) respond;
  final List<RequestOptions> seen = [];
  final List<Object?> bodies = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    if (requestStream == null) {
      bodies.add(null);
    } else {
      final text = utf8.decode(await requestStream.expand((c) => c).toList());
      bodies.add(text.isEmpty ? null : jsonDecode(text));
    }
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object body, [int status = 200]) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

ResponseBody _empty() => ResponseBody.fromString('', 204);

ResponseBody _err(int status, String code) =>
    _json({'code': code, 'message': 'x', 'request_id': 'req-1'}, status);

(ApiMeetingsRepository, _Adapter) _repo(
  ResponseBody Function(RequestOptions o) respond,
) {
  final adapter = _Adapter(respond);
  return (
    ApiMeetingsRepository(
      Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter,
    ),
    adapter,
  );
}

const _t = '2026-11-03T07:00:00Z';

Map<String, Object?> _meeting({
  String role = 'coordinator',
  String id = 'm1',
}) => {
  'meeting_id': id,
  'program_id': 'p1',
  'owner_department_id': 'd1',
  'title': 'Haftalık',
  'meeting_date': _t,
  'members_included': true,
  'created_by_account_id': 'a1',
  'created_by_role': role,
  'created_at': _t,
  'updated_at': _t,
  'departments': [
    {'department_id': 'd1', 'department_name': 'Mekanik'},
    {'department_id': 'd2', 'department_name': 'Yazılım'},
  ],
};

Map<String, Object?> _agenda({bool checked = false}) => {
  'agenda_item_id': 'g1',
  'meeting_id': 'm1',
  'title': 'Bütçe',
  'sort_order': 1,
  'is_checked': checked,
  'checked_at': checked ? _t : null,
  'checked_by_account_id': checked ? 'a2' : null,
  'created_at': _t,
};

Map<String, Object?> _note({Object? role = 'member'}) => {
  'note_id': 'n1',
  'meeting_id': 'm1',
  'author_account_id': null,
  'author_name': 'Ayşe',
  'author_role': role,
  'content': 'Not',
  'converted_to_work_item_id': null,
  'created_at': _t,
  'updated_at': _t,
};

const _effects = {'failed_messages': 2, 'event_failed': true};

void main() {
  group('createMeeting', () {
    test(
      'gövde + MeetingCreated eşleme (failed_participants null → boş)',
      () async {
        final (repo, a) = _repo(
          (_) => _json({
            'meeting': _meeting(),
            'failed_participants': null,
            'side_effects': _effects,
          }),
        );
        final r = await repo.createMeeting(
          MeetingDraft(
            title: 'Haftalık',
            meetingDate: DateTime(2026, 11, 3, 10, 5),
            departmentIds: const ['d1', 'd2'],
            participantIds: const ['u1'],
            membersIncluded: true,
            agendaItems: const ['Bütçe'],
            isInstant: false,
          ),
        );
        final o = a.seen.single;
        expect((o.method, o.uri.path), ('POST', '/v1/meetings'));
        expect(a.bodies.single, {
          'title': 'Haftalık',
          'meeting_date': '2026-11-03T10:05:00',
          'department_ids': ['d1', 'd2'],
          'participant_ids': ['u1'],
          'members_included': true,
          'agenda_items': ['Bütçe'],
          'is_instant': false,
        });
        expect(r.meeting.id, 'm1');
        expect(r.meeting.meetingDate, DateTime.utc(2026, 11, 3, 7));
        expect(r.meeting.createdByRole, MeetingRole.coordinator);
        expect(r.meeting.departments.map((d) => (d.id, d.name)), [
          ('d1', 'Mekanik'),
          ('d2', 'Yazılım'),
        ]);
        expect(r.failedParticipants, isEmpty);
        expect(r.sideEffects.failedMessages, 2);
        expect(r.sideEffects.eventFailed, isTrue);
      },
    );

    test('meeting_date: UTC → RFC 3339 Z, yerel → saat dilimsiz', () {
      expect(
        ApiMeetingsRepository.meetingDateWire(DateTime.utc(2026, 1, 2, 3, 4)),
        '2026-01-02T03:04:00.000Z',
      );
      expect(
        ApiMeetingsRepository.meetingDateWire(DateTime(2026, 1, 2, 3, 4, 5)),
        '2026-01-02T03:04:05',
      );
    });

    test('422 → ApiError', () async {
      final (repo, _) = _repo((_) => _err(422, 'collaboration.input_invalid'));
      await expectLater(
        repo.createMeeting(
          MeetingDraft(
            title: 't',
            meetingDate: DateTime.utc(2020),
            departmentIds: const ['d1'],
          ),
        ),
        throwsA(
          isA<ApiError>()
              .having((e) => e.code, 'code', 'collaboration.input_invalid')
              .having((e) => e.status, 'status', 422),
        ),
      );
    });
  });

  group('listeler', () {
    test(
      'listMeetings: imleç sorguya, next_cursor dilime; bilinmeyen rol unknown',
      () async {
        final (repo, a) = _repo(
          (_) => _json({
            'items': [_meeting(role: 'superadmin')],
            'next_cursor': 'c2',
          }),
        );
        final s = await repo.listMeetings(
          const PageRequest(limit: 10, cursor: 'c1'),
        );
        final o = a.seen.single;
        expect(o.uri.path, '/v1/meetings');
        expect(o.uri.queryParameters, {'limit': '10', 'cursor': 'c1'});
        expect(s.items.single.createdByRole, MeetingRole.unknown);
        expect(s.nextCursor, 'c2');
      },
    );

    test('next_cursor "" → son sayfa', () async {
      final (repo, a) = _repo(
        (_) => _json({'items': <Object>[], 'next_cursor': ''}),
      );
      final s = await repo.listMeetings();
      expect(a.seen.single.uri.queryParameters, isEmpty);
      expect(s.hasMore, isFalse);
      expect(s.items, isEmpty);
    });

    test('listDeletedMeetings ve adminListDeletedMeetings yolları', () async {
      final deleted = {..._meeting(), 'deleted_at': _t};
      final (repo, a) = _repo(
        (_) => _json({
          'items': [deleted],
          'next_cursor': '',
        }),
      );
      final s1 = await repo.listDeletedMeetings();
      final s2 = await repo.adminListDeletedMeetings(
        const PageRequest(limit: 5),
      );
      expect(a.seen.map((o) => o.uri.path), [
        '/v1/meetings/deleted',
        '/v1/admin/deleted/meetings',
      ]);
      expect(a.seen.last.uri.queryParameters, {'limit': '5'});
      expect(s1.items.single.deletedAt, DateTime.utc(2026, 11, 3, 7));
      expect(s2.items.single.id, 'm1');
    });

    test('403 → ApiError', () async {
      final (repo, _) = _repo((_) => _err(403, 'collaboration.not_authorized'));
      await expectLater(
        repo.listDeletedMeetings(),
        throwsA(isA<ApiError>().having((e) => e.status, 'status', 403)),
      );
    });
  });

  group('yaşam döngüsü', () {
    test('restoreMeeting / permanentDeleteMeeting', () async {
      final (repo, a) = _repo(
        (o) => _json({
          'meeting_id': 'm1',
          'status': o.method == 'PATCH' ? 'restored' : 'purged',
        }),
      );
      final r1 = await repo.restoreMeeting('m1');
      final r2 = await repo.permanentDeleteMeeting('m1');
      expect(a.seen.map((o) => (o.method, o.uri.path)), [
        ('PATCH', '/v1/admin/restore/meetings/m1'),
        ('DELETE', '/v1/admin/permanent/meetings/m1'),
      ]);
      expect(r1.status, MeetingLifecycleStatus.restored);
      expect(r2.status, MeetingLifecycleStatus.purged);
    });

    test('bilinmeyen durum → unknown', () async {
      final (repo, _) = _repo(
        (_) => _json({'meeting_id': 'm1', 'status': 'archived'}),
      );
      expect(
        (await repo.restoreMeeting('m1')).status,
        MeetingLifecycleStatus.unknown,
      );
    });

    test('deleteMeeting → DELETE 204', () async {
      final (repo, a) = _repo((_) => _empty());
      await repo.deleteMeeting('m1');
      expect(
        (a.seen.single.method, a.seen.single.uri.path),
        ('DELETE', '/v1/meetings/m1'),
      );
    });
  });

  group('getMeeting', () {
    test('ayrıntı eşleme', () async {
      final (repo, a) = _repo(
        (_) => _json({
          ..._meeting(),
          'viewer_role': 'member',
          'participants': [
            {'account_id': 'u1', 'full_name': 'Ali Veli'},
          ],
          'agenda': [_agenda(checked: true)],
          'notes': {
            'items': [_note(role: null)],
            'next_cursor': 'n2',
          },
          'conference': null,
          'conference_available': false,
        }),
      );
      final d = await repo.getMeeting('m1');
      expect(a.seen.single.uri.path, '/v1/meetings/m1');
      expect(d.meeting.title, 'Haftalık');
      expect(d.meeting.membersIncluded, isTrue);
      expect(d.viewerRole, MeetingRole.member);
      expect(d.participants.single.fullName, 'Ali Veli');
      final g = d.agenda.single;
      expect(
        (g.id, g.title, g.sortOrder, g.isChecked, g.checkedByAccountId),
        ('g1', 'Bütçe', 1, true, 'a2'),
      );
      expect(g.checkedAt, DateTime.utc(2026, 11, 3, 7));
      final n = d.notes.items.single;
      expect(n.authorRole, MeetingRole.unknown);
      expect(n.authorAccountId, isNull);
      expect(d.notes.nextCursor, 'n2');
    });

    test('404 → ApiError; bozuk gövde → invalid_response', () async {
      final (repo, _) = _repo(
        (_) => _err(404, 'collaboration.meeting_not_found'),
      );
      await expectLater(
        repo.getMeeting('x'),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            'collaboration.meeting_not_found',
          ),
        ),
      );
      final (repo2, _) = _repo((_) => _json({'meeting_id': 1}));
      await expectLater(
        repo2.getMeeting('x'),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            ClientErrorCode.invalidResponse,
          ),
        ),
      );
    });
  });

  test('updateMeeting: yalnız verilen alanlar gider; MeetingRevised', () async {
    final (repo, a) = _repo(
      (_) => _json({..._meeting(role: 'admin'), 'side_effects': _effects}),
    );
    final r = await repo.updateMeeting(
      'm1',
      MeetingChanges(title: 'Yeni', meetingDate: DateTime.utc(2026, 12, 1, 9)),
    );
    final o = a.seen.single;
    expect((o.method, o.uri.path), ('PATCH', '/v1/meetings/m1'));
    expect(a.bodies.single, {
      'title': 'Yeni',
      'meeting_date': '2026-12-01T09:00:00.000Z',
    });
    expect(r.meeting.createdByRole, MeetingRole.admin);
    expect(r.sideEffects.failedMessages, 2);
  });

  test('katılımcı ekle / çıkar', () async {
    final (repo, a) = _repo(
      (o) => o.method == 'POST'
          ? _json({'meeting_id': 'm1', 'user_id': 'u1'})
          : _empty(),
    );
    await repo.addParticipant('m1', 'u1');
    await repo.removeParticipant('m1', 'u1');
    expect(a.seen.map((o) => (o.method, o.uri.path)), [
      ('POST', '/v1/meetings/m1/participants'),
      ('DELETE', '/v1/meetings/m1/participants/u1'),
    ]);
    expect(a.bodies.first, {'user_id': 'u1'});
  });

  group('gündem', () {
    test('ekle / listele / güncelle / sil', () async {
      final (repo, a) = _repo((o) {
        if (o.method == 'DELETE') return _empty();
        if (o.method == 'GET') {
          return _json({
            'items': [_agenda()],
            'next_cursor': '',
          });
        }
        return _json(_agenda(checked: o.method == 'PATCH'));
      });
      final added = await repo.addAgendaItem('m1', 'Bütçe');
      final list = await repo.listAgenda('m1');
      final upd = await repo.updateAgendaItem('g1', isChecked: true);
      await repo.deleteAgendaItem('g1');
      expect(a.seen.map((o) => (o.method, o.uri.path)), [
        ('POST', '/v1/meetings/m1/agenda'),
        ('GET', '/v1/meetings/m1/agenda'),
        ('PATCH', '/v1/meeting-agenda/g1'),
        ('DELETE', '/v1/meeting-agenda/g1'),
      ]);
      expect(a.bodies[0], {'title': 'Bütçe'});
      expect(a.bodies[2], {'is_checked': true});
      expect(added.isChecked, isFalse);
      expect(list.single.id, 'g1');
      expect(upd.isChecked, isTrue);
    });
  });

  group('notlar', () {
    test('ekle / listele / güncelle / sil', () async {
      final (repo, a) = _repo((o) {
        if (o.method == 'DELETE') return _empty();
        if (o.method == 'GET') {
          return _json({
            'items': [_note(), _note(role: 'boss')],
            'next_cursor': 'c9',
          });
        }
        return _json(_note(role: 'coordinator'));
      });
      final n = await repo.addNote('m1', 'Not');
      final s = await repo.listNotes('m1', const PageRequest(limit: 2));
      final u = await repo.updateNote('n1', 'Düzeltme');
      await repo.deleteNote('n1');
      expect(a.seen.map((o) => (o.method, o.uri.path)), [
        ('POST', '/v1/meetings/m1/notes'),
        ('GET', '/v1/meetings/m1/notes'),
        ('PATCH', '/v1/meeting-notes/n1'),
        ('DELETE', '/v1/meeting-notes/n1'),
      ]);
      expect(a.seen[1].uri.queryParameters, {'limit': '2'});
      expect(a.bodies[0], {'content': 'Not'});
      expect(a.bodies[2], {'content': 'Düzeltme'});
      expect(n.authorRole, MeetingRole.coordinator);
      expect(s.items.map((x) => x.authorRole), [
        MeetingRole.member,
        MeetingRole.unknown,
      ]);
      expect(s.nextCursor, 'c9');
      expect(u.authorName, 'Ayşe');
    });

    test('429 hız sınırı → ApiError', () async {
      final (repo, _) = _repo((_) => _err(429, 'platform.rate_limited'));
      await expectLater(
        repo.addNote('m1', 'x'),
        throwsA(isA<ApiError>().having((e) => e.status, 'status', 429)),
      );
    });
  });

  test('convertNoteToTask: gövde ve NoteConversion', () async {
    final (repo, a) = _repo(
      (_) => _json({
        'work_item_id': 'w7',
        'note': {..._note(), 'converted_to_work_item_id': 'w7'},
      }),
    );
    final r = await repo.convertNoteToTask(
      'n1',
      NoteTaskDraft(
        startDate: DateTime(2026, 11, 3, 15, 30),
        endDate: DateTime(2026, 11, 10),
        priority: MeetingTaskPriority.urgent,
        departmentId: 'd1',
        assigneeAccountIds: const ['u1'],
      ),
    );
    final o = a.seen.single;
    expect(
      (o.method, o.uri.path),
      ('POST', '/v1/meeting-notes/n1/convert-to-task'),
    );
    final body = a.bodies.single! as Map;
    expect(body['priority'], 'acil');
    expect(body['department_id'], 'd1');
    expect(body['assignee_account_ids'], ['u1']);
    // Üretilmiş DTO `format: date` alanını tam tarih-saat yazar (envanter: açık sorun); gün
    // bileşeni doğru, saat atılmış olmalı.
    expect(body['start_date'] as String, startsWith('2026-11-03'));
    expect(body['start_date'] as String, isNot(contains('15:30')));
    expect(body['end_date'] as String, startsWith('2026-11-10'));
    expect(body.containsKey('title'), isFalse);
    expect(r.workItemId, 'w7');
    expect(r.note.convertedToWorkItemId, 'w7');
  });
}
