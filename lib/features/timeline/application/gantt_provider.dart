import 'package:flutter/foundation.dart' show listEquals;
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

/// Ayrıntıdaki not/dosya/alt görevler Gantt isteğinin girdisi değildir. Katalogdaki
/// yükleme, erişim, görev kümesi ve tarihler ise sunucu çizelgesini yeniden okutur.
final class _GanttCatalogInput {
  _GanttCatalogInput(AsyncValue<TaskCatalog> catalog)
    : loading = catalog.isLoading,
      access = catalog.value?.access,
      dates = [
        for (final task in catalog.value?.tasks ?? const <TaskItem>[])
          (task.code, task.start, task.due, task.datesRevision),
      ];

  final bool loading;
  final TaskAccess? access;
  final List<(String, DateTime, DateTime, int?)> dates;

  @override
  bool operator ==(Object other) =>
      other is _GanttCatalogInput &&
      loading == other.loading &&
      identical(access, other.access) &&
      listEquals(dates, other.dates);

  @override
  int get hashCode => Object.hash(loading, access, Object.hashAll(dates));
}

// Katalog ilk yüklemeyi bitirince de aynı Future döner: yükleniyor → veri geçişi
// Gantt isteğini ikinci kez başlatmaz. Ayrıntı eklenince bu sağlayıcı değişmez.
final _ganttCatalogProvider = Provider.autoDispose<Future<TaskCatalog>>((ref) {
  ref.watch(taskCatalogControllerProvider.select(_GanttCatalogInput.new));
  return ref.read(taskCatalogControllerProvider.future);
});

/// Gantt okuması etkin görünümü izler: yönetici bütün departmanları (`gantt/admin`), koordinatör
/// yalnız etkin koordinatörlüğü (`gantt`), üye o koordinatörlükteki kendi görevlerini
/// (`gantt/mine`) okur. Birleşik çok departmanlı görünüm sunucuda yok (GAP-053).
final ganttScheduleProvider = FutureProvider.autoDispose((ref) async {
  ref.watch(sessionGenerationProvider);
  final scope = ref.watch(scopeStateProvider);
  final catalog = await ref.watch(_ganttCatalogProvider);
  // Katalog ilk kez tamamlanırken ya da kapsam değişirken önceki bekleme bayatlar.
  if (!ref.mounted) return GanttSchedule(tasks: const [], links: const []);
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
/// Aynı görünüm yenilenirken son çizelge korunur; bu sayede kayıttan sonra kaydırma
/// sahipleri sökülüp açılıştaki "bugün" konumuna dönmez. Başka sahipte eski veri yoktur.
final timelineCatalogProvider = Provider.autoDispose<AsyncValue<TaskCatalog>>((
  ref,
) {
  final catalog = ref.watch(taskCatalogControllerProvider);
  if (catalog.isLoading && !catalog.hasValue) {
    return const AsyncLoading<TaskCatalog>();
  }
  final snapshot = ref.watch(_timelineSnapshotProvider);
  final scope = ref.watch(scopeStateProvider);
  final lens = ref.watch(timelineLensProvider);
  final owner = (
    ref.watch(sessionGenerationProvider),
    scope.programId,
    scope.departmentId,
    scope.role,
    lens,
  );
  if (snapshot.owner != owner) {
    snapshot.owner = owner;
    snapshot.catalog = null;
  }
  final schedule = ref.watch(ganttScheduleProvider);
  if (catalog.isLoading || catalog.hasError) return snapshot.pending(catalog);
  if (schedule.isLoading || schedule.hasError) {
    return snapshot.pending(schedule);
  }
  final c = catalog.requireValue;
  final gantt = schedule.requireValue;
  final current = c.withTasks(
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
  snapshot.catalog = current;
  return AsyncData(current);
});

// Tek görünümün son başarılı izdüşümü; sağlayıcı bırakılınca bu kayıt da bırakılır.
final _timelineSnapshotProvider = Provider.autoDispose<_TimelineSnapshot>(
  (ref) => _TimelineSnapshot(),
);

class _TimelineSnapshot {
  Object? owner;
  TaskCatalog? catalog;

  AsyncValue<TaskCatalog> pending<T>(AsyncValue<T> source) {
    if (source.isLoading) {
      final previous = catalog;
      return previous == null ? const AsyncLoading() : AsyncData(previous);
    }
    return AsyncError(source.error!, source.stackTrace!);
  }
}
