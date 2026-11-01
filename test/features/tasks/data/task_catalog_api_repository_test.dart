// tasks sunucu kataloğu (istemci akışları §2, v0.7.0-api): görev listesi bütün roller için
// program bağlamında TEK `GET /v1/program/work-items` akışı (S2; yalnız `X-Nizamio-Program`,
// departman başlığı YOK), imleçle bütün sayfalar (sayfa 200; imleç tekrarında durur).
// Departman süzgeci sunucuda (`department_id`); seçenekler yöneticide
// `GET /v1/program/departments` (kesilme başlığı → bayrak), diğerlerinde bu programdaki ekip
// satırları. Fan-out yok; 404 `work.program_scope_invalid` → süzgeç temizlenir. Rol
// /v1/me + /v1/me/departments'tan; WorkItem → TaskItem (tarihler, adlar); hata ApiError.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/http/interceptors.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/server/server_address.dart';
import 'package:nizamio/features/tasks/data/task_catalog_api_repository.dart';
import 'package:nizamio/features/tasks/domain/task_access.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';

const _url = 'https://api.test';
const _list = '/v1/program/work-items';

/// Yol + süzgeç + imlece göre yanıt veren sahte uç. Anahtar: `yol`, `yol?department_id=…`,
/// `yol?cursor=…`, `yol?department_id=…&cursor=…` (en özelden genele aranır).
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
    final q = options.uri.queryParameters;
    final dept = q['department_id'];
    final cursor = q['cursor'];
    final keys = [
      if (dept != null && cursor != null)
        '$path?department_id=$dept&cursor=$cursor',
      if (dept != null) '$path?department_id=$dept',
      if (cursor != null) '$path?cursor=$cursor',
      path,
    ];
    final key = keys.firstWhere(bodies.containsKey, orElse: () => path);
    return ResponseBody.fromString(
      jsonEncode(bodies[key]),
      statuses[key] ?? 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        ...?headers[key],
      },
    );
  }

  @override
  void close({bool force = false}) {}

  Iterable<RequestOptions> get lists => seen.where((o) => o.uri.path == _list);
}

/// Gerçek sözleşme kapısı (ApiGuardInterceptor) ile: kapsamda bir departman SEÇİLİ olsa da
/// liste isteği departman başlığı taşımamalı.
ApiTaskCatalogRepository _repo(_Adapter adapter) {
  final scope = ScopeController()
    ..selectProgram('p1')
    ..selectDepartment('dKapsam');
  final dio = Dio(BaseOptions(baseUrl: _url))
    ..httpClientAdapter = adapter
    ..interceptors.add(
      ApiGuardInterceptor(
        server: ServerAddress.parse(_url, Flavor.prod),
        flavor: Flavor.prod,
        scope: scope,
      ),
    );
  return ApiTaskCatalogRepository(
    dio,
    programId: () => 'p1',
    now: () => DateTime(2026, 11, 1, 15, 30),
  );
}

Map<String, Object> _page(List<Object> items, [String? next]) => {
  'items': items,
  'next_cursor': ?next,
};

Map<String, Object?> _item(
  String id,
  String dept, {
  bool evidence = false,
  int total = 0,
  int done = 0,
  String? name = 'Ali Veli',
}) => {
  'work_item_id': id,
  'program_id': 'p1',
  'department_id': dept,
  'title': 'Görev $id',
  'priority': 'yuksek',
  'status': 'devam_ediyor',
  'assignee_account_ids': ['u2'],
  'assignees': [
    {'account_id': 'u2', 'full_name': name},
  ],
  'start_on': '2026-10-05',
  'end_on': '2026-10-18',
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

Map<String, Object> _programDepartments(List<(String, String, String?)> rows) =>
    {
      'departments': [
        for (final (id, name, code) in rows)
          {'department_id': id, 'display_name': name, 'code': ?code},
      ],
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
  test('üye: tek liste ucu (program bağlamı), departman başlığı yok, imleçle bütün sayfalar '
      '(sayfa 200); fan-out ve yönetici uçları yok', () async {
    final adapter = _Adapter({
      '/v1/me': _me(),
      '/v1/me/departments': _seats([
        ('p2', 'd9', 'koordinator'),
        ('p1', 'd1', 'uye'),
        ('p1', 'd2', 'koordinator'),
      ]),
      _list: _page([
        _item('w1', 'd1', evidence: true, total: 3, done: 1),
      ], 'c2'),
      '$_list?cursor=c2': _page([_item('w2', 'd2')]),
      for (final p in [..._adminOnly, '/v1/departments', '/v1/work-items'])
        p: _forbidden,
    });
    final c = await _repo(adapter).load();

    expect(c.tasks.map((t) => t.id), ['w1', 'w2']);
    expect(adapter.lists, hasLength(2));
    for (final o in adapter.lists) {
      expect(o.headers['X-Nizamio-Program'], 'p1');
      expect(
        o.headers.containsKey('X-Nizamio-Department'),
        isFalse,
        reason: 'S2: departman başlığı gönderilmez (kapsamda seçili olsa da)',
      );
      expect(o.uri.queryParameters['limit'], '200');
      expect(o.uri.queryParameters.containsKey('department_id'), isFalse);
    }
    expect(adapter.lists.map((o) => o.uri.queryParameters['cursor']), [
      null,
      'c2',
    ]);
    expect(adapter.seen.map((o) => o.uri.path).toSet(), {
      '/v1/me',
      '/v1/me/departments',
      _list,
    }, reason: 'departman başına liste yok; yönetici/şirket uçları yok');
    expect(c.access!.roleIn('p1', 'd1'), SeatRole.member);
    expect(c.people.single.role, PersonRole.coordinator);
    expect(c.departmentId, isNull, reason: 'süzgeç yok');
    expect(c.departmentFilterCleared, isFalse);
    expect(c.departments.map((d) => d.id), ['d1', 'd2']);
    expect(c.coordinatorships.map((d) => d.code), ['d1', 'd2']);
    expect(c.tasks.map((t) => t.displayCode), ['Ad d1', 'Ad d2']);
  });

  test('WorkItem → TaskItem eşlemesi', () async {
    final c = await _repo(
      _Adapter({
        '/v1/me': _me(),
        '/v1/me/departments': _seats([('p1', 'd1', 'koordinator')]),
        _list: _page([_item('w1', 'd1', evidence: true, total: 3, done: 1)]),
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
    expect(t.plannedEnd, DateTime(2026, 10, 20));
    expect(t.start, DateTime(2026, 10, 5), reason: 'start_on');
    expect(t.due, DateTime(2026, 10, 18), reason: 'end_on');
    expect(t.overdueDays, 4, reason: 'gecikme sunucudan');
    expect(t.lateness!.isOverdue, isTrue);
    expect(t.description, isNull, reason: 'açıklama yalnız tekil okumada');
    expect(c.nameOf('u2'), 'Ali Veli', reason: 'assignees[].full_name');
    expect(t.files, 0, reason: 'liste dosya sayısı taşımaz');
    expect(c.today, DateTime(2026, 11));
    expect(c.me, 'me');
    expect(c.people.single.name, 'Ayşe Kaya');
  });

  test('departman süzgeci sunucuya department_id olarak gider (her sayfada); süzme '
      'telefonda yapılmaz', () async {
    final adapter = _Adapter({
      '/v1/me': _me(),
      '/v1/me/departments': _seats([
        ('p1', 'd1', 'koordinator'),
        ('p1', 'd2', 'uye'),
      ]),
      '$_list?department_id=d2': _page([_item('w9', 'd2')], 'k'),
      // Sunucu ne dönerse o: başka departmanın satırı istemcide elenmez.
      '$_list?department_id=d2&cursor=k': _page([_item('w10', 'd1')]),
    });
    final c = await _repo(adapter).load(departmentId: 'd2');
    expect(c.tasks.map((t) => t.id), ['w9', 'w10']);
    expect(adapter.lists.map((o) => o.uri.queryParameters['department_id']), [
      'd2',
      'd2',
    ]);
    expect(adapter.lists.map((o) => o.headers['X-Nizamio-Department']), [
      null,
      null,
    ]);
    expect(c.departmentId, 'd2');
    expect(c.departmentFilterCleared, isFalse);
  });

  test('boş süzgeç → süzgeç yok', () async {
    final adapter = _Adapter({
      '/v1/me': _me(),
      '/v1/me/departments': _seats([('p1', 'd1', 'uye')]),
      _list: _page([]),
    });
    final c = await _repo(adapter).load(departmentId: '');
    expect(
      adapter.lists.single.uri.queryParameters.containsKey('department_id'),
      isFalse,
    );
    expect(c.departmentId, isNull);
    expect(c.departmentFilterCleared, isFalse);
  });

  test('404 work.program_scope_invalid (süzgeç departmanı silinmiş/bağsız) → süzgeç '
      'temizlenir, liste süzgeçsiz okunur, bilgi bayrağı', () async {
    final adapter = _Adapter(
      {
        '/v1/me': _me(admin: true),
        '/v1/me/departments': {'departments': null},
        '/v1/program/departments': _programDepartments([
          ('d1', 'Altyapı', 'ALT'),
          ('d5', 'Bilişim', null),
        ]),
        '$_list?department_id=d5': {
          'code': 'work.program_scope_invalid',
          'message': 'x',
          'request_id': 'q',
        },
        _list: _page([_item('w1', 'd1')]),
      },
      statuses: {'$_list?department_id=d5': 404},
    );
    final c = await _repo(adapter).load(departmentId: 'd5');
    expect(adapter.lists.map((o) => o.uri.queryParameters['department_id']), [
      'd5',
      null,
    ]);
    expect(c.departmentId, isNull);
    expect(c.departmentFilterCleared, isTrue);
    expect(c.tasks.single.id, 'w1');
  });

  test('süzgeç seçenekler arasında değil (kesik olmayan liste) → gönderilmez, temizlenir', () async {
    final adapter = _Adapter({
      '/v1/me': _me(),
      '/v1/me/departments': _seats([('p1', 'd1', 'uye')]),
      _list: _page([_item('w1', 'd1')]),
    });
    final c = await _repo(adapter).load(departmentId: 'eski');
    expect(
      adapter.lists.single.uri.queryParameters.containsKey('department_id'),
      isFalse,
    );
    expect(c.departmentId, isNull);
    expect(c.departmentFilterCleared, isTrue);
  });

  test('süzgeçsiz 404 (programda ekip satırı yok) ve 403 atlanmaz: ApiError fırlar', () async {
    for (final (status, code) in [
      (404, 'work.program_scope_invalid'),
      (403, 'organization.membership_required'),
    ]) {
      final adapter = _Adapter(
        {
          '/v1/me': _me(),
          '/v1/me/departments': {'departments': null},
          _list: {'code': code, 'message': 'x', 'request_id': 'q'},
        },
        statuses: {_list: status},
      );
      await expectLater(
        _repo(adapter).load(),
        throwsA(isA<ApiError>().having((e) => e.code, 'code', code)),
      );
      expect(adapter.lists, hasLength(1), reason: 'yeniden deneme yok');
    }
  });

  test('yönetici: seçenekler listProgramDepartments; tek liste akışı (ekip satırından '
      'bağımsız), kısa anahtar kod yoksa ad', () async {
    final adapter = _Adapter({
      '/v1/me': _me(admin: true),
      '/v1/me/departments': _seats([('p1', 'd2', 'koordinator')]),
      '/v1/program/departments': _programDepartments([
        ('d5', 'Altyapı', 'ALT'),
        ('d2', 'Bilişim', null),
        ('d7', 'Saha', 'SAH'),
      ]),
      _list: _page([_item('w5', 'd5'), _item('w2', 'd2'), _item('w7', 'd7')]),
    });
    final c = await _repo(adapter).load();
    expect(adapter.seen.map((o) => o.uri.path), [
      '/v1/me',
      '/v1/me/departments',
      '/v1/program/departments',
      _list,
    ]);
    expect(c.departmentId, isNull);
    expect(c.departments.map((d) => d.label), ['ALT', 'Bilişim', 'SAH']);
    expect(c.departmentsTruncated, isFalse);
    expect(c.tasks.map((t) => t.displayCode), ['ALT', 'Bilişim', 'SAH']);
    expect(c.coordinatorships.map((d) => d.name), [
      'Altyapı',
      'Bilişim',
      'Saha',
    ]);
    expect(c.people.single.role, PersonRole.admin);
  });

  test('yönetici: X-Result-Truncated → kesik bayrağı; kesik listede görünmeyen süzgeç '
      'sunucuya gider', () async {
    final adapter = _Adapter(
      {
        '/v1/me': _me(admin: true),
        '/v1/me/departments': {'departments': null},
        '/v1/program/departments': _programDepartments([
          ('d1', 'Altyapı', 'ALT'),
        ]),
        '$_list?department_id=d900': _page([_item('w9', 'd900')]),
      },
      headers: {
        '/v1/program/departments': {
          'X-Result-Truncated': ['true'],
        },
      },
    );
    final c = await _repo(adapter).load(departmentId: 'd900');
    expect(c.departmentsTruncated, isTrue);
    expect(c.departmentId, 'd900');
    expect(c.departmentFilterCleared, isFalse);
    expect(
      c.tasks.single.displayCode,
      'd900',
      reason: 'ad bilinmiyor → kimlik',
    );
  });

  test('üye/koordinatör listProgramDepartments çağırmaz; seçenekler bu programdaki ekip '
      'satırları', () async {
    final adapter = _Adapter({
      '/v1/me': _me(),
      '/v1/me/departments': _seats([
        ('p1', 'd1', 'koordinator'),
        ('p1', 'd2', 'uye'),
        ('p2', 'd9', 'uye'),
      ]),
      _list: _page([]),
    });
    final c = await _repo(adapter).load();
    expect(
      adapter.seen.map((o) => o.uri.path),
      isNot(contains('/v1/program/departments')),
    );
    expect(c.departments.map((d) => d.id), ['d1', 'd2']);
  });

  test('atanan adı null → ad dizinine girmez (arayüz nötr etiket)', () async {
    final c = await _repo(
      _Adapter({
        '/v1/me': _me(),
        '/v1/me/departments': _seats([('p1', 'd1', 'koordinator')]),
        _list: _page([_item('w1', 'd1', name: null)]),
      }),
    ).load();
    expect(c.tasks.single.assignees, ['u2']);
    expect(c.nameOf('u2'), isNull);
    expect(c.nameOf('me'), 'Ayşe Kaya');
  });

  test(
    'imleç tekrarında durur (sonsuz döngü yok), kesilme sessiz değil',
    () async {
      final adapter = _Adapter({
        '/v1/me': _me(),
        '/v1/me/departments': _seats([('p1', 'd1', 'uye')]),
        _list: _page([_item('w1', 'd1')], 'c'),
        '$_list?cursor=c': _page([_item('w2', 'd1')], 'c'),
      });
      final c = await _repo(adapter).load();
      expect(
        adapter.lists,
        hasLength(2),
        reason: 'aynı imleç ikinci kez istenmez',
      );
      expect(c.truncated, isTrue);
      expect(c.tasks.map((t) => t.id), ['w1', 'w2']);

      final whole = await _repo(
        _Adapter({
          '/v1/me': _me(),
          '/v1/me/departments': _seats([('p1', 'd1', 'uye')]),
          _list: _page([_item('w1', 'd1')]),
        }),
      ).load();
      expect(whole.truncated, isFalse);
    },
  );
}
