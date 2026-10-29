// tasks data katmanı: silinmiş görevler (ŞY) → DeletedTask, imleç, geri yükleme, kalıcı silme.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/features/tasks/data/deleted_work_item_api_repository.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';
import 'package:nizamio/features/tasks/domain/work_item.dart';

import 'work_fake_dio.dart';

(ApiDeletedWorkItemRepository, FakeAdapter) _repo(
  Object body, {
  int status = 200,
}) {
  final (dio, adapter) = fakeDio(body, status: status);
  return (ApiDeletedWorkItemRepository(dio), adapter);
}

void main() {
  test('list: GET imleçli → DeletedTask', () async {
    final (repo, a) = _repo({
      'items': [
        {
          'work_item_id': 'w1',
          'title': 'Silinen',
          'department_id': 'd1',
          'status': 'iade_edildi',
          'deleted_at': '2026-11-01T08:00:00Z',
          'file_count': 4,
        },
        {
          'work_item_id': 'w2',
          'title': 'B',
          'department_id': 'd2',
          'status': 'bilinmez',
          'deleted_at': '2026-11-02T08:00:00Z',
          'file_count': 0,
        },
      ],
      'next_cursor': 'c2',
    });
    final s = await repo.list(const PageRequest(limit: 10));
    expect(a.last.uri.path, '/v1/admin/deleted/work-items');
    expect(a.last.uri.queryParameters, {'limit': '10'});
    expect(s.nextCursor, 'c2');
    expect(
      s.items.first,
      DeletedTask(
        id: 'w1',
        title: 'Silinen',
        departmentId: 'd1',
        status: TaskStatus.returned,
        deletedAt: DateTime.utc(2026, 11, 1, 8),
        fileCount: 4,
      ),
    );
    expect(s.items.last.status, TaskStatus.unknown);
  });

  test('list: son sayfa', () async {
    final (repo, _) = _repo({'items': <Object>[]});
    final s = await repo.list();
    expect(s.items, isEmpty);
    expect(s.hasMore, isFalse);
  });

  test('list: yetkisiz → ApiError', () async {
    final (repo, _) = _repo(errorEnvelope('work.not_authorized'), status: 403);
    await expectLater(repo.list(), throwsApiError('work.not_authorized'));
  });

  test('restore: PATCH', () async {
    final (repo, a) = _repo({'work_item_id': 'w1', 'status': 'restored'});
    await repo.restore('w1');
    expect(a.last.method, 'PATCH');
    expect(a.last.uri.path, '/v1/admin/restore/work-items/w1');
  });

  test('restore: tanımsız sonuç durumu throw etmez', () async {
    final (repo, _) = _repo({'work_item_id': 'w1', 'status': 'yeni'});
    await repo.restore('w1');
  });

  test('purge: DELETE, silinen dosya sayısı', () async {
    final (repo, a) = _repo({
      'work_item_id': 'w1',
      'status': 'purged',
      'files_deleted': 3,
    });
    expect(await repo.purge('w1'), 3);
    expect(a.last.method, 'DELETE');
    expect(a.last.uri.path, '/v1/admin/permanent/work-items/w1');
  });

  test('purge: hata → ApiError', () async {
    final (repo, _) = _repo(errorEnvelope('platform.not_found'), status: 404);
    await expectLater(repo.purge('w9'), throwsApiError('platform.not_found'));
  });
}
