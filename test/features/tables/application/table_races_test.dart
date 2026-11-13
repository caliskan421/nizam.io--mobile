// Yarış ve dayanıklılık senaryoları (Codex hükmü 1–9): Completer kapılarıyla sıra testte
// denetlenir. Çakışma ardındaki düzenleme yabancı değeri ezmez; imleç yalnız görünüm
// güncellenince ilerler; geciken makbuz/snapshot yeni görünümü geri almaz; komut yan okuması
// düşse de kayıt tek kalır; çakışma okuması düşerse yazımlar korunur; belirsiz batch aynı
// gövde+anahtarla, yeni düzenleme ayrı gider; snapshot'ın atladığı yorum olayı listeleri
// yeniler; arka planda uçuştaki yakalama yeni yakalama kurmaz; presence tek kapıdan geçer.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tables/application/table_controller.dart';
import 'package:nizamio/features/tables/application/table_sync_controller.dart';
import 'package:nizamio/features/tables/application/table_view.dart';
import 'package:nizamio/features/tables/application/tables_providers.dart';
import 'package:nizamio/features/tables/domain/table_models.dart';
import 'package:nizamio/features/tables/domain/table_operation.dart';

import '../fake_tables_repository.dart';
import '../tables_test_support.dart';

final _r1 = TableCellKey('r1', 'c1');

Future<(ProviderContainer, TableController, FakeTablesRepository)> _open({
  List<Override> extra = const [],
}) async {
  final repo = FakeTablesRepository()..add('t1', rows: 3);
  final c = tablesContainer(repo, extra: extra)
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
    '1: çakışan uçuşun ardındaki düzenleme yabancı sürüme taşınıp ezmez',
    () async {
      final (c, n, repo) = await _open();
      final gate = repo.gate = Completer<void>();
      n.editCell('r1', 'c1', 'a');
      final first = n.flush();
      await pumpEventQueue();
      n.editCell('r1', 'c1', 'ab');
      repo.foreignWrite('t1', 'r1', 'c1', 'onların');
      gate.complete();
      await first;
      await n.flush();
      expect(repo.tables['t1']!.cells[_r1]!.value, 'onların');
      expect(_v(c).cell('r1', 'c1').value, 'onların');
      expect(_v(c).conflicts, contains(_r1));
      expect(_v(c).pendingWrites, 0);
    },
  );

  test(
    '2: yeniden okuma düşerse imleç ilerlemez; sonraki yakalama olayı uygular',
    () async {
      final (c, n, repo) = await _open();
      final cursor = n.cursor;
      repo
        ..foreignWrite('t1', 'r2', 'c1', 'yeni')
        ..snapshotErrors.add(ApiError('client.network_error'));
      await expectLater(n.catchUp(), throwsA(isA<ApiError>()));
      expect(n.cursor, cursor);
      await n.catchUp();
      expect(_v(c).cell('r2', 'c1').value, 'yeni');
      expect(n.cursor, repo.tables['t1']!.meta.sequence);
    },
  );

  test(
    '3a: geciken kendi makbuzu daha yeni yabancı değeri geri almaz',
    () async {
      final (c, n, repo) = await _open();
      final late = repo.responseGate = Completer<void>();
      n.editCell('r1', 'c1', 'benim');
      final sending = n.flush();
      await pumpEventQueue();
      repo.foreignWrite('t1', 'r1', 'c1', 'onların');
      await n.catchUp();
      late.complete();
      await sending;
      expect(_v(c).cell('r1', 'c1').value, 'onların');
      expect(_v(c).cell('r1', 'c1').version, 2);
    },
  );

  test('3b: geciken eski snapshot daha yeni snapshot\'ı geri almaz', () async {
    final (c, n, repo) = await _open();
    final old = repo.snapshotGate = Completer<void>();
    final a = n.refresh();
    await pumpEventQueue();
    repo.foreignWrite('t1', 'r1', 'c1', 'yeni');
    final b = n.refresh();
    await pumpEventQueue();
    old.complete();
    await Future.wait([a, b]);
    expect(_v(c).cell('r1', 'c1').value, 'yeni');
  });

  test('4a: makbuz sonrası yan okuma düşse de komut başarılıdır', () async {
    final (c, n, repo) = await _open();
    repo.responseGate = Completer<void>()..complete();
    repo.snapshotErrors.add(ApiError('client.network_error'));
    final row = await n.addRow();
    expect(row, isNotNull);
    expect(repo.tables['t1']!.rows, hasLength(4));
    // Görünüm sonraki yakalamada yenilenir.
    await n.catchUp();
    expect(_v(c).rows.map((r) => r.id), contains(row));
  });

  test('4b: belirsiz komut araya başka komut girse de yeniden dene aynı anahtar, tek kayıt', () async {
    final (c, n, repo) = await _open();
    repo.loseNextResponses = 1;
    await expectLater(n.addRow(), throwsA(isA<ApiError>()));
    expect(_v(c).uncertainCommands, 1);
    await n.rename('Yeni ad');
    await n.retryCommands();
    final adds = [
      for (final (k, op) in repo.applied)
        if (op is AddRow) k,
    ];
    expect(adds, hasLength(2));
    expect(adds.first, adds.last);
    expect(repo.tables['t1']!.rows, hasLength(4));
    expect(_v(c).uncertainCommands, 0);
  });

  test('5: çakışma okuması düşerse batch ve diğer yazımlar korunur, hata yakalanır', () async {
    final (c, n, repo) = await _open();
    repo.foreignWrite('t1', 'r1', 'c1', 'onların');
    n
      ..editCell('r1', 'c1', 'x')
      ..editCell('r2', 'c1', 'y');
    repo.snapshotErrors.add(ApiError('client.network_error'));
    await n.flush();
    expect(_v(c).pendingWrites, 2);
    expect(_v(c).writeError, isNotNull);
    await n.retryWrites();
    expect(_v(c).conflicts, contains(_r1));
    expect(repo.tables['t1']!.cells[TableCellKey('r2', 'c1')]!.value, 'y');
    expect(repo.tables['t1']!.cells[_r1]!.value, 'onların');
  });

  test(
    '6: belirsiz batch aynı gövde+anahtarla, yeni düzenleme ayrı gider',
    () async {
      final (c, n, repo) = await _open();
      repo.loseNextResponses = 1;
      n.editCell('r1', 'c1', 'a');
      await n.flush();
      n.editCell('r2', 'c1', 'b');
      await n.flush(); // belirsiz batch çözülmeden yeni düzenleme gitmez
      expect(_sets(repo), hasLength(1));
      await n.retryWrites();
      final sets = _sets(repo);
      expect(sets, hasLength(3));
      expect(repo.applied[1].$1, repo.applied[0].$1);
      expect(sets[1].signature, sets[0].signature);
      expect(sets[2].cells.single.rowId, 'r2');
      expect(repo.tables['t1']!.cells[_r1]!.version, 1);
      expect(_v(c).pendingWrites, 0);
    },
  );

  test(
    '7: snapshot\'ın atladığı yorum olayı yorum listelerini yeniler',
    () async {
      final (c, n, repo) = await _open();
      final rev = _v(c).commentsRevision;
      repo.foreignComment('t1');
      await n.addRow();
      expect(_v(c).commentsRevision, greaterThan(rev));
    },
  );

  group('canlı döngü', () {
    Future<(ProviderContainer, FakeTablesRepository)> live({
      Duration interval = const Duration(milliseconds: 20),
      Duration gap = const Duration(hours: 1),
    }) async {
      final (c, _, repo) = await _open(
        extra: [
          tableLiveTimingProvider.overrideWithValue((
            coalesce: Duration.zero,
            presenceInterval: interval,
            presenceMinGap: gap,
          )),
          tableReconnectDelayProvider.overrideWithValue((_) => Duration.zero),
        ],
      );
      c.listen(tableSyncControllerProvider('t1'), (_, _) {});
      await pumpEventQueue();
      repo.streams.last.add(const TableStreamReady(1));
      await pumpEventQueue();
      return (c, repo);
    }

    test(
      '8: arka plana geçişte uçuştaki yakalama yeni yakalama kurmaz',
      () async {
        final (c, repo) = await live();
        final hold = repo.changesGate = Completer<void>();
        repo.foreignWrite('t1', 'r1', 'c1', 'x');
        repo.streams.last.add(const TableStreamChanged(2));
        await pumpEventQueue();
        repo.foreignWrite('t1', 'r2', 'c1', 'y');
        repo.streams.last.add(const TableStreamChanged(3));
        await pumpEventQueue();
        final calls = repo.changesCalls.length;
        c.read(tablesForegroundProvider.notifier).set(false);
        hold.complete();
        await pumpEventQueue();
        expect(repo.changesCalls.length, calls);
      },
    );

    test('9: presence gönderimleri tek kapıdan: aralık dolmadan periyodik/seçim gitmez', () async {
      final (c, repo) = await live();
      final sync = c.read(tableSyncControllerProvider('t1').notifier)
        ..select('r1', 'c1')
        ..select('r2', 'c1');
      await Future<void>.delayed(const Duration(milliseconds: 80));
      await pumpEventQueue();
      expect(repo.presence.where((p) => p.$1 == 'set'), hasLength(1));
      expect(repo.presence.where((p) => p.$2 == 'r1'), isEmpty);
      sync.select(null, null);
    });

    test(
      '9b: ölçülen presence aralığı en az alt sınır; r1 hiç gitmez',
      () async {
        const gap = Duration(milliseconds: 40);
        final (c, repo) = await live(
          interval: const Duration(milliseconds: 15),
          gap: gap,
        );
        c.read(tableSyncControllerProvider('t1').notifier)
          ..select('r1', 'c1')
          ..select('r2', 'c1');
        await Future<void>.delayed(const Duration(milliseconds: 150));
        await pumpEventQueue();
        final at = repo.presenceAt;
        expect(at.length, greaterThanOrEqualTo(2));
        for (var i = 1; i < at.length; i++) {
          expect(
            at[i].difference(at[i - 1]),
            greaterThanOrEqualTo(gap - const Duration(milliseconds: 2)),
          );
        }
        expect(repo.presence.where((p) => p.$2 == 'r1'), isEmpty);
        expect(repo.presence.where((p) => p.$2 == 'r2'), isNotEmpty);
      },
    );
  });
}
