import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';
import 'package:nizamio/core/ui/widgets/buttons/buttons.dart';
import 'package:nizamio/core/ui/widgets/lists/nz_menu_group.dart';
import 'package:nizamio/core/ui/widgets/overlays/nz_bottom_sheet.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';
import 'package:nizamio/features/tables/presentation/table_design.dart';
import 'package:nizamio/features/tables/presentation/table_linked_targets.dart';
import 'package:nizamio/features/tables/presentation/table_workspace_grid.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';
import 'table_workspace_flow_test.dart' show WorkspaceServer, openWorkspace;

class LinkedServer extends WorkspaceServer {
  LinkedServer(this.multiple) {
    columns
      ..clear()
      ..add(
        TableColumnState(
          const TableField(
            id: 'link',
            name: 'Bağlı tablo',
            type: TableFieldType.link,
          ),
          240,
          multiple,
          'table_reference',
        ),
      );
    rows.add(TableRecord(id: 'r1'));
  }
  final bool multiple;
  bool denied = false;
  final reads = <String>[];
  TableDocument target(String id) => TableDocument(
    id: id,
    title: id == 't2' ? 'Birinci · İlişki' : 'İkinci tablo',
    area: TableArea.personal,
    fields: const [],
    unit: '',
    programId: 'p1',
    ownerId: 'me',
    remote: true,
  );
  @override
  Future<List<TableDocument>> list(TableLocation l, String account) async =>
      l.personal ? [document, target('t2'), target('t3')] : [];
  @override
  Future<TableWorkspace> workspace(
    TableLocation l,
    String id,
    String account, {
    TableReadQuery query = const TableReadQuery(),
  }) async {
    reads.add(id);
    if (id != 't1') {
      if (denied) throw ApiError('tables.not_found', status: 404);
      return TableWorkspace(
        document: target(id),
        schema: 1,
        sequence: 1,
        columns: const [],
        cells: const [],
      );
    }
    return TableWorkspace(
      document: document,
      schema: 1,
      sequence: 1,
      columns: columns,
      cells: [
        TableCellState(
          row: 'r1',
          column: 'link',
          value: multiple ? ['t2', null, 't3', 'unresolved'] : 't2',
          display: multiple
              ? 'Birinci · İlişki · — · İkinci tablo · —'
              : 'Birinci · İlişki',
          redacted: multiple,
          version: 1,
        ),
      ],
      linkedTables: const {
        TableDocumentId('t2'): 'Birinci · İlişki',
        TableDocumentId('t3'): 'İkinci tablo',
      },
    );
  }
}

void main() {
  setUpFonts();
  for (final size in [const Size(390, 844), const Size(1180, 820)]) {
    for (final multiple in [false, true]) {
      testWidgets(
        'bağlı hücre sheetinden tablo açılır; gizli hedef açılmaz: $size $multiple',
        (tester) async {
          final server = LinkedServer(multiple);
          final phase = ValueNotifier(AppPhase.scoped);
          addTearDown(phase.dispose);
          await openWorkspace(tester, server, phase, size);
          final cell = find
              .descendant(
                of: find.byType(TableWorkspaceGrid),
                matching: find.textContaining('Birinci'),
              )
              .first;
          await tester.tap(cell);
          await settle(tester);
          expect(find.byType(TableLinkedTargets), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(TableLinkedTargets),
              matching: find.text('Birinci · İlişki'),
            ),
            findsOneWidget,
          );
          expect(
            find.descendant(
              of: find.byType(TableLinkedTargets),
              matching: find.text('İkinci tablo'),
            ),
            multiple ? findsOneWidget : findsNothing,
          );
          expect(find.text('unresolved'), findsNothing);
          final target = multiple ? 'İkinci tablo' : 'Birinci · İlişki';
          await tester.tap(
            find.descendant(
              of: find.byType(TableLinkedTargets),
              matching: find.widgetWithText(NzMenuRow, target),
            ),
          );
          await settle(tester);
          expect(server.reads.last, multiple ? 't3' : 't2');
          expect(find.byType(NzBottomSheetContent), findsNothing);
          expect(server.edits, isEmpty);
          await tester.tap(
            find.byWidgetPredicate(
              (w) => w is NzIconButton && w.semanticLabel == 'Geri',
            ),
          );
          await settle(tester);
          expect(
            tester
                .widget<TableWorkspaceGrid>(find.byType(TableWorkspaceGrid))
                .data
                .document
                .id,
            't1',
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
  for (final size in [const Size(390, 844), const Size(1180, 820)]) {
    testWidgets(
      'başlıktaki bağlantı ve iç içe tablolarda sistem geri kaynağı korur: $size',
      (tester) async {
        final server = LinkedServer(false);
        final phase = ValueNotifier(AppPhase.scoped);
        addTearDown(phase.dispose);
        await openWorkspace(tester, server, phase, size);
        final appbarX = tester.getTopLeft(find.text('Çalışma tablosu')).dx;
        await tester.tap(
          find.widgetWithText(TableDesignButton, 'Birinci · İlişki'),
        );
        await settle(tester);
        expect(
          tester
              .widget<TableWorkspaceGrid>(find.byType(TableWorkspaceGrid))
              .data
              .document
              .id,
          't2',
        );
        tester
            .element(find.byType(TableWorkspaceGrid))
            .appNav
            .openLinkedTable('t3');
        await settle(tester);
        expect(
          tester
              .widget<TableWorkspaceGrid>(find.byType(TableWorkspaceGrid))
              .data
              .document
              .id,
          't3',
        );
        await tester.binding.handlePopRoute();
        await tester.pump();
        expect(
          tester.getTopLeft(find.text('Birinci · İlişki')).dx,
          closeTo(appbarX, .1),
        );
        await tester.pump(const Duration(milliseconds: 80));
        expect(
          tester.getTopLeft(find.text('Birinci · İlişki')).dx,
          closeTo(appbarX, .1),
        );
        await settle(tester);
        expect(
          tester
              .widget<TableWorkspaceGrid>(find.byType(TableWorkspaceGrid))
              .data
              .document
              .id,
          't2',
        );
        await tester.binding.handlePopRoute();
        await settle(tester);
        expect(
          tester
              .widget<TableWorkspaceGrid>(find.byType(TableWorkspaceGrid))
              .data
              .document
              .id,
          't1',
        );
        expect(server.edits, isEmpty);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('erişimi sonradan kaldırılan hedefte backend reddi gösterilir', (
    tester,
  ) async {
    final server = LinkedServer(false);
    final phase = ValueNotifier(AppPhase.scoped);
    addTearDown(phase.dispose);
    await openWorkspace(tester, server, phase, const Size(390, 844));
    await tester.tap(
      find
          .descendant(
            of: find.byType(TableWorkspaceGrid),
            matching: find.textContaining('Birinci'),
          )
          .first,
    );
    await settle(tester);
    server.denied = true;
    await tester.tap(
      find.descendant(
        of: find.byType(TableLinkedTargets),
        matching: find.widgetWithText(NzMenuRow, 'Birinci · İlişki'),
      ),
    );
    await settle(tester);
    expect(server.reads.last, 't2');
    expect(find.byType(TableWorkspaceGrid), findsNothing);
    expect(server.edits, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
