import 'package:meta/meta.dart';

import '../../../core/domain/effective_role.dart';
import 'task_catalog.dart';
import 'task_query.dart';
import 'work_item.dart';

// Koordinatör görünümünün karar mantığı (saf Dart): etkin görünüme göre görev kümesi, onay
// kuyruğu, atanmamış görevler, ekip yükü, görünüm/sıralama kümeleri ve doğrudan süre uzatma
// sınırı. Kaynak yalnız yüklü görev kataloğudur; sunucuda olmayan veri türetilmez (gönderim
// anı, dosya sayısı, bağımlılık kilidi listede yok — sunum bunları göstermez).

/// Doğrudan süre uzatmanın (onay gerekmez) üst sınırı: ürün kuralı 7 gün. Sunucu 1–90 kabul
/// eder (WORK-K40); 7 günü aşan değişiklik tarih talebiyle yapılır.
const maxDirectExtendDays = 7;

/// Süre uzatma alt sayfasının seçenekleri.
const extendDayOptions = [1, 3, 5, 7];

/// [days] doğrudan uzatılabilir mi (1–[maxDirectExtendDays]).
bool isValidExtendDays(int days) => days >= 1 && days <= maxDirectExtendDays;

/// İade sebebi ve tarih talebi gerekçesinin istemci üst sınırı (karakter).
const decisionReasonMaxLength = 1000;

/// Sebep geçerli mi: kırpılmış hâli boş değil ve [decisionReasonMaxLength]'i aşmıyor.
bool isValidDecisionReason(String reason) {
  final r = reason.trim();
  return r.isNotEmpty && r.length <= decisionReasonMaxLength;
}

/// Gecikme: sunucu bayrağı, yoksa gecikme günü (bitmemiş görevde).
bool isTaskLate(TaskItem t) =>
    t.lateness?.isOverdue ?? (!t.isDone && t.isOverdue);

/// Atanmamış açık görev (sorumlu bekliyor).
bool isUnassigned(TaskItem t) =>
    !t.isDone && t.status != TaskStatus.unknown && t.assignees.isEmpty;

/// Etkin görünümün görev kümesi (arayüz süzgeci; yetkiyi genişletmez). Yönetici görünümü ya
/// da koordinatörlük bilinmiyorsa küme olduğu gibidir; Koordinatör görünümünde yalnız
/// [departmentId] görevleri; Üye görünümünde ayrıca yalnız [me]'ye atananlar.
List<TaskItem> scopedTasks(
  Iterable<TaskItem> tasks, {
  required EffectiveRole role,
  required String? departmentId,
  required String me,
}) {
  if (role == EffectiveRole.admin || departmentId == null) {
    return List.of(tasks);
  }
  return [
    for (final t in tasks)
      if (t.departmentId == departmentId &&
          (role != EffectiveRole.member || t.assignees.contains(me)))
        t,
  ];
}

/// Onay kuyruğu: onaya sunulmuş görevler, bitişi yakın olan önce (gönderim anı sunucu
/// listesinde yok; sıra bitiş tarihidir). Eşitlikte giriş sırası korunur.
List<TaskItem> approvalQueue(Iterable<TaskItem> tasks) => _byDue([
  for (final t in tasks)
    if (t.status == TaskStatus.review) t,
]);

/// Atanmamış açık görevler, bitişi yakın olan önce.
List<TaskItem> unassignedTasks(Iterable<TaskItem> tasks) => _byDue([
  for (final t in tasks)
    if (isUnassigned(t)) t,
]);

List<TaskItem> _byDue(List<TaskItem> list) {
  final indexed = [for (var i = 0; i < list.length; i++) (i, list[i])];
  indexed.sort((a, b) {
    final c = a.$2.due.compareTo(b.$2.due);
    return c != 0 ? c : a.$1 - b.$1;
  });
  return [for (final e in indexed) e.$2];
}

/// Bir kişinin açık görev yükü (ekip yükü şeridi): devam, onayda, geciken, iade.
@immutable
final class TeamLoad {
  const TeamLoad({
    required this.personId,
    required this.open,
    required this.inProgress,
    required this.review,
    required this.late,
    required this.returned,
  });

  final String personId;

  /// Bitmemiş görev sayısı.
  final int open;
  final int inProgress;
  final int review;

  /// Geciken (durumdan bağımsız; [open] içinde).
  final int late;
  final int returned;

  @override
  bool operator ==(Object other) =>
      other is TeamLoad &&
      other.personId == personId &&
      other.open == open &&
      other.inProgress == inProgress &&
      other.review == review &&
      other.late == late &&
      other.returned == returned;

  @override
  int get hashCode =>
      Object.hash(personId, open, inProgress, review, late, returned);
}

/// Ekip yükü: [team] (koordinatörlüğün ekibi; katalogdan) ile [tasks]'ta atanan herkes;
/// kişi başına bitmemiş görevlerin sayımı. Backend koordinatöre ekip yükü ucu açmaz
/// (reports/workload yalnız şirket yöneticisi): sayım istemcide, görünen görevlerden.
/// Sıra: açık görevi çok olan önce; eşitlikte geciken çok olan, sonra giriş sırası.
List<TeamLoad> teamLoad(
  Iterable<TaskItem> tasks, {
  List<String> team = const [],
}) {
  final order = <String>[...team];
  final seen = {...team};
  final open = [
    for (final t in tasks)
      if (!t.isDone) t,
  ];
  for (final t in open) {
    for (final a in t.assignees) {
      if (seen.add(a)) order.add(a);
    }
  }
  TeamLoad loadOf(String id) {
    final mine = [
      for (final t in open)
        if (t.assignees.contains(id)) t,
    ];
    int count(bool Function(TaskItem t) test) => mine.where(test).length;
    return TeamLoad(
      personId: id,
      open: mine.length,
      inProgress: count((t) => t.status == TaskStatus.inProgress),
      review: count((t) => t.status == TaskStatus.review),
      late: count(isTaskLate),
      returned: count((t) => t.status == TaskStatus.returned),
    );
  }

  final indexed = [
    for (var i = 0; i < order.length; i++) (i, loadOf(order[i])),
  ];
  indexed.sort((a, b) {
    final o = b.$2.open - a.$2.open;
    if (o != 0) return o;
    final l = b.$2.late - a.$2.late;
    return l != 0 ? l : a.$1 - b.$1;
  });
  return [for (final e in indexed) e.$2];
}

/// Koordinatörlük özeti (ana sayfa özet kartı ve çipler).
typedef CoordinatorSummary = ({
  int total,
  int done,
  int review,
  int inProgress,
  int returned,
  int todo,
  int late,
  int unassigned,
});

CoordinatorSummary summarizeTasks(Iterable<TaskItem> tasks) {
  final list = List.of(tasks);
  int count(bool Function(TaskItem t) test) => list.where(test).length;
  return (
    total: list.length,
    done: count((t) => t.isDone),
    review: count((t) => t.status == TaskStatus.review),
    inProgress: count((t) => t.status == TaskStatus.inProgress),
    returned: count((t) => t.status == TaskStatus.returned),
    todo: count((t) => t.status == TaskStatus.todo),
    late: count(isTaskLate),
    unassigned: count(isUnassigned),
  );
}

/// Görev listesi görünüm kutucukları: koordinatörde "Atanmamış" var, "Tarih talebi" yok
/// (talepler ayrı satırda); diğer görünümlerde bugünkü küme.
List<TaskView> taskViewsFor({required bool coordinator}) => coordinator
    ? const [
        TaskView.all,
        TaskView.late,
        TaskView.review,
        TaskView.unassigned,
        TaskView.inProgress,
        TaskView.notStarted,
        TaskView.done,
      ]
    : const [
        TaskView.all,
        TaskView.late,
        TaskView.inProgress,
        TaskView.review,
        TaskView.dateRequest,
        TaskView.notStarted,
        TaskView.done,
      ];

/// Sıralama seçenekleri: koordinatörde duruma göre (varsayılan) var, koordinatörlüğe göre
/// yok (tek koordinatörlük görünür).
List<TaskSort> taskSortsFor({required bool coordinator}) => coordinator
    ? const [TaskSort.status, TaskSort.created, TaskSort.due, TaskSort.start]
    : const [
        TaskSort.created,
        TaskSort.due,
        TaskSort.start,
        TaskSort.coordinatorship,
      ];

/// Geçerli sıralama: kullanıcı seçmediyse ([picked] false) rolün varsayılanı (koordinatörde
/// duruma göre, diğerlerinde bitiş); seçtiği ölçüt rolde yoksa rolün ilk seçeneği.
TaskSort resolveTaskSort(
  TaskSort chosen, {
  required bool picked,
  required bool coordinator,
}) {
  final options = taskSortsFor(coordinator: coordinator);
  if (!picked) return coordinator ? TaskSort.status : TaskSort.due;
  return options.contains(chosen) ? chosen : options.first;
}

/// Görev başlatmayı kilitleyen ön görevler: [links] içindeki ön görevlerden katalogda
/// görünen ve bitmemiş olanlar (görünmeyen ön görevin durumu bilinmez; kilit sayılmaz).
List<TaskItem> blockingPrerequisites(
  TaskDependencies links,
  TaskItem? Function(String id) taskById,
) => [
  for (final d in links.dependencies)
    if (taskById(d.dependsOnId) case final t? when !t.isDone) t,
];
