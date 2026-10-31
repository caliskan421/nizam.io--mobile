// tasks sunucu kataloğu: uçlar paralel okunur ve TaskCatalog'a eşlenir — görev kodu sunucu
// kimliği, görünen kod departman kodu; not sayısı/oluşturan rapor listesinden; kişi rolleri ve
// koordinatörlük ekibi bu programın üyelik etiketlerinden; kullanıcılar imleçle; hata ApiError.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tasks/data/task_catalog_api_repository.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';

/// Yola (ve imlece) göre yanıt veren sahte uç.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.bodies, {this.statuses = const {}});

  final Map<String, Object> bodies;
  final Map<String, int> statuses;
  final List<RequestOptions> seen = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    final cursor = options.uri.queryParameters['cursor'];
    final path = options.uri.path;
    final key = cursor == null ? path : '$path?cursor=$cursor';
    return ResponseBody.fromString(
      jsonEncode(bodies[key]),
      statuses[path] ?? 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

ApiTaskCatalogRepository _repo(_Adapter adapter) => ApiTaskCatalogRepository(
  Dio(BaseOptions(baseUrl: 'https://api.test'))..httpClientAdapter = adapter,
  programId: () => 'p1',
  now: () => DateTime(2026, 11, 1, 15, 30),
);

const _lateness = {
  'is_overdue': true,
  'days_overdue': 4,
  'is_completed_late': false,
  'days_late': 0,
  'is_completed_early': false,
  'days_early': 0,
};

Map<String, Object> _bodies() => {
  '/v1/me': {
    'account_id': 'me',
    'email': 'a@b.test',
    'full_name': 'Ayşe Kaya',
    'company_admin': true,
  },
  '/v1/work-items/gantt/admin': {
    'tasks': [
      {
        'work_item_id': 'w1',
        'title': 'Kablo',
        'program_id': 'p1',
        'department_id': 'd1',
        'priority': 'yuksek',
        'status': 'devam_ediyor',
        'start_on': '2026-10-01',
        'end_on': '2026-10-28',
        'planned_end_on': '',
        'completed_on': '',
        'assignee_account_ids': ['u2'],
        'lateness': _lateness,
      },
      {
        'work_item_id': 'w2',
        'title': 'Boru',
        'program_id': 'p1',
        'department_id': 'd2',
        'priority': 'orta',
        'status': 'tamamlandi',
        'start_on': '2026-09-01',
        'end_on': '2026-09-10',
        'planned_end_on': '2026-09-08',
        'completed_on': '2026-09-10',
        'assignee_account_ids': <String>[],
        'lateness': {..._lateness, 'is_overdue': false, 'days_overdue': 0},
      },
    ],
    'links': <Object>[],
  },
  '/v1/reports/dashboard/tasks': {
    'tasks': [
      {
        'work_item_id': 'w1',
        'title': 'Kablo',
        'department_id': 'd1',
        'department_name': 'Altyapı',
        'status': 'devam_ediyor',
        'priority': 'yuksek',
        'start_on': '2026-10-01',
        'end_on': '2026-10-28',
        'planned_end_on': null,
        'completed_on': null,
        'created_by': {'account_id': 'me', 'full_name': 'Ayşe Kaya'},
        'assignees': <Object>[],
        'is_overdue': true,
        'days_overdue': 4,
        'is_completed_late': false,
        'days_late': 0,
        'is_completed_early': false,
        'days_early': 0,
        'has_pending_dependency': false,
        'dependency_count': 0,
        'note_count': 3,
        'created_at': '2026-09-20T08:00:00Z',
      },
    ],
    'total': 1,
  },
  '/v1/reports/dashboard/coordinatorships': {
    'coordinatorships': [
      for (final (id, name, lead) in [
        ('d1', 'Altyapı', 'u1'),
        ('d2', 'Fuar', null),
      ])
        {
          'department_id': id,
          'name': name,
          'kind': 'koordinatorluk',
          'coordinators': [
            if (lead != null) {'account_id': lead, 'full_name': 'Ali Avcı'},
          ],
          'total_tasks': 1,
          'completed_tasks': 0,
          'in_progress_tasks': 1,
          'not_started_tasks': 0,
          'overdue_tasks': 0,
          'completion_rate': 0.0,
          'member_count': 1,
          'meeting_count': 0,
          'last_activity_at': null,
        },
    ],
  },
  '/v1/departments': {
    'departments': [
      {
        'department_id': 'd1',
        'name': 'Altyapı',
        'kind': 'koordinatorluk',
        'code': 'ALT',
      },
      {'department_id': 'd2', 'name': 'Fuar', 'kind': 'koordinatorluk'},
    ],
  },
  '/v1/admin/users': {
    'users': [
      {
        'account_id': 'me',
        'full_name': 'Ayşe Kaya',
        'memberships': ['p1:d1:uye'],
      },
      {
        'account_id': 'u1',
        'full_name': 'Ali Avcı',
        'memberships': ['p1:d1:koordinator', 'p1:d2:koordinator'],
      },
    ],
    'next_cursor': 'c2',
  },
  '/v1/admin/users?cursor=c2': {
    'users': [
      {
        'account_id': 'u2',
        'full_name': 'Veli Can',
        // Başka programdaki koordinatörlük bu programda rol vermez.
        'memberships': ['p1:d1:uye', 'p9:d9:koordinator', 'bozuk'],
      },
    ],
  },
};

void main() {
  test('uçlar okunur; kullanıcılar imleç bitene kadar', () async {
    final adapter = _Adapter(_bodies());
    await _repo(adapter).load();
    final paths = adapter.seen.map((o) => o.uri.path).toList();
    expect(paths.where((p) => p == '/v1/admin/users'), hasLength(2));
    expect(
      paths.toSet(),
      _bodies().keys.where((k) => !k.contains('?')).toSet(),
    );
  });

  test(
    'görev: kimlik kod, departman kodu görünen kod, rapor alanları',
    () async {
      final c = await _repo(_Adapter(_bodies())).load();
      expect(c.today, DateTime(2026, 11));
      expect(c.me, 'me');
      final w1 = c.task('w1')!;
      expect(w1.id, 'w1');
      expect(w1.displayCode, 'ALT');
      expect(w1.coordinatorship, 'd1');
      expect(w1.departmentId, 'd1');
      expect(w1.programId, 'p1');
      expect(w1.title, 'Kablo');
      expect(w1.status, TaskStatus.inProgress);
      expect(w1.priority, TaskPriority.high);
      expect(w1.start, DateTime(2026, 10));
      expect(w1.due, DateTime(2026, 10, 28));
      expect(w1.plannedEnd, isNull);
      expect(w1.completedAt, isNull);
      expect(w1.assignees, ['u2']);
      expect(w1.overdueDays, 4);
      expect(w1.lateness!.isOverdue, isTrue);
      expect(w1.notes, 3);
      expect(w1.creator, 'me');
      expect(w1.createdAt, DateTime.utc(2026, 9, 20, 8));

      final w2 = c.task('w2')!;
      expect(w2.displayCode, 'w2', reason: 'departman kodu yoksa kimlik');
      expect(w2.status, TaskStatus.done);
      expect(w2.plannedEnd, DateTime(2026, 9, 8));
      expect(w2.completedAt, DateTime(2026, 9, 10));
      expect(w2.notes, 0, reason: 'rapor listesinde yok');
      expect(w2.creator, isNull);
    },
  );

  test('kişiler ve roller; koordinatörlük ekibi bu programdan', () async {
    final c = await _repo(_Adapter(_bodies())).load();
    expect(c.people.map((p) => p.id), ['me', 'u1', 'u2']);
    expect(c.person('me')!.role, PersonRole.admin);
    expect(c.person('u1')!.role, PersonRole.coordinator);
    expect(c.person('u2')!.role, PersonRole.member);
    expect(c.person('u2')!.name, 'Veli Can');

    expect(c.coordinatorships.map((k) => k.code), ['d1', 'd2']);
    final alt = c.coordinatorship('d1')!;
    expect(alt.name, 'Altyapı');
    expect(alt.leads, ['u1']);
    expect(alt.members, ['me', 'u2']);
    final fuar = c.coordinatorship('d2')!;
    expect(fuar.leads, ['u1'], reason: 'raporda olmayan koordinatör üyelikten');
    expect(fuar.members, isEmpty);
  });

  test('yetki yoksa sunucu hatası fırlar', () async {
    final adapter = _Adapter(
      {
        ..._bodies(),
        '/v1/work-items/gantt/admin': {
          'code': 'work.not_authorized',
          'message': 'work.not_authorized',
          'request_id': 'q1',
        },
      },
      statuses: {'/v1/work-items/gantt/admin': 403},
    );
    await expectLater(
      _repo(adapter).load(),
      throwsA(
        isA<ApiError>().having((e) => e.code, 'code', 'work.not_authorized'),
      ),
    );
  });
}
