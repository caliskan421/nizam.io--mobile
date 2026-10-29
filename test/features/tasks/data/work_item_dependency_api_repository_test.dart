// tasks data katmanı: bağımlılık uçları → TaskDependency/TaskDependencies, hata → ApiError.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/data/work_item_dependency_api_repository.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';

import 'work_fake_dio.dart';

Map<String, Object?> _edge(String id, String w, String on) => {
  'dependency_id': id,
  'work_item_id': w,
  'depends_on_work_item_id': on,
};

(ApiWorkItemDependencyRepository, FakeAdapter) _repo(
  Object body, {
  int status = 200,
}) {
  final (dio, adapter) = fakeDio(body, status: status);
  return (ApiWorkItemDependencyRepository(dio), adapter);
}

void main() {
  test('add: POST gövdesi → TaskDependency', () async {
    final (repo, a) = _repo(_edge('e1', 'w2', 'w1'));
    final d = await repo.add('w2', 'w1');
    expect(a.last.method, 'POST');
    expect(a.last.uri.path, '/v1/work-items/w2/dependencies');
    expect(a.sentJson, {'depends_on_work_item_id': 'w1'});
    expect(
      d,
      const TaskDependency(id: 'e1', workItemId: 'w2', dependsOnId: 'w1'),
    );
  });

  test('add: döngü → ApiError', () async {
    final (repo, _) = _repo(
      errorEnvelope('work.dependency_cycle'),
      status: 422,
    );
    await expectLater(
      repo.add('w1', 'w2'),
      throwsApiError('work.dependency_cycle'),
    );
  });

  test('list: GET → ön görevler ve bağımlılar', () async {
    final (repo, a) = _repo({
      'dependencies': [_edge('e1', 'w2', 'w1')],
      'dependents': [_edge('e2', 'w3', 'w2'), _edge('e3', 'w4', 'w2')],
    });
    final r = await repo.list('w2');
    expect(a.last.method, 'GET');
    expect(a.last.uri.path, '/v1/work-items/w2/dependencies');
    expect(r.dependencies.single.dependsOnId, 'w1');
    expect(r.dependents.map((e) => e.workItemId), ['w3', 'w4']);
    expect(r.dependents.first.crossDepartment, isNull);
  });

  test('list: boş', () async {
    final (repo, _) = _repo({
      'dependencies': <Object>[],
      'dependents': <Object>[],
    });
    final r = await repo.list('w1');
    expect(r.dependencies, isEmpty);
    expect(r.dependents, isEmpty);
  });

  test('remove: DELETE kenar kimliğiyle', () async {
    final (repo, a) = _repo({'status': 'removed'});
    await repo.remove('w2', 'e1');
    expect(a.last.method, 'DELETE');
    expect(a.last.uri.path, '/v1/work-items/w2/dependencies/e1');
  });

  test('remove: 404 → ApiError', () async {
    final (repo, _) = _repo(errorEnvelope('platform.not_found'), status: 404);
    await expectLater(
      repo.remove('w2', 'e9'),
      throwsApiError('platform.not_found'),
    );
  });
}
