import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tables/application/table_detail_controller.dart';
import 'package:nizamio/features/tables/application/tables_controller.dart';
import 'package:nizamio/features/tables/application/tables_server.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';
import 'package:nizamio/features/tables/presentation/table_workspace_grid.dart';
import 'package:nizamio/features/tables/presentation/table_workspace_page.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../features/tables/application/table_progressive_load_test.dart'
    show ProgressiveServer;
import 'router_test_support.dart';
import 'table_workspace_flow_test.dart' show WorkspaceServer;
import 'tables_backend_flow_test.dart' show choices;

class SlowTableServer extends WorkspaceServer {
  final snapshotGate = Completer<void>();
  @override
  Future<TableWorkspace> workspace(
    TableLocation location,
    String id,
    String account, {
    TableReadQuery query = const TableReadQuery(),
  }) async {
    await snapshotGate.future;
    final data = await super.workspace(location, id, account, query: query);
    return TableWorkspace(
      document: data.document.copyWith(title: 'Güncel çalışma planı'),
      schema: data.schema,
      sequence: data.sequence,
      columns: data.columns,
      cells: data.cells,
    );
  }
}

void main() {
  setUpFonts();
  for (final width in [390.0, 1180.0]) {
    testWidgets(
      'snapshot beklerken bilinen ad görünür, güncel ad gelince yenilenir: $width',
      (tester) async {
        final server = SlowTableServer();
        final phase = ValueNotifier(AppPhase.scoped);
        addTearDown(phase.dispose);
        final router = await pumpRouter(
          tester,
          phase,
          width: width,
          tablePrototype: false,
          overrides: [
            tablesRepositoryProvider.overrideWithValue(server),
            tableSharingChoicesProvider.overrideWith((ref) async => choices),
            scopeStateProvider.overrideWith(
              (ref) => const ScopeSelection(programId: 'p1'),
            ),
            sessionGenerationProvider.overrideWith((ref) => 1),
          ],
        );
        router.go('/tables/t1');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        final container = ProviderScope.containerOf(
          tester.element(find.byType(TableWorkspacePage)),
        );
        await container.read(tablesControllerProvider.notifier).ready;
        await tester.pump();
        expect(find.text('Çalışma tablosu'), findsOneWidget);
        expect(find.text('Tablo'), findsNothing);
        expect(find.byType(TableWorkspaceGrid), findsNothing);
        server.snapshotGate.complete();
        await settle(tester);
        expect(find.text('Güncel çalışma planı'), findsOneWidget);
        expect(find.byType(TableWorkspaceGrid), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
    testWidgets('ilk satırlar kalanlar yüklenirken görünür: $width', (
      tester,
    ) async {
      final server = ProgressiveServer();
      final phase = ValueNotifier(AppPhase.scoped);
      addTearDown(phase.dispose);
      final router = await pumpRouter(
        tester,
        phase,
        width: width,
        tablePrototype: false,
        overrides: [
          tablesRepositoryProvider.overrideWithValue(server),
          tableSharingChoicesProvider.overrideWith((ref) async => choices),
          scopeStateProvider.overrideWith(
            (ref) => const ScopeSelection(programId: 'p1'),
          ),
          sessionGenerationProvider.overrideWith((ref) => 1),
        ],
      );
      router.go('/tables/t1');
      for (var i = 0; i < 15; i++) {
        await tester.pump(const Duration(milliseconds: 40));
      }
      expect(find.byType(TableWorkspaceGrid), findsOneWidget);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(TableWorkspacePage)),
      );
      expect(
        container.read(tableDetailProvider('t1')).data!.document.rows,
        hasLength(20),
      );
      expect(container.read(tableDetailProvider('t1')).prefetching, isTrue);
      server.expandGate.complete();
      await settle(tester);
      expect(
        container.read(tableDetailProvider('t1')).data!.document.rows,
        hasLength(100),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
