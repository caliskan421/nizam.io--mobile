import 'package:meta/meta.dart';

import 'task_catalog.dart';

/// Tarihsiz görev satırı: `GET /v1/work-items` (liste), `POST /v1/work-items` (oluşturma) ve
/// `PATCH /v1/work-items/{id}` (güncelleme) yanıtı (`WorkItem`).
///
/// [TaskItem] ile aynı kavramdır, ama sunucunun bu yüzü başlangıç/bitiş taşımaz (backend adayı
/// B-02); [TaskItem.start]/[TaskItem.due] UI'da zorunlu olduğundan ayrı tip. Tarihli görünüm
/// Gantt'tan gelir (`GanttSchedule.tasks` → [TaskItem]); alan adları [TaskItem] ile aynıdır.
@immutable
final class TaskSummary {
  const TaskSummary({
    required this.id,
    required this.programId,
    required this.departmentId,
    required this.title,
    required this.priority,
    required this.status,
    required this.assignees,
    required this.lateness,
    this.plannedEnd,
    this.completedAt,
  });

  /// `work_item_id`.
  final String id;
  final String programId;
  final String departmentId;
  final String title;
  final TaskPriority priority;
  final TaskStatus status;

  /// Atanan kişi kimlikleri (`assignee_account_ids`).
  final List<String> assignees;

  /// Sunucunun gecikme bayrakları (`is_overdue`, `days_overdue`, …).
  final TaskLateness lateness;

  /// `planned_end_on`.
  final DateTime? plannedEnd;

  /// `completed_on` (gün).
  final DateTime? completedAt;

  bool get isDone => status == TaskStatus.done;

  @override
  bool operator ==(Object other) =>
      other is TaskSummary &&
      other.id == id &&
      other.programId == programId &&
      other.departmentId == departmentId &&
      other.title == title &&
      other.priority == priority &&
      other.status == status &&
      _sameList(other.assignees, assignees) &&
      other.lateness == lateness &&
      other.plannedEnd == plannedEnd &&
      other.completedAt == completedAt;

  @override
  int get hashCode => Object.hash(
    id,
    programId,
    departmentId,
    title,
    priority,
    status,
    Object.hashAll(assignees),
    lateness,
    plannedEnd,
    completedAt,
  );
}

/// Çağıranın atandığı görevin kısa satırı (`GET /v1/work-items/my-tasks`, `MyTask`).
@immutable
final class AssignedTask {
  const AssignedTask({
    required this.id,
    required this.title,
    required this.status,
  });

  final String id;
  final String title;
  final TaskStatus status;

  @override
  bool operator ==(Object other) =>
      other is AssignedTask &&
      other.id == id &&
      other.title == title &&
      other.status == status;

  @override
  int get hashCode => Object.hash(id, title, status);
}

/// Yeni görev komutu (`POST /v1/work-items`, `CreateWorkItemRequest`). Sunucu tek atanan
/// alır; çoklu atama ardından `addAssignees` ile yapılır. Koordinatör için 40 günlük geçmiş
/// penceresi sunucuda denetlenir (WORK-K06).
@immutable
final class TaskDraft {
  const TaskDraft({
    required this.title,
    required this.start,
    required this.due,
    this.description,
    this.priority,
    this.assignee,
  });

  final String title;

  /// Başlangıç günü (`start_on`; saat yok sayılır).
  final DateTime start;

  /// Bitiş günü (`end_on`).
  final DateTime due;
  final String? description;

  /// `null` → sunucu varsayılanı. [TaskPriority.unknown] gönderilemez.
  final TaskPriority? priority;

  /// Tek atanan kişi kimliği (`assignee_account_id`).
  final String? assignee;
}

/// Görev güncelleme komutu (`PATCH /v1/work-items/{id}`, `UpdateWorkItemRequest`). `null`
/// alan gönderilmez. Bitişi ileri alan güncelleme bağımlı görevleri zincirleme kaydırır
/// (WORK-K28): çağıran ilgili görevleri yeniden yüklemeli. Korumalı `completed_on` ve
/// `submitted_on` alanları bilerek yoktur (dolu gönderilirse 422).
@immutable
final class TaskPatch {
  const TaskPatch({
    this.title,
    this.description,
    this.priority,
    this.start,
    this.due,
    this.plannedEnd,
  });

  final String? title;
  final String? description;

  /// [TaskPriority.unknown] gönderilemez.
  final TaskPriority? priority;
  final DateTime? start;
  final DateTime? due;
  final DateTime? plannedEnd;
}

/// Geçişi yapan aktörün rolü (`TransitionResult.actor`).
enum TransitionActor {
  /// `uye`.
  member,

  /// `koordinator`.
  coordinator,

  /// `koordinator_kendi_gorevi`: koordinatör kendi atandığı görevde.
  coordinatorOwnTask,
  unknown,
}

/// Durum geçişinin sonucu (`TransitionResult`).
@immutable
final class TaskTransition {
  const TaskTransition({
    required this.workItemId,
    required this.from,
    required this.to,
    required this.actor,
    this.due,
  });

  final String workItemId;
  final TaskStatus from;
  final TaskStatus to;
  final TransitionActor actor;

  /// Geçişin değiştirdiği bitiş (`end_on`; onayda tamamlanma gününe çekilebilir).
  final DateTime? due;

  @override
  bool operator ==(Object other) =>
      other is TaskTransition &&
      other.workItemId == workItemId &&
      other.from == from &&
      other.to == to &&
      other.actor == actor &&
      other.due == due;

  @override
  int get hashCode => Object.hash(workItemId, from, to, actor, due);
}

/// Görevin tarih kümesi (`WorkItemDates`): tamamlanma/bitiş düzeltmelerinin yanıtı.
@immutable
final class TaskDates {
  const TaskDates({
    required this.start,
    required this.due,
    this.plannedEnd,
    this.completedAt,
    this.originalCompletedAt,
    this.submittedAt,
  });

  /// `start_on`.
  final DateTime start;

  /// `end_on`.
  final DateTime due;

  /// `planned_end_on`.
  final DateTime? plannedEnd;

  /// `completed_on`.
  final DateTime? completedAt;

  /// `original_completed_on`: düzeltmeden önceki tamamlanma günü.
  final DateTime? originalCompletedAt;

  /// `submitted_on`: onaya sunma günü.
  final DateTime? submittedAt;

  @override
  bool operator ==(Object other) =>
      other is TaskDates &&
      other.start == start &&
      other.due == due &&
      other.plannedEnd == plannedEnd &&
      other.completedAt == completedAt &&
      other.originalCompletedAt == originalCompletedAt &&
      other.submittedAt == submittedAt;

  @override
  int get hashCode => Object.hash(
    start,
    due,
    plannedEnd,
    completedAt,
    originalCompletedAt,
    submittedAt,
  );
}

/// Bitiş uzatmanın sonucu (`ExtendResult`).
@immutable
final class TaskExtension {
  const TaskExtension({required this.due, required this.cascadeCount});

  /// Yeni bitiş (`new_end_on`).
  final DateTime due;

  /// Zincirleme kaydırılan bağımlı görev sayısı (`cascade_count`).
  final int cascadeCount;

  @override
  bool operator ==(Object other) =>
      other is TaskExtension &&
      other.due == due &&
      other.cascadeCount == cascadeCount;

  @override
  int get hashCode => Object.hash(due, cascadeCount);
}

/// Görevin bağımlılıkları (`DependencyList`): [dependencies] bu görevin beklediği ön görevler,
/// [dependents] bu görevi bekleyenler.
@immutable
final class TaskDependencies {
  TaskDependencies({
    required List<TaskDependency> dependencies,
    required List<TaskDependency> dependents,
  }) : dependencies = List.unmodifiable(dependencies),
       dependents = List.unmodifiable(dependents);

  final List<TaskDependency> dependencies;
  final List<TaskDependency> dependents;
}

/// Sayfasız listenin satırları ve sunucunun bildirdiği toplam (`total`). Sözleşmede imleçsiz
/// bazı listeler (`WorkItemNoteList`, `DateChangeRequestList`) zorunlu `total` taşır;
/// `PageSlice` imleçli listeler içindir ve toplam taşımaz.
@immutable
final class CountedList<T> {
  CountedList({required List<T> items, required this.total})
    : items = List.unmodifiable(items);

  final List<T> items;

  /// Sunucunun bildirdiği toplam (satır sayısından okunmaz).
  final int total;
}

/// Silinmiş (yumuşak silme) görev satırı (`DeletedWorkItem`; ŞY çöp kutusu).
@immutable
final class DeletedTask {
  const DeletedTask({
    required this.id,
    required this.title,
    required this.departmentId,
    required this.status,
    required this.deletedAt,
    required this.fileCount,
  });

  final String id;
  final String title;
  final String departmentId;

  /// Silinmeden önceki durum (sunucuda serbest dize; tanımsızsa [TaskStatus.unknown]).
  final TaskStatus status;
  final DateTime deletedAt;

  /// Korunan ek dosya sayısı (`file_count`).
  final int fileCount;

  @override
  bool operator ==(Object other) =>
      other is DeletedTask &&
      other.id == id &&
      other.title == title &&
      other.departmentId == departmentId &&
      other.status == status &&
      other.deletedAt == deletedAt &&
      other.fileCount == fileCount;

  @override
  int get hashCode =>
      Object.hash(id, title, departmentId, status, deletedAt, fileCount);
}

bool _sameList(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
