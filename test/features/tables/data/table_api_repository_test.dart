// tables data katmanı: alan → rota + kapsam (S3 program+departman, S2 program), DTO →
// domain (bilinmeyen sütun tipi atlanır, hücre/referans/redaksiyon), komut gövdesi
// (kind ayırıcı, boş hücre null olarak gider, expected_schema), işlem anahtarı başlığı,
// changes/comments/presence, SSE çerçeveleri, hata zarfı → ApiError.
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/tables/data/table_api_repository.dart';
import 'package:nizamio/features/tables/domain/table_models.dart';
import 'package:nizamio/features/tables/domain/table_operation.dart';

/// Yol → (durum, gövde) ya da SSE akışı; istekler ve JSON gövdeleri kaydedilir.
class _Http implements HttpClientAdapter {
  _Http(this.routes);
  final Map<String, Object> routes;
  final seen = <RequestOptions>[];
  final bodies = <Object?>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    if (requestStream != null) {
      final bytes = await requestStream.expand((c) => c).toList();
      bodies.add(bytes.isEmpty ? null : jsonDecode(utf8.decode(bytes)));
    } else {
      bodies.add(null);
    }
    final r = routes['${options.method} ${options.uri.path}'];
    if (r is Stream<Uint8List>) {
      return ResponseBody(
        r,
        200,
        headers: {
          Headers.contentTypeHeader: ['text/event-stream'],
        },
      );
    }
    final (status, body) = r is (int, Object?) ? r : (404, null);
    return ResponseBody.fromString(
      body == null ? '' : jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiTablesRepository, _Http) _repo(Map<String, Object> routes) {
  final a = _Http(routes);
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = a;
  return (ApiTablesRepository(() => dio), a);
}

const _coord = TableScope.coordinatorship(programId: 'p1', departmentId: 'd1');
const _personal = TableScope.personal(programId: 'p1');

Map<String, Object?> _table(String id, {String space = 'coordinatorship'}) => {
  'id': id,
  'owner_id': 'a1',
  'name': 'Plan',
  'program_id': 'p1',
  'department_id': space == 'personal' ? '' : 'd1',
  'space': space,
  'schema_version': 3,
  'sequence': 41,
  'team_role': 'viewer',
  'is_template': false,
};

Map<String, Object?> _receipt({Object? cells}) => {
  'table_id': 't1',
  'sequence': 42,
  'schema_version': 3,
  'replayed': false,
  'id': 'x1',
  'cells': ?cells,
};

String _env(String code, {List<Object?>? fields}) => jsonEncode({
  'code': code,
  'message': 'x',
  'request_id': 'r',
  'fields': ?fields,
});

Matcher _apiError(String code) =>
    throwsA(isA<ApiError>().having((e) => e.code, 'code', code));

Stream<Uint8List> _sse(List<String> chunks) => Stream.fromIterable([
  for (final c in chunks) Uint8List.fromList(utf8.encode(c)),
]);

void main() {
  group('kapsam ve rota', () {
    test('koordinatörlük listesi S3: program + departman sabitlenir', () async {
      final (repo, http) = _repo({
        'GET /v1/tables': (
          200,
          {
            'items': [_table('t1')],
            'next_cursor': 'c2',
          },
        ),
      });
      final page = await repo.list(_coord, page: const PageRequest(limit: 50));
      final o = http.seen.single;
      expect(o.queryParameters['limit'], 50);
      expect(o.extra['nizamio.program'], 'p1');
      expect(o.extra['nizamio.department'], 'd1');
      expect(page.nextCursor, 'c2');
      final t = page.items.single;
      expect(t.scope, _coord);
      expect(t.schemaVersion, 3);
      expect(t.sequence, 41);
      expect(t.teamRole, TableTeamRole.viewer);
      expect(t.ownedBy('a1'), isTrue);
      expect(t.ownedBy('a2'), isFalse);
    });

    test('kişisel liste S2: yalnız program, /v1/personal rotası', () async {
      final (repo, http) = _repo({
        'GET /v1/personal/tables': (
          200,
          {
            'items': [_table('t2', space: 'personal')],
          },
        ),
      });
      final page = await repo.list(_personal, template: false);
      final o = http.seen.single;
      expect(o.extra['nizamio.program'], 'p1');
      expect(o.extra.containsKey('nizamio.department'), isFalse);
      expect(o.uri.queryParameters['template'], 'false');
      expect(page.items.single.scope, _personal);
      expect(page.hasMore, isFalse);
    });

    test(
      'oluşturma: Idempotency-Key başlığı ve create_table gövdesi',
      () async {
        final (repo, http) = _repo({
          'POST /v1/personal/tables': (201, _receipt()),
        });
        final r = await repo.create(_personal, 'Yeni', requestKey: 'k' * 22);
        expect(http.seen.single.headers['Idempotency-Key'], 'k' * 22);
        expect(http.bodies.single, {'name': 'Yeni', 'kind': 'create_table'});
        expect(r.id, 'x1');
        expect(r.sequence, 42);
      },
    );
  });

  group('snapshot', () {
    test(
      'sütun/satır/hücre/referans/ek eşlemesi; bilinmeyen tip atlanır',
      () async {
        final (repo, _) = _repo({
          'GET /v1/tables/t1': (
            200,
            {
              'table': _table('t1'),
              'columns': [
                {
                  'id': 'c2',
                  'name': 'Sayı',
                  'type': 'number',
                  'width': 120,
                  'position': 2,
                  'multiple': false,
                },
                {
                  'id': 'c1',
                  'name': 'Ad',
                  'type': 'text',
                  'width': 200,
                  'position': 1,
                  'multiple': false,
                },
                {
                  'id': 'c3',
                  'name': 'Kişi',
                  'type': 'person_reference',
                  'width': 200,
                  'position': 3,
                  'multiple': true,
                },
                {
                  'id': 'c4',
                  'name': 'Yeni',
                  'type': 'gelecek_tip',
                  'width': 200,
                  'position': 4,
                  'multiple': false,
                },
              ],
              'rows': [
                {'id': 'r1', 'position': 1048576},
              ],
              'cells': [
                {
                  'row_id': 'r1',
                  'column_id': 'c1',
                  'value': 'Merhaba',
                  'version': 2,
                },
                {'row_id': 'r1', 'column_id': 'c2', 'value': 1.5, 'version': 1},
                {
                  'row_id': 'r1',
                  'column_id': 'c3',
                  'value': ['u1', null],
                  'version': 4,
                  'redacted': true,
                },
              ],
              'references': {
                'people': {'u1': 'Ayşe'},
                'bilinmeyen': {'x': 'y'},
              },
              'attachments': {
                'f1': {
                  'id': 'f1',
                  'name': 'a.pdf',
                  'content_type': 'application/pdf',
                  'size_bytes': 10,
                },
              },
              'next_cursor': '2097152',
            },
          ),
        });
        final s = await repo.snapshot(_coord, 't1');
        expect(s.columns.map((c) => c.id), ['c1', 'c2', 'c3']);
        expect(s.columns.last.kind, TableColumnKind.personReference);
        expect(s.columns.last.multiple, isTrue);
        expect(s.cells[TableCellKey('r1', 'c1')]!.value, 'Merhaba');
        expect(s.cells[TableCellKey('r1', 'c1')]!.version, 2);
        expect(s.cells[TableCellKey('r1', 'c2')]!.value, 1.5);
        final ref = s.cells[TableCellKey('r1', 'c3')]!;
        expect(ref.value, ['u1', null]);
        expect(ref.redacted, isTrue);
        expect(s.references[TableRefKey(TableRefKind.people, 'u1')], 'Ayşe');
        expect(s.references.length, 1);
        expect(s.attachments[const TableAttachmentId('f1')]!.name, 'a.pdf');
        expect(s.nextCursor, '2097152');
      },
    );

    test(
      'nesne hücre değeri şemaya aykırı → client.invalid_response',
      () async {
        final (repo, _) = _repo({
          'GET /v1/tables/t1': (
            200,
            {
              'table': _table('t1'),
              'columns': <Object?>[],
              'rows': <Object?>[],
              'cells': [
                {
                  'row_id': 'r1',
                  'column_id': 'c1',
                  'value': {'a': 1},
                  'version': 1,
                },
              ],
            },
          ),
        });
        expect(
          repo.snapshot(_coord, 't1'),
          _apiError(ClientErrorCode.invalidResponse),
        );
      },
    );
  });

  group('komutlar', () {
    test('set_cells: sürüm + boş hücre null olarak gider; makbuz yeni sürümleri taşır', () async {
      final (repo, http) = _repo({
        'POST /v1/tables/t1/operations': (
          200,
          _receipt(
            cells: [
              {'row_id': 'r1', 'column_id': 'c1', 'value': null, 'version': 3},
              {'row_id': 'r1', 'column_id': 'c2', 'value': null, 'version': 1},
            ],
          ),
        ),
      });
      final r = await repo.apply(
        _coord,
        't1',
        SetCells(const [
          TableCellWrite(rowId: 'r1', columnId: 'c1', value: 'x', version: 2),
          TableCellWrite(rowId: 'r1', columnId: 'c2', value: null, version: 0),
        ]),
        requestKey: 'k' * 22,
      );
      expect(http.bodies.single, {
        'kind': 'set_cells',
        'cells': [
          {'row_id': 'r1', 'column_id': 'c1', 'value': 'x', 'version': 2},
          {'row_id': 'r1', 'column_id': 'c2', 'value': null, 'version': 0},
        ],
      });
      expect(http.seen.single.headers['Idempotency-Key'], 'k' * 22);
      expect(r.cellVersions[TableCellKey('r1', 'c1')], 3);
      expect(r.cellVersions[TableCellKey('r1', 'c2')], 1);
    });

    test('sütun komutları expected_schema taşır; kişisel rota', () async {
      final (repo, http) = _repo({
        'POST /v1/personal/tables/t1/operations': (200, _receipt()),
      });
      await repo.apply(
        _personal,
        't1',
        const AddColumn(
          name: 'Tarih',
          kind: TableColumnKind.date,
          width: 160,
          expectedSchema: 3,
        ),
        requestKey: 'k' * 22,
      );
      await repo.apply(
        _personal,
        't1',
        const MoveColumn(id: 'c1', expectedSchema: 4),
        requestKey: 'j' * 22,
      );
      await repo.apply(
        _personal,
        't1',
        const SetTeamRole(null),
        requestKey: 'm' * 22,
      );
      expect(http.bodies[0], {
        'kind': 'add_column',
        'name': 'Tarih',
        'type': 'date',
        'width': 160,
        'expected_schema': 3,
        'multiple': false,
      });
      expect(http.bodies[1], {
        'kind': 'move_column',
        'id': 'c1',
        'expected_schema': 4,
      });
      expect(http.bodies[2], {'kind': 'set_team_role', 'role': 'none'});
    });

    test('undo makbuzu: atlanan hücreler eşlenir', () async {
      final (repo, _) = _repo({
        'POST /v1/tables/t1/operations': (
          200,
          {
            ..._receipt(),
            'skipped': [
              {'row_id': 'r1', 'column_id': 'c1', 'reason': 'changed'},
            ],
          },
        ),
      });
      final r = await repo.apply(
        _coord,
        't1',
        const UndoCells(40),
        requestKey: 'k' * 22,
      );
      expect(r.skipped.single.reason, TableUndoSkipReason.changed);
    });

    test('409 cell_conflict zarfı ApiError olur', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = _Raw(409, _env('tables.cell_conflict'));
      final repo = ApiTablesRepository(() => dio);
      expect(
        repo.apply(_coord, 't1', const AddRow(), requestKey: 'k' * 22),
        _apiError('tables.cell_conflict'),
      );
    });

    test('bağ yoksa istek gönderilmez', () {
      final repo = ApiTablesRepository(() => null);
      expect(repo.list(_coord), _apiError(ClientErrorCode.serverNotVerified));
    });
  });

  group('canlı yüz', () {
    test('changes: after zorunlu, sayfa eşlemesi, bilinmeyen tür', () async {
      final (repo, http) = _repo({
        'GET /v1/tables/t1/changes': (
          200,
          {
            'table_id': 't1',
            'changes': [
              {'table_id': 't1', 'seq': 42, 'kind': 'set_cells'},
              {'table_id': 't1', 'seq': 43, 'kind': 'yeni_tur'},
            ],
            'cursor': 43,
            'sequence': 50,
            'more': true,
          },
        ),
      });
      final c = await repo.changes(_coord, 't1', after: 41, limit: 200);
      expect(http.seen.single.queryParameters['after'], '41');
      expect(c.changes.map((e) => e.kind), [
        TableChangeKind.setCells,
        TableChangeKind.unknown,
      ]);
      expect(c.cursor, 43);
      expect(c.sequence, 50);
      expect(c.more, isTrue);
    });

    test('changes 409 replay_expired nedeni fields[0].message', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = _Raw(
          409,
          _env(
            'tables.replay_expired',
            fields: [
              {
                'field': 'after',
                'code': 'tables.replay_expired',
                'message': 'window',
              },
            ],
          ),
        );
      final repo = ApiTablesRepository(() => dio);
      await expectLater(
        repo.changes(_coord, 't1', after: 1),
        throwsA(
          isA<ApiError>().having(
            (e) => e.fields.single.message,
            'neden',
            'window',
          ),
        ),
      );
    });

    test('comments: yazar görünmezse null; imleç', () async {
      final (repo, http) = _repo({
        'GET /v1/tables/t1/comments': (
          200,
          {
            'items': [
              {
                'id': 'm1',
                'row_id': 'r1',
                'column_id': null,
                'author': {'id': 'a2', 'name': 'Ali'},
                'mine': false,
                'body': 'Not',
                'seq': 7,
                'created_at': '2026-11-13T10:00:00Z',
                'edited_at': null,
              },
              {
                'id': 'm2',
                'row_id': 'r1',
                'column_id': 'c1',
                'author': null,
                'mine': true,
                'body': 'B',
                'seq': 9,
                'created_at': '2026-11-13T10:01:00Z',
                'edited_at': null,
              },
            ],
            'next_cursor': '9',
          },
        ),
      });
      final p = await repo.comments(_coord, 't1', rowId: 'r1');
      expect(http.seen.single.queryParameters['row_id'], 'r1');
      expect(p.items.first.authorName, 'Ali');
      expect(p.items.last.authorId, isNull);
      expect(p.items.last.mine, isTrue);
      expect(p.nextCursor, '9');
    });

    test('presence: seçim gövdesi, anahtar yok; ayrılma DELETE', () async {
      final (repo, http) = _repo({
        'POST /v1/tables/t1/presence': (204, null),
        'DELETE /v1/tables/t1/presence': (204, null),
      });
      await repo.setPresence(_coord, 't1', rowId: 'r1', columnId: 'c1');
      await repo.leavePresence(_coord, 't1');
      expect(http.bodies.first, {'row_id': 'r1', 'column_id': 'c1'});
      expect(http.seen.first.headers.containsKey('Idempotency-Key'), isFalse);
      expect(http.seen.last.method, 'DELETE');
    });

    test('akış: ready/changed/presence çerçeveleri, ping ve bilinmeyen olay atlanır', () async {
      final (repo, http) = _repo({
        'GET /v1/personal/tables/t1/stream': _sse([
          'event: ready\ndata: {"table_id":"t1","sequence":57}\n\n',
          ': ping\n\n',
          'event: changed\ndata: {"table_id":"t1","sequence":58}\n\n',
          'event: gelecek\ndata: {}\n\n',
          'event: presence\ndata: {"table_id":"t1","participants":[{"key":"k1","account_id":"a2","name":"Ali","row_id":"","column_id":""}]}\n\n',
        ]),
      });
      final events = await repo.stream(_personal, 't1').toList();
      expect((events[0] as TableStreamReady).sequence, 57);
      expect((events[1] as TableStreamChanged).sequence, 58);
      final p = (events[2] as TablePresenceUpdate).participants.single;
      expect(p.name, 'Ali');
      expect(p.rowId, isNull);
      expect(events, hasLength(3));
      final o = http.seen.single;
      expect(o.responseType, ResponseType.stream);
      expect(o.headers['Accept'], 'text/event-stream');
      expect(o.extra['openapi'], isA<Map<Object?, Object?>>());
      expect(o.extra['nizamio.program'], 'p1');
    });

    test('akış: şemaya aykırı çerçeve client.invalid_response', () async {
      final (repo, _) = _repo({
        'GET /v1/tables/t1/stream': _sse([
          'event: changed\ndata: {"table_id":"t1"}\n\n',
        ]),
      });
      expect(
        repo.stream(_coord, 't1').toList(),
        _apiError(ClientErrorCode.invalidResponse),
      );
    });
  });
}

/// Her isteğe aynı ham yanıt.
class _Raw implements HttpClientAdapter {
  _Raw(this.status, this.body);
  final int status;
  final String body;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    body,
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
  @override
  void close({bool force = false}) {}
}
