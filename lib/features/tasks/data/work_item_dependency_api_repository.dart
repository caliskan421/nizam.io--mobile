import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/api/generated/models/dependency_edge.dart';
import '../../../core/api/generated/models/dependency_request.dart';
import '../../../core/errors/api_error.dart';
import '../domain/task_catalog.dart';
import '../domain/work_item.dart';
import '../domain/work_item_repository.dart';

/// [WorkItemDependencyRepository]'nin üretilmiş `WorkClient` ile gerçekleştirmesi (S3).
class ApiWorkItemDependencyRepository implements WorkItemDependencyRepository {
  ApiWorkItemDependencyRepository(Dio dio) : _client = WorkClient(dio);

  final WorkClient _client;

  @override
  Future<TaskDependency> add(String id, String dependsOnId) => apiCall(
    () async => _taskDependency(
      await _client.addDependency(
        id: id,
        body: DependencyRequest(dependsOnWorkItemId: dependsOnId),
      ),
    ),
  );

  @override
  Future<TaskDependencies> list(String id) => apiCall(() async {
    final r = await _client.listDependencies(id: id);
    return TaskDependencies(
      dependencies: r.dependencies.map(_taskDependency).toList(),
      dependents: r.dependents.map(_taskDependency).toList(),
    );
  });

  @override
  Future<void> remove(String id, String dependencyId) =>
      apiCall(() => _client.removeDependency(id: id, depId: dependencyId));
}

TaskDependency _taskDependency(DependencyEdge r) => TaskDependency(
  id: r.dependencyId,
  workItemId: r.workItemId,
  dependsOnId: r.dependsOnWorkItemId,
);
