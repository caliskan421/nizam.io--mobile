// Toplantı uçlarının bellek içi sahte sunucusu (controller ve form testleri). Gerçek bileşim
// kökü ([pilotHarness]) bu sunucuyla konuşur: DI bağlantısı ve tel eşlemesi birlikte sınanır.
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../support/fake_backend.dart';
import '../../support/harness.dart';
import '../pilot_support.dart';

const _t = '2026-11-03T07:00:00Z';

Map<String, Object?> meetingWire({
  String id = 'm1',
  String title = 'Haftalık koordinasyon',
  String date = '2030-01-10T07:00:00Z',
  String? deletedAt,
  List<String> departments = const ['d1', 'd2'],
  String inviteMode = 'coordinatorship',
  String? place,
  Map<String, Object?>? summary,
}) => {
  'meeting_id': id,
  'program_id': 'prog-1',
  'owner_department_id': departments.first,
  'title': title,
  'meeting_date': date,
  'members_included': false,
  'invite_mode': inviteMode,
  'place': place,
  'created_by_account_id': 'acc-1',
  'created_by_role': 'admin',
  'created_at': _t,
  'updated_at': _t,
  'departments': [
    for (final d in departments)
      {'department_id': d, 'department_name': 'Ad $d', 'deleted': false},
  ],
  'deleted_at': deletedAt,
  'summary': ?summary,
};

/// Liste satırı özeti (`MeetingSummary`).
Map<String, Object?> summaryWire({
  int agenda = 2,
  int checked = 0,
  int notes = 1,
  int people = 1,
  String status = 'none',
  String? started,
  String? ended,
  int connected = 0,
}) => {
  'agenda_total': agenda,
  'agenda_checked': checked,
  'note_count': notes,
  'participant_count': people,
  'conference_status': status,
  'conference_started_at': started,
  'conference_ended_at': ended,
  'connected_count': connected,
};

/// Katılımcı satırı (`Participant`); [teams]: (departman, rol) çiftleri.
Map<String, Object?> participantWire(
  String id,
  String name, {
  List<(String, String)> teams = const [],
}) => {
  'account_id': id,
  'full_name': name,
  'teams': [
    for (final (d, role) in teams)
      {'department_id': d, 'department_name': 'Ad $d', 'role': role},
  ],
};

/// Konferans (`Conference`); [connected] bağlı hesaplar (gözlenmişse).
Map<String, Object?> conferenceWire({
  String status = 'live',
  List<String>? connected,
}) => {
  'id': 'c1',
  'status': status,
  'started_at': _t,
  'started_by_account_id': 'acc-1',
  'connected': {
    'count': connected?.length ?? 0,
    'account_ids': connected ?? const <String>[],
    'observed_at': connected == null ? null : _t,
  },
};

Map<String, Object?> agendaWire(
  String id, {
  int order = 1,
  bool checked = false,
  String title = 'Madde',
}) => {
  'agenda_item_id': id,
  'meeting_id': 'm1',
  'title': title,
  'sort_order': order,
  'is_checked': checked,
  'checked_at': checked ? _t : null,
  'checked_by_account_id': checked ? 'acc-1' : null,
  'created_at': _t,
};

Map<String, Object?> noteWire(
  String id, {
  String author = 'acc-1',
  String role = 'admin',
  String content = 'Not',
  String created = _t,
  String? task,
}) => {
  'note_id': id,
  'meeting_id': 'm1',
  'author_account_id': author,
  'author_name': 'Yazar $author',
  'author_role': role,
  'content': content,
  'converted_to_work_item_id': task,
  'created_at': created,
  'updated_at': created,
  'edit_revision': 1,
};

class MeetingsServer {
  MeetingsServer({this.admin = true, this.seat});

  /// `GET /v1/me` `company_admin`.
  bool admin;

  /// `d1` departmanındaki ekip rolü (`koordinator` / `uye`); null → ekip satırı yok.
  String? seat;

  final _pilot = PilotBackend();

  /// `listMeetings` sayfaları (imleç `c1`, `c2`… ile ilerler).
  List<List<Map<String, Object?>>> pages = [
    [meetingWire(summary: summaryWire())],
  ];
  List<Map<String, Object?>> deleted = [];

  String viewerRole = 'admin';
  List<Map<String, Object?>> participants = [
    participantWire('acc-1', 'Ayşe Yılmaz'),
  ];

  /// Ayrıntının davet kipi ve son biten konferansı.
  String inviteMode = 'coordinatorship';
  Map<String, Object?>? lastConference;
  List<Map<String, Object?>> agenda = [
    agendaWire('g1'),
    agendaWire('g2', order: 2),
  ];

  /// Notların ilk sayfası (ayrıntıda) ve imleçli devamı.
  List<Map<String, Object?>> notes = [noteWire('n1')];
  List<Map<String, Object?>> moreNotes = [];
  Map<String, Object?>? conference;

  /// Yolun (`METHOD /yol`) yanıtını değiştirir (hata enjeksiyonu).
  final overrides = <String, ResponseBody Function()>{};

  /// Doluysa yazmalar bu tamamlanana kadar bekler (iyimser durum gözlemi).
  Completer<void>? hold;

  FutureOr<ResponseBody> handle(Seen r) async {
    final key = '${r.method} ${r.path}';
    final custom = overrides[key];
    if (r.method != 'GET') await hold?.future;
    if (custom != null) return custom();
    final body = r.body is Map ? r.body! as Map : const <Object?, Object?>{};
    switch (key) {
      case 'GET /v1/me':
        return jsonResponse(200, {
          'account_id': 'acc-1',
          'email': 'a@b.test',
          'full_name': 'Ayşe Yılmaz',
          'company_admin': admin,
        });
      case 'GET /v1/program/departments':
        return jsonResponse(200, {
          'departments': [
            {'department_id': 'd1', 'display_name': 'Altyapı', 'code': 'ALT'},
            {'department_id': 'd2', 'display_name': 'Mekanik', 'code': 'MEK'},
          ],
        });
      case 'GET /v1/me/departments':
        return jsonResponse(200, {
          'departments': [
            if (seat case final role?)
              {
                'program_id': 'prog-1',
                'program_name': 'Program Bir',
                'department_id': 'd1',
                'display_name': 'Altyapı',
                'role': role,
              },
          ],
        });
      case 'GET /v1/meetings':
        final i = int.tryParse((r.query['cursor'] ?? 'c0').substring(1)) ?? 0;
        return jsonResponse(200, {
          'items': pages[i],
          'next_cursor': i + 1 < pages.length ? 'c${i + 1}' : '',
        });
      case 'GET /v1/admin/deleted/meetings':
        return jsonResponse(200, {'items': deleted, 'next_cursor': ''});
      case 'GET /v1/meetings/m1':
        return jsonResponse(200, {
          ...meetingWire(inviteMode: inviteMode),
          'conference': conference,
          'last_conference': lastConference,
          'conference_available': true,
          'viewer_role': viewerRole,
          'participants': participants,
          'agenda': agenda,
          'notes': {
            'items': notes,
            'next_cursor': moreNotes.isEmpty ? '' : 'n2',
            'total': notes.length + moreNotes.length,
            'counts': {'all': 0, 'converted': 0, 'mine': 0},
          },
        });
      case 'GET /v1/meetings/m1/notes':
        return jsonResponse(200, {
          'items': moreNotes,
          'next_cursor': '',
          'total': notes.length + moreNotes.length,
          'counts': {'all': 0, 'converted': 0, 'mine': 0},
        });
      case 'POST /v1/meetings/m1/agenda':
        return jsonResponse(
          201,
          agendaWire('g9', order: 9, title: '${body['title']}'),
        );
      case 'POST /v1/meetings/m1/notes':
        return jsonResponse(
          201,
          noteWire(
            'n9',
            content: '${body['content']}',
            created: '2030-01-10T08:00:00Z',
          ),
        );
      case 'POST /v1/meetings/m1/conference':
        return jsonResponse(201, {'conference': conferenceWire()});
      case 'POST /v1/meetings/m1/participants':
        return jsonResponse(201, {
          'meeting_id': 'm1',
          'user_id': '${body['user_id']}',
        });
      case 'POST /v1/meetings':
        return jsonResponse(201, {
          'meeting': meetingWire(id: 'm7', title: '${body['title']}'),
          'failed_participants': null,
          'side_effects': {'failed_messages': 0, 'event_failed': false},
        });
      case 'PATCH /v1/meetings/m1':
        return jsonResponse(200, {
          ...meetingWire(inviteMode: inviteMode),
          'side_effects': {'failed_messages': 0, 'event_failed': false},
        });
      case 'PATCH /v1/admin/restore/meetings/mx':
        return jsonResponse(200, {'meeting_id': 'mx', 'status': 'restored'});
      case 'POST /v1/meeting-notes/n1/convert-to-task':
        return jsonResponse(201, {
          'work_item_id': 'w9',
          'note': noteWire('n1', task: 'w9'),
        });
    }
    if (r.method == 'PATCH' && r.path.startsWith('/v1/meeting-agenda/')) {
      final id = r.path.split('/').last;
      final row = agenda.firstWhere(
        (a) => a['agenda_item_id'] == id,
        orElse: () => agendaWire(id),
      );
      final checked = body.containsKey('is_checked')
          ? body['is_checked'] == true
          : row['is_checked'] == true;
      return jsonResponse(
        200,
        agendaWire(
          id,
          order: row['sort_order']! as int,
          title: body['title'] as String? ?? row['title']! as String,
          checked: checked,
        ),
      );
    }
    if (r.method == 'PATCH' && r.path.startsWith('/v1/meeting-notes/')) {
      return jsonResponse(
        200,
        noteWire(r.path.split('/').last, content: '${body['content']}'),
      );
    }
    if (r.method == 'DELETE' &&
        r.path.startsWith('/v1/admin/permanent/meetings/')) {
      return jsonResponse(200, {
        'meeting_id': r.path.split('/').last,
        'status': 'purged',
      });
    }
    if (r.method == 'DELETE') return ResponseBody.fromString('', 204);
    return _pilot.handle(r);
  }
}

/// Oturum açık, `prog-1` seçili, görev kataloğu okunmuş; istek kaydı temiz.
Future<(Harness, ProviderContainer)> openMeetings(MeetingsServer server) async {
  final h = await pilotHarness(PilotBackend(), signedIn: true);
  h.backend.handler = server.handle;
  h.read(scopeControllerProvider).selectProgram('prog-1');
  final c = h.container..listen(taskCatalogControllerProvider, (_, _) {});
  await c.read(taskCatalogControllerProvider.future);
  h.backend.requests.clear();
  return (h, c);
}

/// Kaydedilen istekler: `METHOD /yol`.
List<String> calls(Harness h) => [
  for (final r in h.backend.requests) '${r.method} ${r.path}',
];
