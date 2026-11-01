// tasks ayrıntısı (sunucu): tekil görev (getWorkItem: açıklama, tarihler, adlar), alt görev,
// not ve dosya görevin KENDİ departmanıyla (açık departman) okunur; kişi adları (null → girmez)
// ad dizinine; tarih talebi role göre (yönetici inceleme kuyruğu, koordinatör kendi
// talepleri, üye çağrı yok) ve göreve göre süzülür; dosya türü/etiketi ve alt görevin bağlı
// dosyası eşlenir; hata ApiError.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tasks/data/task_details_api_repository.dart';
import 'package:nizamio/features/tasks/domain/task_access.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';

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
    return ResponseBody.fromString(
      jsonEncode(bodies[path]),
      statuses[path] ?? 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

ApiTaskDetailsRepository _repo(_Adapter adapter) => ApiTaskDetailsRepository(
  Dio(BaseOptions(baseUrl: 'https://api.test'))..httpClientAdapter = adapter,
);

final _task = TaskItem(
  code: 'w1',
  shortCode: 'ALT',
  title: 'Hidrofor',
  coordinatorship: 'd1',
  departmentId: 'd1',
  programId: 'p1',
  status: TaskStatus.inProgress,
  priority: TaskPriority.medium,
  start: DateTime(2026, 7, 2),
  due: DateTime(2026, 9, 20),
  assignees: const [],
);

TaskAccess _access({bool admin = false, SeatRole? role}) => TaskAccess(
  accountId: 'me',
  companyAdmin: admin,
  seats: [
    if (role != null)
      TeamSeat(
        programId: 'p1',
        departmentId: 'd1',
        departmentName: 'Altyapı',
        role: role,
      ),
  ],
);

final _admin = _access(admin: true);

Map<String, Object> _request(String id, String item, String status) => {
  'request_id': id,
  'work_item_id': item,
  'status': status,
  'old_start_on': '2026-07-02',
  'new_start_on': '2026-07-02',
  'old_end_on': '2026-09-20',
  'new_end_on': '2026-11-10',
};

/// Yetkisiz uç: çağrılırsa 403 (rol seçiminin yanlış uca gitmediğinin kanıtı).
const _forbidden = {
  'code': 'work.not_authorized',
  'message': 'x',
  'request_id': 'q',
};

Map<String, Object> _file(
  String id,
  String name,
  String type,
  String tag, {
  String? subtask,
}) => {
  'file_id': id,
  'work_item_id': 'w1',
  'display_name': name,
  'content_type': type,
  'size_bytes': 1500,
  'tag': tag,
  'uploaded_by_account_id': 'u1',
  'uploaded_by_full_name': 'Ufuk Bir',
  'subtask_id': ?subtask,
};

Map<String, Object?> _detail() => {
  'work_item_id': 'w1',
  'program_id': 'p1',
  'department_id': 'd1',
  'title': 'Hidrofor (güncel)',
  'priority': 'acil',
  'status': 'onaya_sunuldu',
  'assignee_account_ids': ['u2', 'u3'],
  'assignees': [
    {'account_id': 'u2', 'full_name': 'Ali Veli'},
    {'account_id': 'u3', 'full_name': null},
  ],
  'start_on': '2026-07-04',
  'end_on': '2026-09-25',
  'is_overdue': true,
  'days_overdue': 6,
  'is_completed_late': false,
  'days_late': 0,
  'is_completed_early': false,
  'days_early': 0,
  'completion_evidence_required': true,
  'subtask_counts': {'total': 2, 'done': 1},
  'description': 'Pompa odasının kurulumu',
};

Map<String, Object> _bodies() => {
  '/v1/work-items/w1': _detail(),
  '/v1/work-items/w1/subtasks': {
    'subtasks': [
      {
        'subtask_id': 's1',
        'work_item_id': 'w1',
        'title': 'Pompa',
        'done': true,
        'created_by_account_id': 'u1',
        'created_at': '2026-07-02T08:00:00Z',
        'updated_at': '2026-07-03T08:00:00Z',
        'assignee_account_id': 'u2',
        'start_on': '2026-07-02',
        'end_on': '2026-07-10',
        'done_by_account_id': 'u4',
        'done_by_full_name': 'Deniz Kapatan',
        'created_by_full_name': 'Ufuk Bir',
        'assignee_full_name': 'Ali Veli',
      },
      {
        'subtask_id': 's2',
        'work_item_id': 'w1',
        'title': 'Test',
        'done': false,
        'created_by_account_id': 'u1',
        'created_at': '2026-07-02T08:00:00Z',
        'updated_at': '2026-07-02T08:00:00Z',
      },
    ],
    'total': 2,
  },
  '/v1/work-items/w1/notes': {
    'notes': [
      {
        'note_id': 'n1',
        'work_item_id': 'w1',
        'author_account_id': 'u5',
        'author_full_name': null,
        'content': 'Pompa geldi',
        'created_at': '2026-07-05T09:00:00Z',
        'updated_at': '2026-07-05T09:00:00Z',
      },
    ],
    'total': 1,
  },
  '/v1/work-items/w1/files': {
    'files': [
      _file('f1', 'Tutanak.pdf', 'application/pdf', 'cikti', subtask: 's1'),
      _file('f2', 'saha.jpg', 'image/jpeg', 'girdi'),
      _file('f3', 'plan.xlsx', 'application/vnd.ms-excel', 'yeni_etiket'),
    ],
  },
  '/v1/date-change-requests': {
    'requests': [
      {
        'request_id': 'r0',
        'work_item_id': 'baska',
        'status': 'pending',
        'old_start_on': '2026-07-02',
        'new_start_on': '2026-07-02',
        'old_end_on': '2026-09-20',
        'new_end_on': '2026-12-01',
      },
      {
        'request_id': 'r1',
        'work_item_id': 'w1',
        'status': 'pending',
        'old_start_on': '2026-07-02',
        'new_start_on': '2026-07-02',
        'old_end_on': '2026-09-20',
        'new_end_on': '2026-11-10',
        'reason': 'Gecikme',
      },
    ],
    'total': 2,
  },
};

void main() {
  test('yönetici: S3 uçlar görevin departmanıyla; tarih talebi inceleme kuyruğundan (bekleyen)', () async {
    final adapter = _Adapter(_bodies());
    await _repo(adapter).load(_task, access: _admin);
    expect(adapter.seen.map((o) => o.uri.path).toSet(), _bodies().keys.toSet());
    for (final o in adapter.seen) {
      final s3 = o.uri.path.startsWith('/v1/work-items/');
      expect(
        o.extra.values.contains('d1'),
        s3,
        reason: '${o.uri.path}: açık departman yalnız S3 uçlarda',
      );
    }
    final dcr = adapter.seen.singleWhere(
      (o) => o.uri.path == '/v1/date-change-requests',
    );
    expect(dcr.uri.queryParameters['status'], 'pending');
  });

  test('alt görevler, notlar, dosyalar ve talep eşlenir', () async {
    final d = (await _repo(_Adapter(_bodies())).load(_task, access: _admin))!;
    final [pompa, test] = d.subtasks;
    expect(pompa.id, 's1');
    expect(pompa.title, 'Pompa');
    expect(pompa.done, isTrue);
    expect(pompa.assignee, 'u2');
    expect(pompa.start, DateTime(2026, 7, 2));
    expect(pompa.end, DateTime(2026, 7, 10));
    expect(pompa.evidence, 'Tutanak.pdf', reason: 'alt göreve bağlı dosya');
    expect(test.done, isFalse);
    expect(test.assignee, isNull);
    expect(test.evidence, isNull);

    final note = d.notes.single;
    expect(note.id, 'n1');
    expect(note.by, 'u5');
    expect(note.text, 'Pompa geldi');
    expect(note.at, DateTime.utc(2026, 7, 5, 9));

    final [pdf, img, other] = d.files;
    expect(pdf.kind, TaskFileKind.pdf);
    expect(pdf.tag, EvidenceTag.output);
    expect(pdf.subtask, 's1');
    expect(pdf.by, 'u1');
    expect(pdf.sizeKb, 2, reason: 'yukarı yuvarlanır');
    expect(img.kind, TaskFileKind.image);
    expect(img.tag, EvidenceTag.input);
    expect(other.kind, TaskFileKind.doc);
    expect(other.tag, EvidenceTag.unknown);

    final r = d.dateRequest!;
    expect(r.id, 'r1');
    expect(r.oldDue, DateTime(2026, 9, 20));
    expect(r.due, DateTime(2026, 11, 10));
    expect(r.reason, 'Gecikme');
    expect(r.isPending, isTrue);
  });

  test('getWorkItem: görevin kendisi (tarih, açıklama, durum, sunucu gecikmesi) ve kişi adları; '
      'null ad dizine girmez', () async {
    final adapter = _Adapter(_bodies());
    final d = (await _repo(adapter).load(_task, access: _admin))!;
    final get = adapter.seen.singleWhere(
      (o) => o.uri.path == '/v1/work-items/w1',
    );
    expect(get.method, 'GET');
    expect(get.extra.values, contains('d1'), reason: 'görevin departmanı');

    final item = d.item!;
    expect(item.id, 'w1');
    expect(item.shortCode, 'ALT', reason: 'kısa anahtar katalogdaki görevden');
    expect(item.title, 'Hidrofor (güncel)');
    expect(item.status, TaskStatus.review);
    expect(item.priority, TaskPriority.urgent);
    expect(item.start, DateTime(2026, 7, 4));
    expect(item.due, DateTime(2026, 9, 25));
    expect(item.description, 'Pompa odasının kurulumu');
    expect(item.assignees, ['u2', 'u3']);
    expect(item.overdueDays, 6, reason: 'gecikme sunucudan');
    expect(item.evidenceRequired, isTrue);
    expect(item.subtaskCounts, (total: 2, done: 1));

    expect(d.subtasks.first.doneBy, 'u4');
    expect(d.subtasks.first.createdBy, 'u1');
    final names = {for (final n in d.names) n.id: n.name};
    expect(names, {'u2': 'Ali Veli', 'u4': 'Deniz Kapatan', 'u1': 'Ufuk Bir'});
    expect(
      names.containsKey('u3') || names.containsKey('u5'),
      isFalse,
      reason: 'null atanan / not yazarı adı dizine girmez',
    );
  });

  test('bekleyen talep yoksa null', () async {
    final d = await _repo(
      _Adapter({
        ..._bodies(),
        '/v1/date-change-requests': {'requests': <Object>[], 'total': 0},
      }),
    ).load(_task, access: _admin);
    expect(d!.dateRequest, isNull);
  });

  test('koordinatör: kendi talepleri görevin departmanıyla; bekleyen önce, yoksa son', () async {
    final adapter = _Adapter(
      {
        ..._bodies(),
        '/v1/date-change-requests': _forbidden,
        '/v1/date-change-requests/mine': {
          'requests': [
            _request('r0', 'baska', 'pending'),
            _request('r1', 'w1', 'rejected'),
            _request('r2', 'w1', 'pending'),
          ],
          'total': 3,
        },
      },
      statuses: {'/v1/date-change-requests': 403},
    );
    final d = await _repo(adapter)
        .load(_task, access: _access(role: SeatRole.coordinator));
    expect(d!.dateRequest!.id, 'r2');
    final mine = adapter.seen.singleWhere(
      (o) => o.uri.path == '/v1/date-change-requests/mine',
    );
    expect(mine.extra.values, contains('d1'));
    expect(
      adapter.seen.map((o) => o.uri.path),
      isNot(contains('/v1/date-change-requests')),
    );

    final settled = await _repo(
      _Adapter({
        ..._bodies(),
        '/v1/date-change-requests/mine': {
          'requests': [_request('r1', 'w1', 'rejected')],
          'total': 1,
        },
      }),
    ).load(_task, access: _access(role: SeatRole.coordinator));
    expect(settled!.dateRequest!.state, DateRequestState.rejected);
  });

  test(
    'üye ve erişimi bilinmeyen: tarih talebi çağrılmaz, ayrıntı yine kurulur',
    () async {
      for (final access in [_access(role: SeatRole.member), null]) {
        final adapter = _Adapter(
          {
            ..._bodies(),
            '/v1/date-change-requests': _forbidden,
            '/v1/date-change-requests/mine': _forbidden,
          },
          statuses: {
            '/v1/date-change-requests': 403,
            '/v1/date-change-requests/mine': 403,
          },
        );
        final d = await _repo(adapter).load(_task, access: access);
        expect(d!.subtasks, hasLength(2));
        expect(d.dateRequest, isNull);
        expect(
          adapter.seen.where(
            (o) => o.uri.path.startsWith('/v1/date-change-requests'),
          ),
          isEmpty,
        );
      }
    },
  );

  test('uç hatası ApiError olarak fırlar', () async {
    final adapter = _Adapter(
      {
        ..._bodies(),
        '/v1/work-items/w1/notes': {
          'code': 'work.not_assigned',
          'message': 'work.not_assigned',
          'request_id': 'q1',
        },
      },
      statuses: {'/v1/work-items/w1/notes': 403},
    );
    await expectLater(
      _repo(adapter).load(_task, access: _admin),
      throwsA(
        isA<ApiError>().having((e) => e.code, 'code', 'work.not_assigned'),
      ),
    );
  });
}
