import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/domain/effective_role.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/ui/widgets/buttons/buttons.dart';
import 'package:nizamio/core/ui/widgets/overlays/nz_bottom_sheet.dart';
import 'package:nizamio/features/tables/application/table_library_view.dart';
import 'package:nizamio/features/tables/application/tables_controller.dart';
import 'package:nizamio/features/tables/application/tables_server.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';
import 'package:nizamio/features/tables/presentation/tables_page.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../features/tables/application/table_create_job_test.dart'
    show RecordingRepository;
import '../../features/tables/application/table_role_choices_test.dart'
    show Catalog, catalog;
import 'router_test_support.dart';

class RoleRepository extends RecordingRepository {
  TableLocation? created;
  final locations = <TableLocation>[];
  @override
  Future<List<TableDocument>> list(TableLocation l, String account) async {
    locations.add(l);
    return [
      TableDocument(
        id: l.personal ? 'private' : 'team',
        title: l.personal ? 'Kişisel kayıt' : 'Ekip kaydı',
        area: l.personal ? TableArea.personal : TableArea.coord,
        unit: l.departmentId,
        programId: l.programId,
        ownerId: account,
        remote: true,
        fields: const [],
      ),
    ];
  }

  @override
  Future<TablePageSlice<TableProjectEntry>> projects(
    TableLocation l, {
    String? cursor,
  }) async => const TablePageSlice([], null);
  @override
  Future<TableWriteReceipt> create(TableLocation l, String name, String key) {
    created = l;
    return super.create(l, name, key);
  }
}

void main() {
  setUpFonts();
  for (final role in [SeatRole.coordinator, SeatRole.member]) {
    for (final size in [const Size(390, 844), const Size(1180, 820)]) {
      testWidgets(
        '$role $size: liste, klasör yetkisi ve koordinatörlükte oluşturma',
        (tester) async {
          final repository = RoleRepository();
          final phase = ValueNotifier(AppPhase.scoped);
          addTearDown(phase.dispose);
          final router = await pumpRouter(
            tester,
            phase,
            width: size.width,
            height: size.height,
            tablePrototype: false,
            overrides: [
              tablesRepositoryProvider.overrideWithValue(repository),
              taskCatalogControllerProvider.overrideWith(
                () => Catalog(catalog(role)),
              ),
              scopeStateProvider.overrideWith(
                (ref) => ScopeSelection(
                  programId: 'p1',
                  departmentId: 'd1',
                  role: role == SeatRole.member
                      ? EffectiveRole.member
                      : EffectiveRole.coordinator,
                ),
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
          expect(repository.locations.toSet(), {
            const TableLocation('p1'),
            const TableLocation('p1', 'd1'),
          });
          controller.setArea(TableArea.personal);
          await settle(tester);
          expect(find.text('Kişisel kayıt'), findsOneWidget);
          controller.setArea(TableArea.coord);
          controller.setUnit('d1');
          await settle(tester);
          expect(find.text('Ekip kaydı'), findsOneWidget);
          final more = find.byWidgetPredicate(
            (w) =>
                w is NzIconButton &&
                w.semanticLabel == 'Tablo görünümü ve sıralama',
          );
          await tester.ensureVisible(more);
          await tester.tap(more);
          await settle(tester);
          await tester.ensureVisible(find.text('Ad · A–Z'));
          await tester.tap(find.text('Ad · A–Z'));
          await settle(tester);
          expect(
            container
                .read(tableLibraryViewProvider(const TableLocation('p1', 'd1')))
                .sort,
            TableLibrarySort.name,
          );
          await tester.tap(more);
          await settle(tester);
          await tester.ensureVisible(find.text('Klasörleri düzenle'));
          await tester.tap(find.text('Klasörleri düzenle'));
          await settle(tester);
          expect(
            find.text('Klasör oluştur'),
            role == SeatRole.coordinator ? findsOneWidget : findsNothing,
          );
          // The member sees organization folders without receiving management rights.
          Navigator.of(tester.element(find.byType(NzBottomSheetContent))).pop();
          await settle(tester);
          final create = find.byWidgetPredicate(
            (w) => w is NzIconButton && w.semanticLabel == 'Yeni tablo',
          );
          await tester.ensureVisible(create);
          await tester.tap(create);
          await settle(tester);
          expect(
            find.descendant(
              of: find.byType(NzBottomSheetContent),
              matching: find.text('Ekip'),
            ),
            findsOneWidget,
          );
          await tester.enterText(
            find.byType(EditableText).last,
            'Rol denemesi',
          );
          await settle(tester);
          await tester.tap(find.text('Oluştur'));
          await settle(tester);
          expect(repository.created, const TableLocation('p1', 'd1'));
          expect(repository.calls.map((c) => c.$1), ['create', 'column:1']);
          expect(repository.grants, isEmpty);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
