// scope ana sayfa özeti (sunucu): beş uç paralel okunur ve HomeDashboard'a eşlenir —
// karşılama /v1/me'den, bekleyen işler tarih talepleri + onaya sunulan görevlerden, zamanında
// ilerleyen sayısı görev listesinden (kesikse null); bir uç hata verirse ApiError fırlar.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/scope/data/home_dashboard_api_repository.dart';
import 'package:nizamio/features/scope/domain/home_dashboard.dart';

/// Yola göre yanıt veren sahte uç; [statuses] yol başına durum kodunu ezer.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.bodies, {this.statuses = const {}, this.headers = const {}});

  final Map<String, Object> bodies;
  final Map<String, int> statuses;
  final Map<String, Map<String, List<String>>> headers;
  final List<RequestOptions> seen = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    final path = options.uri.path;
    return ResponseBody.fromString(
      jsonEncode(bodies[path]),
      statuses[path] ?? 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        ...?headers[path],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

ApiHomeDashboardRepository _repo(_Adapter adapter) =>
    ApiHomeDashboardRepository(
      Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter,
    );

Map<String, Object?> _task(
  String id,
  String title,
  String status, {
  bool overdue = false,
}) => {
  'work_item_id': id,
  'title': title,
  'department_id': 'd1',
  'department_name': 'Altyapı',
  'status': status,
  'priority': 'orta',
  'start_on': '2026-10-01',
  'end_on': '2026-11-01',
  'planned_end_on': null,
  'completed_on': null,
  'created_by': {'account_id': 'a1', 'full_name': 'Ayşe Kaya'},
  'assignees': <Object>[],
  'is_overdue': overdue,
  'days_overdue': overdue ? 3 : 0,
  'is_completed_late': false,
  'days_late': 0,
  'is_completed_early': false,
  'days_early': 0,
  'has_pending_dependency': false,
  'dependency_count': 0,
  'note_count': 0,
  'created_at': '2026-09-01T08:00:00Z',
};

Map<String, Object> _bodies({bool admin = true}) => {
  '/v1/me': {
    'account_id': 'me1',
    'email': 'ayse@nizam.local',
    'full_name': 'Ayşe Kaya',
    'company_admin': admin,
  },
  '/v1/reports/dashboard': {
    'program_id': 'p1',
    'program_name': 'Teknofest',
    'total_coordinatorships': 1,
    'total_tasks': 10,
    'active_tasks': 6,
    'completed_tasks': 4,
    'overdue_tasks': 2,
    'pending_approvals': 1,
    'pending_date_changes': 2,
    'task_status_distribution': {
      'baslanmadi': 1,
      'devam_ediyor': 3,
      'onaya_sunuldu': 1,
      'iade_edildi': 1,
      'tamamlandi': 4,
    },
    'priority_distribution': {'orta': 10},
    'total_users': 9,
    'total_admins': 1,
    'total_coordinators': 2,
    'total_members': 6,
    'deleted_records': 0,
    'coordinatorship_stats': [
      {
        'department_id': 'd1',
        'name': 'Altyapı',
        'kind': 'koordinatorluk',
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
        'last_activity_at': null,
      },
    ],
    'overdue_tasks_list': <Object>[],
    'generated_at': '2026-10-21T08:00:00Z',
  },
  '/v1/reports/dashboard/tasks': {
    'tasks': [
      _task('w1', 'Kablo', 'devam_ediyor'),
      _task('w2', 'Boru', 'devam_ediyor', overdue: true),
      _task('w3', 'Pano', 'devam_ediyor'),
      _task('w4', 'Rapor', 'onaya_sunuldu'),
      _task('w5', 'Hidrofor', 'baslanmadi'),
    ],
    'total': 5,
  },
  '/v1/date-change-requests': {
    'requests': [
      {
        'request_id': 'r1',
        'work_item_id': 'w5',
        'status': 'pending',
        'old_start_on': '2026-10-01',
        'new_start_on': '2026-10-01',
        'old_end_on': '2026-11-01',
        'new_end_on': '2026-11-11',
        'reason': 'Gecikme',
      },
      {
        'request_id': 'r2',
        'work_item_id': 'w2',
        'status': 'pending',
        'old_start_on': '2026-10-01',
        'new_start_on': '2026-10-05',
        'old_end_on': '2026-11-01',
        'new_end_on': '2026-11-01',
      },
      {
        'request_id': 'r3',
        'work_item_id': 'listede-yok',
        'status': 'pending',
        'old_start_on': '2026-10-01',
        'new_start_on': '2026-10-01',
        'old_end_on': '2026-11-01',
        'new_end_on': '2026-11-02',
      },
    ],
    'total': 3,
  },
  '/v1/messages/unread-count': {'count': 7},
};

void main() {
  test('beş uç okunur, tarih talebi yalnız bekleyenler', () async {
    final adapter = _Adapter(_bodies());
    await _repo(adapter).load();
    expect(adapter.seen.map((o) => o.uri.path).toSet(), _bodies().keys.toSet());
    final dcr = adapter.seen.singleWhere(
      (o) => o.uri.path == '/v1/date-change-requests',
    );
    expect(dcr.uri.queryParameters['status'], 'pending');
  });

  test('karşılama, sayılar ve rozetler', () async {
    final d = await _repo(_Adapter(_bodies())).load();
    expect(d.greetingName, 'Ayşe Kaya');
    expect(d.greetingEmail, 'ayse@nizam.local');
    expect(d.greetingRole, TeamRole.admin);
    expect(d.demoProgramName, isNull);
    expect(d.lastActivity, isNull, reason: 'işlem geçmişi ucu yok');
    expect(d.tasks.total, 10);
    expect(d.tasks.done, 4);
    expect(d.tasks.inProgress, 3);
    expect(d.tasks.inProgressOnTime, 2, reason: 'devam eden ve gecikmemiş');
    expect(d.tasks.late, 2);
    expect(d.tasks.awaitingApproval, 1);
    expect(d.team.users, 9);
    expect(d.coordinatorships.single.code, 'd1');
    expect(d.coordinatorships.single.leads, ['Ayşe Kaya']);
    expect(d.counts.unreadMessages, 7);
    expect(d.counts.pendingRequests, 2);
    expect(d.counts.lateTasks, 2);
    expect(d.counts.tasksAwaitingApproval, 1);
  });

  test('yönetici olmayan hesapta rol bilinmiyor', () async {
    final d = await _repo(_Adapter(_bodies(admin: false))).load();
    expect(d.greetingRole, isNull);
  });

  test(
    'bekleyen işler: tarih talepleri (görev adıyla), sonra onaylar',
    () async {
      final d = await _repo(_Adapter(_bodies())).load();
      expect(d.pending, hasLength(3), reason: 'listede olmayan görev atlanır');
      final [shift, startOnly, approval] = d.pending;
      expect(shift.taskCode, 'w5');
      expect(shift.title, 'Hidrofor');
      expect(shift.label, 'Altyapı', reason: 'kimlik yerine departman adı');
      expect(shift.kind, PendingKind.dateChange);
      expect(shift.requestedShiftDays, 10);
      expect(shift.requestedDate, DateTime(2026, 11, 11));
      expect(startOnly.taskCode, 'w2');
      expect(startOnly.requestedShiftDays, isNull, reason: 'bitiş değişmedi');
      expect(approval.taskCode, 'w4');
      expect(approval.title, 'Rapor');
      expect(approval.kind, PendingKind.approval);
    },
  );

  test('kesik görev listesinde zamanında sayısı bilinmiyor', () async {
    final adapter = _Adapter(
      _bodies(),
      headers: {
        '/v1/reports/dashboard/tasks': {
          'X-Result-Truncated': ['true'],
        },
      },
    );
    final d = await _repo(adapter).load();
    expect(d.tasks.inProgressOnTime, isNull);
  });

  test('pano yetkisi yoksa sunucu hatası fırlar', () async {
    final adapter = _Adapter(
      {
        ..._bodies(admin: false),
        '/v1/reports/dashboard': {
          'code': 'reporting.not_authorized',
          'message': 'reporting.not_authorized',
          'request_id': 'q1',
        },
      },
      statuses: {'/v1/reports/dashboard': 403},
    );
    await expectLater(
      _repo(adapter).load(),
      throwsA(
        isA<ApiError>().having(
          (e) => e.code,
          'code',
          'reporting.not_authorized',
        ),
      ),
    );
  });
}
