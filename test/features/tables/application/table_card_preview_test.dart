import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tables/application/table_card_preview.dart';
import 'package:nizamio/features/tables/application/tables_server.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';

import '../../../app/router/tables_backend_flow_test.dart' show choices;
import 'table_create_job_test.dart' show RecordingRepository;

class PreviewRepository extends RecordingRepository {
  final reads = <(TableLocation, String, String, int)>[];
  @override
  Future<TableWorkspace> workspace(
    TableLocation location,
    String id,
    String account, {
    TableReadQuery query = const TableReadQuery(),
  }) async {
    reads.add((location, id, account, query.limit));
    return TableWorkspace(
      document: TableDocument(
        id: id,
        title: 'Tablo',
        area: TableArea.coord,
        fields: const [],
      ),
      schema: 1,
      sequence: 1,
      columns: const [],
      cells: const [],
    );
  }
}

void main() {
  test('kart önizlemesi tablonun kendi kapsamında satır sayısını önizleme sınırından bağımsız okur', () async {
    final repo = PreviewRepository();
    final container = ProviderContainer(
      overrides: [
        tablesRepositoryProvider.overrideWithValue(repo),
        tableSharingChoicesProvider.overrideWith((ref) async => choices),
        sessionGenerationProvider.overrideWith((ref) => 1),
        scopeStateProvider.overrideWith(
          (ref) =>
              const ScopeSelection(programId: 'other', departmentId: 'other'),
        ),
      ],
    );
    addTearDown(container.dispose);
    final doc = TableDocument(
      id: 't1',
      title: 'Tablo',
      area: TableArea.coord,
      programId: 'p1',
      unit: 'd1',
      remote: true,
      fields: const [],
    );
    final provider = tableCardPreviewProvider(doc);
    final sub = container.listen(provider, (_, _) {});
    addTearDown(sub.close);
    await container.read(provider.future);
    expect(repo.reads, [
      (const TableLocation('p1', 'd1'), 't1', choices.accountId, 100),
    ]);
    expect(repo.calls, isEmpty);
    // Listening again reuses the read; a list refresh supplies a new document key.
    await container.read(provider.future);
    expect(repo.reads, hasLength(1));
  });
}
