import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/api/generated/models/gantt.dart';
import '../../../core/api/generated/models/gantt_task.dart';
import '../../../core/errors/api_error.dart';
import '../../tasks/tasks.dart';
import '../domain/gantt_schedule.dart';

/// [GanttRepository]'nin üretilmiş `WorkClient` ile gerçekleştirmesi. DTO'lar bu katmanda
/// kalır (A1); eşleme [apiCall] içinde yapılır: geçersiz gün dizgesi `client.invalid_response`
/// olur.
///
/// Spec notu: `GanttTask.start_on/end_on/planned_end_on/completed_on` `format: date`
/// taşımadığından dizge üretilir (backend adayı B-20); `planned_end_on` ve `completed_on`
/// boş dizgeyse yoktur.
class ApiGanttRepository implements GanttRepository {
  ApiGanttRepository(Dio dio) : _client = WorkClient(dio);

  /// Sözleşmede "yalnız gecikenler" süzgecinin değeri.
  static const overdueFlag = 'true';

  final WorkClient _client;

  @override
  Future<GanttSchedule> coordinator() =>
      apiCall(() async => _schedule(await _client.coordinatorGantt()));

  @override
  Future<GanttSchedule> member() =>
      apiCall(() async => _schedule(await _client.memberGantt()));

  @override
  Future<GanttSchedule> admin({bool overdueOnly = false}) => apiCall(
    () async => _schedule(
      await _client.adminGantt(overdue: overdueOnly ? overdueFlag : null),
    ),
  );

  static GanttSchedule _schedule(Gantt g) => GanttSchedule(
    tasks: g.tasks.map(_task).toList(),
    links: [
      for (final l in g.links)
        TaskDependency(
          id: l.dependencyId,
          workItemId: l.target,
          dependsOnId: l.source,
          crossDepartment: l.crossDepartment,
        ),
    ],
  );

  static TaskItem _task(GanttTask t) {
    final lateness = TaskLateness(
      isOverdue: t.lateness.isOverdue,
      daysOverdue: t.lateness.daysOverdue,
      isCompletedLate: t.lateness.isCompletedLate,
      daysLate: t.lateness.daysLate,
      isCompletedEarly: t.lateness.isCompletedEarly,
      daysEarly: t.lateness.daysEarly,
    );
    return TaskItem(
      code: t.workItemId,
      id: t.workItemId,
      title: t.title,
      coordinatorship: t.departmentId,
      departmentId: t.departmentId,
      programId: t.programId,
      status: _status(t.status),
      priority: _priority(t.priority.json),
      start: DateTime.parse(t.startOn),
      due: DateTime.parse(t.endOn),
      plannedEnd: _optionalDay(t.plannedEndOn),
      completedAt: _optionalDay(t.completedOn),
      assignees: List.unmodifiable(t.assigneeAccountIds),
      lateness: lateness,
      overdueDays: lateness.daysOverdue,
    );
  }

  static DateTime? _optionalDay(String s) =>
      s.isEmpty ? null : DateTime.parse(s);

  // Ortaklaştırma adayı: tasks/data/work_item_mapping.dart ile aynı eşleme (B3 nedeniyle kopya).
  static TaskStatus _status(String? wire) => switch (wire) {
    'baslanmadi' => TaskStatus.todo,
    'devam_ediyor' => TaskStatus.inProgress,
    'onaya_sunuldu' => TaskStatus.review,
    'iade_edildi' => TaskStatus.returned,
    'tamamlandi' => TaskStatus.done,
    _ => TaskStatus.unknown,
  };

  static TaskPriority _priority(String? wire) => switch (wire) {
    'dusuk' => TaskPriority.low,
    'orta' => TaskPriority.medium,
    'yuksek' => TaskPriority.high,
    'acil' => TaskPriority.urgent,
    _ => TaskPriority.unknown,
  };
}
