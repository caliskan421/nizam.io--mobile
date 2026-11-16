import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tables/application/table_detail_controller.dart';
import 'package:nizamio/features/tables/domain/table_edit.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';

import '../../../app/router/table_workspace_flow_test.dart'
    show WorkspaceServer;
import 'table_detail_controller_test.dart' show setup, flush;

class RecoverServer extends WorkspaceServer {
  bool denyRead = false;
  @override
  Future<TableWorkspace> workspace(
    TableLocation l,
    String id,
    String account, {
    TableReadQuery query = const TableReadQuery(),
  }) {
    if (denyRead) throw ApiError('tables.forbidden', status: 403);
    return super.workspace(l, id, account, query: query);
  }
}

void main() {
  test(
    'belirsiz yanıt ardından erişim kaybı anahtarı silmez; içerik gizlenir',
    () async {
      final server = RecoverServer();
      final c = setup(server);
      await flush();
      final controller = c.read(tableDetailProvider('t1').notifier);
      server.failure = ApiError('client.network_error');
      await controller.send(const RenameTable('Yeni ad'));
      final key = server.edits.last.key;
      server.failure = ApiError('tables.forbidden', status: 403);
      await controller.retry();
      expect(c.read(tableDetailProvider('t1')).pending, isTrue);
      server.denyRead = true;
      await controller.refresh();
      expect(c.read(tableDetailProvider('t1')).data, isNull);
      expect(c.read(tableDetailProvider('t1')).pending, isTrue);
      server.failure = null;
      server.denyRead = false;
      expect(await controller.retry(), isNotNull);
      expect(server.edits.map((e) => e.key).toSet(), {key});
      expect(c.read(tableDetailProvider('t1')).pending, isFalse);
    },
  );

  test(
    'bozuk başarı yanıtında aynı anahtar korunur; açık ret yeni işlem açabilir',
    () async {
      final server = WorkspaceServer();
      final c = setup(server);
      await flush();
      final controller = c.read(tableDetailProvider('t1').notifier);
      server.failure = ApiError('client.invalid_response');
      await controller.send(const RenameTable('Yeni ad'));
      expect(c.read(tableDetailProvider('t1')).pending, isTrue);
      final key = server.edits.last.key;
      server.failure = null;
      await controller.retry();
      expect(server.edits.last.key, key);
      server.failure = ApiError('tables.cell_conflict', status: 409);
      await controller.send(
        const WriteTableCells([TableCellWrite('r1', 'c1', 'x', 0)]),
      );
      expect(c.read(tableDetailProvider('t1')).pending, isFalse);
      server.failure = null;
      expect(await controller.send(const RenameTable('Başka ad')), isNotNull);
      expect(server.edits.last.key, isNot(key));
    },
  );
}
