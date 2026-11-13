// Canlı tablo senkronu: akış açılışı (tablo yüklenince), ready/changed → changes ile yakalama,
// yabancı değişiklik → snapshot yenileme, kendi yankısı → yenileme yok, olay birleştirme
// (tek uçuş + tek bekleyen), replay_expired → tam yükleme, yorum olayı → yorum sayacı,
// kopma → geri çekilmeli yeniden bağlanma + imleçten yakalama, 403 → çevrimdışı, 429
// Retry-After, arka plan → akış ve presence kapanır, presence döngüsü ve seçim aralığı,
// bekleyen yazımın ezilmemesi. Zamanlama kısaltılmış sağlayıcılarla; gecikme sabit.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tables/application/table_controller.dart';
import 'package:nizamio/features/tables/application/table_sync_controller.dart';
import 'package:nizamio/features/tables/application/table_view.dart';
import 'package:nizamio/features/tables/application/tables_providers.dart';
import 'package:nizamio/features/tables/domain/table_models.dart';

import '../fake_tables_repository.dart';
import '../tables_test_support.dart';

// Birleştirme ve yeniden bağlanma beklemesi sıfır: sıra yalnız olay kuyruğuyla ilerler
// (gerçek zaman penceresi yok). Ara durumlar [_Live.states] kaydıyla doğrulanır.
const _coalesce = Duration.zero;

Future<void> _settle() => pumpEventQueue();

class _Live {
  _Live(this.repo, this.c, this.reconnects);
  final FakeTablesRepository repo;
  final ProviderContainer c;

  /// Yeniden bağlanma beklemesi istenen ardışık başarısızlık sayıları.
  final List<int> reconnects;

  /// Canlı durumun bütün geçişleri (sırayla).
  final states = <TableLiveStatus>[];

  TableController get table => c.read(tableControllerProvider('t1').notifier);
  TableView get view => c.read(tableControllerProvider('t1')).requireValue;
  TableLiveState get live => c.read(tableSyncControllerProvider('t1'));
  StreamController<TableStreamEvent> get stream => repo.streams.last;
  int get snapshots => repo.snapshots.length;
}

Future<_Live> _open({
  FakeTablesRepository? repo,
  Duration presenceInterval = const Duration(seconds: 10),
  Duration presenceMinGap = const Duration(milliseconds: 40),
}) async {
  final r = repo ?? (FakeTablesRepository()..add('t1', rows: 3));
  final delays = <int>[];
  final c = tablesContainer(
    r,
    extra: [
      tableLiveTimingProvider.overrideWithValue((
        coalesce: _coalesce,
        presenceInterval: presenceInterval,
        presenceMinGap: presenceMinGap,
      )),
      tableReconnectDelayProvider.overrideWithValue((failures) {
        delays.add(failures);
        return Duration.zero;
      }),
    ],
  );
  c
    ..listen(tableControllerProvider('t1'), (_, _) {})
    ..listen(tableSyncControllerProvider('t1'), (_, _) {});
  await c.read(tableControllerProvider('t1').future);
  final live = _Live(r, c, delays);
  c.listen(
    tableSyncControllerProvider('t1'),
    (_, next) => live.states.add(next.status),
    fireImmediately: true,
  );
  await _settle();
  return live;
}

/// Akışa `ready` verip ilk yakalamayı bitirir.
Future<void> _ready(_Live s) async {
  s.stream.add(TableStreamReady(s.view.meta.sequence));
  await _settle();
}

void main() {
  test(
    'tablo yüklenince akış açılır; ready → canlı, imleçten yakalama',
    () async {
      final s = await _open();
      expect(s.repo.streams, hasLength(1));
      expect(s.live.status, TableLiveStatus.connecting);
      await _ready(s);
      expect(s.live.status, TableLiveStatus.live);
      expect(s.repo.changesCalls, [1]);
    },
  );

  test(
    'yabancı değişiklik: changes → snapshot yeniden okunur, değer görünür',
    () async {
      final s = await _open();
      await _ready(s);
      final before = s.snapshots;
      s.repo.foreignWrite('t1', 'r2', 'c1', 'onların');
      s.stream.add(TableStreamChanged(s.repo.tables['t1']!.meta.sequence));
      await _settle();
      expect(s.snapshots, before + 1);
      expect(s.view.cell('r2', 'c1').value, 'onların');
      expect(s.table.cursor, s.repo.tables['t1']!.meta.sequence);
    },
  );

  test('kendi yankısı: changes okunur ama snapshot okunmaz', () async {
    final s = await _open();
    await _ready(s);
    s.table.editCell('r1', 'c1', 'benim');
    await s.table.flush();
    final before = s.snapshots;
    final calls = s.repo.changesCalls.length;
    s.stream.add(TableStreamChanged(s.repo.tables['t1']!.meta.sequence));
    await _settle();
    expect(s.repo.changesCalls.length, calls + 1);
    expect(s.snapshots, before);
    expect(s.table.cursor, s.repo.tables['t1']!.meta.sequence);
  });

  test(
    'ardışık changed birleştirilir; imleçten küçük ipucu yok sayılır',
    () async {
      final s = await _open();
      await _ready(s);
      final calls = s.repo.changesCalls.length;
      for (var i = 0; i < 3; i++) {
        s.repo.foreignWrite('t1', 'r1', 'c1', 'v$i');
        s.stream.add(TableStreamChanged(s.repo.tables['t1']!.meta.sequence));
      }
      await _settle();
      expect(s.repo.changesCalls.length, calls + 1);
      s.stream.add(TableStreamChanged(s.table.cursor));
      await _settle();
      expect(s.repo.changesCalls.length, calls + 1);
    },
  );

  test('replay_expired: tam yeniden yükleme', () async {
    final s = await _open();
    await _ready(s);
    s.repo.foreignWrite('t1', 'r1', 'c1', 'x');
    s.repo.changesErrors.add(ApiError('tables.replay_expired', status: 409));
    final before = s.snapshots;
    s.stream.add(TableStreamChanged(s.repo.tables['t1']!.meta.sequence));
    await _settle();
    expect(s.snapshots, greaterThan(before));
    expect(s.view.cell('r1', 'c1').value, 'x');
  });

  test('yorum olayı yalnız yorum sayacını artırır (snapshot yok)', () async {
    final s = await _open();
    await _ready(s);
    final before = s.snapshots;
    final rev = s.view.commentsRevision;
    s.repo.foreignComment('t1');
    s.stream.add(TableStreamChanged(s.repo.tables['t1']!.meta.sequence));
    await _settle();
    expect(s.snapshots, before);
    expect(s.view.commentsRevision, rev + 1);
  });

  test('changes 404: erişim kaybı, tablo salt okunur', () async {
    final s = await _open();
    await _ready(s);
    s.repo.changesErrors.add(ApiError('tables.not_found', status: 404));
    s.stream.add(TableStreamChanged(s.table.cursor + 1));
    await _settle();
    expect(s.view.accessLost, isTrue);
    expect(s.view.editable, isFalse);
  });

  test('kopma: geri çekilmeyle yeniden bağlanır, ready kaçan olayı imleçten yakalar', () async {
    final s = await _open();
    await _ready(s);
    final cursor = s.table.cursor;
    await s.stream.close();
    await _settle();
    expect(s.states, contains(TableLiveStatus.retrying));
    expect(s.repo.streams, hasLength(2));
    expect(s.reconnects, isNotEmpty);
    s.repo.foreignWrite('t1', 'r3', 'c1', 'kopukken');
    await _ready(s);
    expect(s.repo.changesCalls.last, cursor);
    expect(s.view.cell('r3', 'c1').value, 'kopukken');
    expect(s.live.status, TableLiveStatus.live);
  });

  test('ağ hatası yeniden dener; 403 açılışı durur (çevrimdışı)', () async {
    final s = await _open();
    s.repo.streamErrors.add(ApiError('tables.forbidden', status: 403));
    s.stream.addError(ApiError('client.network_error'));
    await _settle();
    expect(
      s.states,
      containsAllInOrder([TableLiveStatus.retrying, TableLiveStatus.offline]),
    );
    expect(s.live.status, TableLiveStatus.offline);
    final opened = s.repo.streams.length;
    await _settle();
    expect(s.repo.streams.length, opened);
  });

  test('429 Retry-After: süre dolmadan akış açılmaz', () async {
    final s = await _open();
    s.stream.addError(
      ApiError(
        'platform.rate_limited',
        status: 429,
        retryAfter: const Duration(hours: 1),
      ),
    );
    await _settle();
    expect(s.repo.streams, hasLength(1));
    expect(s.live.status, TableLiveStatus.retrying);
  });

  test(
    'arka plan: akış kapanır, presence silinir; ön plan: yeniden açılır',
    () async {
      final s = await _open();
      await _ready(s);
      expect(s.repo.presence.first.$1, 'set');
      s.c.read(tablesForegroundProvider.notifier).set(false);
      await _settle();
      expect(s.repo.streams.first.hasListener, isFalse);
      expect(s.live.status, TableLiveStatus.idle);
      expect(s.repo.presence.last.$1, 'leave');
      s.c.read(tablesForegroundProvider.notifier).set(true);
      await _settle();
      expect(s.repo.streams, hasLength(2));
      expect(s.live.status, TableLiveStatus.connecting);
    },
  );

  test('presence: uçuştaki gönderim varken seçimler tek bekleyende birleşir; katılımcı listesi', () async {
    // Uçuş kapısıyla deterministik: açılış gönderimi uçuştayken iki seçim yapılır; yalnız
    // sonuncusu (r2) tek bekleyen olarak gider, r1 hiç gitmez. Aralık sıfır, periyot uzun.
    final s = await _open(presenceMinGap: Duration.zero);
    final gate = s.repo.presenceGate = Completer<void>();
    s.stream.add(TableStreamReady(s.view.meta.sequence));
    await _settle();
    expect(s.repo.presence, hasLength(1));
    s.c.read(tableSyncControllerProvider('t1').notifier)
      ..select('r1', 'c1')
      ..select('r2', 'c1');
    await _settle();
    expect(s.repo.presence, hasLength(1));
    gate.complete();
    await _settle();
    expect(s.repo.presence.map((p) => p.$2), [null, 'r2']);
    s.stream.add(
      TablePresenceUpdate(const [
        TableParticipant(
          key: 'k',
          accountId: 'a2',
          name: 'Ali',
          rowId: 'r1',
          columnId: 'c1',
        ),
      ]),
    );
    await _settle();
    expect(s.live.participants.single.name, 'Ali');
  });

  test(
    'yabancı yenileme bekleyen yazımı ezmez; aynı hücre çakışma işaretlenir',
    () async {
      final s = await _open();
      await _ready(s);
      s.table
        ..editCell('r1', 'c1', 'benim')
        ..editCell('r2', 'c1', 'benim2');
      s.repo
        ..foreignWrite('t1', 'r1', 'c1', 'onların')
        ..foreignWrite('t1', 'r3', 'c1', 'başka');
      await s.table.catchUp();
      expect(s.view.cell('r1', 'c1').value, 'benim');
      expect(s.view.cell('r2', 'c1').value, 'benim2');
      expect(s.view.cell('r3', 'c1').value, 'başka');
      expect(s.view.conflicts, {TableCellKey('r1', 'c1')});
      expect(s.view.pendingWrites, 2);
    },
  );
}
