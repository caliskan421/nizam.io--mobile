// tasks ayrıntısı (sunucu): alt görev, not ve dosya görevin KENDİ departmanıyla (açık
// departman) okunur; bekleyen tarih talebi göreve göre süzülür; dosya türü/etiketi ve alt
// görev kanıtı eşlenir; hata ApiError.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tasks/data/task_details_api_repository.dart';
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
  title: 'Hidrofor',
  coordinatorship: 'd1',
  departmentId: 'd1',
  status: TaskStatus.inProgress,
  priority: TaskPriority.medium,
  start: DateTime(2026, 7, 2),
  due: DateTime(2026, 9, 20),
  assignees: const [],
);

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
  'subtask_id': ?subtask,
};

Map<String, Object> _bodies() => {
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
        'author_account_id': 'u2',
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
  test(
    'S3 uçlar görevin departmanıyla; tarih talebi yalnız bekleyenler',
    () async {
      final adapter = _Adapter(_bodies());
      await _repo(adapter).load(_task);
      expect(
        adapter.seen.map((o) => o.uri.path).toSet(),
        _bodies().keys.toSet(),
      );
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
    },
  );

  test('alt görevler, notlar, dosyalar ve talep eşlenir', () async {
    final d = (await _repo(_Adapter(_bodies())).load(_task))!;
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
    expect(note.by, 'u2');
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

  test('bekleyen talep yoksa null', () async {
    final d = await _repo(
      _Adapter({
        ..._bodies(),
        '/v1/date-change-requests': {'requests': <Object>[], 'total': 0},
      }),
    ).load(_task);
    expect(d!.dateRequest, isNull);
  });

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
      _repo(adapter).load(_task),
      throwsA(
        isA<ApiError>().having((e) => e.code, 'code', 'work.not_assigned'),
      ),
    );
  });
}
