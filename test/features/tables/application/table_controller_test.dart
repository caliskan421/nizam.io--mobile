// Tablo denetleyicisi: kapsam çözümü (liste → alan; derin bağlantıda koordinatörlük 404 →
// kişisel), hücre yazımı (birleştirme, ≤100 batch, CAS sürümü, makbuz sürümü), 409
// cell_conflict yakınsaması, sonucu bilinmeyen gönderimde AYNI anahtar, 403 salt okunur,
// şema CAS'lı sütun komutları, uçuştaki batch sırasında aynı hücrenin yeniden tabanı,
// koşullu geri alma.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tables/application/table_controller.dart';
import 'package:nizamio/features/tables/application/table_view.dart';
import 'package:nizamio/features/tables/application/tables_list_controller.dart';
import 'package:nizamio/features/tables/domain/table_models.dart';
import 'package:nizamio/features/tables/domain/table_operation.dart';

import '../fake_tables_repository.dart';
import '../tables_test_support.dart';

const _personal = TableScope.personal(programId: 'p1');

Future<(ProviderContainer, TableController)> _open(
  FakeTablesRepository repo,
  String id,
) async {
  final c = tablesContainer(repo);
  c.listen(tableControllerProvider(id), (_, _) {});
  await c.read(tableControllerProvider(id).future);
  return (c, c.read(tableControllerProvider(id).notifier));
}

TableView _view(ProviderContainer c, String id) =>
    c.read(tableControllerProvider(id)).requireValue;

List<SetCells> _setCells(FakeTablesRepository repo) => [
  for (final (_, op) in repo.applied)
    if (op is SetCells) op,
];

void main() {
  group('yükleme', () {
    test('derin bağlantı: koordinatörlükte 404 → kişisel alan', () async {
      final repo = FakeTablesRepository()..add('t1', scope: _personal);
      final (c, _) = await _open(repo, 't1');
      expect(_view(c, 't1').meta.scope, _personal);
      expect(repo.snapshots.first.$1.space, TableSpace.coordinatorship);
    });

    test('listede görülen tablonun alanı doğrudan kullanılır', () async {
      final repo = FakeTablesRepository()..add('t1', scope: _personal);
      final c = tablesContainer(repo);
      c.listen(tablesListControllerProvider, (_, _) {});
      await c.read(tablesListControllerProvider.future);
      c.listen(tableControllerProvider('t1'), (_, _) {});
      await c.read(tableControllerProvider('t1').future);
      expect(repo.snapshots.map((s) => s.$1), [_personal]);
    });

    test('sayfalar: loadMore sonraki imleci okur ve satırları ekler', () async {
      final repo = FakeTablesRepository()..add('t1', rows: 250);
      final (c, n) = await _open(repo, 't1');
      expect(_view(c, 't1').rows, hasLength(200));
      expect(_view(c, 't1').hasMore, isTrue);
      await n.loadMore();
      expect(_view(c, 't1').rows, hasLength(250));
      expect(_view(c, 't1').hasMore, isFalse);
    });
  });

  group('hücre yazımı', () {
    test('ardışık düzenlemeler tek set_cells; okunan sürüm gider, makbuz sürümü yazılır', () async {
      final repo = FakeTablesRepository()..add('t1', rows: 2);
      repo.foreignWrite('t1', 'r1', 'c1', 'eski'); // sürüm 1
      final (c, n) = await _open(repo, 't1');
      n
        ..editCell('r1', 'c1', 'a')
        ..editCell('r1', 'c1', 'ab')
        ..editCell('r2', 'c1', 'x');
      expect(_view(c, 't1').cell('r1', 'c1').value, 'ab');
      expect(_view(c, 't1').pendingWrites, 2);
      await n.flush();
      final sent = _setCells(repo).single.cells;
      expect(sent.map((w) => (w.rowId, w.value, w.version)), [
        ('r1', 'ab', 1),
        ('r2', 'x', 0),
      ]);
      final v = _view(c, 't1');
      expect(v.cell('r1', 'c1').version, 2);
      expect(v.cell('r2', 'c1').version, 1);
      expect(v.pendingWrites, 0);
      expect(v.undoSequence, isNotNull);
      expect(n.ownSequences, contains(v.undoSequence));
    });

    test('150 hücre iki batch: 100 + 50', () async {
      final repo = FakeTablesRepository()..add('t1', rows: 150);
      final (_, n) = await _open(repo, 't1');
      for (var i = 1; i <= 150; i++) {
        n.editCell('r$i', 'c1', 'v$i');
      }
      await n.flush();
      expect(_setCells(repo).map((s) => s.cells.length), [100, 50]);
    });

    test('409 cell_conflict: başkasının hücresi çakışma, diğeri yeni anahtarla yeniden gider', () async {
      final repo = FakeTablesRepository()..add('t1', rows: 2);
      final (c, n) = await _open(repo, 't1');
      repo.foreignWrite('t1', 'r1', 'c1', 'onların');
      n
        ..editCell('r1', 'c1', 'benim')
        ..editCell('r2', 'c1', 'diğer');
      await n.flush();
      final sends = _setCells(repo);
      expect(sends, hasLength(2));
      expect(sends.last.cells.single.rowId, 'r2');
      expect(repo.applied.first.$1, isNot(repo.applied.last.$1));
      final v = _view(c, 't1');
      expect(v.conflicts, {TableCellKey('r1', 'c1')});
      expect(v.cell('r1', 'c1').value, 'onların');
      expect(v.cell('r2', 'c1').value, 'diğer');
      expect(
        repo.tables['t1']!.cells[TableCellKey('r2', 'c1')]!.value,
        'diğer',
      );
      n.dismissConflicts();
      expect(_view(c, 't1').conflicts, isEmpty);
    });

    test('sonucu bilinmeyen gönderim: hata görünür, yeniden deneme AYNI anahtar (tekrar)', () async {
      final repo = FakeTablesRepository()..add('t1');
      final (c, n) = await _open(repo, 't1');
      repo.loseNextResponses = 1;
      n.editCell('r1', 'c1', 'x');
      await n.flush();
      var v = _view(c, 't1');
      expect(v.writeError?.code, 'client.timeout');
      expect(v.pendingWrites, 1);
      expect(v.cell('r1', 'c1').value, 'x');
      await n.retryWrites();
      v = _view(c, 't1');
      expect(repo.applied, hasLength(2));
      expect(repo.applied.first.$1, repo.applied.last.$1);
      expect(v.writeError, isNull);
      expect(v.pendingWrites, 0);
      expect(v.cell('r1', 'c1').version, 1);
      // Sunucuda tek yazım oldu.
      expect(repo.tables['t1']!.cells[TableCellKey('r1', 'c1')]!.version, 1);
    });

    test('403 forbidden: tablo salt okunur, sunucu değeri geri gelir, düzenleme yok sayılır', () async {
      final repo = FakeTablesRepository()..add('t1');
      final (c, n) = await _open(repo, 't1');
      repo.applyErrors.add(ApiError('tables.forbidden', status: 403));
      n.editCell('r1', 'c1', 'x');
      await n.flush();
      final v = _view(c, 't1');
      expect(v.readOnly, isTrue);
      expect(v.cell('r1', 'c1').value, isNull);
      n.editCell('r1', 'c1', 'y');
      expect(_view(c, 't1').pendingWrites, 0);
    });

    test(
      'uçuştaki batch sırasında aynı hücre: ikinci gönderim makbuzdaki sürümle',
      () async {
        final repo = FakeTablesRepository()..add('t1');
        final (_, n) = await _open(repo, 't1');
        final gate = repo.gate = Completer<void>();
        n.editCell('r1', 'c1', 'a');
        final first = n.flush();
        await Future<void>.delayed(Duration.zero);
        n.editCell('r1', 'c1', 'b');
        gate.complete();
        await first;
        await n.flush();
        final sends = _setCells(repo);
        expect(
          sends.map((s) => (s.cells.single.value, s.cells.single.version)),
          [('a', 0), ('b', 1)],
        );
      },
    );

    test('düzenlenemeyen tip ve redakte hücre kuyruğa girmez', () async {
      final repo = FakeTablesRepository()
        ..add(
          't1',
          columns: [TableColumnKind.personReference, TableColumnKind.text],
        );
      repo.tables['t1']!.cells[TableCellKey('r1', 'c2')] = const TableCellData(
        value: 'gizli',
        version: 3,
        redacted: true,
      );
      final (c, n) = await _open(repo, 't1');
      n
        ..editCell('r1', 'c1', 'u1')
        ..editCell('r1', 'c2', 'x');
      expect(_view(c, 't1').pendingWrites, 0);
    });
  });

  group('komutlar', () {
    test('sütun ekleme expected_schema gönderir; şema artar', () async {
      final repo = FakeTablesRepository()..add('t1');
      final (c, n) = await _open(repo, 't1');
      final id = await n.addColumn('Tarih', TableColumnKind.date);
      final op = repo.applied.single.$2 as AddColumn;
      expect(op.expectedSchema, 1);
      final v = _view(c, 't1');
      expect(v.meta.schemaVersion, 2);
      expect(v.column(id!)!.kind, TableColumnKind.date);
    });

    test('409 schema_conflict: sütunlar yeniden okunur, hata fırlar', () async {
      final repo = FakeTablesRepository()..add('t1');
      final (c, n) = await _open(repo, 't1');
      repo.tables['t1']!.meta = repo.tables['t1']!.meta.copyWith(
        schemaVersion: 5,
      );
      await expectLater(
        n.renameColumn('c1', 'Yeni'),
        throwsA(
          isA<ApiError>().having(
            (e) => e.code,
            'code',
            'tables.schema_conflict',
          ),
        ),
      );
      expect(_view(c, 't1').meta.schemaVersion, 5);
      await n.renameColumn('c1', 'Yeni');
      expect(_view(c, 't1').column('c1')!.name, 'Yeni');
    });

    test(
      'komuttan önce bekleyen hücreler gönderilir; satır ekleme kimlik döner',
      () async {
        final repo = FakeTablesRepository()..add('t1');
        final (c, n) = await _open(repo, 't1');
        n.editCell('r1', 'c1', 'x');
        final row = await n.addRow();
        expect(repo.applied.map((a) => a.$2.runtimeType), [SetCells, AddRow]);
        expect(_view(c, 't1').rows.map((r) => r.id), contains(row));
      },
    );

    test('yeniden adlandırma liste kaydını da günceller', () async {
      final repo = FakeTablesRepository()..add('t1');
      final c = tablesContainer(repo);
      c.listen(tablesListControllerProvider, (_, _) {});
      await c.read(tablesListControllerProvider.future);
      c.listen(tableControllerProvider('t1'), (_, _) {});
      await c.read(tableControllerProvider('t1').future);
      await c.read(tableControllerProvider('t1').notifier).rename(' Yeni ');
      expect(_view(c, 't1').meta.name, 'Yeni');
      expect(
        c.read(tablesListControllerProvider).value!.find('t1')!.name,
        'Yeni',
      );
    });

    test('geri alma son kendi set_cells sırasını gönderir', () async {
      final repo = FakeTablesRepository()..add('t1');
      final (c, n) = await _open(repo, 't1');
      n.editCell('r1', 'c1', 'x');
      await n.flush();
      final seq = _view(c, 't1').undoSequence!;
      await n.undoLast();
      expect((repo.applied.last.$2 as UndoCells).sequence, seq);
      expect(_view(c, 't1').undoSequence, isNull);
    });
  });
}
