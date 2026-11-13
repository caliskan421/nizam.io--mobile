// Bekletilen yazım: 409 cell_conflict → çözümleme snapshot'ı 429 → batch bekletilir; şerit
// "yeniden dene" sunar (kalıcı ret "kapat"); Retry-After varsa kendiliğinden, yoksa kullanıcı
// yeniden denemesiyle kuyruk ilerler.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tables/application/table_controller.dart';
import 'package:nizamio/features/tables/application/table_view.dart';
import 'package:nizamio/features/tables/domain/table_models.dart';
import 'package:nizamio/features/tables/domain/table_operation.dart';

import '../fake_tables_repository.dart';
import '../tables_test_support.dart';

Future<(ProviderContainer, TableController, FakeTablesRepository)>
_open() async {
  final repo = FakeTablesRepository()..add('t1', rows: 2);
  final c = tablesContainer(repo)
    ..listen(tableControllerProvider('t1'), (_, _) {});
  await c.read(tableControllerProvider('t1').future);
  return (c, c.read(tableControllerProvider('t1').notifier), repo);
}

TableView _v(ProviderContainer c) =>
    c.read(tableControllerProvider('t1')).requireValue;

void main() {
  test(
    '409 → snapshot 429: şerit yeniden dene; yeniden deneme kuyruğu ilerletir',
    () async {
      final (c, n, repo) = await _open();
      repo.foreignWrite('t1', 'r1', 'c1', 'onların');
      n
        ..editCell('r1', 'c1', 'benim')
        ..editCell('r2', 'c1', 'diğer');
      repo.snapshotErrors.add(ApiError('platform.rate_limited', status: 429));
      await n.flush();
      expect(_v(c).writeNotice, TableWriteNotice.retry);
      n.dismissWriteError(); // bekletilen batch varken kapatma kuyruğu kilitlemez/gizlemez
      expect(_v(c).writeNotice, TableWriteNotice.retry);
      n.editCell('r2', 'c1', 'son');
      await n.retryWrites();
      expect(_v(c).writeNotice, TableWriteNotice.none);
      expect(_v(c).pendingWrites, 0);
      expect(repo.tables['t1']!.cells[TableCellKey('r2', 'c1')]!.value, 'son');
      expect(_v(c).conflicts, contains(TableCellKey('r1', 'c1')));
    },
  );

  test(
    '429 Retry-After: bekletilen batch kendiliğinden yeniden gider',
    () async {
      final (c, n, repo) = await _open();
      repo.foreignWrite('t1', 'r1', 'c1', 'onların');
      n.editCell('r2', 'c1', 'diğer');
      n.editCell('r1', 'c1', 'benim');
      repo.snapshotErrors.add(
        ApiError(
          'platform.rate_limited',
          status: 429,
          retryAfter: const Duration(milliseconds: 1),
        ),
      );
      await n.flush();
      for (var i = 0; i < 100 && _v(c).pendingWrites > 0; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 2));
      }
      expect(_v(c).pendingWrites, 0);
      expect(
        repo.tables['t1']!.cells[TableCellKey('r2', 'c1')]!.value,
        'diğer',
      );
    },
  );

  test('kalıcı 422 ret: şerit kapat, kapatma bildirimi kaldırır', () async {
    final (c, n, repo) = await _open();
    repo.applyErrors.add(ApiError('tables.input_invalid', status: 422));
    n.editCell('r1', 'c1', 'x');
    await n.flush();
    expect(_v(c).writeNotice, TableWriteNotice.dismiss);
    n.dismissWriteError();
    expect(_v(c).writeNotice, TableWriteNotice.none);
  });

  test('N1: çözümleme okuması yeniden kurulumdan sonra 429 dönerse eski batch geri gelmez', () async {
    final (c, n, repo) = await _open();
    repo.foreignWrite('t1', 'r1', 'c1', 'onların');
    n.editCell('r1', 'c1', 'benim');
    final gate = repo.snapshotGate = Completer<void>();
    repo.snapshotErrors.add(
      ApiError(
        'platform.rate_limited',
        status: 429,
        retryAfter: const Duration(milliseconds: 1),
      ),
    );
    final sending = n.flush(); // 409 → çözümleme snapshot'ı kapıda bekler
    await pumpEventQueue();
    c.invalidate(
      tableControllerProvider('t1'),
    ); // oturum/kapsam yeniden kurulumu gibi
    await c.read(tableControllerProvider('t1').future);
    gate.complete();
    await sending;
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await pumpEventQueue();
    final sets = repo.applied.where((a) => a.$2 is SetCells).length;
    expect(sets, 1, reason: 'eski batch yeniden gönderilmez');
    expect(_v(c).pendingWrites, 0);
    expect(_v(c).writesHeld, isFalse);
    expect(_v(c).writeError, isNull);
  });
}
