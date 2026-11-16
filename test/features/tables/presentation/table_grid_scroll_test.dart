import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/presentation/table_workspace_grid.dart';

import '../../../core/ui/widgets/feedback/feedback_test_support.dart';

void main() {
  setUpFonts();
  for (final width in [390.0, 1180.0]) {
    testWidgets(
      'satır numarasından sürükleme tüm sütunları birlikte kaydırır: $width',
      (tester) async {
        tester.view.physicalSize = Size(width, 820);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final columns = [
          for (var i = 0; i < 6; i++)
            TableColumnState(
              TableField(id: 'c$i', name: 'Alan $i'),
              230,
              false,
              'text',
            ),
        ];
        final data = TableWorkspace(
          document: TableDocument(
            id: 't',
            title: 'Plan',
            area: TableArea.personal,
            fields: columns.map((c) => c.field).toList(),
            rows: [TableRecord(id: 'r')],
          ),
          schema: 1,
          sequence: 1,
          columns: columns,
          cells: const [
            TableCellState(
              row: 'r',
              column: 'c0',
              value: 'İlk hücre',
              display: 'İlk hücre',
              version: 1,
            ),
          ],
        );
        var opened = false;
        await tester.pumpWidget(
          testApp(
            Scaffold(
              body: SingleChildScrollView(
                child: TableWorkspaceGrid(
                  data: data,
                  onCell: (_, _) {},
                  onRow: (_) => opened = true,
                  onColumn: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final number = find.byKey(const ValueKey(('table-row-number', 'r')));
        final heading = find.byKey(const ValueKey('table-row-number-header'));
        final cell = find.text('İlk hücre');
        final before = tester.getTopLeft(number);
        final cellBefore = tester.getTopLeft(cell);
        final headingBefore = tester.getTopLeft(heading);
        await tester.drag(number, const Offset(-180, 0));
        await tester.pumpAndSettle();
        final shift = tester.getTopLeft(number).dx - before.dx;
        expect(shift, lessThan(-100));
        expect(tester.getTopLeft(cell).dx - cellBefore.dx, closeTo(shift, .1));
        expect(
          tester.getTopLeft(heading).dx - headingBefore.dx,
          closeTo(shift, .1),
        );
        expect(opened, isFalse);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
