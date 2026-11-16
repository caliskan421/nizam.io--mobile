import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tables/data/tables_api_repository.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';

import '../../../support/fake_backend.dart';
import '../../tasks/data/work_fake_dio.dart';

const receipt = {
  'table_id': 't1',
  'sequence': 1,
  'schema_version': 1,
  'replayed': false,
};
Map<String, Object?> table({String department = '', String owner = 'me'}) => {
  'id': 't1',
  'owner_id': owner,
  'name': 'Tablo',
  'program_id': 'p1',
  'department_id': department,
  'space': department.isEmpty ? 'personal' : 'coordinatorship',
  'schema_version': 1,
  'sequence': 1,
};
void main() {
  for (final personal in [true, false]) {
    test(
      'oluşturma, sütun, paylaşım açık kapsamla: personal=$personal',
      () async {
        final (dio, adapter) = fakeDio(receipt);
        addTearDown(dio.close);
        final repo = ApiTablesRepository(() => dio);
        final location = TableLocation('p1', personal ? '' : 'd1');
        final prefix = personal ? '/v1/personal/tables' : '/v1/tables';
        await repo.create(location, 'Tablo', 'creation-key-0123456789');
        expect(adapter.seen.single.path, prefix);
        expect(adapter.sentJson, {'name': 'Tablo'});
        expect(adapter.last.extra.values, contains('p1'));
        expect(adapter.last.extra.values.contains('d1'), !personal);
        adapter.seen.clear();
        await repo.addColumn(
          location,
          't1',
          const TableField(id: 'local', name: 'Ad'),
          3,
          'column-key-0123456789012',
        );
        expect(adapter.sentJson, {
          'kind': 'add_column',
          'name': 'Ad',
          'type': 'text',
          'width': 180,
          'multiple': false,
          'expected_schema': 3,
        });
        expect(adapter.last.path, '$prefix/t1/operations');
        adapter.seen.clear();
        await repo.grant(
          location,
          't1',
          'u2',
          TableAccess.view,
          'grant-key-01234567890123',
        );
        expect(adapter.sentJson, {
          'kind': 'grant',
          'account_id': 'u2',
          'role': 'viewer',
        });
        expect(
          adapter.last.headers['Idempotency-Key'],
          'grant-key-01234567890123',
        );
      },
    );
  }
  test('ekip yetkisi ve öneri gövdesi; boş proje null gönderilmez', () async {
    final (dio, a) = fakeDio(receipt);
    addTearDown(dio.close);
    final repo = ApiTablesRepository(() => dio);
    await repo.setTeamRole(
      const TableLocation('p1', 'd1'),
      't1',
      TableAccess.edit,
      'team-key-012345678901234',
    );
    expect(a.sentJson, {'kind': 'set_team_role', 'role': 'editor'});
    a.seen.clear();
    await repo.propose(
      const TableLocation('p1'),
      't1',
      'd1',
      TableAccess.view,
      'proposal-key-0123456789',
    );
    expect(a.last.path, '/v1/personal/tables/t1/operations');
    expect(a.sentJson, {
      'kind': 'propose_move',
      'target_space': 'coordinatorship',
      'target_department_id': 'd1',
      'role': 'viewer',
    });
  });
  test('liste bütün sayfaları okur, kişisel paylaşımı ayrı gruplar', () async {
    final backend = FakeBackend(
      (r) => jsonResponse(200, {
        'items': [table(owner: r.query['cursor'] == null ? 'me' : 'other')],
        if (r.query['cursor'] == null) 'next_cursor': 'next-page',
      }),
    );
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = backend;
    addTearDown(dio.close);
    final rows = await ApiTablesRepository(() => dio)
        .list(const TableLocation('p1'), 'me');
    expect(backend.requests.length, 2);
    expect(rows.map((d) => d.area), [TableArea.personal, TableArea.shared]);
    expect(rows.every((d) => d.remote && !d.editable && !d.canShare), isTrue);
  });
  test('imleç döngüsü ve yanlış kapsam sessiz başarı sayılmaz', () async {
    final (dio, _) = fakeDio({
      'items': [table()],
      'next_cursor': 'same',
    });
    addTearDown(dio.close);
    await expectLater(
      ApiTablesRepository(() => dio).list(const TableLocation('p1'), 'me'),
      throwsApiError('client.invalid_response'),
    );
    await expectLater(
      ApiTablesRepository(() => dio).list(const TableLocation('other'), 'me'),
      throwsApiError('client.invalid_response'),
    );
  });
  test(
    'scalar snapshot ayrıştırılır, gizli referans kimliği gösterilmez',
    () async {
      final (dio, _) = fakeDio({
        'table': table(),
        'columns': [
          {
            'id': 'name',
            'name': 'Ad',
            'type': 'text',
            'multiple': false,
            'width': 180,
            'position': 1,
          },
          {
            'id': 'person',
            'name': 'Kişi',
            'type': 'person_reference',
            'multiple': false,
            'width': 180,
            'position': 2,
          },
        ],
        'rows': [
          {'id': 'r1'},
        ],
        'cells': [
          {'row_id': 'r1', 'column_id': 'name', 'value': 'Merhaba'},
          {'row_id': 'r1', 'column_id': 'person', 'value': 'hidden-id'},
        ],
        'next_cursor': 'more',
      });
      addTearDown(dio.close);
      final doc = await ApiTablesRepository(() => dio)
          .read(const TableLocation('p1'), 't1', 'me');
      expect(doc.rows.single.cells[const TableFieldId('name')], 'Merhaba');
      expect(doc.rows.single.cells[const TableFieldId('person')], '—');
      expect(doc.previewHasMore, isTrue);
    },
  );
  test('doğrulanmış bağ yokken ve boş programla yazma olmaz', () async {
    await expectLater(
      ApiTablesRepository(() => null)
          .create(const TableLocation('p1'), 'Ad', 'key'),
      throwsApiError('client.server_not_verified'),
    );
    final (dio, a) = fakeDio(receipt);
    addTearDown(dio.close);
    await expectLater(
      ApiTablesRepository(() => dio)
          .create(const TableLocation(''), 'Ad', 'key'),
      throwsApiError('client.scope_missing'),
    );
    expect(a.seen, isEmpty);
  });
  test('403 sunucu hatası ApiError olarak korunur', () async {
    final (dio, _) = fakeDio(errorEnvelope('tables.forbidden'), status: 403);
    addTearDown(dio.close);
    await expectLater(
      ApiTablesRepository(() => dio)
          .create(const TableLocation('p1'), 'Ad', 'key'),
      throwsA(
        isA<ApiError>().having((e) => e.code, 'code', 'tables.forbidden'),
      ),
    );
  });
}
