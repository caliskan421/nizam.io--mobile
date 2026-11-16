import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/ui/widgets/buttons/buttons.dart';
import 'package:nizamio/core/ui/widgets/inputs/inputs.dart';
import 'package:nizamio/core/ui/widgets/overlays/nz_bottom_sheet.dart';
import 'package:nizamio/features/tables/application/tables_server.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import 'router_test_support.dart';
import 'tables_backend_flow_test.dart' show ListRepository;

const teamChoices = TableSharingChoices(
  accountId: 'me',
  people: {
    TablePersonId('a'): 'Ali',
    TablePersonId('b'): 'Banu',
    TablePersonId('c'): 'Cem',
    TablePersonId('admin'): 'Dış admin',
  },
  roles: {
    TablePersonId('a'): TableSharingRole.coordinator,
    TablePersonId('b'): TableSharingRole.member,
    TablePersonId('c'): TableSharingRole.member,
    TablePersonId('admin'): TableSharingRole.admin,
  },
  departments: {TableDepartmentId('d1'): 'Ekip A'},
  directDepartments: {'d1'},
  memberships: {
    TablePersonId('a'): {'d1'},
    TablePersonId('b'): {'d1'},
    TablePersonId('c'): {'d1'},
  },
);

void main() {
  setUpFonts();
  for (final size in [const Size(390, 844), const Size(1180, 820)]) {
    testWidgets(
      'ekip seçili kalır; kişiye yetki değiştirilebilir ve kişi çıkarılabilir: $size',
      (tester) async {
        final repo = ListRepository()..failGrant = false;
        final phase = ValueNotifier(AppPhase.scoped);
        addTearDown(phase.dispose);
        final router = await pumpRouter(
          tester,
          phase,
          width: size.width,
          height: size.height,
          tablePrototype: false,
          overrides: [
            tablesRepositoryProvider.overrideWithValue(repo),
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
        await tester.tap(find.bySemanticsLabel('Yeni tablo').first);
        await settle(tester);
        await tester.enterText(find.byType(EditableText).last, 'Ekip planı');
        await settle(tester);
        await tester.tap(find.text('Paylaşım'));
        await settle(tester);
        await tester.tap(find.text('Koordinatörlük').last);
        await settle(tester);
        await tester.ensureVisible(find.text('Tablonun koordinatörlüğü'));
        await tester.tap(find.text('Tablonun koordinatörlüğü'));
        await settle(tester);
        await tester.ensureVisible(find.text('Ekip A').last);
        await tester.tap(find.text('Ekip A').last);
        await settle(tester);
        await tester.ensureVisible(find.text('Tüm ekip'));
        await tester.tap(find.text('Tüm ekip'));
        await settle(tester);
        for (final name in ['Ali', 'Banu', 'Cem']) {
          expect(
            find.byWidgetPredicate(
              (w) =>
                  w is NzPillTabs && w.semanticLabel == '$name erişim yetkisi',
            ),
            findsOneWidget,
          );
        }
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is NzPillTabs &&
                w.semanticLabel == 'Dış admin erişim yetkisi',
          ),
          findsNothing,
        );
        final ali = find.descendant(
          of: find.byWidgetPredicate(
            (w) => w is NzPillTabs && w.semanticLabel == 'Ali erişim yetkisi',
          ),
          matching: find.text('Düzenleme'),
        );
        await tester.ensureVisible(ali);
        await tester.tap(ali);
        await settle(tester);
        final remove = find.byWidgetPredicate(
          (w) =>
              w is NzIconButton && w.semanticLabel == 'Cem paylaşımını kaldır',
        );
        await tester.ensureVisible(remove);
        await tester.tap(remove);
        await settle(tester);
        expect(repo.calls, isEmpty);
        await tester.tap(find.text('Oluştur'));
        await settle(tester);
        expect(repo.grants.map((g) => (g.person, g.access)).toSet(), {
          ('a', TableAccess.edit),
          ('b', TableAccess.view),
        });
        expect(repo.calls.map((c) => c.$1), [
          'create',
          'column:1',
          'grant',
          'grant',
        ]);
        expect(tester.takeException(), isNull);
      },
    );
    testWidgets(
      'koordinatörlük değişimi eski kişileri ayıklar ve tek konuma kaydeder: $size',
      (tester) async {
        final repo = ListRepository()..failGrant = false;
        final phase = ValueNotifier(AppPhase.scoped);
        addTearDown(phase.dispose);
        final choices = TableSharingChoices(
          accountId: 'me',
          people: {...teamChoices.people, const TablePersonId('d'): 'Deniz'},
          roles: teamChoices.roles,
          departments: const {
            TableDepartmentId('d1'): 'Ekip A',
            TableDepartmentId('d2'): 'Ekip B',
          },
          directDepartments: const {'d1', 'd2'},
          memberships: {
            ...teamChoices.memberships,
            const TablePersonId('b'): {'d1', 'd2'},
            const TablePersonId('d'): {'d2'},
          },
        );
        final router = await pumpRouter(
          tester,
          phase,
          width: size.width,
          height: size.height,
          tablePrototype: false,
          overrides: [
            tablesRepositoryProvider.overrideWithValue(repo),
            tableSharingChoicesProvider.overrideWith((ref) async => choices),
            scopeStateProvider.overrideWith(
              (ref) => const ScopeSelection(programId: 'p1'),
            ),
            sessionGenerationProvider.overrideWith((ref) => 1),
          ],
        );
        router.go('/tables');
        await settle(tester);
        await tester.tap(find.bySemanticsLabel('Yeni tablo').first);
        await settle(tester);
        await tester.enterText(find.byType(EditableText).last, 'Ekip değişimi');
        await settle(tester);
        await tester.tap(find.text('Paylaşım'));
        await settle(tester);
        await tester.tap(find.text('Koordinatörlük').last);
        await settle(tester);
        Future<void> choose(String label) async {
          final field = find.text('Tablonun koordinatörlüğü');
          await tester.ensureVisible(field);
          await tester.tap(field);
          await settle(tester);
          await tester.tap(find.text(label).last);
          await settle(tester);
        }

        await choose('Ekip A');
        final sheet = find.byType(NzBottomSheetContent);
        expect(
          find.descendant(of: sheet, matching: find.text('Ekip B')),
          findsNothing,
        );
        await tester.ensureVisible(find.text('Tüm ekip'));
        await tester.tap(find.text('Tüm ekip'));
        await settle(tester);
        await choose('Ekip B');
        expect(
          tester.widget<NzSelect<String>>(find.byType(NzSelect<String>)).value,
          'd2',
        );
        expect(
          find.descendant(of: sheet, matching: find.text('Ekip A')),
          findsNothing,
        );
        Finder permission(String name) => find.byWidgetPredicate(
          (w) => w is NzPillTabs && w.semanticLabel == '$name erişim yetkisi',
        );
        expect(permission('Ali'), findsNothing);
        expect(permission('Cem'), findsNothing);
        expect(permission('Banu'), findsOneWidget);
        expect(permission('Deniz'), findsNothing);
        expect(repo.calls, isEmpty);
        await tester.tap(find.text('Oluştur'));
        await settle(tester);
        expect(repo.createdLocation!.departmentId, 'd2');
        expect(repo.grants.map((g) => (g.person, g.access)).toSet(), {
          ('b', TableAccess.view),
        });
        expect(repo.calls.map((c) => c.$1), ['create', 'column:1', 'grant']);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
