import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/gantt_schedule.dart';

typedef GanttScope = ({String program, String department});
final ganttRepositoryProvider = Provider.family<GanttRepository, GanttScope>(
  (ref, scope) => throw UnimplementedError(),
);
final ganttScheduleProvider = FutureProvider.autoDispose((ref) async {
  ref.watch(sessionGenerationProvider);
  final scope = ref.watch(scopeStateProvider);
  final catalog = await ref.watch(taskCatalogControllerProvider.future);
  final program = scope.programId;
  final view = catalog.viewIn(scope);
  // Etkin görünüme izdüşürülmüş erişim: Üye görünümündeki koordinatör üye ucunu okur.
  final access = view.viewAccess;
  if (program == null || access == null) {
    return GanttSchedule(tasks: const [], links: const []);
  }
  if (view.isAdminView) {
    return ref
        .watch(ganttRepositoryProvider((program: program, department: '')))
        .admin();
  }
  final tasks = <TaskItem>[];
  final links = <TaskDependency>[];
  var truncated = false;
  for (final seat in access.seatsIn(program)) {
    if (!ref.mounted) {
      throw StateError('disposed');
    }
    if (seat.role == SeatRole.unknown) {
      continue;
    }
    final repository = ref.watch(
      ganttRepositoryProvider((
        program: program,
        department: seat.departmentId,
      )),
    );
    final schedule = seat.role == SeatRole.coordinator
        ? await repository.coordinator()
        : await repository.member();
    tasks.addAll(schedule.tasks);
    links.addAll(schedule.links);
    truncated = truncated || schedule.truncated;
  }
  return GanttSchedule(tasks: tasks, links: links, truncated: truncated);
});

/// Gantt okuması tam görevlerin yerine geçmez: düzenleme sürümleri katalogda kalır.
final timelineCatalogProvider = Provider.autoDispose<AsyncValue<TaskCatalog>>((
  ref,
) {
  final catalog = ref.watch(taskCatalogControllerProvider);
  final schedule = ref.watch(ganttScheduleProvider);
  if (catalog.isLoading || catalog.hasError) return catalog;
  return schedule.whenData((gantt) {
    final c = catalog.requireValue;
    return c.withTasks([
      for (final date in gantt.tasks)
        if (c.task(date.code) case final task?)
          task.copyWith(start: date.start, due: date.due)
        else
          date,
    ], truncated: c.truncated || gantt.truncated);
  });
});
