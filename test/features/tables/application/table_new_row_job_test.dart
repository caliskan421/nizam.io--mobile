import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tables/application/table_detail_controller.dart';
import 'package:nizamio/features/tables/application/table_new_row_job.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_edit.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';

import '../../../app/router/table_workspace_flow_test.dart'
    show WorkspaceServer;
import 'table_detail_controller_test.dart' show setup, flush;

class RowWriteServer extends WorkspaceServer {
  ApiError? cellError;
  bool lostCellReply = false;
  void Function()? afterAdd;
  @override
  Future<TableOperationReceipt> execute(
    TableLocation l,
    String id,
    TableEdit edit,
    String key,
  ) async {
    if (edit is WriteTableCells && cellError != null) throw cellError!;
    final r = await super.execute(l, id, edit, key);
    if (edit is AddTableRow) afterAdd?.call();
    if (edit is WriteTableCells && lostCellReply) {
      lostCellReply = false;
      throw ApiError('client.network_error');
    }
    return r;
  }
}

void main() {
  test('yeni satır hücre yanıtı kaybolursa aynı hücre anahtarı sürer, ikinci satır oluşmaz', () async {
    final server = RowWriteServer()..lostCellReply = true;
    final job = TableNewRowJob(server, const TableLocation('p1'), 't1', {
      const TableFieldId('c1'): 'Başlık',
    }, {});
    await expectLater(job.run('ignored'), throwsA(isA<ApiError>()));
    expect(server.rows, hasLength(1));
    expect(server.cells.single.version, 1);
    final result = await job.run('ignored');
    expect(server.rows, hasLength(1));
    expect(server.cells.single.version, 1);
    final writes = server.edits
        .where((e) => e.edit is WriteTableCells)
        .toList();
    expect(writes.map((e) => e.key).toSet(), hasLength(1));
    expect(result.rowSequence, 2);
    expect(result.sequence, 3);
  });
  test(
    'kısmi yeni satır açık hata alsa da plan korunur ve aynı satır tamamlanır',
    () async {
      final server = RowWriteServer()
        ..cellError = ApiError('tables.input_invalid', status: 422);
      final c = setup(server);
      await flush();
      final controller = c.read(tableDetailProvider('t1').notifier);
      final job = TableNewRowJob(
        server,
        controller.location,
        't1',
        {const TableFieldId('c1'): 'Başlık'},
        {},
        isCurrent: controller.captureGuard(),
      );
      expect(
        await controller.perform(
          job.run,
          focusRow: true,
          retainOnError: () => job.started,
        ),
        isNull,
      );
      expect(c.read(tableDetailProvider('t1')).pending, isTrue);
      expect(server.rows, hasLength(1));
      server.cellError = null;
      expect(await controller.retry(), isNotNull);
      expect(server.rows, hasLength(1));
      expect(server.cells.single.value, 'Başlık');
      expect(c.read(tableDetailProvider('t1')).pending, isFalse);
    },
  );
  test('hesap/kapsam çiti satırdan sonra kapanırsa hücre yazılmaz', () async {
    final server = RowWriteServer();
    var active = true;
    server.afterAdd = () => active = false;
    final job = TableNewRowJob(
      server,
      const TableLocation('p1'),
      't1',
      {const TableFieldId('c1'): 'Başlık'},
      {},
      isCurrent: () => active,
    );
    await expectLater(
      job.run('ignored'),
      throwsA(
        isA<ApiError>().having((e) => e.code, 'code', 'client.scope_changed'),
      ),
    );
    expect(server.edits.where((e) => e.edit is WriteTableCells), isEmpty);
  });
}
