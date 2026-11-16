import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/ui/page/nz_page.dart';
import 'package:nizamio/core/ui/widgets/buttons/buttons.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_folder_card.dart';
import 'package:nizamio/features/tables/application/tables_controller.dart';
import 'package:nizamio/features/tables/application/tables_server.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';
import 'package:nizamio/features/tables/presentation/table_library_panel.dart';
import 'package:nizamio/features/tables/presentation/tables_page.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../features/tables/application/table_create_job_test.dart'
    show RecordingRepository;
import 'router_test_support.dart';
import 'tables_backend_flow_test.dart' show choices;
import 'users_tables_flow_test.dart' show sheetPng;

class FolderRepository extends RecordingRepository {
  bool failPage = true;
  final reads = <(TableLocation, String?)>[];
  @override
  Future<List<TableDocument>> list(
    TableLocation location,
    String account,
  ) async => location.personal
      ? [
          for (final (id, name, project) in [
            ('a', 'Zebra', 'p1'),
            ('b', 'Arama', 'p2'),
            ('c', 'Genel', null),
          ])
            TableDocument(
              id: id,
              title: name,
              area: TableArea.personal,
              remote: true,
              unit: '',
              fields: const [],
              projectId: project,
              programId: location.programId,
              ownerId: account,
            ),
        ]
      : [];
  @override
  Future<TablePageSlice<TableProjectEntry>> projects(
    TableLocation location, {
    String? cursor,
  }) async {
    reads.add((location, cursor));
    if (failPage) {
      failPage = false;
      throw ApiError('client.timeout');
    }
    return cursor == null
        ? const TablePageSlice([TableProjectEntry('p1', 'Saha')], 'next')
        : const TablePageSlice([TableProjectEntry('p2', 'Ofis')], null);
  }
}

void main() {
  setUpFonts();
  for (final size in [const Size(390, 844), const Size(1180, 820)]) {
    testWidgets('klasör sayfalama, hata kurtarma, filtre ve sıralama: $size', (
      tester,
    ) async {
      final repo = FolderRepository();
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
      final controller = container.read(tablesControllerProvider.notifier);
      controller.setArea(TableArea.personal);
      await settle(tester);
      Future<void> icon(String label) async {
        final target = find.byWidgetPredicate(
          (w) => w is NzIconButton && w.semanticLabel == label,
        );
        await tester.ensureVisible(target);
        await tester.tap(target);
        await settle(tester);
      }

      await tester.ensureVisible(find.byType(TableLibraryPanel));
      File('/tmp/nizam-refine-library-${size.width.toInt()}.png')
          .writeAsBytesSync(await sheetPng(tester));
      await icon('Tabloları sırala');
      await tester.tap(find.text('Ad · A–Z'));
      await settle(tester);
      expect(
        tester
            .widgetList<Text>(
              find.descendant(
                of: find.byType(TableLibraryPanel),
                matching: find.byType(Text),
              ),
            )
            .map((w) => w.data)
            .where((s) => ['Arama', 'Genel', 'Zebra'].contains(s)),
        ['Arama', 'Genel', 'Zebra'],
      );
      await icon('Görünümü değiştir');
      await tester.tap(find.text('Klasörler'));
      await settle(tester);
      await tester.tap(find.text('Yeniden dene'));
      await settle(tester);
      expect(find.byType(NzFolderCard), findsOneWidget);
      expect(find.text('Saha'), findsOneWidget);
      final readsBeforeRefresh = repo.reads.length;
      final page = tester.widget<NzPage>(
        find.descendant(
          of: find.byType(TablesPage),
          matching: find.byType(NzPage),
        ),
      );
      await page.onRefresh!();
      await settle(tester);
      expect(repo.reads.length, greaterThan(readsBeforeRefresh));

      await icon('Sonraki klasörler');
      expect(find.text('Ofis'), findsOneWidget);
      expect(repo.reads.last, (const TableLocation('p1'), 'next'));
      await tester.tap(find.text('Ofis'));
      await settle(tester);
      expect(container.read(tablesControllerProvider).project, 'p2');
      expect(find.text('Arama'), findsOneWidget);
      expect(find.text('Zebra'), findsNothing);
      await icon('Klasörlere dön');
      expect(container.read(tablesControllerProvider).project, isNull);
      await icon('Görünümü değiştir');
      await tester.tap(find.text('Tümü'));
      await settle(tester);
      expect(find.text('Zebra'), findsOneWidget);
      expect(find.text('Genel'), findsOneWidget);
      expect(find.text('Hızlı başla'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
