import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_edit.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';
import 'package:nizamio/features/tables/presentation/table_grid_value.dart';
import 'package:nizamio/features/tables/presentation/table_workspace_grid.dart';
import 'package:nizamio/features/tables/presentation/table_workspace_input.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';
import 'table_workspace_flow_test.dart' show WorkspaceServer, openWorkspace;
import 'users_tables_flow_test.dart' show sheetPng;

class ReferenceServer extends WorkspaceServer {
  ReferenceServer() {
    columns.clear();
    columns.addAll([
      const TableColumnState(
        TableField(id: 'c1', name: 'Adım'),
        240,
        false,
        'text',
      ),
      const TableColumnState(
        TableField(id: 'person', name: 'Sorumlu', type: TableFieldType.person),
        190,
        false,
        'person_reference',
      ),
      const TableColumnState(
        TableField(id: 'task', name: 'Görev', type: TableFieldType.task),
        230,
        false,
        'task_reference',
      ),
      const TableColumnState(
        TableField(id: 'date', name: 'Son tarih', type: TableFieldType.date),
        150,
        false,
        'date',
      ),
      const TableColumnState(
        TableField(id: 'file', name: 'Kanıt', type: TableFieldType.file),
        190,
        false,
        'attachment',
      ),
      const TableColumnState(
        TableField(id: 'done', name: 'Tamamlandı', type: TableFieldType.todo),
        120,
        false,
        'checkbox',
      ),
    ]);
    rows.addAll([
      TableRecord(id: 'r1'),
      TableRecord(id: 'r2'),
      TableRecord(id: 'r3'),
    ]);
    void cell(String row, String col, Object? value, String label) => cells.add(
      TableCellState(
        row: row,
        column: col,
        value: value,
        display: label,
        version: 1,
      ),
    );
    cell('r1', 'c1', 'Pompaların sahaya teslimi', 'Pompaların sahaya teslimi');
    cell(
      'r2',
      'c1',
      'Vinç ve elektrik bağlantısı kontrolü',
      'Vinç ve elektrik bağlantısı kontrolü',
    );
    cell(
      'r3',
      'c1',
      'Montaj ekibinin saha planı',
      'Montaj ekibinin saha planı',
    );
    cell('r1', 'person', 'person1', 'Kadir Özbek');
    cell('r2', 'person', 'person2', 'Reha Koçak');
    cell('r3', 'person', 'person3', 'Ali Avcı');
    cell('r1', 'task', 'task1', 'Havalimanı yerleşkesi hidrofor sistemi');
    cell('r2', 'task', 'task1', 'Havalimanı yerleşkesi hidrofor sistemi');
    cell('r3', 'task', 'task2', 'Montaj, test ve devreye alma');
    cell('r1', 'date', '2026-11-18', '2026-11-18');
    cell('r2', 'date', '2026-11-19', '2026-11-19');
    cell('r1', 'file', 'a1', 'Teslim tutanağı.pdf');
    cell('r2', 'done', true, '✓');
  }
  Completer<void>? writeGate;
  @override
  Future<TableOperationReceipt> execute(
    TableLocation location,
    String id,
    TableEdit edit,
    String key,
  ) async {
    await writeGate?.future;
    return super.execute(location, id, edit, key);
  }

  TableReadQuery? lastQuery;
  @override
  Future<TableWorkspace> workspace(
    TableLocation l,
    String id,
    String account, {
    TableReadQuery query = const TableReadQuery(),
  }) async {
    lastQuery = query;
    final filter = query.filters.where((f) => f.column == 'done').firstOrNull;
    final visible = filter == null
        ? rows
        : rows
              .where(
                (r) =>
                    (cells
                            .where((c) => c.row == r.id && c.column == 'done')
                            .firstOrNull
                            ?.value ==
                        true) ==
                    (filter.value == 'true'),
              )
              .toList();
    return TableWorkspace(
      document: document.copyWith(rows: visible),
      schema: schema,
      sequence: sequence,
      columns: columns,
      cells: cells,
    );
  }
}

void main() {
  setUpFonts();
  testWidgets('standart satır girdisi negatif ondalık ve üs metnini korur', (
    tester,
  ) async {
    Object? changed;
    await tester.pumpWidget(
      ProviderScope(
        child: testApp(
          TableWorkspaceInput(
            column: const TableColumnState(
              TableField(id: 'n', name: 'Tutar', type: TableFieldType.number),
              180,
              false,
              'number',
            ),
            value: null,
            onChanged: (value) => changed = value,
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), '-12,50');
    expect((changed! as TableDecimal).value, '-12.50');
    await tester.enterText(find.byType(TextField), '1.25e-10');
    expect((changed! as TableDecimal).value, '1.25e-10');
    expect((changed! as TableDecimal).valid, isTrue);
  });
  for (final size in [const Size(360, 640), const Size(1180, 820)]) {
    testWidgets('referans düzeni: türler, özetler ve hücre güncelleme: $size', (
      tester,
    ) async {
      final server = ReferenceServer();
      final phase = ValueNotifier(AppPhase.scoped);
      addTearDown(phase.dispose);
      await openWorkspace(tester, server, phase, size, dark: true);
      File('/tmp/nizam-web-reference-${size.width.toInt()}.png')
          .writeAsBytesSync(await sheetPng(tester));
      final grid = find.byType(TableWorkspaceGrid);
      final check = find
          .descendant(of: grid, matching: find.byType(TableGridValue))
          .at(5);
      await tester.ensureVisible(check);
      final topBefore = tester.getTopLeft(grid).dy;
      server.writeGate = Completer<void>();
      await tester.tap(check);
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.getTopLeft(grid).dy, closeTo(topBefore, .1));
      expect(find.text('Son işlemin sonucu henüz doğrulanmadı.'), findsNothing);
      server.writeGate!.complete();
      await settle(tester);
      expect(tester.getTopLeft(grid).dy, closeTo(topBefore, .1));
      final write = server.edits.last.edit as WriteTableCells;
      expect(write.cells.single.row, 'r1');
      expect(write.cells.single.column, 'done');
      expect(write.cells.single.value, true);
      expect(write.cells.single.version, 0);
      await tester.ensureVisible(find.text('Pompaların sahaya teslimi'));
      await tester.tap(find.text('Pompaların sahaya teslimi'));
      await settle(tester);
      File('/tmp/nizam-web-reference-input-${size.width.toInt()}.png')
          .writeAsBytesSync(await sheetPng(tester));
      expect(tester.takeException(), isNull);
    });
  }
}
