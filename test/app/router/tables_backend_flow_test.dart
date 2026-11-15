import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tables/application/tables_controller.dart';
import 'package:nizamio/features/tables/application/tables_server.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';
import 'package:nizamio/features/tables/presentation/tables_page.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../features/tables/application/table_create_job_test.dart'
    show RecordingRepository;
import 'router_test_support.dart';

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
  memberships: {
    TablePersonId('u2'): {'d1'},
  },
);
void main() {
  setUpFonts();
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
      expect(find.text('Gerçek Kişi'), findsOneWidget);
      expect(find.text('Kadir Özbek'), findsNothing);
      await tester.ensureVisible(find.text('Gerçek Kişi'));
      await tester.tap(find.text('Gerçek Kişi'));
      await settle(tester);
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
    testWidgets('koordinatörlük paylaşımı doğru kayıt yolunu seçer: $direct', (
      tester,
    ) async {
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
      await tester.ensureVisible(find.text('Gerçek Ekip'));
      await tester.tap(find.text('Gerçek Ekip'));
      await settle(tester);
      await tester.ensureVisible(find.text('Düzenleme'));
      await tester.tap(find.text('Düzenleme'));
      await tester.tap(find.text('Oluştur'));
      await settle(tester);
      expect(repo.createdLocation!.personal, !direct);
      expect(repo.calls.map((c) => c.$1), [
        'create',
        'column:1',
        direct ? 'team' : 'proposal',
      ]);
      expect(tester.takeException(), isNull);
    });
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
}
