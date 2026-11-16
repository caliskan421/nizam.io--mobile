import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tables/application/tables_controller.dart';
import 'package:nizamio/features/tables/application/tables_server.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';

import 'table_create_job_test.dart' show RecordingRepository;

class Selected extends Notifier<String> {
  @override
  String build() => 'old';
  void change() => state = 'new';
}

final selected = NotifierProvider<Selected, String>(Selected.new);

class Server extends RecordingRepository {
  final responses = <String, Completer<List<TableDocument>>>{};
  final starts = <String, Completer<void>>{};
  Future<void> started(String id) =>
      starts.putIfAbsent(id, Completer<void>.new).future;
  @override
  Future<List<TableDocument>> list(TableLocation l, String account) {
    final response = responses.putIfAbsent(
      l.programId,
      Completer<List<TableDocument>>.new,
    );
    starts.putIfAbsent(l.programId, Completer<void>.new).complete();
    return response.future;
  }
}

class SnapshotServer extends RecordingRepository {
  String title = 'Tablo';
  bool fail = false;
  int reads = 0;
  @override
  Future<List<TableDocument>> list(
    TableLocation location,
    String account,
  ) async {
    reads++;
    if (fail) throw ApiError('tables.forbidden');
    return [
      TableDocument(
        id: 't1',
        title: title,
        area: TableArea.personal,
        fields: const [],
        remote: true,
        programId: location.programId,
        ownerId: account,
      ),
    ];
  }
}

const emptyChoices = TableSharingChoices(
  accountId: 'me',
  people: {},
  departments: {},
  directDepartments: {},
  memberships: {},
);
void main() {
  test(
    'eski programın gecikmiş listesi yeni kapsama yazılmaz, demo yoktur',
    () async {
      final server = Server();
      final container = ProviderContainer(
        overrides: [
          tablesRepositoryProvider.overrideWithValue(server),
          tableSharingChoicesProvider.overrideWith((ref) async => emptyChoices),
          sessionGenerationProvider.overrideWith((ref) => 1),
          scopeStateProvider.overrideWith(
            (ref) => ScopeSelection(programId: ref.watch(selected)),
          ),
        ],
      );
      addTearDown(container.dispose);
      container.listen(tablesControllerProvider, (_, _) {});
      await container.pump();
      await server.started('old');
      expect(container.read(tablesControllerProvider).area, TableArea.coord);
      container
          .read(tablesControllerProvider.notifier)
          .setArea(TableArea.personal);
      expect(container.read(tablesControllerProvider).documents, isEmpty);
      container.read(selected.notifier).change();
      await container.pump();
      await server.started('new');
      expect(container.read(tablesControllerProvider).area, TableArea.coord);
      server.responses['new']!.complete([
        TableDocument(
          id: 'new-table',
          title: 'Yeni',
          area: TableArea.personal,
          fields: const [],
          remote: true,
          programId: 'new',
        ),
      ]);
      await container.pump();
      server.responses['old']!.complete([
        TableDocument(
          id: 'old-table',
          title: 'Eski',
          area: TableArea.personal,
          fields: const [],
          remote: true,
          programId: 'old',
        ),
      ]);
      await container.pump();
      final state = container.read(tablesControllerProvider);
      expect(state.documents.single.id, 'new-table');
      expect(state.loading, isFalse);
      expect(state.remote, isTrue);
      final controller = container.read(tablesControllerProvider.notifier);
      controller.ensureDemoFixtures();
      expect(
        controller.create(
          title: 'Sahte',
          fields: const [TableField(id: 'x', name: 'Ad')],
        ),
        isNull,
      );
      expect(
        controller.duplicate('new-table', empty: false, suffix: 'Sahte'),
        isNull,
      );
      expect(
        container.read(tablesControllerProvider).documents.single.id,
        'new-table',
      );
    },
  );
  test('liste hatası boş liste başarısı veya demo olarak sunulmaz', () async {
    final server = Server();
    final container = ProviderContainer(
      overrides: [
        tablesRepositoryProvider.overrideWithValue(server),
        tableSharingChoicesProvider.overrideWith((ref) async => emptyChoices),
        sessionGenerationProvider.overrideWith((ref) => 1),
        scopeStateProvider.overrideWith(
          (ref) => const ScopeSelection(programId: 'old'),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(tablesControllerProvider, (_, _) {});
    await container.pump();
    await server.started('old');
    server.responses['old']!.completeError(ApiError('tables.forbidden'));
    await container.pump();
    final state = container.read(tablesControllerProvider);
    expect(state.error?.code, 'tables.forbidden');
    expect(state.loading, isFalse);
    expect(state.documents, isEmpty);
  });
  test(
    'yenileme aynı veriyi korur, değişikliği uygular ve hatada görünümü silmez',
    () async {
      final server = SnapshotServer();
      final container = ProviderContainer(
        overrides: [
          tablesRepositoryProvider.overrideWithValue(server),
          tableSharingChoicesProvider.overrideWith((ref) async => emptyChoices),
          sessionGenerationProvider.overrideWith((ref) => 1),
          scopeStateProvider.overrideWith(
            (ref) => const ScopeSelection(programId: 'p1'),
          ),
        ],
      );
      addTearDown(container.dispose);
      container.listen(tablesControllerProvider, (_, _) {});
      await Future<void>.delayed(Duration.zero);
      final ctl = container.read(tablesControllerProvider.notifier);
      final before = container.read(tablesControllerProvider);
      expect(before.loading, isFalse);
      final first = ctl.refresh();
      expect(identical(first, ctl.refresh()), isTrue);
      await first;
      expect(
        identical(before, container.read(tablesControllerProvider)),
        isTrue,
      );
      final reads = server.reads;
      await ctl.refreshIfStale();
      expect(server.reads, reads);
      server.title = 'Yeni ad';
      await ctl.refresh();
      expect(
        container.read(tablesControllerProvider).documents.single.title,
        'Yeni ad',
      );
      server.fail = true;
      await expectLater(ctl.refresh(), throwsA(isA<ApiError>()));
      final failed = container.read(tablesControllerProvider);
      expect(failed.documents.single.title, 'Yeni ad');
      expect(failed.error?.code, 'tables.forbidden');
    },
  );
}
