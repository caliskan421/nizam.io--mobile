import 'dart:async';

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

class ProgressiveServer extends WorkspaceServer {
  ProgressiveServer() {
    rows.addAll(List.generate(160, (i) => TableRecord(id: 'r$i')));
  }
  final expandGate = Completer<void>();
  final reads = <TableReadQuery>[];
  ApiError? expansionError;
  @override
  Future<TableWorkspace> workspace(
    TableLocation location,
    String id,
    String account, {
    TableReadQuery query = const TableReadQuery(),
  }) async {
    reads.add(query);
    final start =
        int.tryParse(query.cursor ?? '') ?? (query.filters.isEmpty ? 0 : 120);
    final pageRows = rows.skip(start).take(query.limit).toList();
    final page = TableWorkspace(
      document: document.copyWith(rows: pageRows),
      schema: schema,
      sequence: sequence,
      columns: List.of(columns),
      cells: List.of(cells),
      cursor: start + pageRows.length < rows.length
          ? '${start + pageRows.length}'
          : null,
    );
    if (query.limit == 100 && query.cursor == null) {
      await expandGate.future;
      if (expansionError case final error?) throw error;
    }
    return page;
  }
}

void main() {
  test('ilk 20 satır bekletilmez; arkada 100 tamamlanır ve sonraki sayfa 100den devam eder', () async {
    final server = ProgressiveServer();
    final c = setup(server);
    await flush();
    var state = c.read(tableDetailProvider('t1'));
    expect(state.data!.document.rows, hasLength(20));
    expect(state.loading, isFalse);
    expect(state.prefetching, isTrue);
    expect(server.reads.map((q) => q.limit), [20, 100]);
    server.expandGate.complete();
    await flush();
    state = c.read(tableDetailProvider('t1'));
    expect(state.data!.document.rows, hasLength(100));
    expect(state.prefetching, isFalse);
    await c.read(tableDetailProvider('t1').notifier).refresh(more: true);
    state = c.read(tableDetailProvider('t1'));
    expect(state.offset, 100);
    expect(state.data!.document.rows.first.id, 'r100');
    expect(state.data!.document.rows, hasLength(60));
  });
  test('geciken genişletme cevabı yeni sorguyu ezmez', () async {
    final server = ProgressiveServer();
    final c = setup(server);
    await flush();
    await c
        .read(tableDetailProvider('t1').notifier)
        .query(
          const TableReadQuery(
            limit: 2,
            filters: [TableQueryFilter('c1', TableQueryOperator.eq, 'other')],
          ),
        );
    server.expandGate.complete();
    await flush();
    final state = c.read(tableDetailProvider('t1'));
    expect(state.data!.document.rows, hasLength(2));
    expect(state.data!.document.rows.first.id, 'r120');
    expect(state.prefetching, isFalse);
  });
  test(
    'genişletme hatasında ilk satırlar kalır, yeniden deneme tamamlar',
    () async {
      final server = ProgressiveServer()
        ..expansionError = ApiError('client.timeout');
      final c = setup(server);
      await flush();
      server.expandGate.complete();
      await flush();
      final state = c.read(tableDetailProvider('t1'));
      expect(state.data!.document.rows, hasLength(20));
      expect(state.error, isNull);
      expect(state.prefetchError?.code, 'client.timeout');
      server.expansionError = null;
      await c.read(tableDetailProvider('t1').notifier).loadRemaining();
      expect(
        c.read(tableDetailProvider('t1')).data!.document.rows,
        hasLength(100),
      );
    },
  );
  test(
    'okuma bütçesi genişletmeye yetmezse küçük sayfalarla devam eder',
    () async {
      final server = ProgressiveServer()
        ..expansionError = ApiError('tables.limit_reached');
      final c = setup(server);
      await flush();
      server.expandGate.complete();
      await flush();
      expect(c.read(tableDetailProvider('t1')).prefetchError, isNull);
      await c.read(tableDetailProvider('t1').notifier).refresh(more: true);
      final state = c.read(tableDetailProvider('t1'));
      expect(state.offset, 20);
      expect(state.data!.document.rows.first.id, 'r20');
    },
  );
  test('erişim kaldırılmışsa ilk yüklenen satırlar da kapanır', () async {
    final server = ProgressiveServer()
      ..expansionError = ApiError('tables.forbidden', status: 403);
    final c = setup(server);
    await flush();
    server.expandGate.complete();
    await flush();
    final state = c.read(tableDetailProvider('t1'));
    expect(state.data, isNull);
    expect(state.error?.code, 'tables.forbidden');
  });
  test('arkadaki eski snapshot kullanıcı yazımını geri getirmez', () async {
    final server = ProgressiveServer();
    final c = setup(server);
    await flush();
    await c
        .read(tableDetailProvider('t1').notifier)
        .send(const WriteTableCells([TableCellWrite('r0', 'c1', 'Yeni', 0)]));
    server.expandGate.complete();
    await flush();
    final state = c.read(tableDetailProvider('t1'));
    expect(state.data!.sequence, 2);
    expect(state.data!.cell('r0', 'c1').value, 'Yeni');
  });
}
