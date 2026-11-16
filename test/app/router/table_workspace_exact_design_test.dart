import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/ui/widgets/buttons/buttons.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_select.dart';
import 'package:nizamio/features/tables/application/tables_server.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/presentation/table_design.dart';
import 'package:nizamio/features/tables/presentation/table_workspace_grid.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';
import 'table_workspace_flow_test.dart' show WorkspaceServer, openWorkspace;
import 'users_tables_flow_test.dart' show sheetPng;

const exactChoices = TableSharingChoices(
  accountId: 'me',
  accountName: 'Kadir Özbek',
  people: {
    TablePersonId('admin'): 'Muhammet Ali Çalışkan',
    TablePersonId('ali'): 'Ali Avcı',
    TablePersonId('abdullah'): 'Abdullah Ateş',
    TablePersonId('reha'): 'Reha Koçak',
  },
  departments: {
    TableDepartmentId('infra'): 'Altyapı ve tesisat',
    TableDepartmentId('system'): 'Sistem koordinatörlüğü',
    TableDepartmentId('electric'): 'Elektrik ve enerji',
  },
  directDepartments: {'infra'},
  memberships: {
    TablePersonId('me'): {'infra'},
    TablePersonId('admin'): {'system'},
    TablePersonId('ali'): {'infra'},
    TablePersonId('abdullah'): {'infra'},
    TablePersonId('reha'): {'electric'},
  },
  roles: {
    TablePersonId('me'): TableSharingRole.coordinator,
    TablePersonId('admin'): TableSharingRole.admin,
    TablePersonId('ali'): TableSharingRole.coordinator,
    TablePersonId('abdullah'): TableSharingRole.coordinator,
    TablePersonId('reha'): TableSharingRole.coordinator,
  },
);

class ExactServer extends WorkspaceServer {
  ExactServer() {
    columns.clear();
    columns.addAll([
      const TableColumnState(
        TableField(id: 'c1', name: 'Adım'),
        220,
        false,
        'text',
      ),
      const TableColumnState(
        TableField(id: 'person', name: 'Sorumlu', type: TableFieldType.person),
        166,
        false,
        'person_reference',
      ),
      const TableColumnState(
        TableField(id: 'task', name: 'Görev', type: TableFieldType.task),
        220,
        false,
        'task_reference',
      ),
      const TableColumnState(
        TableField(id: 'date', name: 'Son tarih', type: TableFieldType.date),
        132,
        false,
        'date',
      ),
      const TableColumnState(
        TableField(id: 'file', name: 'Kanıt', type: TableFieldType.file),
        190,
        true,
        'file_reference',
      ),
      const TableColumnState(
        TableField(id: 'done', name: 'Tamam', type: TableFieldType.todo),
        86,
        false,
        'checkbox',
      ),
    ]);
    final titles = [
      'Pompaların sahaya teslimi',
      'Vinç ve elektrik bağlantısı kontrolü',
      'Montaj ekibinin saha planı',
      'Basınç testi',
      'Teslim tutanağı',
    ];
    final people = [
      'Kadir Özbek',
      'Reha Koçak',
      'Ali Avcı',
      'Abdullah Ateş',
      'Kadir Özbek',
    ];
    final dates = [
      '2026-10-28',
      '2026-10-27',
      '2026-10-26',
      '2026-10-30',
      '2026-11-02',
    ];
    for (var i = 0; i < 5; i++) {
      final row = 'r${i + 1}';
      rows.add(TableRecord(id: row));
      void cell(String col, Object? value, String label) => cells.add(
        TableCellState(
          row: row,
          column: col,
          value: value,
          display: label,
          version: 1,
        ),
      );
      cell('c1', titles[i], titles[i]);
      cell('person', 'p${i == 4 ? 0 : i}', people[i]);
      cell(
        'task',
        'task$i',
        i < 2
            ? 'Havalimanı yerleşkesi hidrofor sistemi'
            : i < 4
            ? 'Montaj, test ve devreye alma'
            : 'Söküm ve altyapı devri',
      );
      cell('date', dates[i], dates[i]);
      cell('done', false, '—');
      if (i == 0) {
        cell('file', ['f1'], 'WhatsApp Image 2026.pdf');
      }
      if (i == 1) {
        cell('file', ['f2', 'f3'], 'WhatsApp Image.pdf · İklimlendirme.pdf');
      }
    }
  }
  @override
  TableDocument get document => TableDocument(
    id: 't1',
    title: 'Hidrofor montaj kontrol listesi',
    area: TableArea.personal,
    fields: [for (final c in columns) c.field],
    rows: rows,
    remote: true,
    programId: 'p1',
    ownerId: 'me',
    unit: 'infra',
    people: {
      const TablePersonId('admin'): TableAccess.edit,
      const TablePersonId('ali'): TableAccess.edit,
      const TablePersonId('abdullah'): TableAccess.edit,
      const TablePersonId('reha'): TableAccess.view,
    },
  );
}

Future<void> shot(WidgetTester tester, String name, Size size) async {
  File('/tmp/nizam-exact-$name-${size.width.toInt()}.png')
      .writeAsBytesSync(await sheetPng(tester));
}

void main() {
  setUpFonts();
  for (final size in [const Size(390, 844), const Size(1180, 820)]) {
    testWidgets(
      'beş referans ekranı ve iptal/gizleme/sıralama davranışı: $size',
      (tester) async {
        final server = ExactServer();
        final phase = ValueNotifier(AppPhase.scoped);
        addTearDown(phase.dispose);
        await openWorkspace(
          tester,
          server,
          phase,
          size,
          dark: true,
          choices: exactChoices,
        );
        await shot(tester, 'table', size);
        await tester.tap(find.widgetWithText(TableDesignButton, 'Yeni satır'));
        await settle(tester);
        await shot(tester, 'new-row', size);
        expect(server.rows, hasLength(5));
        await tester.tap(find.text('Vazgeç'));
        await settle(tester);
        expect(server.rows, hasLength(5));
        await tester.tap(find.byKey(const ValueKey('table-sharing-people')));
        await settle(tester);
        await shot(tester, 'share', size);
        expect(find.text('Programdaki herkes'), findsOneWidget);
        await tester.tap(find.widgetWithText(TableDesignButton, 'Kapat'));
        await settle(tester);
        await tester.tap(find.widgetWithText(TableDesignButton, 'Sütunlar'));
        await settle(tester);
        await shot(tester, 'columns', size);
        final hide = find.byWidgetPredicate(
          (w) => w is NzIconButton && w.semanticLabel == 'Kanıt gizle',
        );
        await tester.ensureVisible(hide);
        await tester.tap(hide);
        await settle(tester);
        await tester.tap(find.widgetWithText(TableDesignButton, 'Bitti'));
        await settle(tester);
        expect(
          find.descendant(
            of: find.byType(TableWorkspaceGrid),
            matching: find.text('Kanıt'),
          ),
          findsNothing,
        );
        await tester.tap(find.widgetWithText(TableDesignButton, 'Sütunlar'));
        await settle(tester);
        final show = find.byWidgetPredicate(
          (w) => w is NzIconButton && w.semanticLabel == 'Kanıt göster',
        );
        await tester.ensureVisible(show);
        await tester.tap(show);
        await settle(tester);
        await tester.tap(
          find.byWidgetPredicate(
            (w) =>
                w is NzIconButton && w.semanticLabel == 'Adım sütununu düzenle',
          ),
        );
        await settle(tester);
        await shot(tester, 'column', size);
        await tester.enterText(find.byType(EditableText).last, 'Kontrol adımı');
        await settle(tester);
        await tester.tap(find.widgetWithText(TableDesignButton, 'Bitti').last);
        await settle(tester);
        expect(server.columns.first.field.name, 'Kontrol adımı');
        final before = server.edits.length;
        final addColumn = find.widgetWithText(TableDesignButton, 'Sütun ekle');
        await tester.ensureVisible(addColumn);
        await tester.tap(addColumn);
        await settle(tester);
        await tester.tap(find.byType(NzSelect<TableFieldType>));
        await settle(tester);
        await shot(tester, 'column-type', size);
        await tester.tap(find.text('Sayı').last);
        await settle(tester);
        await tester.tap(find.text('Vazgeç'));
        await settle(tester);
        expect(server.edits.length, before);

        expect(tester.takeException(), isNull);
      },
    );
  }
}
