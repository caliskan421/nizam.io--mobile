import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tables/application/table_detail_controller.dart';
import 'package:nizamio/features/tables/application/tables_server.dart';
import 'package:nizamio/features/tables/domain/table_edit.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';

import '../../../app/router/table_workspace_flow_test.dart'
    show WorkspaceServer, workspaceChoices;

class TestSession extends Notifier<int> {
  @override
  int build() => 1;
  void change() => state++;
}

final session = NotifierProvider<TestSession, int>(TestSession.new);

ProviderContainer setup(WorkspaceServer server) {
  final c = ProviderContainer(
    overrides: [
      tablesRepositoryProvider.overrideWithValue(server),
      tableSharingChoicesProvider.overrideWith((ref) async => workspaceChoices),
      scopeStateProvider.overrideWith(
        (ref) => const ScopeSelection(programId: 'p1'),
      ),
      sessionGenerationProvider.overrideWith((ref) => ref.watch(session)),
    ],
  );
  addTearDown(c.dispose);
  final listener = c.listen(tableDetailProvider('t1'), (_, _) {});
  addTearDown(listener.close);
  return c;
}

Future<void> flush() async {
  for (var i = 0; i < 20; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

class LiveServer extends WorkspaceServer {
  LiveServer() {
    addTearDown(live.close);
  }
  // Closed by the constructor’s registered test teardown.
  // ignore: close_sinks
  final live = StreamController<TableLiveEvent>.broadcast();
  final afters = <int>[];
  final presenceCalls = <({String? row, String? column, bool leave})>[];
  @override
  Stream<TableLiveEvent> watch(TableLocation l, String id) => live.stream;
  @override
  Future<TableChangePage> changes(TableLocation l, String id, int after) async {
    afters.add(after);
    if (after == 1) {
      return const TableChangePage(
        [TableChangeEntry(2, 'add_row'), TableChangeEntry(3, 'set_cells')],
        3,
        1000,
        true,
      );
    }
    if (after == 3) {
      return const TableChangePage(
        [TableChangeEntry(4, 'rename_table')],
        4,
        1000,
        false,
      );
    }
    return TableChangePage([], after, 1000, false);
  }

  @override
  Future<void> presence(
    TableLocation l,
    String id, {
    String? row,
    String? column,
    bool leave = false,
  }) async {
    presenceCalls.add((row: row, column: column, leave: leave));
  }
}

class SlowWriteServer extends WorkspaceServer {
  final pending = Completer<TableOperationReceipt>();
  @override
  Future<TableOperationReceipt> execute(
    TableLocation l,
    String id,
    TableEdit edit,
    String key,
  ) => pending.future;
}

void main() {
  test(
    'yanıt kaybolursa aynı komut ve anahtar sürer; ikinci satır oluşmaz',
    () async {
      final server = WorkspaceServer();
      final c = setup(server);
      await flush();
      final controller = c.read(tableDetailProvider('t1').notifier);
      expect(c.read(tableDetailProvider('t1')).data, isNotNull);
      server.loseReply = true;
      expect(await controller.send(const AddTableRow()), isNull);
      expect(server.rows.length, 1);
      expect(c.read(tableDetailProvider('t1')).pending, isTrue);
      expect(await controller.send(const RenameTable('Başka işlem')), isNull);
      expect(server.edits.length, 1);
      expect(await controller.retry(), isNotNull);
      expect(server.edits.map((e) => e.key).toSet().length, 1);
      expect(server.rows.length, 1);
      expect(c.read(tableDetailProvider('t1')).pending, isFalse);
      await flush();
    },
  );
  test('eski oturumdaki yazmanın cevabı yeni oturuma uygulanmaz', () async {
    final server = SlowWriteServer();
    final c = setup(server);
    await flush();
    final controller = c.read(tableDetailProvider('t1').notifier);
    final writing = controller.send(const AddTableRow());
    c.read(session.notifier).change();
    await flush();
    server.pending.complete(
      const TableOperationReceipt(
        table: 't1',
        sequence: 999,
        schema: 99,
        id: 'old-row',
      ),
    );
    expect(await writing, isNull);
    expect(c.read(tableDetailProvider('t1')).pending, isFalse);
    expect(c.read(tableDetailProvider('t1')).data?.schema, 1);
  });
  test('SSE sequence replay imlecinin yerine geçmez; changes bütün sayfaları tüketir', () async {
    final server = LiveServer();
    addTearDown(server.live.close);
    final c = setup(server);
    await flush();
    server.sequence = 1000;
    server.live.add(const TableLiveEvent(1000));
    await flush();
    expect(server.afters, [1, 3]);
    expect(c.read(tableDetailProvider('t1')).changes.map((e) => e.sequence), [
      2,
      3,
      4,
    ]);
    server.live.add(const TableLiveEvent(1001));
    await flush();
    expect(server.afters.last, 4);
  });
  test(
    'ekran gizlenince presence bırakılır ve yeni olaylar işlenmez',
    () async {
      final server = LiveServer();
      addTearDown(server.live.close);
      final c = setup(server);
      await flush();
      c.read(tableDetailProvider('t1').notifier).active(false);
      await flush();
      expect(server.presenceCalls.last.leave, isTrue);
      server.live.add(const TableLiveEvent(1000));
      await flush();
      expect(server.afters, isEmpty);
    },
  );
}
