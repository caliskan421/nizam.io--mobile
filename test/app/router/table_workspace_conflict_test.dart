import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/ui/widgets/buttons/buttons.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_edit.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/presentation/table_workspace_grid.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';
import 'table_workspace_flow_test.dart' show WorkspaceServer, openWorkspace;

void main() {
  setUpFonts();
  for (final size in [const Size(360, 640), const Size(1180, 820)]) {
    testWidgets(
      'satır formu yalnız değişen hücreleri tek batch gönderir: $size',
      (tester) async {
        final server = WorkspaceServer()..rows.add(TableRecord(id: 'r1'));
        server.columns.addAll([
          const TableColumnState(
            TableField(id: 'c2', name: 'Not'),
            180,
            false,
            'text',
          ),
          const TableColumnState(
            TableField(id: 'c3', name: 'Korunan'),
            180,
            false,
            'text',
          ),
        ]);
        server.cells.add(
          const TableCellState(
            row: 'r1',
            column: 'c3',
            value: 'Dokunulmadı',
            display: 'Dokunulmadı',
            version: 8,
          ),
        );
        final phase = ValueNotifier(AppPhase.scoped);
        addTearDown(phase.dispose);
        await openWorkspace(tester, server, phase, size);
        await tester.tap(
          find
              .descendant(
                of: find.byType(TableWorkspaceGrid),
                matching: find.text('1'),
              )
              .first,
        );
        await settle(tester);
        await tester.tap(find.text('Satırı düzenle'));
        await settle(tester);
        await tester.enterText(find.byType(EditableText).last, 'Başlık');
        await tester.tap(find.text('Not').last);
        await settle(tester);
        await tester.enterText(find.byType(EditableText).last, 'Açıklama');
        await settle(tester);
        await tester.tap(find.text('Bitti'));
        await settle(tester);
        await tester.tap(find.text('Kaydet'));
        await settle(tester);
        final writes = server.edits
            .where((e) => e.edit is WriteTableCells)
            .toList();
        expect(writes, hasLength(1));
        expect(
          (writes.single.edit as WriteTableCells).cells
              .map((c) => c.column)
              .toSet(),
          {'c1', 'c2'},
        );
        expect(server.cells.where((c) => c.column == 'c3').single.version, 8);
        expect(tester.takeException(), isNull);
      },
    );
    testWidgets(
      'çakışma taslağı korur, karşılaştırma ve açık onay ister: $size',
      (tester) async {
        final server = WorkspaceServer()..rows.add(TableRecord(id: 'r1'));
        server.cells.add(
          const TableCellState(
            row: 'r1',
            column: 'c1',
            value: 'İlk',
            display: 'İlk',
            version: 1,
          ),
        );
        final phase = ValueNotifier(AppPhase.scoped);
        addTearDown(phase.dispose);
        await openWorkspace(tester, server, phase, size);
        await tester.tap(find.text('İlk'));
        await settle(tester);
        await tester.enterText(
          find.byType(EditableText).last,
          'Benim taslağım',
        );
        server.cells[0] = const TableCellState(
          row: 'r1',
          column: 'c1',
          value: 'Başkasının kaydı',
          display: 'Başkasının kaydı',
          version: 2,
        );
        await settle(tester);
        await tester.tap(find.text('Kaydet'));
        await settle(tester);
        expect(server.cells.single.value, 'Başkasının kaydı');
        expect(find.text('Benim taslağım'), findsOneWidget);
        await tester.tap(find.text('Güncel hücreleri karşılaştır'));
        await settle(tester);
        expect(find.text('Ad: Başkasının kaydı'), findsOneWidget);
        final button = tester.widget<NzButton>(
          find.widgetWithText(NzButton, 'Kaydet'),
        );
        expect(button.onPressed, isNull);
        final ack = find.text(
          'Güncel değerlerin yerine taslağımdaki değişiklikleri kaydet',
        );
        await tester.ensureVisible(ack);
        await tester.tap(ack);
        await settle(tester);
        await tester.tap(find.text('Kaydet'));
        await settle(tester);
        expect(server.cells.single.value, 'Benim taslağım');
        expect(server.cells.single.version, 3);
        expect(
          (server.edits.last.edit as WriteTableCells).cells.single.version,
          2,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
