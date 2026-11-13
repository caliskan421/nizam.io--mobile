// Referans aday kaynakları (data): kişi — koordinatörlükte departman ekibi (`listMembers`,
// yalnız aktif), kişiselde program adayları (`listMeetingParticipantCandidates`, imleçli);
// departman — yöneticiye program departmanları, diğerine seçili programdaki ekip satırları;
// görev — `listProgramWorkItems`; dosya — görevin kendi departman kapsamıyla. Kapsam başlığı
// her istekte açıkça sabitlenir.
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tables/data/table_api_repository.dart';
import 'package:nizamio/features/tables/data/table_reference_api_repository.dart';
import 'package:nizamio/features/tables/domain/table_models.dart';
import 'package:nizamio/features/tables/domain/table_operation.dart';
import 'package:nizamio/features/tables/domain/table_reference_sources.dart';

import '../../coordinatorships/coord_backend.dart' show workItem;

class _Http implements HttpClientAdapter {
  _Http(this.routes);
  final Map<String, Object? Function(RequestOptions o)> routes;
  final seen = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    final r = routes['${options.method} ${options.uri.path}'];
    return ResponseBody.fromString(
      jsonEncode(r == null ? {'code': 'x', 'message': 'x'} : r(options)),
      r == null ? 404 : 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

(ApiTableReferenceSources, _Http) _repo(
  Map<String, Object? Function(RequestOptions o)> routes,
) {
  final a = _Http(routes);
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = a;
  return (ApiTableReferenceSources(() => dio), a);
}

const _coord = TableScope.coordinatorship(programId: 'p1', departmentId: 'd1');
const _personal = TableScope.personal(programId: 'p1');

Map<String, Object?> _me({required bool admin}) => {
  'account_id': 'me',
  'email': 'me@test',
  'full_name': 'Ben',
  'company_admin': admin,
};

void main() {
  test(
    'kişi (koordinatörlük): departman ekibi, yalnız aktif; program başlığı',
    () async {
      final (repo, http) = _repo({
        'GET /v1/departments/d1/members': (_) => {
          'members': [
            {
              'membership_id': 'm1',
              'account_id': 'u1',
              'full_name': 'Ayşe',
              'role': 'member',
              'status': 'active',
            },
            {
              'membership_id': 'm2',
              'account_id': 'u2',
              'full_name': 'Eski',
              'role': 'member',
              'status': 'deleted',
            },
          ],
        },
      });
      final people = await repo.people(_coord);
      expect(people.map((p) => p.id), ['u1']);
      expect(http.seen.single.extra['nizamio.program'], 'p1');
    },
  );

  test('kişi (kişisel): program adayları imleç boşalana dek', () async {
    final (repo, http) = _repo({
      'GET /v1/meetings/participant-candidates': (o) =>
          o.uri.queryParameters['cursor'] == null
          ? {
              'items': [
                {
                  'account_id': 'u1',
                  'full_name': 'Ayşe',
                  'teams': <Object?>[],
                  'is_participant': false,
                },
              ],
              'next_cursor': 'u1',
            }
          : {
              'items': [
                {
                  'account_id': 'u2',
                  'full_name': 'Ali',
                  'teams': <Object?>[],
                  'is_participant': false,
                },
              ],
              'next_cursor': '',
            },
    });
    final people = await repo.people(_personal);
    expect(people.map((p) => p.name), ['Ayşe', 'Ali']);
    expect(http.seen, hasLength(2));
  });

  test('departman: yöneticiye program departmanları', () async {
    final (repo, _) = _repo({
      'GET /v1/me': (_) => _me(admin: true),
      'GET /v1/program/departments': (_) => {
        'departments': [
          {'department_id': 'd1', 'display_name': 'Altyapı'},
          {'department_id': 'd2', 'display_name': 'Saha'},
        ],
      },
    });
    expect((await repo.departments(_coord)).map((d) => d.id), ['d1', 'd2']);
  });

  test(
    'departman: yönetici değilse yalnız bu programdaki ekip satırları',
    () async {
      final (repo, _) = _repo({
        'GET /v1/me': (_) => _me(admin: false),
        'GET /v1/me/departments': (_) => {
          'departments': [
            {
              'program_id': 'p1',
              'program_name': 'P',
              'department_id': 'd1',
              'display_name': 'Altyapı',
              'role': 'member',
            },
            {
              'program_id': 'p2',
              'program_name': 'Q',
              'department_id': 'd9',
              'display_name': 'Başka',
              'role': 'member',
            },
          ],
        },
      });
      expect((await repo.departments(_coord)).map((d) => d.id), ['d1']);
    },
  );

  test('görev: program görevleri, departman bilgisiyle; imleç', () async {
    final (repo, http) = _repo({
      'GET /v1/program/work-items': (_) => {
        'items': [workItem('w1', 'd3', 'Kurulum', 'open', const [])],
        'next_cursor': 'c2',
      },
    });
    final page = await repo.tasks(_coord);
    expect(page.items.single.departmentId, 'd3');
    expect(page.nextCursor, 'c2');
    expect(http.seen.single.extra['nizamio.program'], 'p1');
  });

  test('dosya: görevin kendi departman kapsamıyla', () async {
    final (repo, http) = _repo({
      'GET /v1/work-items/w1/files': (_) => {
        'files': [
          {
            'file_id': 'f1',
            'work_item_id': 'w1',
            'display_name': 'a.pdf',
            'content_type': 'application/pdf',
            'size_bytes': 10,
            'tag': 'other',
            'uploaded_by_account_id': 'u1',
            'uploaded_by_full_name': null,
            'uploaded_at': '2026-11-14T10:00:00Z',
          },
        ],
      },
    });
    final files = await repo.files(
      _coord,
      const TableRefCandidate(id: 'w1', name: 'Kurulum', departmentId: 'd3'),
    );
    expect(files.single.id, 'f1');
    expect(http.seen.single.extra['nizamio.department'], 'd3');
  });

  test(
    'referans değerleri gidiş-dönüş: tekli kimlik, çoklu liste, temizleme null',
    () async {
      Object? body;
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = _Body((b) => body = b);
      await ApiTablesRepository(() => dio).apply(
        _coord,
        't1',
        SetCells(const [
          TableCellWrite(rowId: 'r1', columnId: 'c1', value: 'u1', version: 0),
          TableCellWrite(
            rowId: 'r1',
            columnId: 'c2',
            value: ['w1', 'w2'],
            version: 3,
          ),
          TableCellWrite(rowId: 'r2', columnId: 'c2', value: null, version: 1),
        ]),
        requestKey: 'k' * 22,
      );
      final cells = (body! as Map)['cells'] as List;
      expect(
        [for (final c in cells) (c as Map)['value']],
        [
          'u1',
          ['w1', 'w2'],
          null,
        ],
      );
      expect(cells.every((c) => !(c as Map).containsKey('redacted')), isTrue);
    },
  );
}

/// İstek gövdesini yakalar, boş makbuz döner.
class _Body implements HttpClientAdapter {
  _Body(this.onBody);
  final void Function(Object? body) onBody;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final bytes = await requestStream!.expand((c) => c).toList();
    onBody(jsonDecode(utf8.decode(bytes)));
    return ResponseBody.fromString(
      jsonEncode({
        'table_id': 't1',
        'sequence': 2,
        'schema_version': 1,
        'replayed': false,
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
