// Bellek içi tablo sunucusu: hücre CAS (K-03/K-05 batch atomik), şema CAS (K-08), işlem
// anahtarı tekrarı (K-04), sıra artışı. Testler hata enjekte eder ve çağrıları sayar.
import 'dart:async';

import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tables/domain/table_models.dart';
import 'package:nizamio/features/tables/domain/table_operation.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';

class FakeTable {
  FakeTable(this.meta);
  TableMeta meta;

  /// Olay günlüğü (seq, tür); `changes` buradan okunur.
  final events = <TableChangeEntry>[];
  final columns = <TableColumnSpec>[];
  final rows = <TableRowRef>[];
  final cells = <TableCellKey, TableCellData>{};
}

class FakeTablesRepository implements TablesRepository {
  final tables = <String, FakeTable>{};
  final applied = <(String key, TableOperation op)>[];
  final snapshots = <(TableScope, String, String?)>[];
  final lists = <TableScope>[];

  /// Sıradaki `apply` çağrısında fırlatılacak hatalar (sunucuya ulaşmadan).
  final applyErrors = <ApiError>[];

  /// Bir sonraki apply sunucuda İŞLENİR ama yanıt kaybolur (zaman aşımı).
  int loseNextResponses = 0;

  /// Bir sonraki apply bu tamamlayıcıyı bekler (uçuştaki batch).
  Completer<void>? gate;

  /// Bir sonraki apply sunucuda HEMEN işlenir, yanıtı bu tamamlayıcıyı bekler (geciken makbuz).
  Completer<void>? responseGate;

  /// Bir sonraki snapshot o anki durumu okur, yanıtı bu tamamlayıcıyı bekler (geciken snapshot).
  Completer<void>? snapshotGate;

  /// Bir sonraki changes yanıtı bu tamamlayıcıyı bekler.
  Completer<void>? changesGate;

  /// Sıradaki snapshot hataları.
  final snapshotErrors = <ApiError>[];

  /// Presence gönderim zamanları (gerçek saat; aralık ölçümü).
  final presenceAt = <DateTime>[];

  /// Bir sonraki presence yanıtı bu tamamlayıcıyı bekler (uçuştaki istek).
  Completer<void>? presenceGate;

  /// Sıradaki presence hataları (ör. 429 + Retry-After).
  final presenceErrors = <ApiError>[];

  /// Sıradaki snapshot yanıtları bunlardan döner (geride kalan kopya / eski okuma).
  final queuedSnapshots = <TableSnapshotPage>[];

  /// Açılan akışlar (test çerçeve/hata/kapanış iter).
  final streams = <StreamController<TableStreamEvent>>[];

  /// `changes` çağrıları (after) ve sıradaki changes hataları.
  final changesCalls = <int>[];
  final changesErrors = <ApiError>[];

  /// Presence çağrıları: ('set', row, col) / ('leave', null, null).
  final presence = <(String, String?, String?)>[];

  /// Sıradaki akış açılış hataları.
  final streamErrors = <ApiError>[];

  final _receipts = <String, (String, TableReceipt)>{};
  var _serial = 0;

  FakeTable add(
    String id, {
    TableScope scope = const TableScope.coordinatorship(
      programId: 'p1',
      departmentId: 'd1',
    ),
    String owner = 'me',
    List<TableColumnKind> columns = const [TableColumnKind.text],
    int rows = 1,
  }) {
    final t = FakeTable(
      TableMeta(
        id: id,
        ownerId: owner,
        name: 'Tablo $id',
        scope: scope,
        schemaVersion: 1,
        sequence: 1,
      ),
    );
    for (var i = 0; i < columns.length; i++) {
      t.columns.add(
        TableColumnSpec(
          id: 'c${i + 1}',
          name: 'Sütun ${i + 1}',
          kind: columns[i],
          width: 200,
          position: i + 1,
        ),
      );
    }
    for (var i = 0; i < rows; i++) {
      t.rows.add(TableRowRef(id: 'r${i + 1}', position: i + 1));
    }
    tables[id] = t;
    return t;
  }

  /// Başka bir kullanıcının yazımı (sürüm ve sıra artar).
  void foreignWrite(String id, String row, String col, Object? value) {
    final t = tables[id]!;
    final k = TableCellKey(row, col);
    final old = t.cells[k] ?? TableCellData.empty;
    t.cells[k] = TableCellData(value: value, version: old.version + 1);
    t.meta = t.meta.copyWith(sequence: t.meta.sequence + 1);
    t.events.add(
      TableChangeEntry(seq: t.meta.sequence, kind: TableChangeKind.setCells),
    );
  }

  /// Başkasının tablo/sütun yeniden adlandırması (sıra ve olay artar).
  void foreignRename(String id, String name, {String? columnId}) {
    final t = tables[id]!;
    if (columnId == null) {
      t.meta = TableMeta(
        id: t.meta.id,
        ownerId: t.meta.ownerId,
        name: name,
        scope: t.meta.scope,
        schemaVersion: t.meta.schemaVersion,
        sequence: t.meta.sequence,
      );
    } else {
      final i = t.columns.indexWhere((c) => c.id == columnId);
      t.columns[i] = t.columns[i].copyWith(name: name);
      t.meta = t.meta.copyWith(schemaVersion: t.meta.schemaVersion + 1);
    }
    t.meta = t.meta.copyWith(sequence: t.meta.sequence + 1);
    t.events.add(
      TableChangeEntry(
        seq: t.meta.sequence,
        kind: columnId == null
            ? TableChangeKind.renameTable
            : TableChangeKind.renameColumn,
      ),
    );
  }

  /// Başkasının yorumu (yalnız olay; içerik testte gerekmez).
  void foreignComment(String id) {
    final t = tables[id]!;
    t.meta = t.meta.copyWith(sequence: t.meta.sequence + 1);
    t.events.add(
      TableChangeEntry(seq: t.meta.sequence, kind: TableChangeKind.addComment),
    );
  }

  FakeTable _get(TableScope scope, String id) {
    final t = tables[id];
    if (t == null || t.meta.scope != scope) {
      throw ApiError('tables.not_found', status: 404);
    }
    return t;
  }

  @override
  Future<PageSlice<TableMeta>> list(
    TableScope scope, {
    PageRequest page = const PageRequest(),
    bool? template,
  }) async {
    lists.add(scope);
    return PageSlice(
      items: [
        for (final t in tables.values)
          if (t.meta.scope == scope) t.meta,
      ],
    );
  }

  @override
  Future<TableReceipt> create(
    TableScope scope,
    String name, {
    required String requestKey,
  }) async {
    final id = 'new${++_serial}';
    add(id, scope: scope).meta = TableMeta(
      id: id,
      ownerId: 'me',
      name: name,
      scope: scope,
      schemaVersion: 1,
      sequence: 0,
    );
    return TableReceipt(
      tableId: id,
      sequence: 0,
      schemaVersion: 1,
      replayed: false,
      id: id,
    );
  }

  @override
  Future<TableSnapshotPage> snapshot(
    TableScope scope,
    String tableId, {
    PageRequest page = const PageRequest(),
  }) async {
    snapshots.add((scope, tableId, page.cursor));
    if (snapshotErrors.isNotEmpty) {
      final e = snapshotErrors.removeAt(0);
      // Kapı varsa hata da gecikir (geciken hata yanıtı).
      final g = snapshotGate;
      if (g != null) {
        snapshotGate = null;
        await g.future;
      }
      throw e;
    }
    if (queuedSnapshots.isNotEmpty) return queuedSnapshots.removeAt(0);
    final t = _get(scope, tableId);
    final limit = page.limit ?? 100;
    final start = page.cursor == null ? 0 : int.parse(page.cursor!);
    final rows = t.rows.skip(start).take(limit).toList();
    final end = start + rows.length;
    final result = TableSnapshotPage(
      meta: t.meta,
      columns: [...t.columns],
      rows: rows,
      cells: {
        for (final e in t.cells.entries)
          if (rows.any((r) => _rowOf(e.key, r.id, t))) e.key: e.value,
      },
      nextCursor: end < t.rows.length ? '$end' : null,
    );
    final g = snapshotGate;
    if (g != null) {
      snapshotGate = null;
      await g.future;
    }
    return result;
  }

  bool _rowOf(TableCellKey k, String row, FakeTable t) =>
      t.columns.any((c) => k == TableCellKey(row, c.id));

  @override
  Future<TableReceipt> apply(
    TableScope scope,
    String tableId,
    TableOperation operation, {
    required String requestKey,
  }) async {
    applied.add((requestKey, operation));
    final g = gate;
    if (g != null) {
      gate = null;
      await g.future;
    }
    if (applyErrors.isNotEmpty) throw applyErrors.removeAt(0);
    final previous = _receipts[requestKey];
    if (previous != null) {
      if (previous.$1 != operation.signature) {
        throw ApiError('tables.idempotency_key_reused', status: 409);
      }
      final r = previous.$2;
      return TableReceipt(
        tableId: r.tableId,
        sequence: r.sequence,
        schemaVersion: r.schemaVersion,
        replayed: true,
        id: r.id,
        cellVersions: r.cellVersions,
      );
    }
    final t = _get(scope, tableId);
    final receipt = _execute(t, operation);
    _receipts[requestKey] = (operation.signature, receipt);
    final rg = responseGate;
    if (rg != null) {
      responseGate = null;
      await rg.future;
    }
    if (loseNextResponses > 0) {
      loseNextResponses--;
      throw ApiError('client.timeout');
    }
    return receipt;
  }

  TableReceipt _execute(FakeTable t, TableOperation op) {
    if (op.schemaBound) {
      final expected = switch (op) {
        AddColumn(:final expectedSchema) ||
        RenameColumn(:final expectedSchema) ||
        ResizeColumn(:final expectedSchema) ||
        DeleteColumn(:final expectedSchema) ||
        MoveColumn(:final expectedSchema) ||
        ConvertColumn(:final expectedSchema) => expectedSchema,
        _ => 0,
      };
      if (expected != t.meta.schemaVersion) {
        throw ApiError('tables.schema_conflict', status: 409);
      }
    }
    final versions = <TableCellKey, int>{};
    String? id;
    var schema = t.meta.schemaVersion;
    switch (op) {
      case SetCells(:final cells):
        for (final c in cells) {
          final current = t.cells[c.key]?.version ?? 0;
          if (current != c.version) {
            throw ApiError('tables.cell_conflict', status: 409);
          }
        }
        for (final c in cells) {
          final v = (t.cells[c.key]?.version ?? 0) + 1;
          t.cells[c.key] = TableCellData(value: c.value, version: v);
          versions[c.key] = v;
        }
      case AddRow():
        id = 'r${t.rows.length + 1}x${++_serial}';
        t.rows.add(TableRowRef(id: id, position: t.rows.length + 1));
      case DeleteRow(id: final row):
        t.rows.removeWhere((r) => r.id == row);
      case AddColumn(:final name, :final kind):
        id = 'c${t.columns.length + 1}x${++_serial}';
        t.columns.add(
          TableColumnSpec(
            id: id,
            name: name,
            kind: kind,
            width: 200,
            position: t.columns.length + 1,
          ),
        );
        schema++;
      case RenameColumn(id: final col, :final name):
        final i = t.columns.indexWhere((c) => c.id == col);
        t.columns[i] = t.columns[i].copyWith(name: name);
        schema++;
      case ResizeColumn(id: final col, :final width):
        final i = t.columns.indexWhere((c) => c.id == col);
        t.columns[i] = t.columns[i].copyWith(width: width);
        schema++; // backend: resize_column şema değişikliğidir (store.go:194)
      case RenameTable(:final name):
        t.meta = TableMeta(
          id: t.meta.id,
          ownerId: t.meta.ownerId,
          name: name,
          scope: t.meta.scope,
          schemaVersion: schema,
          sequence: t.meta.sequence,
        );
      default:
        break;
    }
    t.meta = t.meta.copyWith(
      sequence: t.meta.sequence + 1,
      schemaVersion: schema,
    );
    t.events.add(
      TableChangeEntry(
        seq: t.meta.sequence,
        kind: switch (op) {
          SetCells() => TableChangeKind.setCells,
          AddRow() => TableChangeKind.addRow,
          AddComment() => TableChangeKind.addComment,
          _ => TableChangeKind.renameTable,
        },
      ),
    );
    return TableReceipt(
      tableId: t.meta.id,
      sequence: t.meta.sequence,
      schemaVersion: schema,
      replayed: false,
      id: id,
      cellVersions: versions,
    );
  }

  @override
  Future<TableChangesPage> changes(
    TableScope scope,
    String tableId, {
    required int after,
    int? limit,
  }) async {
    changesCalls.add(after);
    if (changesErrors.isNotEmpty) throw changesErrors.removeAt(0);
    final t = _get(scope, tableId);
    final page = [
      for (final e in t.events)
        if (e.seq > after) e,
    ].take(limit ?? 100).toList();
    final cursor = page.isEmpty ? after : page.last.seq;
    final result = TableChangesPage(
      changes: page,
      cursor: cursor,
      sequence: t.meta.sequence,
      more: cursor < t.meta.sequence,
    );
    // Yanıt o anki günlükten hesaplanır, teslimi kapıyı bekler (geciken yanıt).
    final g = changesGate;
    if (g != null) {
      changesGate = null;
      await g.future;
    }
    return result;
  }

  @override
  Future<PageSlice<TableCommentItem>> comments(
    TableScope scope,
    String tableId, {
    String? rowId,
    PageRequest page = const PageRequest(),
  }) async => PageSlice(items: const []);

  @override
  Future<void> setPresence(
    TableScope scope,
    String tableId, {
    String? rowId,
    String? columnId,
  }) async {
    presence.add(('set', rowId, columnId));
    presenceAt.add(DateTime.now());
    final g = presenceGate;
    if (g != null) {
      presenceGate = null;
      await g.future;
    }
    if (presenceErrors.isNotEmpty) throw presenceErrors.removeAt(0);
  }

  @override
  Future<void> leavePresence(TableScope scope, String tableId) async =>
      presence.add(('leave', null, null));

  @override
  Stream<TableStreamEvent> stream(TableScope scope, String tableId) {
    if (streamErrors.isNotEmpty) {
      return Stream.error(streamErrors.removeAt(0));
    }
    final c = StreamController<TableStreamEvent>();
    streams.add(c);
    return c.stream;
  }
}
