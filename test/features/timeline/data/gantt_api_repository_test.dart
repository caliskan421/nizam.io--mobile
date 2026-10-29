// timeline data katmanı: Gantt uçları → GanttSchedule (TaskItem + TaskDependency), boş
// isteğe bağlı gün dizgesi, bilinmeyen enum → unknown, hata → ApiError.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/data/gantt_api_repository.dart';

import '../../tasks/data/work_fake_dio.dart';

Map<String, Object?> _task({
  String id = 'w1',
  String status = 'tamamlandi',
  String priority = 'orta',
  String planned = '2026-11-10',
  String completed = '2026-11-12',
  String start = '2026-11-01',
}) => {
  'work_item_id': id,
  'title': 'Görev $id',
  'program_id': 'p1',
  'department_id': 'd1',
  'priority': priority,
  'status': status,
  'start_on': start,
  'end_on': '2026-11-12',
  'planned_end_on': planned,
  'completed_on': completed,
  'assignee_account_ids': ['a1'],
  'lateness': {
    'is_overdue': false,
    'days_overdue': 0,
    'is_completed_late': true,
    'days_late': 2,
    'is_completed_early': false,
    'days_early': 0,
  },
};

Map<String, Object?> _gantt(List<Map<String, Object?>> tasks) => {
  'tasks': tasks,
  'links': [
    {
      'dependency_id': 'e1',
      'source': 'w1',
      'target': 'w2',
      'cross_department': true,
    },
  ],
};

(ApiGanttRepository, FakeAdapter) _repo(Object body, {int status = 200}) {
  final (dio, adapter) = fakeDio(body, status: status);
  return (ApiGanttRepository(dio), adapter);
}

void main() {
  test('coordinator: GET /gantt → TaskItem ve bağlantılar', () async {
    final (repo, a) = _repo(_gantt([_task()]));
    final g = await repo.coordinator();
    expect(a.last.method, 'GET');
    expect(a.last.uri.path, '/v1/work-items/gantt');
    final t = g.tasks.single;
    expect(t.id, 'w1');
    expect(t.code, 'w1');
    expect(t.coordinatorship, 'd1');
    expect(t.departmentId, 'd1');
    expect(t.programId, 'p1');
    expect(t.status, TaskStatus.done);
    expect(t.priority, TaskPriority.medium);
    expect(t.start, DateTime(2026, 11, 1));
    expect(t.due, DateTime(2026, 11, 12));
    expect(t.plannedEnd, DateTime(2026, 11, 10));
    expect(t.completedAt, DateTime(2026, 11, 12));
    expect(t.assignees, ['a1']);
    expect(t.lateness, const TaskLateness(isCompletedLate: true, daysLate: 2));
    expect(t.creator, isNull);
    expect(t.createdAt, isNull);
    expect(
      g.links.single,
      const TaskDependency(
        id: 'e1',
        workItemId: 'w2',
        dependsOnId: 'w1',
        crossDepartment: true,
      ),
    );
    expect(g.dependentIds, {'w2'});
  });

  test('member: GET /gantt/mine; boş isteğe bağlı günler null', () async {
    final (repo, a) = _repo(
      _gantt([_task(status: 'devam_ediyor', planned: '', completed: '')]),
    );
    final t = (await repo.member()).tasks.single;
    expect(a.last.uri.path, '/v1/work-items/gantt/mine');
    expect(t.plannedEnd, isNull);
    expect(t.completedAt, isNull);
    expect(t.status, TaskStatus.inProgress);
  });

  test('admin: overdueOnly → overdue=true; süzgeçsiz sorgu boş', () async {
    final (repo, a) = _repo(_gantt([]));
    await repo.admin(overdueOnly: true);
    expect(a.last.uri.path, '/v1/work-items/gantt/admin');
    expect(a.last.uri.queryParameters, {'overdue': 'true'});
    final (repo2, b) = _repo(_gantt([]));
    final g = await repo2.admin();
    expect(b.last.uri.queryParameters, isEmpty);
    expect(g.tasks, isEmpty);
  });

  test('bilinmeyen durum/öncelik → unknown; acil → urgent', () async {
    final (repo, _) = _repo(
      _gantt([
        _task(status: 'yeni', priority: 'kritik'),
        _task(id: 'w2', priority: 'acil'),
      ]),
    );
    final g = await repo.coordinator();
    expect(g.tasks[0].status, TaskStatus.unknown);
    expect(g.tasks[0].priority, TaskPriority.unknown);
    expect(g.tasks[1].priority, TaskPriority.urgent);
  });

  test('geçersiz gün dizgesi → client.invalid_response', () async {
    final (repo, _) = _repo(_gantt([_task(start: 'dün')]));
    await expectLater(
      repo.coordinator(),
      throwsApiError(ClientErrorCode.invalidResponse),
    );
  });

  test('hata zarfı → ApiError', () async {
    final (repo, _) = _repo(errorEnvelope('work.not_authorized'), status: 403);
    await expectLater(repo.admin(), throwsApiError('work.not_authorized'));
  });
}
