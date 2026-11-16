import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tables/data/tables_api_repository.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_edit.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';

import '../../tasks/data/work_fake_dio.dart';
import 'tables_api_repository_test.dart' show table, receipt;

const field = TableField(id: 'c1', name: 'Ad');
void main() {
  final edits = <({TableEdit edit, Map<String, Object?> body})>[
    (
      edit: const RenameTable('Yeni'),
      body: {'kind': 'rename_table', 'name': 'Yeni'},
    ),
    (edit: const DeleteTable(), body: {'kind': 'delete_table'}),
    (edit: const AddTableRow(), body: {'kind': 'add_row'}),
    (
      edit: const DeleteTableRow('r1'),
      body: {'kind': 'delete_row', 'id': 'r1'},
    ),
    (
      edit: const MoveTableRow('r1', null),
      body: {'kind': 'move_row', 'id': 'r1'},
    ),
    (
      edit: const EditTableColumn(TableColumnAction.add, field, 3),
      body: {
        'kind': 'add_column',
        'name': 'Ad',
        'type': 'text',
        'width': 180,
        'expected_schema': 3,
        'multiple': false,
      },
    ),
    (
      edit: const EditTableColumn(TableColumnAction.rename, field, 3),
      body: {
        'kind': 'rename_column',
        'id': 'c1',
        'name': 'Ad',
        'expected_schema': 3,
      },
    ),
    (
      edit: const EditTableColumn(
        TableColumnAction.resize,
        field,
        3,
        width: 240,
      ),
      body: {
        'kind': 'resize_column',
        'id': 'c1',
        'width': 240,
        'expected_schema': 3,
      },
    ),
    (
      edit: const EditTableColumn(TableColumnAction.delete, field, 3),
      body: {'kind': 'delete_column', 'id': 'c1', 'expected_schema': 3},
    ),
    (
      edit: const EditTableColumn(
        TableColumnAction.move,
        field,
        3,
        after: 'c2',
      ),
      body: {
        'kind': 'move_column',
        'id': 'c1',
        'after_id': 'c2',
        'expected_schema': 3,
      },
    ),
    (
      edit: const EditTableColumn(TableColumnAction.convert, field, 3),
      body: {
        'kind': 'convert_column',
        'id': 'c1',
        'type': 'text',
        'expected_schema': 3,
      },
    ),
    (
      edit: const GrantTableAccess('u1', TableAccess.edit),
      body: {'kind': 'grant', 'account_id': 'u1', 'role': 'editor'},
    ),
    (
      edit: const GrantTableAccess('u1', TableAccess.off),
      body: {'kind': 'revoke', 'account_id': 'u1'},
    ),
    (
      edit: const SetTableTeam(TableAccess.off),
      body: {'kind': 'set_team_role', 'role': 'none'},
    ),
    (
      edit: const SetTableProject(null),
      body: {'kind': 'set_project', 'project_id': ''},
    ),
    (
      edit: const SetTableTemplate(true),
      body: {'kind': 'set_template', 'template': true},
    ),
    (
      edit: const UndoTableCells(42),
      body: {'kind': 'undo_cells', 'sequence': 42},
    ),
    (
      edit: const TransferTable(TableTransferAction.move, TableLocation('p1')),
      body: {'kind': 'move_table', 'target_space': 'personal'},
    ),
    (
      edit: const TransferTable(
        TableTransferAction.proposeMove,
        TableLocation('p1', 'd2'),
      ),
      body: {
        'kind': 'propose_move',
        'target_space': 'coordinatorship',
        'target_department_id': 'd2',
        'role': 'viewer',
      },
    ),
    (
      edit: const TransferTable(
        TableTransferAction.proposeCopy,
        TableLocation('p1', 'd2'),
      ),
      body: {
        'kind': 'propose_copy',
        'target_space': 'coordinatorship',
        'target_department_id': 'd2',
        'role': 'viewer',
      },
    ),
    (
      edit: const TransferTable(
        TableTransferAction.withdraw,
        TableLocation('p1'),
      ),
      body: {'kind': 'withdraw_proposal'},
    ),
    (
      edit: const EditTableComment(
        TableCommentAction.add,
        row: 'r1',
        column: 'c1',
        body: 'Yorum',
      ),
      body: {
        'kind': 'add_comment',
        'row_id': 'r1',
        'column_id': 'c1',
        'body': 'Yorum',
      },
    ),
    (
      edit: const EditTableComment(
        TableCommentAction.edit,
        id: 'm1',
        body: 'Yeni',
      ),
      body: {'kind': 'edit_comment', 'id': 'm1', 'body': 'Yeni'},
    ),
    (
      edit: const EditTableComment(TableCommentAction.delete, id: 'm1'),
      body: {'kind': 'delete_comment', 'id': 'm1'},
    ),
  ];
  for (final personal in [true, false]) {
    final location = TableLocation('p1', personal ? '' : 'd1');
    for (final e in edits) {
      test(
        '${personal ? 'kişisel' : 'koordinatörlük'}: ${e.body['kind']}',
        () async {
          final (dio, a) = fakeDio({
            ...receipt,
            'sequence': 42,
            'id': 'new-id',
          });
          addTearDown(dio.close);
          final r = await ApiTablesRepository(() => dio)
              .execute(location, 't1', e.edit, 'request-key-01234567890');
          expect(a.sentJson, e.body);
          expect(
            a.last.path,
            '${personal ? '/v1/personal/tables' : '/v1/tables'}/t1/operations',
          );
          expect(a.last.headers['Idempotency-Key'], 'request-key-01234567890');
          expect(a.last.extra.values, contains('p1'));
          expect(a.last.extra.values.contains('d1'), !personal);
          expect(r.sequence, 42);
          expect(r.id, 'new-id');
        },
      );
    }
    test('hücre scalar/batch ve sürümler: $personal', () async {
      final (dio, a) = fakeDio(receipt);
      addTearDown(dio.close);
      await ApiTablesRepository(() => dio).execute(
        location,
        't1',
        const WriteTableCells([
          TableCellWrite('r1', 'c1', 'Yeni', 9),
          TableCellWrite('r1', 'c2', null, 0),
          TableCellWrite('r1', 'c3', true, 2),
          TableCellWrite('r1', 'c4', ['visible-id'], 1),
        ]),
        'request-key-01234567890',
      );
      expect(a.sentJson, {
        'kind': 'set_cells',
        'cells': [
          {'row_id': 'r1', 'column_id': 'c1', 'value': 'Yeni', 'version': 9},
          {'row_id': 'r1', 'column_id': 'c2', 'value': null, 'version': 0},
          {'row_id': 'r1', 'column_id': 'c3', 'value': true, 'version': 2},
          {
            'row_id': 'r1',
            'column_id': 'c4',
            'value': ['visible-id'],
            'version': 1,
          },
        ],
      });
    });
  }
  test('ondalık okumada ve geri yazmada kayıpsızdır; CAS sürümü korunur', () async {
    final (dio, a) = fakeDio(
      '''{"table":${jsonEncode(table())},"columns":[{"id":"c1","name":"Sayı","type":"number","multiple":false,"width":180,"position":1}],"rows":[{"id":"r1"}],"cells":[{"row_id":"r1","column_id":"c1","value":12345678901234567890.1200,"version":7}]}''',
    );
    addTearDown(dio.close);
    final workspace = await ApiTablesRepository(() => dio)
        .workspace(const TableLocation('p1'), 't1', 'me');
    final cell = workspace.cell('r1', 'c1');
    expect(cell.value, isA<TableDecimal>());
    expect('${cell.value}', '12345678901234567890.1200');
    expect(cell.version, 7);
    expect(cell.display, '12345678901234567890.1200');
    expect(workspace.cell('r1', 'empty').version, 0);
    expect(a.last.queryParameters, {'limit': 100});
  });
  test('ondalık yazımında tam sayı/ölçek ve üslü biçim korunur', () async {
    final (dio, a) = fakeDio(receipt);
    addTearDown(dio.close);
    await ApiTablesRepository(() => dio).execute(
      const TableLocation('p1'),
      't1',
      const WriteTableCells([
        TableCellWrite(
          'r1',
          'c1',
          TableDecimal('12345678901234567890.1200'),
          7,
        ),
        TableCellWrite('r1', 'c2', TableDecimal('1e-1000'), 0),
      ]),
      'request-key-01234567890',
    );
    expect(a.last.data, isA<String>());
    expect(a.last.data, contains('12345678901234567890.1200'));
    expect(a.last.data, contains('1e-1000'));
  });
  test('süzgeç/sıralama ve opak imleç olduğu gibi gönderilir', () async {
    final (dio, a) = fakeDio({
      'table': table(),
      'columns': <Object?>[],
      'rows': <Object?>[],
      'cells': <Object?>[],
    });
    addTearDown(dio.close);
    await ApiTablesRepository(() => dio).workspace(
      const TableLocation('p1'),
      't1',
      'me',
      query: const TableReadQuery(
        cursor: 'v2.opaque',
        filters: [
          TableQueryFilter('c1', TableQueryOperator.contains, 'a:b'),
          TableQueryFilter('c2', TableQueryOperator.empty),
        ],
        sorts: [
          (column: 'c1', descending: true),
          (column: 'c2', descending: false),
        ],
      ),
    );
    expect(a.last.queryParameters, {
      'limit': 100,
      'cursor': 'v2.opaque',
      'filter': ['c1:contains:a:b', 'c2:empty'],
      'sort': ['c1:desc', 'c2:asc'],
    });
    expect(a.last.listFormat, ListFormat.multi);
  });
  test('kopya optional null alanları göndermez; kaynak ve hedef kapsamları ayrıdır', () async {
    final (dio, a) = fakeDio(receipt);
    addTearDown(dio.close);
    await ApiTablesRepository(() => dio).copy(
      const TableLocation('p1', 'd1'),
      't1',
      const TableLocation('p2'),
      full: false,
      key: 'request-key-01234567890',
    );
    expect(a.last.path, '/v1/personal/table-copies');
    expect(a.last.extra.values, contains('p2'));
    expect(a.sentJson, {
      'source_table_id': 't1',
      'source_space': 'coordinatorship',
      'source_program_id': 'p1',
      'source_department_id': 'd1',
      'mode': 'structure',
    });
  });
}
