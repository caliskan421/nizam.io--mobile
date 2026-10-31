// tasks sunucu kataloğu: herkes için `GET /v1/work-items` departman başına (açık departman,
// imleçle); departmanlar seçili kapsamdan ya da ekip satırlarından, yöneticide ek olarak şirket
// listesinden (programa bağlı olmayan atlanır); rol /v1/me + /v1/me/departments'tan; WorkItem →
// TaskItem (kanıt bayrağı, alt görev sayıları, gecikme); yönetici rapor/kullanıcı/Gantt uçları
// çağrılmaz; hata ApiError.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tasks/data/task_catalog_api_repository.dart';
import 'package:nizamio/features/tasks/domain/task_access.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';

const _dept = 'nizamio.department';

/// Yol + açık departman + imlece göre yanıt veren sahte uç. Anahtar: `yol`,
/// `yol@departman`, `yol@departman?cursor=…` (en özelden genele aranır).
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
    final path = options.uri.path;
    final dept = options.extra[_dept];
    final cursor = options.uri.queryParameters['cursor'];
    final keys = [
      if (dept != null && cursor != null) '$path@$dept?cursor=$cursor',
      if (dept != null) '$path@$dept',
      path,
    ];
    final key = keys.firstWhere(bodies.containsKey, orElse: () => path);
    return ResponseBody.fromString(
      jsonEncode(bodies[key]),
      statuses[key] ?? 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

ApiTaskCatalogRepository _repo(_Adapter adapter, {String? department}) =>
    ApiTaskCatalogRepository(
      Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter,
      programId: () => 'p1',
      departmentId: () => department,
      now: () => DateTime(2026, 11, 1, 15, 30),
    );

Map<String, Object?> _item(
  String id,
  String dept, {
  bool evidence = false,
  int total = 0,
  int done = 0,
}) => {
  'work_item_id': id,
  'program_id': 'p1',
  'department_id': dept,
  'title': 'Görev $id',
  'priority': 'yuksek',
  'status': 'devam_ediyor',
  'assignee_account_ids': ['u2'],
  'is_overdue': true,
  'days_overdue': 4,
  'is_completed_late': false,
  'days_late': 0,
  'is_completed_early': false,
  'days_early': 0,
  'completion_evidence_required': evidence,
  'subtask_counts': {'total': total, 'done': done},
  'planned_end_on': '2026-10-20',
};

Map<String, Object> _me({bool admin = false}) => {
  'account_id': 'me',
  'email': 'a@b.test',
  'full_name': 'Ayşe Kaya',
  'company_admin': admin,
};

Map<String, Object> _seats(List<(String, String, String)> rows) => {
  'departments': [
    for (final (program, dept, role) in rows)
      {
        'program_id': program,
        'program_name': 'Program',
        'department_id': dept,
        'display_name': 'Ad $dept',
        'role': role,
      },
  ],
};

const _forbidden = {
  'code': 'work.not_authorized',
  'message': 'x',
  'request_id': 'q',
};

const _adminOnly = [
  '/v1/work-items/gantt/admin',
  '/v1/reports/dashboard/tasks',
  '/v1/reports/dashboard/coordinatorships',
  '/v1/admin/users',
];

void main() {
  test('üye: yalnız bu programdaki ekip satırının departmanı; imleçle tüm sayfalar', () async {
    final adapter = _Adapter({
      '/v1/me': _me(),
      '/v1/me/departments': _seats([
        ('p1', 'd1', 'uye'),
        ('p2', 'd9', 'koordinator'),
      ]),
      '/v1/work-items@d1': {
        'items': [_item('w1', 'd1', evidence: true, total: 3, done: 1)],
        'next_cursor': 'c2',
      },
      '/v1/work-items@d1?cursor=c2': {
        'items': [_item('w2', 'd1')],
      },
      for (final p in [..._adminOnly, '/v1/departments']) p: _forbidden,
    });
    final c = await _repo(adapter).load();

    expect(c.tasks.map((t) => t.id), ['w1', 'w2']);
    final lists = adapter.seen.where((o) => o.uri.path == '/v1/work-items');
    expect(lists.map((o) => o.extra[_dept]), ['d1', 'd1']);
    expect(lists.map((o) => o.uri.queryParameters['limit']), ['200', '200']);
    expect(adapter.seen.map((o) => o.uri.path).toSet(), {
      '/v1/me',
      '/v1/me/departments',
      '/v1/work-items',
    }, reason: 'yönetici uçları ve şirket departman listesi çağrılmaz');
    expect(c.access!.companyAdmin, isFalse);
    expect(c.access!.roleIn('p1', 'd1'), SeatRole.member);
    expect(c.people.single.role, PersonRole.member);
    expect(c.coordinatorships.single.code, 'd1');
    expect(c.coordinatorships.single.name, 'Ad d1');
  });

  test('WorkItem → TaskItem eşlemesi', () async {
    final c = await _repo(
      _Adapter({
        '/v1/me': _me(),
        '/v1/me/departments': _seats([('p1', 'd1', 'koordinator')]),
        '/v1/work-items@d1': {
          'items': [_item('w1', 'd1', evidence: true, total: 3, done: 1)],
        },
      }),
    ).load();
    final t = c.tasks.single;
    expect(t.id, 'w1');
    expect(t.code, 'w1');
    expect(t.departmentId, 'd1');
    expect(t.coordinatorship, 'd1');
    expect(t.programId, 'p1');
    expect(t.status, TaskStatus.inProgress);
    expect(t.priority, TaskPriority.high);
    expect(t.assignees, ['u2']);
    expect(t.evidenceRequired, isTrue);
    expect(t.subtaskCounts, (total: 3, done: 1));
    expect(t.subtaskTotal, 3);
    expect(t.subtaskDoneTotal, 1);
    expect(t.overdueDays, 4);
    expect(t.lateness!.isOverdue, isTrue);
    expect(t.plannedEnd, DateTime(2026, 10, 20));
    expect(t.files, 0, reason: 'liste dosya sayısı taşımaz');
    expect(c.today, DateTime(2026, 11));
    expect(c.me, 'me');
    expect(c.people.single.name, 'Ayşe Kaya');
    expect(c.people.single.role, PersonRole.coordinator);
  });

  test('kapsamda departman seçiliyse yalnız o departman okunur', () async {
    final adapter = _Adapter({
      '/v1/me': _me(admin: true),
      '/v1/me/departments': _seats([
        ('p1', 'd1', 'koordinator'),
        ('p1', 'd2', 'uye'),
      ]),
      '/v1/work-items@d2': {
        'items': [_item('w9', 'd2')],
      },
      '/v1/departments': _forbidden,
    });
    final c = await _repo(adapter, department: 'd2').load();
    expect(c.tasks.map((t) => t.id), ['w9']);
    expect(
      adapter.seen
          .where((o) => o.uri.path == '/v1/work-items')
          .map((o) => o.extra[_dept]),
      ['d2'],
    );
    expect(
      adapter.seen.map((o) => o.uri.path),
      isNot(contains('/v1/departments')),
    );
  });

  test('yönetici: ekip satırları + şirket departmanları; programda olmayan atlanır', () async {
    final adapter = _Adapter(
      {
        '/v1/me': _me(admin: true),
        '/v1/me/departments': _seats([('p1', 'd1', 'koordinator')]),
        '/v1/departments': {
          'departments': [
            {
              'department_id': 'd1',
              'name': 'Altyapı',
              'kind': 'x',
              'code': 'ALT',
            },
            {
              'department_id': 'd2',
              'name': 'Yazılım',
              'kind': 'x',
              'code': 'YZL',
            },
            {'department_id': 'd3', 'name': 'Dış', 'kind': 'x'},
          ],
        },
        '/v1/work-items@d1': {
          'items': [_item('w1', 'd1')],
        },
        '/v1/work-items@d2': {
          'items': [_item('w2', 'd2')],
        },
        '/v1/work-items@d3': {
          'code': 'work.program_scope_invalid',
          'message': 'x',
          'request_id': 'q',
        },
        for (final p in _adminOnly) p: _forbidden,
      },
      statuses: {'/v1/work-items@d3': 404},
    );
    final c = await _repo(adapter).load();
    expect(c.tasks.map((t) => (t.id, t.displayCode)), [
      ('w1', 'ALT'),
      ('w2', 'YZL'),
    ]);
    expect(c.coordinatorships.map((d) => (d.code, d.name)), [
      ('d1', 'Ad d1'),
      ('d2', 'Yazılım'),
    ], reason: 'programda olmayan departman koordinatörlük olarak görünmez');
    expect(c.people.single.role, PersonRole.admin);
    expect(c.access!.seesAllIn('p1', 'd2'), isTrue);
    for (final p in _adminOnly) {
      expect(adapter.seen.map((o) => o.uri.path), isNot(contains(p)));
    }
  });

  test('ekip satırının liste hatası atlanmaz: ApiError fırlar', () async {
    final adapter = _Adapter(
      {
        '/v1/me': _me(),
        '/v1/me/departments': _seats([('p1', 'd1', 'uye')]),
        '/v1/work-items@d1': {
          'code': 'work.program_scope_invalid',
          'message': 'x',
          'request_id': 'q',
        },
      },
      statuses: {'/v1/work-items@d1': 404},
    );
    await expectLater(
      _repo(adapter).load(),
      throwsA(
        isA<ApiError>().having(
          (e) => e.code,
          'code',
          'work.program_scope_invalid',
        ),
      ),
    );
  });

  test('ekip satırı yoksa (yönetici değil) liste boş, istek yok', () async {
    final adapter = _Adapter({
      '/v1/me': _me(),
      '/v1/me/departments': {'departments': null},
    });
    final c = await _repo(adapter).load();
    expect(c.tasks, isEmpty);
    expect(c.coordinatorships, isEmpty);
    expect(
      adapter.seen.map((o) => o.uri.path),
      isNot(contains('/v1/work-items')),
    );
  });
}
