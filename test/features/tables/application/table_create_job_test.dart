import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/tables/application/table_create_job.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';

class RecordingRepository implements TablesRepository {
  final calls = <(String, String)>[];
  bool failGrant = true;
  bool failCreate = false;
  Completer<void>? gate;
  @override
  Future<TableWriteReceipt> create(
    TableLocation l,
    String name,
    String key,
  ) async {
    calls.add(('create', key));
    if (gate != null) await gate!.future;
    if (failCreate) {
      failCreate = false;
      throw ApiError('client.timeout');
    }
    return const TableWriteReceipt('t1', 1);
  }

  @override
  Future<TableWriteReceipt> addColumn(
    TableLocation l,
    String id,
    TableField f,
    int version,
    String key,
  ) async {
    calls.add(('column:$version', key));
    return TableWriteReceipt(id, version + 1);
  }

  @override
  Future<void> grant(
    TableLocation l,
    String id,
    String person,
    TableAccess a,
    String key,
  ) async {
    calls.add(('grant', key));
    if (failGrant) {
      failGrant = false;
      throw ApiError('client.timeout');
    }
  }

  @override
  Future<void> setTeamRole(
    TableLocation l,
    String id,
    TableAccess a,
    String key,
  ) async {
    calls.add(('team', key));
  }

  @override
  Future<void> propose(
    TableLocation l,
    String id,
    String department,
    TableAccess a,
    String key,
  ) async {
    calls.add(('proposal', key));
  }

  @override
  Future<List<TableDocument>> list(TableLocation l, String id) async => [];
  @override
  Future<TableDocument> read(TableLocation l, String id, String account) =>
      throw UnimplementedError();
}

TableCreateJob job(RecordingRepository repo, {bool proposal = false}) =>
    TableCreateJob(
      repository: repo,
      location: TableLocation('p1', proposal ? '' : 'd1'),
      title: 'Tablo',
      fields: const [
        TableField(id: 'f1', name: 'Ad'),
        TableField(id: 'f2', name: 'Not'),
      ],
      people: proposal ? {} : {const TablePersonId('u2'): TableAccess.view},
      teamAccess: TableAccess.edit,
      proposalDepartment: proposal ? 'd1' : null,
    );
void main() {
  test(
    'kısmi paylaşım hatası aynı anahtarla sürer, ikinci tablo/sütun üretmez',
    () async {
      final repo = RecordingRepository();
      final plan = job(repo);
      await expectLater(
        plan.submit(isCurrent: () => true),
        throwsA(isA<ApiError>()),
      );
      expect(plan.tableId, 't1');
      expect(plan.completed, isFalse);
      await plan.submit(isCurrent: () => true);
      expect(repo.calls.map((c) => c.$1), [
        'create',
        'column:1',
        'column:2',
        'grant',
        'grant',
        'team',
      ]);
      expect(repo.calls[3].$2, repo.calls[4].$2);
      expect(repo.calls.first.$2, isNot(repo.calls[1].$2));
      expect(plan.completed, isTrue);
    },
  );
  test('belirsiz oluşturma aynı anahtarla yeniden denenir', () async {
    final repo = RecordingRepository()
      ..failCreate = true
      ..failGrant = false;
    final plan = job(repo);
    await expectLater(
      plan.submit(isCurrent: () => true),
      throwsA(isA<ApiError>()),
    );
    await plan.submit(isCurrent: () => true);
    expect(repo.calls[0].$2, repo.calls[1].$2);
  });
  test(
    'üye kişisel tablo oluşturur ve yalnız öneri gönderir; ekip rolü açmaz',
    () async {
      final repo = RecordingRepository();
      await job(repo, proposal: true).submit(isCurrent: () => true);
      expect(repo.calls.map((c) => c.$1), [
        'create',
        'column:1',
        'column:2',
        'proposal',
      ]);
    },
  );
  test(
    'kapsam değişince sonraki yazım yok; çift gönderim reddedilir',
    () async {
      final repo = RecordingRepository()..gate = Completer<void>();
      final plan = job(repo);
      var current = true;
      final first = plan.submit(isCurrent: () => current);
      await expectLater(
        plan.submit(isCurrent: () => current),
        throwsStateError,
      );
      current = false;
      repo.gate!.complete();
      await expectLater(
        first,
        throwsA(
          isA<ApiError>().having((e) => e.code, 'code', 'client.scope_changed'),
        ),
      );
      expect(repo.calls.map((c) => c.$1), ['create']);
    },
  );
}
