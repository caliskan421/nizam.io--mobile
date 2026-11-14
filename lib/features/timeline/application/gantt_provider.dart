import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/gantt_schedule.dart';
import '../domain/timeline_dates.dart';
import '../domain/timeline_rules.dart';

typedef GanttScope = ({String program, String department});
final ganttRepositoryProvider = Provider.family<GanttRepository, GanttScope>(
  (ref, scope) => throw UnimplementedError(),
);

/// Süre uzatma ve bitişi bugüne çekme (bileşim kökünde bağlanır).
final timelineDateRepositoryProvider = Provider<TimelineDateRepository>(
  (ref) => throw UnimplementedError(),
);

/// Koordinatör görünümünün sekmesi. Telefon ve tablet aynı seçimi paylaşır; kapsam (program, rol, koordinatörlük) değişince koordinatörlüğün görevlerine döner.
final timelineTabProvider =
    NotifierProvider<TimelineTabController, TimelineTab>(
      TimelineTabController.new,
    );

class TimelineTabController extends Notifier<TimelineTab> {
  @override
  TimelineTab build() {
    // Çıkışta kapsam temizlenir; oturum nesli ayrıca izlenmez.
    ref.watch(scopeStateProvider);
    return TimelineTab.department;
  }

  void select(TimelineTab tab) => state = tab;
}

/// Etkin görünümün çizelge izdüşümü (kilitli koordinatörlük, sekme, 7 gün kuralı).
final timelineLensProvider = Provider.autoDispose<TimelineLens>((ref) {
  final view = ref.watch(effectiveAccessProvider);
  return TimelineLens.of(
    adminView: view.isAdminView,
    coordinatorView: view.isCoordinatorView,
    department: view.departmentId,
    tab: ref.watch(timelineTabProvider),
  );
});

/// Gantt okuması etkin görünümü izler: yönetici bütün departmanları (`gantt/admin`), koordinatör
/// yalnız etkin koordinatörlüğü (`gantt`), üye o koordinatörlükteki kendi görevlerini
/// (`gantt/mine`) okur. Birleşik çok departmanlı görünüm sunucuda yok (GAP-053).
final ganttScheduleProvider = FutureProvider.autoDispose((ref) async {
  ref.watch(sessionGenerationProvider);
  final scope = ref.watch(scopeStateProvider);
  final catalog = await ref.watch(taskCatalogControllerProvider.future);
  final program = scope.programId;
  final view = catalog.viewIn(scope);
  final department = view.departmentId;
  if (program == null || !view.known) {
    return GanttSchedule(tasks: const [], links: const []);
  }
  if (view.isAdminView) {
    return ref
        .watch(ganttRepositoryProvider((program: program, department: '')))
        .admin();
  }
  if (department == null) {
    return GanttSchedule(tasks: const [], links: const []);
  }
  final repository = ref.watch(
    ganttRepositoryProvider((program: program, department: department)),
  );
  return view.isCoordinatorView
      ? repository.coordinator()
      : repository.member();
});

/// Gantt okuması tam görevlerin yerine geçmez: düzenleme sürümleri katalogda kalır. Görev
/// kümesi sekme/rol izdüşümünden geçer ([timelineTaskSet]); telefon ve tablet aynı kümeyi görür.
final timelineCatalogProvider = Provider.autoDispose<AsyncValue<TaskCatalog>>((
  ref,
) {
  final catalog = ref.watch(taskCatalogControllerProvider);
  final schedule = ref.watch(ganttScheduleProvider);
  final lens = ref.watch(timelineLensProvider);
  if (catalog.isLoading || catalog.hasError) return catalog;
  return schedule.whenData((gantt) {
    final c = catalog.requireValue;
    return c.withTasks(
      timelineTaskSet(
        [
          for (final date in gantt.tasks)
            if (c.task(date.code) case final task?)
              task.copyWith(start: date.start, due: date.due)
            else
              date,
        ],
        lens,
        c.me,
      ),
      truncated: c.truncated || gantt.truncated,
    );
  });
});
