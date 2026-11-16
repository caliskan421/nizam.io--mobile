import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/ui/widgets/buttons/buttons.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_edit.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/presentation/table_grid_value.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';
import 'table_workspace_flow_test.dart' show WorkspaceServer, openWorkspace;

void main() {
  setUpFonts();
  for (final size in [const Size(390, 844), const Size(1180, 820)]) {
    for (final (type, invalid, valid) in [
      (TableFieldType.email, 'yanlis@', 'ad@ornek.com'),
      (TableFieldType.phone, 'abc123', '+90 (532) 123-45-67'),
    ]) {
      testWidgets(
        '$type hatalı hücre yazılmaz, düzeltilince kaydedilir: $size',
        (tester) async {
          final server = WorkspaceServer();
          server.columns[0] = TableColumnState(
            TableField(id: 'c1', name: 'İletişim', type: type),
            240,
            false,
            type.name,
          );
          server.rows.add(TableRecord(id: 'r1'));
          final phase = ValueNotifier(AppPhase.scoped);
          addTearDown(phase.dispose);
          await openWorkspace(tester, server, phase, size);
          final cell = find.byType(TableGridValue).first;
          await tester.ensureVisible(cell);
          await tester.tap(cell);
          await settle(tester);
          await tester.enterText(find.byType(EditableText).last, invalid);
          await settle(tester);
          final save = find.byWidgetPredicate(
            (w) => w is NzButton && w.label == 'Kaydet',
          );
          expect(tester.widget<NzButton>(save).onPressed, isNull);
          expect(server.edits, isEmpty);
          await tester.enterText(find.byType(EditableText).last, ' $valid ');
          await settle(tester);
          expect(tester.widget<NzButton>(save).onPressed, isNotNull);
          await tester.tap(save);
          await settle(tester);
          final edit = server.edits.single.edit as WriteTableCells;
          expect(edit.cells.single.value, valid);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
