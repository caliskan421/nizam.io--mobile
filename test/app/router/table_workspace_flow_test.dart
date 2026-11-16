import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/ui/widgets/buttons/buttons.dart';
import 'package:nizamio/features/tables/application/tables_server.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_edit.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../features/tables/application/table_create_job_test.dart'
    show RecordingRepository;
import 'router_test_support.dart';
import 'users_tables_flow_test.dart' show sheetPng;

class WorkspaceServer extends RecordingRepository {
  final edits = <({TableEdit edit, String key})>[];
  final cells = <TableCellState>[];
  final rows = <TableRecord>[];
  final columns = <TableColumnState>[
    const TableColumnState(
      TableField(id: 'c1', name: 'Ad'),
      180,
      false,
      'text',
    ),
  ];
  int sequence = 1;
  int schema = 1;
  ApiError? failure;
  bool loseReply = false;
  final receipts = <String, TableOperationReceipt>{};
  TableDocument get document => TableDocument(
    id: 't1',
    title: 'Çalışma tablosu',
    area: TableArea.personal,
    fields: [for (final c in columns) c.field],
    rows: rows,
    unit: '',
    remote: true,
    programId: 'p1',
    ownerId: 'me',
  );
  @override
  Future<List<TableDocument>> list(TableLocation l, String account) async =>
      l.personal ? [document] : [];
  @override
  Future<TableWorkspace> workspace(
    TableLocation l,
    String id,
    String account, {
    TableReadQuery query = const TableReadQuery(),
  }) async => TableWorkspace(
    document: document,
    schema: schema,
    sequence: sequence,
    columns: List.of(columns),
    cells: List.of(cells),
  );
  @override
  Stream<TableLiveEvent> watch(TableLocation l, String id) =>
      const Stream.empty();
  @override
  Future<void> presence(
    TableLocation l,
    String id, {
    String? row,
    String? column,
    bool leave = false,
  }) async {}
  @override
  Future<TableChangePage> changes(
    TableLocation l,
    String id,
    int after,
  ) async => TableChangePage([], sequence, sequence, false);
  @override
  Future<TableOperationReceipt> execute(
    TableLocation l,
    String id,
    TableEdit edit,
    String key,
  ) async {
    edits.add((edit: edit, key: key));
    if (receipts[key] case final previous?) return previous;
    if (failure case final e?) throw e;
    String? created;
    switch (edit) {
      case AddTableRow():
        created = 'r${rows.length + 1}';
        rows.add(TableRecord(id: created));
      case WriteTableCells(:final cells):
        for (final c in cells) {
          final old = this.cells
              .where((v) => v.row == c.row && v.column == c.column)
              .firstOrNull;
          if (c.version != (old?.version ?? 0)) {
            throw ApiError('tables.cell_conflict', status: 409);
          }
        }
        for (final c in cells) {
          final old = this.cells
              .where((v) => v.row == c.row && v.column == c.column)
              .firstOrNull;
          this.cells.remove(old);
          this.cells.add(
            TableCellState(
              row: c.row,
              column: c.column,
              value: c.value,
              display: c.value?.toString() ?? '—',
              version: c.version + 1,
            ),
          );
        }
      case EditTableColumn():
        if (edit.schema != schema) {
          throw ApiError('tables.schema_conflict', status: 409);
        }
        if (edit.action == TableColumnAction.add) {
          created = 'c${columns.length + 1}';
          schema++;
          columns.add(
            TableColumnState(
              TableField(
                id: created,
                name: edit.field.name,
                type: edit.field.type,
              ),
              180,
              edit.multiple,
              edit.field.type.name,
            ),
          );
        } else {
          final index = columns.indexWhere((c) => c.field.id == edit.field.id);
          if (index < 0) throw ApiError('tables.column_not_found');
          final old = columns[index];
          switch (edit.action) {
            case TableColumnAction.rename:
              columns[index] = TableColumnState(
                edit.field,
                old.width,
                old.multiple,
                old.wireType,
              );
            case TableColumnAction.resize:
              columns[index] = TableColumnState(
                old.field,
                edit.width,
                old.multiple,
                old.wireType,
              );
            case TableColumnAction.convert:
              columns[index] = TableColumnState(
                edit.field,
                old.width,
                edit.multiple,
                edit.field.type.name,
              );
            case TableColumnAction.move:
              columns.removeAt(index);
              final after = edit.after == null
                  ? -1
                  : columns.indexWhere((c) => c.field.id == edit.after);
              columns.insert(after + 1, old);
            case TableColumnAction.delete:
              columns.removeAt(index);
            case TableColumnAction.add:
              break;
          }
          schema++;
        }
      default:
        break;
    }
    sequence++;
    final result = TableOperationReceipt(
      table: id,
      sequence: sequence,
      schema: schema,
      id: created,
    );
    receipts[key] = result;
    if (loseReply) {
      loseReply = false;
      throw ApiError('client.network_error');
    }
    return result;
  }
}

const workspaceChoices = TableSharingChoices(
  accountId: 'me',
  people: {},
  departments: {},
  directDepartments: {},
  memberships: {},
);

Future<void> openWorkspace(
  WidgetTester tester,
  WorkspaceServer server,
  ValueNotifier<AppPhase> phase,
  Size size, {
  bool dark = false,
  TableSharingChoices choices = workspaceChoices,
}) async {
  final router = await pumpRouter(
    tester,
    phase,
    width: size.width,
    height: size.height,
    tablePrototype: false,
    dark: dark,
    overrides: [
      tablesRepositoryProvider.overrideWithValue(server),
      tableSharingChoicesProvider.overrideWith((ref) async => choices),
      scopeStateProvider.overrideWith(
        (ref) => const ScopeSelection(programId: 'p1'),
      ),
      sessionGenerationProvider.overrideWith((ref) => 1),
    ],
  );
  router.go('/tables');
  await settle(tester);
  await tester.tap(find.text('Kişisel'));
  await settle(tester);
  await tester.scrollUntilVisible(
    find.text(server.document.title),
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await Scrollable.ensureVisible(
    tester.element(find.text(server.document.title)),
    alignment: .3,
  );
  await settle(tester);
  await tester.tap(find.text(server.document.title));
  await settle(tester);
}

void main() {
  setUpFonts();
  for (final size in [const Size(360, 640), const Size(1180, 820)]) {
    testWidgets('sütunsuz tabloda son + başlığından ilk sütun eklenir: $size', (
      tester,
    ) async {
      final server = WorkspaceServer()..columns.clear();
      final phase = ValueNotifier(AppPhase.scoped);
      addTearDown(phase.dispose);
      await openWorkspace(tester, server, phase, size);
      final addColumn = find.byWidgetPredicate(
        (w) => w is NzIconButton && w.semanticLabel == 'Sütun ekle',
      );
      expect(addColumn, findsOneWidget);
      await tester.tap(addColumn);
      await settle(tester);
      await tester.enterText(find.byType(EditableText).last, 'İlk sütun');
      await settle(tester);
      await tester.tap(find.text('Kaydet'));
      await settle(tester);
      expect(server.columns.single.field.name, 'İlk sütun');
      expect(addColumn, findsOneWidget);
      expect(tester.takeException(), isNull);
    });
    testWidgets('canlı tablo: boş durum, satır, hücre ve sütun kaydı: $size', (
      tester,
    ) async {
      final server = WorkspaceServer();
      final phase = ValueNotifier(AppPhase.scoped);
      addTearDown(phase.dispose);
      await openWorkspace(tester, server, phase, size);
      File('/tmp/nizam-workspace-initial-${size.width.toInt()}.png')
          .writeAsBytesSync(await sheetPng(tester));
      expect(find.text('İlk kaydını ekle'), findsOneWidget);
      expect(find.text('Salt okunur önizleme'), findsNothing);
      await tester.tap(find.text('Yeni satır'));
      await settle(tester);
      expect(server.rows, isEmpty);
      await tester.enterText(
        find.byType(EditableText).last,
        'Telefon ve tablette kayıt',
      );
      await settle(tester);
      await tester.tap(find.text('Ekle'));
      await settle(tester);
      expect(server.cells.single.version, 1);
      expect(find.text('Telefon ve tablette kayıt'), findsOneWidget);
      await tester.tap(find.text('Telefon ve tablette kayıt'));
      await settle(tester);
      await tester.enterText(
        find.byType(EditableText).last,
        'Güncellenen kayıt',
      );
      await settle(tester);
      await tester.tap(find.text('Kaydet'));
      await settle(tester);
      expect(server.cells.single.version, 2);
      expect(
        (server.edits.last.edit as WriteTableCells).cells.single.version,
        1,
      );
      await tester.ensureVisible(
        find.byWidgetPredicate(
          (w) => w is NzIconButton && w.semanticLabel == 'Sütun ekle',
        ),
      );
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is NzIconButton && w.semanticLabel == 'Sütun ekle',
        ),
      );
      await settle(tester);
      await tester.enterText(find.byType(EditableText).last, 'Not');
      await settle(tester);
      await tester.tap(find.text('Kaydet'));
      await settle(tester);
      expect(server.columns.last.field.name, 'Not');
      expect(server.schema, 2);
      expect(find.text('Not'), findsOneWidget);
      if (const bool.fromEnvironment('NIZAMIO_TABLET_HOST_SHOTS')) {
        File('/tmp/nizam-workspace-${size.width.toInt()}.png')
            .writeAsBytesSync(await sheetPng(tester));
      }
      expect(tester.takeException(), isNull);
    });
  }
}
