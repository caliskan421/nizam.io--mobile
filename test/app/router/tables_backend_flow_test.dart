import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/ui/widgets/overlays/overlays.dart';
import 'package:nizamio/features/tables/application/tables_controller.dart';
import 'package:nizamio/features/tables/application/tables_server.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';
import 'package:nizamio/features/tables/presentation/tables_page.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../features/tables/application/table_create_job_test.dart'
    show RecordingRepository;
import 'router_test_support.dart';
import 'users_tables_flow_test.dart' show sheetPng;

class ListRepository extends RecordingRepository {
  TableLocation? createdLocation;
  @override
  Future<TableWriteReceipt> create(
    TableLocation l,
    String name,
    String key,
  ) async {
    createdLocation = l;
    return super.create(l, name, key);
  }

  @override
  Future<List<TableDocument>> list(TableLocation l, String account) async =>
      createdLocation?.departmentId == l.departmentId
      ? [
          TableDocument(
            id: 't1',
            title: 'Sunucu tablosu',
            area: l.personal ? TableArea.personal : TableArea.coord,
            fields: const [],
            remote: true,
            unit: l.departmentId,
            programId: 'p1',
            ownerId: account,
          ),
        ]
      : [];
}

const choices = TableSharingChoices(
  accountId: 'me',
  people: {TablePersonId('u2'): 'Gerçek Kişi'},
  departments: {TableDepartmentId('d1'): 'Gerçek Ekip'},
  directDepartments: {'d1'},
  roles: {TablePersonId('u2'): TableSharingRole.coordinator},
  memberships: {
    TablePersonId('u2'): {'d1'},
  },
);
void main() {
  setUpFonts();
  for (final fromTemplate in [false, true]) {
    testWidgets(
      'koordinatörlük içinden oluşturma konumu korur: $fromTemplate',
      (tester) async {
        final repo = ListRepository()..failGrant = false;
        final phase = ValueNotifier(AppPhase.scoped);
        addTearDown(phase.dispose);
        final router = await pumpRouter(
          tester,
          phase,
          width: 390,
          height: 844,
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
        final controller = ProviderScope.containerOf(
          tester.element(find.byType(TablesPage)),
        ).read(tablesControllerProvider.notifier);
        controller.setArea(TableArea.coord);
        controller.setUnit('d1');
        await settle(tester);
        final trigger = fromTemplate
            ? find.text('Boş tablo')
            : find.bySemanticsLabel('Yeni tablo').first;
        await tester.ensureVisible(trigger);
        await tester.tap(trigger);
        await settle(tester);
        await tester.enterText(find.byType(TextField).last, 'Sunucu tablosu');
        await settle(tester);
        expect(
          find.descendant(
            of: find.byType(NzBottomSheetContent),
            matching: find.text('Gerçek Ekip'),
          ),
          findsOneWidget,
        );
        await tester.tap(find.text('Oluştur'));
        await settle(tester);
        expect(repo.createdLocation!.departmentId, 'd1');
        expect(repo.calls.map((c) => c.$1), ['create', 'column:1']);
        expect(tester.takeException(), isNull);
      },
    );
  }
  for (final size in [const Size(360, 640), const Size(1180, 820)]) {
    testWidgets('sunucu formu kaydeder, demo üretmez: $size', (tester) async {
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
          tableSharingChoicesProvider.overrideWith((ref) async => choices),
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
      expect(container.read(tablesControllerProvider).remote, isTrue);
      expect(container.read(tablesControllerProvider).documents, isEmpty);
      await tester.tap(find.bySemanticsLabel('Yeni tablo').first);
      await settle(tester);
      await tester.enterText(find.byType(TextField).last, 'Sunucu tablosu');
      await settle(tester);
      await tester.tap(find.text('Paylaşım'));
      await settle(tester);
      expect(find.text('Gerçek Kişi'), findsNothing);
      await tester.ensureVisible(find.text('Gerçek Ekip').last);
      await tester.tap(find.text('Gerçek Ekip').last);
      await settle(tester);
      expect(find.text('Kadir Özbek'), findsNothing);
      await tester.ensureVisible(find.text('Gerçek Kişi'));
      await tester.tap(find.text('Gerçek Kişi'));
      await settle(tester);
      expect(find.text('Koordinatör · Gerçek Ekip'), findsNothing);
      if (const bool.fromEnvironment('NIZAMIO_TABLET_HOST_SHOTS')) {
        await tester.ensureVisible(find.text('Paylaşılan kişiler'));
        await settle(tester);
        File('/tmp/nizamio-table-person-ui-${size.width.toInt()}.png')
            .writeAsBytesSync(await sheetPng(tester));
      }
      await tester.tap(find.text('Oluştur'));
      await settle(tester);
      expect(repo.calls.map((c) => c.$1), ['create', 'column:1', 'grant']);
      expect(
        container.read(tablesControllerProvider).documents.single.title,
        'Sunucu tablosu',
      );
      expect(locationOf(router), '/tables');
      expect(tester.takeException(), isNull);
    });
  }
  for (final direct in [true, false]) {
    testWidgets(
      'yeni koordinatörlük tablosu doğrudan açılır, ekip erişimi isteğe bağlı: $direct',
      (tester) async {
        final repo = ListRepository()..failGrant = false;
        final phase = ValueNotifier(AppPhase.scoped);
        addTearDown(phase.dispose);
        final selectedChoices = TableSharingChoices(
          accountId: 'me',
          people: choices.people,
          departments: choices.departments,
          directDepartments: direct ? {'d1'} : {},
          memberships: choices.memberships,
        );
        final router = await pumpRouter(
          tester,
          phase,
          width: 390,
          height: 844,
          tablePrototype: false,
          overrides: [
            tablesRepositoryProvider.overrideWithValue(repo),
            tableSharingChoicesProvider.overrideWith(
              (ref) async => selectedChoices,
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
        await tester.enterText(find.byType(TextField).last, 'Sunucu tablosu');
        await settle(tester);
        await tester.tap(find.text('Paylaşım'));
        await settle(tester);
        await tester.tap(find.text('Koordinatörlük').last);
        await settle(tester);
        await tester.ensureVisible(find.text('Tablonun koordinatörlüğü'));
        await tester.tap(find.text('Tablonun koordinatörlüğü'));
        await settle(tester);
        await tester.ensureVisible(find.text('Gerçek Ekip').last);
        await tester.tap(find.text('Gerçek Ekip').last);
        await settle(tester);
        await tester.ensureVisible(find.text('Gerçek Kişi'));
        await tester.tap(find.text('Gerçek Kişi'));
        await settle(tester);
        await tester.ensureVisible(find.text('Tüm ekip'));
        await tester.tap(find.text('Tüm ekip'));
        await settle(tester);
        final teamPermission = find.descendant(
          of: find.bySemanticsLabel('Koordinatörlük ekibinin erişim yetkisi'),
          matching: find.text('Düzenleme'),
        );
        await tester.ensureVisible(teamPermission);
        await tester.tap(teamPermission);
        await tester.tap(find.text('Oluştur'));
        await settle(tester);
        expect(repo.createdLocation!.personal, isFalse);
        expect(repo.calls.map((c) => c.$1), ['create', 'column:1', 'team']);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('kısmi kayıt kapatılıp açılınca aynı tablodan sürer', (
    tester,
  ) async {
    final repo = ListRepository();
    final phase = ValueNotifier(AppPhase.scoped);
    addTearDown(phase.dispose);
    final router = await pumpRouter(
      tester,
      phase,
      width: 390,
      height: 844,
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
    await tester.enterText(find.byType(TextField).last, 'Sunucu tablosu');
    await settle(tester);
    await tester.tap(find.text('Paylaşım'));
    await settle(tester);
    await tester.ensureVisible(find.text('Gerçek Ekip').last);
    await tester.tap(find.text('Gerçek Ekip').last);
    await settle(tester);
    await tester.ensureVisible(find.text('Gerçek Kişi'));
    await tester.tap(find.text('Gerçek Kişi'));
    await settle(tester);
    await tester.tap(find.text('Oluştur'));
    await settle(tester);
    expect(find.text('Kayda devam et'), findsOneWidget);
    await tester.tap(find.text('Vazgeç'));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('Yeni tablo').first);
    await settle(tester);
    await tester.tap(find.text('Kayda devam et'));
    await settle(tester);
    expect(repo.calls.map((c) => c.$1), [
      'create',
      'column:1',
      'grant',
      'grant',
    ]);
    expect(repo.calls[2].$2, repo.calls[3].$2);
    expect(tester.takeException(), isNull);
  });
  testWidgets('şablon kartı seçilen düzeni salt okunur forma ve kayda taşır', (
    tester,
  ) async {
    final repo = ListRepository()..failGrant = false;
    final phase = ValueNotifier(AppPhase.scoped);
    addTearDown(phase.dispose);
    final router = await pumpRouter(
      tester,
      phase,
      width: 390,
      height: 844,
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
    expect(find.text('Yenile'), findsNothing);
    await tester.ensureVisible(find.text('Görev listesi'));
    await tester.tap(find.text('Görev listesi'));
    await settle(tester);
    final sheet = find.byType(NzBottomSheetContent);
    expect(
      find.descendant(of: sheet, matching: find.text('Görev listesi')),
      findsOneWidget,
    );
    await tester.tap(find.text('Başlangıç düzeni'));
    await settle(tester);
    expect(
      find.descendant(of: sheet, matching: find.text('Etkinlik planı')),
      findsNothing,
    );
    await tester.enterText(find.byType(TextField).last, 'Sunucu tablosu');
    await settle(tester);
    await tester.tap(find.text('Oluştur'));
    await settle(tester);
    expect(repo.calls.where((c) => c.$1.startsWith('column:')).length, 5);
    expect(tester.takeException(), isNull);
  });
  for (final direct in [true, false]) {
    testWidgets(
      'koordinatörlükte yalnız seçilen kişinin yetkisi kaydedilir: $direct',
      (tester) async {
        final repo = ListRepository()..failGrant = false;
        final phase = ValueNotifier(AppPhase.scoped);
        addTearDown(phase.dispose);
        final target = TableSharingChoices(
          accountId: 'me',
          people: choices.people,
          departments: choices.departments,
          memberships: choices.memberships,
          roles: choices.roles,
          directDepartments: direct ? {'d1'} : {},
        );
        final router = await pumpRouter(
          tester,
          phase,
          width: 390,
          height: 844,
          tablePrototype: false,
          overrides: [
            tablesRepositoryProvider.overrideWithValue(repo),
            tableSharingChoicesProvider.overrideWith((ref) async => target),
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
        await tester.enterText(find.byType(TextField).last, 'Sunucu tablosu');
        await settle(tester);
        await tester.tap(find.text('Paylaşım'));
        await settle(tester);
        await tester.tap(find.text('Koordinatörlük').last);
        await settle(tester);
        await tester.ensureVisible(find.text('Tablonun koordinatörlüğü'));
        await tester.tap(find.text('Tablonun koordinatörlüğü'));
        await settle(tester);
        await tester.ensureVisible(find.text('Gerçek Ekip').last);
        await tester.tap(find.text('Gerçek Ekip').last);
        await settle(tester);
        await tester.ensureVisible(find.text('Gerçek Kişi'));
        await tester.tap(find.text('Gerçek Kişi'));
        await settle(tester);
        final teamPermission = find.descendant(
          of: find.bySemanticsLabel('Gerçek Kişi erişim yetkisi'),
          matching: find.text('Düzenleme'),
        );
        await tester.ensureVisible(teamPermission);
        await tester.tap(teamPermission);
        await tester.tap(find.text('Oluştur'));
        await settle(tester);
        expect(repo.createdLocation!.departmentId, 'd1');
        expect(repo.calls.map((c) => c.$1), ['create', 'column:1', 'grant']);
        expect(repo.grants.single.person, 'u2');
        expect(repo.grants.single.location.departmentId, 'd1');
        expect(repo.grants.single.access, TableAccess.edit);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'kişi grupları kapalı başlar; koordinatörler üyelerden önce gelir',
    (tester) async {
      final repo = ListRepository()..failGrant = false;
      final phase = ValueNotifier(AppPhase.scoped);
      addTearDown(phase.dispose);
      const grouped = TableSharingChoices(
        accountId: 'me',
        people: {
          TablePersonId('u2'): 'Z Koordinatör',
          TablePersonId('u3'): 'A Üye',
        },
        departments: {TableDepartmentId('d1'): 'Gerçek Ekip'},
        directDepartments: {'d1'},
        roles: {
          TablePersonId('u2'): TableSharingRole.coordinator,
          TablePersonId('u3'): TableSharingRole.member,
        },
        coordinators: {
          TableDepartmentId('d1'): {TablePersonId('u2')},
        },
        memberships: {
          TablePersonId('u2'): {'d1'},
          TablePersonId('u3'): {'d1'},
        },
      );
      final router = await pumpRouter(
        tester,
        phase,
        width: 390,
        height: 844,
        tablePrototype: false,
        overrides: [
          tablesRepositoryProvider.overrideWithValue(repo),
          tableSharingChoicesProvider.overrideWith((ref) async => grouped),
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
      await tester.tap(find.text('Paylaşım'));
      await settle(tester);
      expect(find.text('Z Koordinatör'), findsNothing);
      expect(find.text('A Üye'), findsNothing);
      await tester.ensureVisible(find.text('Gerçek Ekip').last);
      await tester.tap(find.text('Gerçek Ekip').last);
      await settle(tester);
      final names = tester
          .widgetList<Text>(find.byType(Text))
          .map((t) => t.data)
          .where((s) => s == 'Z Koordinatör' || s == 'A Üye')
          .toList();
      expect(names, ['Z Koordinatör', 'A Üye']);
      expect(find.text('Koordinatör · Gerçek Ekip'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
