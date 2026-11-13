// Referans hücre yazımı: seçim → set_cells gövdesi (tekli kimlik, çoklu benzersiz liste, boş
// → null), görünen ad hemen yereldir ve makbuzdan sonra snapshot'tan okunur, 422
// `tables.reference_unavailable` değeri geri alır ve anlaşılır hata bırakır, gizlenmiş hücre
// yalnız bilinçli tam değiştirmeyle yazılır (istekte `redacted` yok).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tables/application/table_controller.dart';
import 'package:nizamio/features/tables/application/table_view.dart';
import 'package:nizamio/features/tables/domain/table_models.dart';
import 'package:nizamio/features/tables/domain/table_operation.dart';
import 'package:nizamio/features/tables/domain/table_reference_sources.dart';

import '../fake_tables_repository.dart';
import '../tables_test_support.dart';

Future<(ProviderContainer, TableController, FakeTablesRepository)>
_open() async {
  final repo = FakeTablesRepository()
    ..add(
      't1',
      columns: [TableColumnKind.personReference, TableColumnKind.taskReference],
    );
  repo.tables['t1']!.columns[1] = const TableColumnSpec(
    id: 'c2',
    name: 'Görevler',
    kind: TableColumnKind.taskReference,
    width: 200,
    position: 2,
    multiple: true,
  );
  final c = tablesContainer(repo)
    ..listen(tableControllerProvider('t1'), (_, _) {});
  await c.read(tableControllerProvider('t1').future);
  return (c, c.read(tableControllerProvider('t1').notifier), repo);
}

TableView _v(ProviderContainer c) =>
    c.read(tableControllerProvider('t1')).requireValue;

List<SetCells> _sets(FakeTablesRepository r) => [
  for (final (_, op) in r.applied)
    if (op is SetCells) op,
];

void main() {
  test(
    'tekli ve çoklu seçim set_cells gövdesine; ad yerelde hemen görünür',
    () async {
      final (c, n, repo) = await _open();
      n
        ..editReference(
          'r1',
          'c1',
          'u1',
          picked: const [TableRefCandidate(id: 'u1', name: 'Ayşe')],
        )
        ..editReference(
          'r1',
          'c2',
          const ['w1', 'w2', 'w1'],
          picked: const [
            TableRefCandidate(id: 'w1', name: 'Kurulum'),
            TableRefCandidate(id: 'w2', name: 'Test'),
          ],
        );
      expect(
        _v(c).referenceName(TableColumnKind.personReference, 'u1'),
        'Ayşe',
      );
      await n.flush();
      final cells = _sets(repo).single.cells;
      expect(cells.map((w) => w.value), [
        'u1',
        ['w1', 'w2'],
      ]);
      expect(cells.every((w) => w.version == 0), isTrue);
    },
  );

  test('çoklu boş seçim null olarak gider', () async {
    final (_, n, repo) = await _open();
    n.editReference('r1', 'c2', const <String>[], picked: const []);
    await n.flush();
    expect(_sets(repo).single.cells.single.value, isNull);
  });

  test('makbuz sonrası görünen ad snapshot\'tan yeniden okunur', () async {
    final (_, n, repo) = await _open();
    n.editReference(
      'r1',
      'c1',
      'u1',
      picked: const [TableRefCandidate(id: 'u1', name: 'Ayşe')],
    );
    final before = repo.snapshots.length;
    await n.flush();
    await pumpEventQueue();
    expect(repo.snapshots.length, greaterThan(before));
  });

  test(
    '422 reference_unavailable: değer geri alınır, anlaşılır hata kalır',
    () async {
      final (c, n, repo) = await _open();
      repo.applyErrors.add(
        ApiError('tables.reference_unavailable', status: 422),
      );
      n.editReference(
        'r1',
        'c1',
        'yok',
        picked: const [TableRefCandidate(id: 'yok', name: 'Kimse')],
      );
      await n.flush();
      expect(_v(c).cell('r1', 'c1').value, isNull);
      expect(_v(c).writeError?.code, 'tables.reference_unavailable');
      expect(_v(c).pendingWrites, 0);
      n.dismissWriteError();
      expect(_v(c).writeError, isNull);
    },
  );

  test(
    'gizlenmiş hücre: düz düzenleme yok sayılır, bilinçli tam değiştirme yazar',
    () async {
      final (c, n, repo) = await _open();
      repo.tables['t1']!.cells[TableCellKey('r1', 'c2')] = const TableCellData(
        value: ['w1', null],
        version: 4,
        redacted: true,
      );
      await n.refresh();
      n.editReference('r1', 'c2', const ['w9'], picked: const []);
      expect(_v(c).pendingWrites, 0);
      n.editReference(
        'r1',
        'c2',
        const ['w9'],
        picked: const [TableRefCandidate(id: 'w9', name: 'Yeni')],
        replaceRedacted: true,
      );
      await n.flush();
      final w = _sets(repo).single.cells.single;
      expect(w.value, ['w9']);
      expect(w.version, 4);
      expect(repo.tables['t1']!.cells[TableCellKey('r1', 'c2')]!.value, ['w9']);
    },
  );
}
