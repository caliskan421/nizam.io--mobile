import 'package:meta/meta.dart';

import '../../tasks/tasks.dart';

/// Sunucunun Gantt zarfı (`Gantt`): tarihli görevler ve bağımlılık bağlantıları. Sayfasızdır.
/// Görevler ortak [TaskItem] varlığına eşlenir (dikey/yatay çizelge `TimelineTask` ile
/// sarar); `GanttLink` → [TaskDependency] (`target` = bağımlı, `source` = ön görev).
@immutable
final class GanttSchedule {
  GanttSchedule({
    required List<TaskItem> tasks,
    required List<TaskDependency> links,
  }) : tasks = List.unmodifiable(tasks),
       links = List.unmodifiable(links);

  final List<TaskItem> tasks;
  final List<TaskDependency> links;

  /// Başka göreve bağımlı görev kimlikleri (`TimelineTask.dependent` kaynağı).
  Set<String> get dependentIds => {for (final l in links) l.workItemId};
}

/// Gantt görünümünün kaynağı (domain portu; gerçekleştirme `data/`). Yüz role göre değişir
/// (WORK-K36): ŞY [admin] (S2, bütün departmanlar), K [coordinator] (S3, kendi departmanı),
/// Ü [member] (S3, yalnız atandığı görevler).
abstract interface class GanttRepository {
  /// `GET /v1/work-items/gantt` (`coordinatorGantt`).
  Future<GanttSchedule> coordinator();

  /// `GET /v1/work-items/gantt/mine` (`memberGantt`).
  Future<GanttSchedule> member();

  /// `GET /v1/work-items/gantt/admin` (`adminGantt`); [overdueOnly] → `overdue=true`.
  Future<GanttSchedule> admin({bool overdueOnly = false});
}
