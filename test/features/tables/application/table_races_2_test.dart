// Yarışlar, tur 2 (Codex hükmü 2): eşit sürümlü makbuz kendi başarısıdır; her kullanıcı
// işlemi ayrı işlem anahtarı; yeni neslin `ready` yakalaması eski uçuşla kaybolmaz; komutla
// doğrulanmış metadata eski snapshot'la geri gitmez; yalnız `_viewSequence` koruması; presence
// uçuş kapısı ve 429 `Retry-After`; durum çubuğunun görünürlük kapısı.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tables/application/table_controller.dart';
import 'package:nizamio/features/tables/application/table_sync_controller.dart';
import 'package:nizamio/features/tables/application/table_view.dart';
import 'package:nizamio/features/tables/application/tables_list_controller.dart';
import 'package:nizamio/features/tables/application/tables_providers.dart';
import 'package:nizamio/features/tables/domain/table_models.dart';
import 'package:nizamio/features/tables/domain/table_operation.dart';
import 'package:nizamio/features/tables/presentation/table_live.dart';

import '../../../core/ui/widgets/feedback/feedback_test_support.dart';
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

List<Override> _liveTiming({
  Duration interval = const Duration(hours: 1),
  Duration gap = Duration.zero,
}) => [
  tableLiveTimingProvider.overrideWithValue((
    coalesce: Duration.zero,
    presenceInterval: interval,
    presenceMinGap: gap,
  )),
  tableReconnectDelayProvider.overrideWithValue((_) => Duration.zero),
];

Future<(ProviderContainer, FakeTablesRepository)> _live({
  Duration interval = const Duration(hours: 1),
  Duration gap = Duration.zero,
}) async {
  final (c, _, repo) = await _open(
    extra: _liveTiming(interval: interval, gap: gap),
  );
  c.listen(tableSyncControllerProvider('t1'), (_, _) {});
  await pumpEventQueue();
  return (c, repo);
}

void main() {
  test('Y1: kendi yazımını önce gören snapshot sonrası makbuz → arkadaki düzenleme kaybolmaz', () async {
    final (c, n, repo) = await _open();
    final late = repo.responseGate = Completer<void>();
    n.editCell('r1', 'c1', 'A');
    final sending = n.flush();
    await pumpEventQueue();
    n.editCell('r1', 'c1', 'B'); // taban 0 (A uçuşta)
    await n.catchUp(); // snapshot A'yı sürüm 1 ile görür (makbuz henüz yok)
    late.complete();
    await sending;
    await n.flush();
    expect(repo.tables['t1']!.cells[_r1]!.value, 'B');
    expect(repo.tables['t1']!.cells[_r1]!.version, 2);
    expect(_v(c).conflicts, isEmpty);
    expect(_v(c).pendingWrites, 0);
  });

  test('Y2: belirsiz komuttan sonraki yeni işlem ayrı anahtarla ayrı kayıt oluşturur', () async {
    final (_, n, repo) = await _open();
    repo.loseNextResponses = 1;
    await expectLater(n.addRow(), throwsA(isA<ApiError>()));
    await n.addRow();
    final keys = [
      for (final (k, op) in repo.applied)
        if (op is AddRow) k,
    ];
    expect(keys, hasLength(2));
    expect(keys.first, isNot(keys.last));
    expect(repo.tables['t1']!.rows, hasLength(5));
  });

  test('Y3: eski uçuş bitmeden ön plana dönüş; yeni neslin ready yakalaması kaybolmaz', () async {
    final (c, repo) = await _live();
    repo.streams.last.add(const TableStreamReady(1));
    await pumpEventQueue();
    // Eski neslin yakalaması: changes döner, yeniden okuma (snapshot) uçuşta kalır.
    final hold = repo.snapshotGate = Completer<void>();
    repo.foreignWrite('t1', 'r1', 'c1', 'x');
    repo.streams.last.add(const TableStreamChanged(2));
    await pumpEventQueue();
    final fg = c.read(tablesForegroundProvider.notifier)..set(false);
    await pumpEventQueue();
    fg.set(true);
    await pumpEventQueue();
    // Yeni bağlantı açılırken başka biri yazar; yeni neslin ready'si bunu yakalamalı.
    repo.foreignWrite('t1', 'r2', 'c1', 'y');
    repo.streams.last.add(const TableStreamReady(3));
    await pumpEventQueue();
    hold.complete();
    await pumpEventQueue();
    expect(_v(c).cell('r2', 'c1').value, 'y');
    expect(c.read(tableControllerProvider('t1').notifier).cursor, 3);
  });

  test(
    'O4: komutla doğrulanmış ad, geciken eski snapshot\'la geri gitmez',
    () async {
      final (c, n, repo) = await _open();
      final old = repo.snapshotGate = Completer<void>();
      final reading = n.refresh();
      await pumpEventQueue();
      await n.rename('Yeni ad');
      old.complete();
      await reading;
      expect(_v(c).meta.name, 'Yeni ad');
    },
  );

  test('viewSequence: sıradan sonra gelen ama daha eski sıralı snapshot uygulanmaz', () async {
    final (c, n, repo) = await _open();
    final stale = await repo.snapshot(_v(c).meta.scope, 't1');
    repo.foreignWrite('t1', 'r1', 'c1', 'yeni');
    await n.refresh();
    repo.queuedSnapshots.add(stale);
    await n.refresh();
    expect(_v(c).cell('r1', 'c1').value, 'yeni');
    expect(_v(c).meta.sequence, 2);
  });

  test(
    'presence uçuş kapısı: istek uçuştayken seçim/periyodik ikinci istek açmaz',
    () async {
      final (c, repo) = await _live(interval: const Duration(milliseconds: 1));
      final gate = repo.presenceGate = Completer<void>();
      repo.streams.last.add(const TableStreamReady(1));
      await pumpEventQueue();
      c.read(tableSyncControllerProvider('t1').notifier)
        ..select('r1', 'c1')
        ..select('r2', 'c1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await pumpEventQueue();
      expect(repo.presence, hasLength(1));
      gate.complete();
      await pumpEventQueue();
      expect(repo.presence[1].$2, 'r2');
      expect(repo.presence.where((p) => p.$2 == 'r1'), isEmpty);
    },
  );

  test('presence 429: Retry-After süresince yeni gönderim yok', () async {
    final (c, repo) = await _live(interval: const Duration(milliseconds: 1));
    repo.presenceErrors.add(
      ApiError(
        'tables.presence_throttled',
        status: 429,
        retryAfter: const Duration(hours: 1),
      ),
    );
    repo.streams.last.add(const TableStreamReady(1));
    await pumpEventQueue();
    c.read(tableSyncControllerProvider('t1').notifier).select('r1', 'c1');
    await Future<void>.delayed(const Duration(milliseconds: 10));
    await pumpEventQueue();
    expect(repo.presence, hasLength(1));
  });

  testWidgets('TableLiveBar görünmezken (TickerMode kapalı) akışı kurmaz', (
    tester,
  ) async {
    final repo = FakeTablesRepository()..add('t1');
    final c = tablesContainer(repo, extra: _liveTiming());
    final page = await repo.snapshot(
      const TableScope.coordinatorship(programId: 'p1', departmentId: 'd1'),
      't1',
      page: const PageRequest(limit: 1),
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        child: testApp(
          TickerMode(
            enabled: false,
            child: TableLiveBar(id: 't1', view: TableView.fromPage(page, 'me')),
          ),
        ),
      ),
    );
    expect(c.exists(tableSyncControllerProvider('t1')), isFalse);
  });

  test(
    'O1a: geciken ad makbuzu daha yeni snapshot\'taki adı geri ezmez',
    () async {
      final (c, n, repo) = await _open();
      final late = repo.responseGate = Completer<void>();
      final renaming = n.rename('Benim');
      await pumpEventQueue();
      repo.foreignRename('t1', 'Onların');
      await n.catchUp();
      expect(_v(c).meta.name, 'Onların');
      late.complete();
      await renaming;
      expect(_v(c).meta.name, 'Onların');
    },
  );

  test('O1b: geciken sütun makbuzu daha yeni snapshot\'taki sütun adını geri ezmez', () async {
    final (c, n, repo) = await _open();
    final late = repo.responseGate = Completer<void>();
    final renaming = n.renameColumn('c1', 'Benim');
    await pumpEventQueue();
    repo.foreignRename('t1', 'Onların', columnId: 'c1');
    await n.catchUp();
    late.complete();
    await renaming;
    expect(_v(c).column('c1')!.name, 'Onların');
  });

  test('O2: belirsiz silme yeniden denenince listeden düşer', () async {
    final (c, n, repo) = await _open();
    c.listen(tablesListControllerProvider, (_, _) {});
    await c.read(tablesListControllerProvider.future);
    repo.loseNextResponses = 1;
    await expectLater(n.deleteTable(), throwsA(isA<ApiError>()));
    expect(c.read(tablesListControllerProvider).value!.find('t1'), isNotNull);
    await n.retryCommands();
    expect(c.read(tablesListControllerProvider).value!.find('t1'), isNull);
    expect(_v(c).deleted, isTrue);
    expect(_v(c).uncertainCommands, 0);
  });
}
