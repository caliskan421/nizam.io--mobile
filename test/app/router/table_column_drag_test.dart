import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_edit.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/presentation/table_design.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';
import 'table_workspace_flow_test.dart' show WorkspaceServer, openWorkspace;

void main() {
  setUpFonts();
  for (final size in [const Size(390, 844), const Size(1180, 820)]) {
    testWidgets(
      'sütun sürüklenirken proxy hatasızdır ve sıra backend üzerinden saklanır: $size',
      (tester) async {
        final server = WorkspaceServer();
        server.columns.addAll(const [
          TableColumnState(
            TableField(id: 'c2', name: 'Telefon', type: TableFieldType.phone),
            180,
            false,
            'phone',
          ),
          TableColumnState(
            TableField(id: 'c3', name: 'E-posta', type: TableFieldType.email),
            180,
            false,
            'email',
          ),
        ]);
        final phase = ValueNotifier(AppPhase.scoped);
        addTearDown(phase.dispose);
        await openWorkspace(tester, server, phase, size);
        await tester.tap(find.widgetWithText(TableDesignButton, 'Sütunlar'));
        await settle(tester);
        final handles = find.byType(ReorderableDragStartListener);
        final start = tester.getCenter(handles.first);
        final end = tester.getCenter(handles.at(2)) + const Offset(0, 20);
        final gesture = await tester.startGesture(start);
        await tester.pump();
        await gesture.moveTo(end);
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull);
        await gesture.up();
        await settle(tester);
        expect(tester.takeException(), isNull);
        final moves = server.edits
            .map((e) => e.edit)
            .whereType<EditTableColumn>()
            .where((e) => e.action == TableColumnAction.move);
        expect(moves, hasLength(1));
        expect(moves.single.field.id, 'c1');
        expect(moves.single.after, 'c2');
        expect(server.columns.map((c) => c.field.id), ['c2', 'c1', 'c3']);
        await tester.tap(find.widgetWithText(TableDesignButton, 'Bitti'));
        await settle(tester);
        await tester.tap(find.widgetWithText(TableDesignButton, 'Sütunlar'));
        await settle(tester);
        expect(tester.takeException(), isNull);
        expect(server.columns[1].field.id, 'c1');
      },
    );
  }
}
