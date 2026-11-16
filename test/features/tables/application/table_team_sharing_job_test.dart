import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tables/application/table_team_sharing_job.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_edit.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';

import 'table_create_job_test.dart' show RecordingRepository;

class SharingServer extends RecordingRepository {
  final writes = <({TableEdit edit, String key})>[];
  final saved = <String, TableOperationReceipt>{};
  final people = <String, TableAccess>{'removed': TableAccess.edit};
  TableAccess team = TableAccess.edit;
  bool loseReply = false;
  bool failTeam = false;
  bool current = true;
  bool invalidate = false;
  int sequence = 0;
  @override
  Future<TableOperationReceipt> execute(
    TableLocation location,
    String id,
    TableEdit edit,
    String key,
  ) async {
    writes.add((edit: edit, key: key));
    if (saved[key] case final previous?) return previous;
    if (failTeam && edit is SetTableTeam) {
      failTeam = false;
      throw ApiError('client.network_error');
    }
    if (edit is GrantTableAccess) {
      if (edit.access == TableAccess.off) {
        people.remove(edit.account);
      } else {
        people[edit.account] = edit.access;
      }
    }
    if (edit is SetTableTeam) {
      team = edit.access;
    }
    final receipt = TableOperationReceipt(
      table: id,
      sequence: ++sequence,
      schema: 1,
    );
    saved[key] = receipt;
    if (invalidate) current = false;
    if (loseReply) {
      loseReply = false;
      throw ApiError('client.network_error');
    }
    return receipt;
  }
}

TableTeamSharingJob job(SharingServer server) => TableTeamSharingJob(
  repository: server,
  location: const TableLocation('p1', 'd1'),
  table: 't1',
  people: const {
    TablePersonId('a'): TableAccess.edit,
    TablePersonId('b'): TableAccess.view,
  },
  changed: const TablePersonId('removed'),
  access: TableAccess.off,
);

void main() {
  test(
    'farklı kişi yetkileri ve çıkarma tamamlanmadan dinamik erişim kapanmaz',
    () async {
      final server = SharingServer()..failTeam = true;
      final plan = job(server);
      await expectLater(
        plan.submit(isCurrent: () => true),
        throwsA(isA<ApiError>()),
      );
      expect(plan.started, isTrue);
      expect(server.team, TableAccess.edit);
      expect(server.people, {'a': TableAccess.edit, 'b': TableAccess.view});
      final key = server.writes.last.key;
      await plan.submit(isCurrent: () => true);
      expect(server.team, TableAccess.off);
      expect(server.writes.last.key, key);
      expect(
        server.writes.where((w) => w.edit is GrantTableAccess),
        hasLength(3),
      );
    },
  );
  test(
    'kayıp makbuz aynı adım ve anahtarla sürer, grant ikinci kez uygulanmaz',
    () async {
      final server = SharingServer()..loseReply = true;
      final plan = job(server);
      await expectLater(
        plan.submit(isCurrent: () => true),
        throwsA(isA<ApiError>()),
      );
      final key = server.writes.single.key;
      await plan.submit(isCurrent: () => true);
      expect(server.writes[1].key, key);
      expect(server.sequence, 4);
      expect(server.people, {'a': TableAccess.edit, 'b': TableAccess.view});
    },
  );
  test('kapsam değişince sonraki grant veya ekip kapatma çalışmaz', () async {
    final server = SharingServer()..invalidate = true;
    await expectLater(
      job(server).submit(isCurrent: () => server.current),
      throwsA(isA<ApiError>()),
    );
    expect(server.writes, hasLength(1));
    expect(server.team, TableAccess.edit);
  });
}
