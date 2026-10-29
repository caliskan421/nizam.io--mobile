// reports data katmanı: rapor DTO'ları → domain, kesilme/total, bilinmeyen enum → unknown,
// hata → ApiError, PDF indirme hedefleri (ağ isteği yok).
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/reports/data/reports_api_repository.dart';
import 'package:nizamio/features/reports/domain/report_common.dart';
import 'package:nizamio/features/reports/domain/report_download.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.body, [this.status = 200, this.headers = const {}]);

  final String body;
  final int status;
  final Map<String, List<String>> headers;
  final List<RequestOptions> seen = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        ...headers,
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiReportsRepository, _Adapter) _repo(
  Object body, {
  int status = 200,
  Map<String, List<String>> headers = const {},
}) {
  final adapter = _Adapter(jsonEncode(body), status, headers);
  return (
    ApiReportsRepository(
      Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter,
    ),
    adapter,
  );
}

const _ayse = {'account_id': 'a1', 'full_name': 'Ayşe Kaya'};
const _ali = {'account_id': 'a2', 'full_name': 'Ali Veli'};

Map<String, Object?> _task({
  String status = 'devam_ediyor',
  String priority = 'yuksek',
}) => {
  'work_item_id': 'w1',
  'title': 'Kablo',
  'department_id': 'd1',
  'department_name': 'Altyapı',
  'status': status,
  'priority': priority,
  'start_on': '2026-09-01',
  'end_on': '2026-10-01',
  'planned_end_on': null,
  'completed_on': null,
  'created_by': _ayse,
  'assignees': [_ali],
  'is_overdue': true,
  'days_overdue': 5,
  'is_completed_late': false,
  'days_late': 0,
  'is_completed_early': false,
  'days_early': 0,
  'has_pending_dependency': true,
  'dependency_count': 1,
  'note_count': 2,
  'created_at': '2026-08-30T09:00:00Z',
};

Map<String, Object?> _meeting({String role = 'coordinator'}) => {
  'meeting_id': 'm1',
  'title': 'Haftalık',
  'meeting_date': '2026-10-10T10:00:00Z',
  'owner_department_id': 'd1',
  'coordinatorships': [
    {'department_id': 'd1', 'name': 'Altyapı', 'deleted': false},
  ],
  'created_by': _ayse,
  'created_by_role': role,
  'members_included': true,
  'participants': [_ali],
  'participant_count': 1,
  'note_count': 1,
};

Map<String, Object?> _stat() => {
  'department_id': 'd1',
  'name': 'Altyapı',
  'kind': 'calisma_grubu',
  'coordinators': [_ayse],
  'total_tasks': 3,
  'completed_tasks': 1,
  'in_progress_tasks': 1,
  'not_started_tasks': 1,
  'overdue_tasks': 0,
  'completion_rate': 33.3,
  'member_count': 4,
  'meeting_count': 1,
  'last_activity_at': '2026-10-20T10:00:00Z',
  'description': 'açıklama',
};

Map<String, Object?> _envelope(String code) => {
  'code': code,
  'message': 'x',
  'request_id': 'r',
};

Matcher _code(String code) =>
    throwsA(isA<ApiError>().having((e) => e.code, 'code', code));

void main() {
  group('dashboardTasks', () {
    test('GET → ReportTaskList (total sunucudan)', () async {
      final (repo, adapter) = _repo({
        'tasks': [_task()],
        'total': 250,
      });
      final r = await repo.dashboardTasks();
      expect(adapter.seen.single.uri.path, '/v1/reports/dashboard/tasks');
      expect(r.total, 250);
      expect(r.truncated, isFalse);
      final t = r.tasks.single;
      expect(t.workItemId, 'w1');
      expect(t.status, ReportTaskStatus.inProgress);
      expect(t.priority, ReportPriority.high);
      expect(t.startOn, DateTime(2026, 9));
      expect(t.endOn, DateTime(2026, 10));
      expect(t.plannedEndOn, isNull);
      expect(t.completedOn, isNull);
      expect(
        t.createdBy,
        const ReportPerson(accountId: 'a1', fullName: 'Ayşe Kaya'),
      );
      expect(t.assignees.single.fullName, 'Ali Veli');
      expect(t.isOverdue, isTrue);
      expect(t.daysOverdue, 5);
      expect(t.hasPendingDependency, isTrue);
      expect(t.dependencyCount, 1);
      expect(t.noteCount, 2);
      expect(t.createdAt, DateTime.utc(2026, 8, 30, 9));
    });

    test('X-Result-Truncated: true → kesilmiş', () async {
      final (repo, _) = _repo(
        {'tasks': <Object>[], 'total': 0},
        headers: {
          'X-Result-Truncated': ['true'],
        },
      );
      expect((await repo.dashboardTasks()).truncated, isTrue);
    });

    test('bilinmeyen durum ve öncelik → unknown', () async {
      final (repo, _) = _repo({
        'tasks': [_task(status: 'arsivlendi', priority: 'kritik')],
        'total': 1,
      });
      final t = (await repo.dashboardTasks()).tasks.single;
      expect(t.status, ReportTaskStatus.unknown);
      expect(t.priority, ReportPriority.unknown);
    });

    test('reporting.not_authorized → ApiError', () async {
      final (repo, _) = _repo(
        _envelope('reporting.not_authorized'),
        status: 403,
      );
      await expectLater(
        repo.dashboardTasks(),
        _code('reporting.not_authorized'),
      );
    });

    test('total eksik → client.invalid_response', () async {
      final (repo, _) = _repo({'tasks': <Object>[]});
      await expectLater(
        repo.dashboardTasks(),
        _code(ClientErrorCode.invalidResponse),
      );
    });
  });

  group('dashboardMeetings', () {
    test('GET → PageSlice<ReportMeeting>', () async {
      final (repo, adapter) = _repo({
        'meetings': [_meeting()],
      });
      final slice = await repo.dashboardMeetings();
      expect(adapter.seen.single.uri.path, '/v1/reports/dashboard/meetings');
      expect(slice.truncated, isFalse);
      final m = slice.items.single;
      expect(m.meetingId, 'm1');
      expect(m.meetingDate, DateTime.utc(2026, 10, 10, 10));
      expect(m.coordinatorships.single.deleted, isFalse);
      expect(m.createdByRole, ReportRole.coordinator);
      expect(m.membersIncluded, isTrue);
      expect(m.participants.single.accountId, 'a2');
      expect(m.participantCount, 1);
      expect(m.noteCount, 1);
    });

    test('kesilme ve bilinmeyen rol', () async {
      final (repo, _) = _repo(
        {
          'meetings': [_meeting(role: 'owner')],
        },
        headers: {
          'X-Result-Truncated': ['true'],
        },
      );
      final slice = await repo.dashboardMeetings();
      expect(slice.truncated, isTrue);
      expect(slice.items.single.createdByRole, ReportRole.unknown);
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(_envelope('program.not_found'), status: 404);
      await expectLater(repo.dashboardMeetings(), _code('program.not_found'));
    });
  });

  group('taskDetail', () {
    test('GET /v1/reports/tasks/{id} → ReportTaskDetail', () async {
      final (repo, adapter) = _repo({
        'task': _task(),
        'description': 'açıklama',
        'dependencies': [
          {
            'work_item_id': 'w0',
            'title': 'Önce',
            'status': 'tamamlandi',
            'department_name': 'Altyapı',
          },
          {
            'work_item_id': 'w9',
            'title': 'Belirsiz',
            'status': 'tuhaf',
            'department_name': 'Altyapı',
          },
        ],
        'recent_notes': [
          {
            'content': 'not',
            'author': _ali,
            'created_at': '2026-10-02T12:00:00Z',
          },
        ],
      });
      final d = await repo.taskDetail('w1');
      expect(adapter.seen.single.uri.path, '/v1/reports/tasks/w1');
      expect(d.task.workItemId, 'w1');
      expect(d.description, 'açıklama');
      expect(d.dependencies.first.status, ReportTaskStatus.completed);
      expect(d.dependencies.last.status, ReportTaskStatus.unknown);
      expect(d.recentNotes.single.author.fullName, 'Ali Veli');
      expect(d.recentNotes.single.createdAt, DateTime.utc(2026, 10, 2, 12));
    });

    test('reporting.not_found → ApiError', () async {
      final (repo, _) = _repo(_envelope('reporting.not_found'), status: 404);
      await expectLater(repo.taskDetail('x'), _code('reporting.not_found'));
    });
  });

  group('meetingDetail', () {
    test('GET /v1/reports/meetings/{id} → ReportMeetingDetail', () async {
      Map<String, Object?> note(String id, String role) => {
        'note_id': id,
        'content': 'c',
        'author': _ayse,
        'author_role': role,
        'created_at': '2026-10-10T11:00:00Z',
        'converted_to_task_id': id == 'n1' ? 'w5' : null,
        'converted_task_title': id == 'n1' ? 'Yeni görev' : null,
      };
      final (repo, adapter) = _repo({
        'meeting': _meeting(),
        'participants': [
          {'account_id': 'a2', 'full_name': 'Ali Veli', 'role': 'member'},
          {'account_id': 'a3', 'full_name': 'X', 'role': 'misafir'},
        ],
        'agenda': [
          {'title': 'Bütçe', 'is_checked': true},
        ],
        'notes': [note('n1', 'admin'), note('n2', ''), note('n3', 'gozlemci')],
      });
      final d = await repo.meetingDetail('m1');
      expect(adapter.seen.single.uri.path, '/v1/reports/meetings/m1');
      expect(d.meeting.title, 'Haftalık');
      expect(d.participants.first.role, ReportRole.member);
      expect(d.participants.last.role, ReportRole.unknown);
      expect(d.agenda.single.isChecked, isTrue);
      expect(d.notes[0].authorRole, ReportRole.admin);
      expect(d.notes[0].convertedToTaskId, 'w5');
      expect(d.notes[0].convertedTaskTitle, 'Yeni görev');
      expect(d.notes[1].authorRole, isNull, reason: 'boş dizge: rol kaydı yok');
      expect(d.notes[1].convertedToTaskId, isNull);
      expect(d.notes[2].authorRole, ReportRole.unknown);
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo(_envelope('reporting.not_found'), status: 404);
      await expectLater(repo.meetingDetail('m'), _code('reporting.not_found'));
    });
  });

  group('workload', () {
    test('GET /v1/reports/workload → WorkloadReport', () async {
      final (repo, adapter) = _repo({
        'program_id': 'p1',
        'program_name': 'Teknofest',
        'members': [
          {
            'account_id': 'a2',
            'full_name': 'Ali Veli',
            'coordinatorships': [
              {
                'department_id': 'd1',
                'name': 'Altyapı',
                'kind': 'koordinatorluk',
              },
              {'department_id': 'd2', 'name': 'Grup'},
            ],
            'tasks': [
              {
                'work_item_id': 'w1',
                'title': 'Kablo',
                'status': 'iade_edildi',
                'priority': 'orta',
                'start_on': '2026-09-01',
                'end_on': '2026-10-01',
                'completed_on': null,
                'department_id': 'd1',
                'department_name': 'Altyapı',
                'is_overdue': false,
                'days_overdue': 0,
                'attachment_count': 2,
                'has_attachment': true,
                'latest_note': 'son',
              },
              {
                'work_item_id': 'w2',
                'title': 'Boru',
                'status': '?',
                'priority': '?',
                'start_on': '2026-09-01',
                'end_on': '2026-10-01',
                'completed_on': '2026-09-20',
                'department_id': 'd1',
                'department_name': 'Altyapı',
                'is_overdue': false,
                'days_overdue': 0,
                'attachment_count': 0,
                'has_attachment': false,
              },
            ],
          },
        ],
        'coordinatorships': [
          {'department_id': 'd1', 'name': 'Altyapı', 'kind': 'yeni'},
        ],
        'total': 1,
        'generated_at': '2026-10-21T08:00:00Z',
      });
      final r = await repo.workload();
      expect(adapter.seen.single.uri.path, '/v1/reports/workload');
      expect(adapter.seen.single.method, 'GET');
      expect(r.programName, 'Teknofest');
      expect(r.total, 1);
      final m = r.members.single;
      expect(
        m.coordinatorships.first.kind,
        ReportDepartmentKind.coordinatorship,
      );
      expect(m.coordinatorships.last.kind, isNull);
      expect(m.tasks.first.status, ReportTaskStatus.returned);
      expect(m.tasks.first.priority, ReportPriority.medium);
      expect(m.tasks.first.attachmentCount, 2);
      expect(m.tasks.first.latestNote, 'son');
      expect(m.tasks.last.status, ReportTaskStatus.unknown);
      expect(m.tasks.last.priority, ReportPriority.unknown);
      expect(m.tasks.last.latestNote, isNull);
      expect(m.tasks.last.completedOn, DateTime(2026, 9, 20));
      expect(r.coordinatorships.single.kind, ReportDepartmentKind.unknown);
    });

    test('reporting.export_in_progress → ApiError (429)', () async {
      final (repo, _) = _repo(
        _envelope('reporting.export_in_progress'),
        status: 429,
      );
      await expectLater(
        repo.workload(),
        throwsA(
          isA<ApiError>()
              .having((e) => e.code, 'code', 'reporting.export_in_progress')
              .having((e) => e.status, 'status', 429),
        ),
      );
    });
  });

  group('season', () {
    Map<String, Object?> body() => {
      'program_id': 'p1',
      'program_name': 'Teknofest',
      'stats': {
        'total_tasks': 3,
        'completed_tasks': 1,
        'completion_rate': 33,
        'overdue_tasks': 0,
        'total_notes': 4,
        'total_attachments': 5,
        'total_meetings': 1,
        'total_messages': 7,
        'total_coordinatorships': 1,
        'total_users': 6,
        'total_members': 4,
      },
      'coordinatorship_performance': [_stat()],
      'task_status_distribution': {'tamamlandi': 1, 'x': 2},
      'priority_distribution': {'orta': 3},
      'tasks': [_task()],
      'meeting_stats': {
        'total_meetings': 1,
        'total_notes': 2,
        'converted_to_task': 1,
        'total_participants': 3,
      },
      'message_stats': {'total': 7, 'from_admins': 2, 'from_others': 5},
      'date_change_stats': {
        'total': 4,
        'approved': 1,
        'rejected': 1,
        'pending': 2,
      },
      'monthly_activity': [
        {
          'month': '2026-09',
          'created_tasks': 3,
          'completed_tasks': 1,
          'meetings': 1,
          'messages': 7,
          'count': 12,
        },
      ],
      'generated_at': '2026-10-21T08:00:00Z',
    };

    test('GET /v1/reports/season → SeasonReport', () async {
      final (repo, adapter) = _repo(body());
      final r = await repo.season();
      expect(adapter.seen.single.uri.path, '/v1/reports/season');
      expect(r.stats.completionRate, 33.0);
      expect(r.stats.totalMessages, 7);
      final c = r.coordinatorshipPerformance.single;
      expect(c.kind, ReportDepartmentKind.workingGroup);
      expect(c.coordinators.single.accountId, 'a1');
      expect(c.completionRate, 33.3);
      expect(c.lastActivityAt, DateTime.utc(2026, 10, 20, 10));
      expect(c.description, 'açıklama');
      expect(r.statusDistribution, {
        ReportTaskStatus.completed: 1,
        ReportTaskStatus.unknown: 2,
      });
      expect(r.priorityDistribution, {ReportPriority.medium: 3});
      expect(r.tasks.single.workItemId, 'w1');
      expect(r.meetingStats.convertedToTask, 1);
      expect(r.messageStats.fromOthers, 5);
      expect(r.dateChangeStats.pending, 2);
      expect(r.monthlyActivity.single.month, '2026-09');
      expect(r.monthlyActivity.single.count, 12);
      expect(r.generatedAt, DateTime.utc(2026, 10, 21, 8));
    });

    test('reporting.capacity_full → ApiError', () async {
      final (repo, _) = _repo(
        _envelope('reporting.capacity_full'),
        status: 503,
      );
      await expectLater(repo.season(), _code('reporting.capacity_full'));
    });
  });

  group('PDF hedefleri (ağ isteği yok)', () {
    test('görev, toplantı, dönem: GET yolları', () {
      final (repo, adapter) = _repo(const <String, Object?>{});
      final t = repo.taskPdf('w 1');
      expect(t.method, ReportDownloadMethod.get);
      expect(t.path, '/v1/reports/tasks/w%201/pdf');
      expect(t.body, isNull);
      expect(repo.meetingPdf('m1').path, '/v1/reports/meetings/m1/pdf');
      final s = repo.seasonPdf();
      expect(s.method, ReportDownloadMethod.get);
      expect(s.path, '/v1/reports/season/pdf');
      expect(adapter.seen, isEmpty);
    });

    test('iş yükü: POST gövdesi member_ids', () {
      final (repo, adapter) = _repo(const <String, Object?>{});
      final w = repo.workloadPdf(['a1', 'a2']);
      expect(w.method, ReportDownloadMethod.post);
      expect(w.path, '/v1/reports/workload');
      expect(w.body, {
        'member_ids': ['a1', 'a2'],
      });
      expect(repo.workloadPdf(const []).body, {'member_ids': <String>[]});
      expect(adapter.seen, isEmpty);
    });
  });
}
