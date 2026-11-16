import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/ui/widgets/buttons/buttons.dart';
import 'package:nizamio/core/ui/widgets/inputs/inputs.dart';
import 'package:nizamio/features/tables/application/tables_controller.dart';
import 'package:nizamio/features/tables/application/tables_server.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_edit.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';
import 'package:nizamio/features/tables/presentation/tables_page.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';
import 'table_team_selection_test.dart' show teamChoices;
import 'table_workspace_flow_test.dart' show WorkspaceServer;

class TeamServer extends WorkspaceServer {
  var team = TableAccess.edit;
  final explicit = <String, TableAccess>{};
  @override
  TableDocument get document => TableDocument(
    id: 't1',
    title: 'Ekip tablosu',
    area: TableArea.coord,
    unit: 'd1',
    programId: 'p1',
    ownerId: 'me',
    remote: true,
    fields: [for (final c in columns) c.field],
    teamAccess: team,
  );
  @override
  Future<List<TableDocument>> list(TableLocation l, String account) async =>
      l.departmentId == 'd1' ? [document] : [];
  @override
  Future<TableOperationReceipt> execute(
    TableLocation l,
    String id,
    TableEdit edit,
    String key,
  ) async {
    expect(l, const TableLocation('p1', 'd1'));
    edits.add((edit: edit, key: key));
    if (edit is GrantTableAccess) {
      if (edit.access == TableAccess.off) {
        explicit.remove(edit.account);
      } else {
        explicit[edit.account] = edit.access;
      }
    }
    if (edit is SetTableTeam) team = edit.access;
    return TableOperationReceipt(
      table: id,
      sequence: ++sequence,
      schema: schema,
    );
  }
}

void main() {
  setUpFonts();
  for (final size in [const Size(390, 844), const Size(1180, 820)]) {
    testWidgets(
      'dinamik ekip seçili gelir; iptal yazmaz, kişisel değişim ekibi korur: $size',
      (tester) async {
        final server = TeamServer();
        final phase = ValueNotifier(AppPhase.scoped);
        addTearDown(phase.dispose);
        final router = await pumpRouter(
          tester,
          phase,
          width: size.width,
          height: size.height,
          tablePrototype: false,
          overrides: [
            tablesRepositoryProvider.overrideWithValue(server),
            tableSharingChoicesProvider.overrideWith(
              (ref) async => teamChoices,
            ),
            scopeStateProvider.overrideWith(
              (ref) => const ScopeSelection(programId: 'p1'),
            ),
            sessionGenerationProvider.overrideWith((ref) => 1),
          ],
        );
        router.go('/tables');
        await settle(tester);
        final container = ProviderScope.containerOf(
          tester.element(find.byType(TablesPage)),
        );
        final controller = container.read(tablesControllerProvider.notifier);
        controller.setArea(TableArea.coord);
        controller.setUnit('d1');
        await settle(tester);
        await tester.tap(find.text('Ekip tablosu'));
        await settle(tester);
        await tester.tap(find.byKey(const ValueKey('table-sharing-people')));
        await settle(tester);
        Finder permission(String name) => find.byWidgetPredicate(
          (w) => w is NzPillTabs && w.semanticLabel == '$name erişim yetkisi',
        );
        expect(permission('Ali'), findsOneWidget);
        expect(permission('Banu'), findsOneWidget);
        expect(permission('Cem'), findsOneWidget);
        expect(permission('Dış admin'), findsNothing);
        Future<void> downgrade() async {
          final view = find.descendant(
            of: permission('Banu'),
            matching: find.text('Görür'),
          );
          await tester.ensureVisible(view);
          await tester.tap(view);
          await settle(tester);
        }

        await downgrade();
        expect(server.edits, isEmpty);
        await tester.tap(find.text('Vazgeç'));
        await settle(tester);
        expect(server.edits, isEmpty);
        await downgrade();
        await tester.tap(find.text('Kişi bazında uygula'));
        await settle(tester);
        expect(server.team, TableAccess.off);
        expect(server.explicit, {
          'a': TableAccess.edit,
          'b': TableAccess.view,
          'c': TableAccess.edit,
        });
        expect(server.edits.last.edit, isA<SetTableTeam>());
        expect(permission('Ali'), findsOneWidget);
        expect(permission('Banu'), findsOneWidget);
        final remove = find.byWidgetPredicate(
          (w) => w is NzIconButton && w.semanticLabel == 'Cem erişimini kaldır',
        );
        await tester.ensureVisible(remove);
        await tester.tap(remove);
        await settle(tester);
        expect(server.explicit, {'a': TableAccess.edit, 'b': TableAccess.view});
        expect(tester.takeException(), isNull);
      },
    );
  }
}
