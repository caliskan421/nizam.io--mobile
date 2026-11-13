// Referans aday kaynakları: tür → kaynak (kişi/departman/görev sahip uçlardan, tablo aynı
// alanın listesinden), görev ve tablo listesi imleçle yürür (tavan), dosya seçilen görevin
// kendi departmanıyla okunur; gezinme kararı (tablo/görev açılır, gizli/diğer tipler açılmaz).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/features/tables/application/table_controller.dart';
import 'package:nizamio/features/tables/application/table_reference_controller.dart';
import 'package:nizamio/features/tables/application/tables_providers.dart';
import 'package:nizamio/features/tables/domain/table_models.dart';
import 'package:nizamio/features/tables/domain/table_reference_sources.dart';

import '../fake_tables_repository.dart';
import '../tables_test_support.dart';

class _Sources implements TableReferenceSources {
  final calls = <String>[];
  TableRefCandidate? fileTask;

  @override
  Future<List<TableRefCandidate>> people(TableScope scope) async {
    calls.add('people:${scope.departmentId}');
    return const [TableRefCandidate(id: 'u1', name: 'Ayşe')];
  }

  @override
  Future<List<TableRefCandidate>> departments(TableScope scope) async {
    calls.add('departments:${scope.programId}');
    return const [TableRefCandidate(id: 'd1', name: 'Altyapı')];
  }

  @override
  Future<PageSlice<TableRefCandidate>> tasks(
    TableScope scope, {
    PageRequest page = const PageRequest(),
  }) async {
    calls.add('tasks:${page.cursor}');
    final n = page.cursor == null ? 0 : int.parse(page.cursor!);
    return PageSlice(
      items: [
        TableRefCandidate(id: 'w$n', name: 'Görev $n', departmentId: 'd1'),
      ],
      nextCursor: '${n + 1}',
    );
  }

  @override
  Future<List<TableRefCandidate>> files(
    TableScope scope,
    TableRefCandidate task,
  ) async {
    fileTask = task;
    return const [TableRefCandidate(id: 'f1', name: 'a.pdf')];
  }
}

void main() {
  Future<(_Sources, ProviderContainer)> open() async {
    final repo = FakeTablesRepository()
      ..add('t1')
      ..add('t2');
    final sources = _Sources();
    final c = tablesContainer(
      repo,
      extra: [tableReferenceSourcesProvider.overrideWithValue(sources)],
    )..listen(tableControllerProvider('t1'), (_, _) {});
    await c.read(tableControllerProvider('t1').future);
    return (sources, c);
  }

  test('tür başına kaynak; kişi tablonun departman kapsamıyla', () async {
    final (s, c) = await open();
    final people = await c.read(
      tableRefCandidatesProvider('t1', TableColumnKind.personReference).future,
    );
    expect(people.single.name, 'Ayşe');
    await c.read(
      tableRefCandidatesProvider(
        't1',
        TableColumnKind.departmentReference,
      ).future,
    );
    expect(s.calls, ['people:d1', 'departments:p1']);
  });

  test('görev listesi imleçle yürür, tavanda durur', () async {
    final (s, c) = await open();
    final tasks = await c.read(
      tableRefCandidatesProvider('t1', TableColumnKind.taskReference).future,
    );
    expect(tasks, hasLength(tableRefMaxPages));
    expect(s.calls.first, 'tasks:null');
  });

  test('tablo referansı aynı alanın tablo listesinden', () async {
    final (_, c) = await open();
    final tables = await c.read(
      tableRefCandidatesProvider('t1', TableColumnKind.tableReference).future,
    );
    expect(tables.map((t) => t.id), containsAll(['t1', 't2']));
  });

  test('dosya: seçilen görevin departmanıyla okunur', () async {
    final (s, c) = await open();
    final files = await c.read(
      tableRefFilesProvider('t1', 'w7', 'd9', 'Kurulum').future,
    );
    expect(files.single.id, 'f1');
    expect(s.fileTask!.departmentId, 'd9');
  });

  group('gezinme kararı', () {
    test('tablo ve görev açılır', () {
      expect(
        tableRefTarget(TableColumnKind.tableReference, 't2', visible: true),
        isA<OpenTableTarget>().having((t) => t.id, 'id', 't2'),
      );
      expect(
        tableRefTarget(TableColumnKind.taskReference, 'w1', visible: true),
        isA<OpenTaskTarget>(),
      );
    });

    test('gizli/adsız hedef ve diğer tipler açılmaz', () {
      expect(
        tableRefTarget(TableColumnKind.tableReference, null, visible: true),
        isA<NoTarget>(),
      );
      expect(
        tableRefTarget(TableColumnKind.tableReference, 't2', visible: false),
        isA<NoTarget>(),
      );
      for (final k in [
        TableColumnKind.personReference,
        TableColumnKind.departmentReference,
        TableColumnKind.fileReference,
      ]) {
        expect(tableRefTarget(k, 'x', visible: true), isA<NoTarget>());
      }
    });
  });
}
