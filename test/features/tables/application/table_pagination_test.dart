import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tables/application/table_detail_controller.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_edit.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';

import '../../../app/router/table_workspace_flow_test.dart'
    show WorkspaceServer;
import 'table_detail_controller_test.dart' show setup, flush;

class PagedServer extends WorkspaceServer {
  PagedServer() {
    rows.addAll(List.generate(7, (i) => TableRecord(id: 'r${i + 1}')));
  }
  final reads = <TableReadQuery>[];
  bool rejectQuery = false;
  bool stale = false;
  int budget = 1;
  @override
  Future<TableWorkspace> workspace(
    TableLocation l,
    String id,
    String account, {
    TableReadQuery query = const TableReadQuery(),
  }) async {
    reads.add(query);
    if (query.limit > budget) throw ApiError('tables.limit_reached');
    if (query.filters.isNotEmpty && rejectQuery) {
      throw ApiError('tables.input_invalid');
    }
    if (query.cursor != null && stale) {
      stale = false;
      throw ApiError('tables.cursor_stale');
    }
    final raw = int.tryParse(query.cursor ?? '0') ?? 0;
    final start = raw > 1000 ? rows.length - 1 : raw;
    final page = rows.skip(start).take(query.limit).toList();
    return TableWorkspace(
      document: document.copyWith(rows: page),
      schema: schema,
      sequence: sequence,
      columns: columns,
      cells: cells,
      cursor: start + page.length < rows.length
          ? '${start + page.length}'
          : null,
    );
  }
}

void main() {
  test(
    'okuma bütçesine uyarlanır; sayfalar birikmez ve geri gidilir',
    () async {
      final server = PagedServer();
      final c = setup(server);
      await flush();
      final controller = c.read(tableDetailProvider('t1').notifier);
      expect(server.reads.map((q) => q.limit), [20, 10, 5, 2, 1]);
      expect(
        c.read(tableDetailProvider('t1')).data!.document.rows.single.id,
        'r1',
      );
      await controller.refresh(more: true);
      var state = c.read(tableDetailProvider('t1'));
      expect(state.page, 2);
      expect(state.offset, 1);
      expect(state.data!.document.rows.single.id, 'r2');
      await controller.refresh(previous: true);
      state = c.read(tableDetailProvider('t1'));
      expect(state.page, 1);
      expect(state.data!.document.rows.single.id, 'r1');
    },
  );

  test('başarısız filtre önceki sayfa ve imleci korur', () async {
    final server = PagedServer()..budget = 100;
    final c = setup(server);
    await flush();
    final controller = c.read(tableDetailProvider('t1').notifier);
    await controller.query(const TableReadQuery(limit: 2));
    await controller.refresh(more: true);
    server.rejectQuery = true;
    await controller.query(
      const TableReadQuery(
        filters: [TableQueryFilter('c1', TableQueryOperator.eq, 'x')],
      ),
    );
    var state = c.read(tableDetailProvider('t1'));
    expect(state.page, 2);
    expect(state.query.filters, isEmpty);
    expect(state.data!.document.rows.first.id, 'r3');
    await controller.refresh(more: true);
    state = c.read(tableDetailProvider('t1'));
    expect(state.page, 3);
    expect(state.data!.document.rows.first.id, 'r5');
  });

  test('bayat imleç ilk sayfaya döner ve filtreyi korur', () async {
    final server = PagedServer()..budget = 100;
    final c = setup(server);
    await flush();
    final controller = c.read(tableDetailProvider('t1').notifier);
    await controller.query(
      const TableReadQuery(
        limit: 2,
        filters: [TableQueryFilter('c1', TableQueryOperator.contains, 'x')],
      ),
    );
    server.stale = true;
    await controller.refresh(more: true);
    final state = c.read(tableDetailProvider('t1'));
    expect(state.page, 1);
    expect(state.error, isNull);
    expect(state.query.filters, hasLength(1));
    expect(state.data!.document.rows.first.id, 'r1');
  });

  test('sonraki sayfada eklenen satır doğrudan açılabilir', () async {
    final server = PagedServer()..budget = 100;
    final c = setup(server);
    await flush();
    final controller = c.read(tableDetailProvider('t1').notifier);
    await controller.query(const TableReadQuery(limit: 2));
    final receipt = await controller.send(const AddTableRow());
    final state = c.read(tableDetailProvider('t1'));
    expect(receipt!.id, 'r8');
    expect(state.query.cursor, isNotNull);
    expect(state.data!.document.rows.single.id, 'r8');
    await controller.query(const TableReadQuery(limit: 2));
    expect(
      c.read(tableDetailProvider('t1')).data!.document.rows.first.id,
      'r1',
    );
  });
}
