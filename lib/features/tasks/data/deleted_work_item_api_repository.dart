import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../domain/work_item.dart';
import '../domain/work_item_repository.dart';
import 'work_item_mapping.dart';

/// [DeletedWorkItemRepository]'nin üretilmiş `WorkClient` ile gerçekleştirmesi (ŞY, S2).
class ApiDeletedWorkItemRepository implements DeletedWorkItemRepository {
  ApiDeletedWorkItemRepository(Dio dio) : _client = WorkClient(dio);

  final WorkClient _client;

  @override
  Future<PageSlice<DeletedTask>> list([
    PageRequest page = const PageRequest(),
  ]) => apiCall(() async {
    final r = await _client.listDeletedWorkItems(
      limit: page.limit,
      cursor: page.cursor,
    );
    return PageSlice(
      items: [
        for (final d in r.items)
          DeletedTask(
            id: d.workItemId,
            title: d.title,
            departmentId: d.departmentId,
            status: taskStatusFromWire(d.status),
            deletedAt: d.deletedAt,
            fileCount: d.fileCount,
          ),
      ],
      nextCursor: r.nextCursor,
    );
  });

  @override
  Future<void> restore(String id) =>
      apiCall(() => _client.restoreWorkItem(id: id));

  @override
  Future<int> purge(String id) => apiCall(
    () async => (await _client.permanentDeleteWorkItem(id: id)).filesDeleted,
  );
}
