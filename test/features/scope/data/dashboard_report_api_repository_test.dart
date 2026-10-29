// scope reporting panosu: DashboardReport DTO → domain, koordinatörlük listesi kesilmesi,
// bilinmeyen anahtar/tür → unknown, hata → ApiError.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/scope/data/dashboard_report_api_repository.dart';
import 'package:nizamio/features/scope/domain/home_dashboard.dart';
import 'package:nizamio/features/scope/domain/home_dashboard_report.dart';

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

(ApiDashboardReportRepository, _Adapter) _repo(
  Object body, {
  int status = 200,
  Map<String, List<String>> headers = const {},
}) {
  final adapter = _Adapter(
    body is String ? body : jsonEncode(body),
    status,
    headers,
  );
  return (
    ApiDashboardReportRepository(
      Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter,
    ),
    adapter,
  );
}

Map<String, Object?> _stat({String kind = 'koordinatorluk'}) => {
  'department_id': 'd1',
  'name': 'Altyapı',
  'kind': kind,
  'coordinators': [
    {'account_id': 'a1', 'full_name': 'Ayşe Kaya'},
  ],
  'total_tasks': 10,
  'completed_tasks': 4,
  'in_progress_tasks': 3,
  'not_started_tasks': 1,
  'overdue_tasks': 2,
  'completion_rate': 40.0,
  'member_count': 5,
  'meeting_count': 2,
  'last_activity_at': '2026-10-20T10:00:00Z',
};

Map<String, Object?> _dashboard() => {
  'program_id': 'p1',
  'program_name': 'Teknofest',
  'total_coordinatorships': 1,
  'total_tasks': 10,
  'active_tasks': 6,
  'completed_tasks': 4,
  'overdue_tasks': 2,
  'pending_approvals': 1,
  'pending_date_changes': 3,
  'task_status_distribution': {
    'baslanmadi': 1,
    'devam_ediyor': 3,
    'onaya_sunuldu': 1,
    'iade_edildi': 1,
    'tamamlandi': 4,
    'yeni_durum': 2,
    'baska': 1,
  },
  'priority_distribution': {'dusuk': 2, 'acil': 1, 'kritik': 7},
  'total_users': 9,
  'total_admins': 1,
  'total_coordinators': 2,
  'total_members': 6,
  'deleted_records': 0,
  'coordinatorship_stats': [_stat()],
  'overdue_tasks_list': [
    {
      'work_item_id': 'w1',
      'title': 'Kablo',
      'department_id': 'd1',
      'department_name': 'Altyapı',
      'assignees': [
        {'account_id': 'a2', 'full_name': 'Ali Veli'},
      ],
      'due_on': '2026-10-01',
      'days_overdue': 5,
    },
  ],
  'generated_at': '2026-10-21T08:00:00Z',
};

Matcher _code(String code) =>
    throwsA(isA<ApiError>().having((e) => e.code, 'code', code));

void main() {
  group('load', () {
    test('GET /v1/reports/dashboard → DashboardReport', () async {
      final (repo, adapter) = _repo(_dashboard());
      final r = await repo.load();
      expect(adapter.seen.single.uri.path, '/v1/reports/dashboard');
      expect(r.programId, 'p1');
      expect(r.programName, 'Teknofest');
      expect(r.totalCoordinatorships, 1);
      expect(r.tasks.total, 10);
      expect(r.tasks.done, 4);
      expect(r.tasks.inProgress, 3, reason: 'devam_ediyor sayısı');
      expect(r.tasks.inProgressOnTime, isNull);
      expect(r.tasks.late, 2);
      expect(r.tasks.awaitingApproval, 1);
      expect(r.activeTasks, 6);
      expect(r.pendingDateChanges, 3);
      expect(r.team.admins, 1);
      expect(r.team.coordinators, 2);
      expect(r.team.members, 6);
      expect(r.team.users, 9);
      expect(r.deletedRecords, 0);
      expect(r.generatedAt, DateTime.utc(2026, 10, 21, 8));
      final o = r.overdueTasks.single;
      expect(o.workItemId, 'w1');
      expect(o.assignees.single.fullName, 'Ali Veli');
      expect(o.dueOn, DateTime(2026, 10, 1));
      expect(o.daysOverdue, 5);
      final c = r.coordinatorships.single;
      expect(c.code, 'd1');
      expect(c.name, 'Altyapı');
      expect(c.leads, ['Ayşe Kaya']);
      expect(c.leadAccountIds, ['a1']);
      expect(c.todo, 1);
      expect(c.inProgress, 3);
      expect(c.inReview, 2, reason: '10 − 4 − 3 − 1');
      expect(c.done, 4);
      expect(c.late, 2);
      expect(c.total, 10);
      expect(c.kind, CoordinatorshipKind.coordinatorship);
      expect(c.completionRate, 40.0);
      expect(c.memberCount, 5);
      expect(c.meetingCount, 2);
      expect(c.lastActivityAt, DateTime.utc(2026, 10, 20, 10));
      expect(c.description, isNull);
    });

    test('dağılım: tanınmayan anahtarlar unknown altında toplanır', () async {
      final (repo, _) = _repo(_dashboard());
      final r = await repo.load();
      expect(r.statusDistribution, {
        DashboardTaskStatus.notStarted: 1,
        DashboardTaskStatus.inProgress: 3,
        DashboardTaskStatus.submitted: 1,
        DashboardTaskStatus.returned: 1,
        DashboardTaskStatus.completed: 4,
        DashboardTaskStatus.unknown: 3,
      });
      expect(r.priorityDistribution, {
        DashboardTaskPriority.low: 2,
        DashboardTaskPriority.urgent: 1,
        DashboardTaskPriority.unknown: 7,
      });
    });

    test('devam_ediyor yoksa inProgress 0', () async {
      final body = _dashboard()..['task_status_distribution'] = {};
      final (repo, _) = _repo(body);
      expect((await repo.load()).tasks.inProgress, 0);
    });

    test('bilinmeyen tür → unknown; kalan negatifse inReview 0', () async {
      final stat = _stat(kind: 'yeni_tur')
        ..['total_tasks'] = 1
        ..['last_activity_at'] = null;
      final body = _dashboard()..['coordinatorship_stats'] = [stat];
      final (repo, _) = _repo(body);
      final c = (await repo.load()).coordinatorships.single;
      expect(c.kind, CoordinatorshipKind.unknown);
      expect(c.inReview, 0);
      expect(c.total, 1, reason: 'sunucu toplamı');
      expect(c.lastActivityAt, isNull);
    });

    test('reporting.not_authorized → ApiError', () async {
      final (repo, _) = _repo({
        'code': 'reporting.not_authorized',
        'message': 'x',
        'request_id': 'r',
      }, status: 403);
      await expectLater(repo.load(), _code('reporting.not_authorized'));
    });

    test('eksik zorunlu alan → client.invalid_response', () async {
      final (repo, _) = _repo(_dashboard()..remove('total_tasks'));
      await expectLater(repo.load(), _code(ClientErrorCode.invalidResponse));
    });
  });

  group('coordinatorships', () {
    test('GET …/coordinatorships → CoordinatorshipSummary listesi', () async {
      final (repo, adapter) = _repo({
        'coordinatorships': [_stat()],
      });
      final slice = await repo.coordinatorships();
      expect(
        adapter.seen.single.uri.path,
        '/v1/reports/dashboard/coordinatorships',
      );
      expect(slice.items.single.code, 'd1');
      expect(slice.truncated, isFalse);
      expect(slice.hasMore, isFalse);
    });

    test('X-Result-Truncated: true → kesilmiş', () async {
      final (repo, _) = _repo(
        {
          'coordinatorships': [_stat()],
        },
        headers: {
          'X-Result-Truncated': ['true'],
        },
      );
      expect((await repo.coordinatorships()).truncated, isTrue);
    });

    test('başlık değeri true değilse kesilmiş sayılmaz', () async {
      final (repo, _) = _repo(
        {'coordinatorships': <Object>[]},
        headers: {
          'X-Result-Truncated': ['1'],
        },
      );
      expect((await repo.coordinatorships()).truncated, isFalse);
    });

    test('hata → ApiError', () async {
      final (repo, _) = _repo({
        'code': 'program.not_found',
        'message': 'x',
        'request_id': 'r',
      }, status: 404);
      await expectLater(repo.coordinatorships(), _code('program.not_found'));
    });
  });
}
