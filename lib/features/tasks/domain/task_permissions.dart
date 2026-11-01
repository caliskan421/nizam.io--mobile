import 'package:meta/meta.dart';

import 'task_access.dart';
import 'task_catalog.dart';
import 'work_item.dart';

/// Durum geçişinin gönderildiği uç (istemci akışları §5): kapsam koordinatörü
/// `transitionWorkItem` (`POST …/transitions`), yalnız atanmış üye `ownStatusWorkItem`
/// (`PATCH …/own-status`).
enum StatusEndpoint { transition, ownStatus }

/// Aktör × durum geçiş matrisi: backend `work/domain/transition.go` (WORK-K12) ile birebir,
/// elle yazılır (istemci akışları §5). İstemci yalnız buradaki hedefleri gösterir; karar yine
/// sunucudadır (matris dışı hedef 409 `work.transition_not_allowed`).
const Map<TransitionActor, Map<TaskStatus, List<TaskStatus>>> statusMatrix = {
  TransitionActor.member: {
    TaskStatus.todo: [TaskStatus.inProgress],
    TaskStatus.inProgress: [TaskStatus.review],
    TaskStatus.review: [],
    TaskStatus.returned: [TaskStatus.inProgress],
    TaskStatus.done: [],
  },
  TransitionActor.coordinator: {
    TaskStatus.todo: [TaskStatus.inProgress, TaskStatus.done],
    TaskStatus.inProgress: [TaskStatus.todo, TaskStatus.done],
    TaskStatus.review: [TaskStatus.done, TaskStatus.returned],
    TaskStatus.returned: [
      TaskStatus.todo,
      TaskStatus.inProgress,
      TaskStatus.done,
    ],
    TaskStatus.done: [TaskStatus.inProgress],
  },
  TransitionActor.coordinatorOwnTask: {
    TaskStatus.todo: [TaskStatus.inProgress, TaskStatus.done],
    TaskStatus.inProgress: [
      TaskStatus.todo,
      TaskStatus.review,
      TaskStatus.done,
    ],
    TaskStatus.review: [TaskStatus.done, TaskStatus.returned],
    TaskStatus.returned: [
      TaskStatus.todo,
      TaskStatus.inProgress,
      TaskStatus.done,
    ],
    TaskStatus.done: [TaskStatus.inProgress],
  },
};

/// Geri alma gerekçesinin asgari uzunluğu (sunucu `reasonMinLen`; sunucu bayt sayar, istemci
/// karakter — karakter ≤ bayt olduğundan istemci denetimi sunucununkinden gevşek değildir).
const revertReasonMinLength = 3;

/// `tamamlandi`'dan çıkış gerekçe ister (WORK-K17).
bool requiresRevertReason(TaskStatus from, TaskStatus to) =>
    from == TaskStatus.done && to != TaskStatus.done;

/// Oturumdaki hesabın TEK görevdeki işlem bazlı yetkileri (istemci akışları §4). Tek bir rol
/// etiketinden değil, ayrı olgulardan türetilir: şirket yöneticisi mi ([admin]), görevin
/// (program, departman) kapsamında koordinatör mü ([coordinator]) / üye satırı var mı
/// ([member]), göreve atanmış mı ([assigned]). Yazar olgusu ([canEditNote]) nota göre okunur.
/// Gizleme güvenlik değildir: sunucu her istekte yetkiyi yeniden denetler.
///
/// Örnek (yerel) katalogda [TaskPermissions.local]: prototip davranışı, her eylem açık.
@immutable
final class TaskPermissions {
  const TaskPermissions._({
    required this.accountId,
    required this.admin,
    required this.coordinator,
    required this.member,
    required this.assigned,
    required this.local,
  });

  /// Örnek katalog: bütün eylemler yerel, kısıt yok.
  const TaskPermissions.local()
    : this._(
        accountId: '',
        admin: false,
        coordinator: false,
        member: false,
        assigned: false,
        local: true,
      );

  /// [access] (sunucu katalogu) ve [task] olgularından; [access] null → [TaskPermissions.local].
  factory TaskPermissions.of(TaskAccess? access, TaskItem task) {
    if (access == null) return const TaskPermissions.local();
    final program = task.programId;
    final department = task.departmentId;
    final role = program == null || department == null || department.isEmpty
        ? null
        : access.roleIn(program, department);
    return TaskPermissions._(
      accountId: access.accountId,
      admin: access.companyAdmin,
      coordinator: role == SeatRole.coordinator,
      member: role == SeatRole.member,
      assigned: task.assignees.contains(access.accountId),
      local: false,
    );
  }

  final String accountId;

  /// Şirket yöneticisi (`/v1/me` `company_admin`).
  final bool admin;

  /// Görevin kapsamında `koordinator` satırı.
  final bool coordinator;

  /// Görevin kapsamında `uye` satırı.
  final bool member;

  /// Göreve atanmış.
  final bool assigned;

  /// Örnek katalog (sunucuya yazılmaz).
  final bool local;

  /// Kapsamda herhangi bir ekip satırı.
  bool get _seat => coordinator || member;

  /// Geçiş aktörü (WORK-K11): koordinatör + atanmış → kendi görevi; koordinatör → koordinatör;
  /// yalnız atanmış üye → üye. Şirket yöneticiliği tek başına aktör değildir (null).
  TransitionActor? get actor => switch (this) {
    _ when coordinator && assigned => TransitionActor.coordinatorOwnTask,
    _ when coordinator => TransitionActor.coordinator,
    _ when member && assigned => TransitionActor.member,
    _ => null,
  };

  /// Durum geçişinin ucu: kapsam koordinatörü (yönetici + koordinatör dahil) `transitions`,
  /// yalnız atanmış üye `own-status`; aktör yoksa null.
  StatusEndpoint? get statusEndpoint => coordinator
      ? StatusEndpoint.transition
      : actor == TransitionActor.member
      ? StatusEndpoint.ownStatus
      : null;

  /// [from] durumundan gösterilecek hedefler (matristen; örnekte her tanımlı durum).
  List<TaskStatus> statusTargets(TaskStatus from) {
    if (local) {
      return [
        for (final s in TaskStatus.known)
          if (s != from) s,
      ];
    }
    final a = actor;
    return a == null ? const [] : statusMatrix[a]?[from] ?? const [];
  }

  /// Not okuma: yönetici, koordinatör ya da atanmış üye.
  bool get canReadNotes =>
      local || admin || coordinator || (member && assigned);

  /// Not yazma: koordinatör ya da atanmış üye; yöneticilik baskındır (reddeder).
  bool get canAddNote =>
      local || (!admin && (coordinator || (member && assigned)));

  /// Notu düzenleme/silme: yalnız yazarı, kapsamda ekip satırı varken.
  bool canEditNote(TaskNote note) =>
      local || (note.id != null && note.by == accountId && _seat);

  /// Alt görev oluştur/sil, başlık/atanan/tarih düzenle: yönetici ya da koordinatör.
  bool get canManageSubtasks => local || admin || coordinator;

  /// Alt görevi kapat/aç: koordinatör her alt görevde; ana göreve atanmış üye alt görev
  /// atamasızsa ya da kendisine atanmışsa. Yönetici tek başına işaretleyemez.
  bool canToggleSubtask(Subtask sub) {
    if (local || coordinator) return true;
    if (!member || !assigned) return false;
    return sub.assignee == null || sub.assignee == accountId;
  }

  /// Alt göreve atanabilecek kişiler: ana görevin atananları (sunucu 422
  /// `work.subtask_assignee_not_assigned`).
  List<String> subtaskAssignees(TaskItem task) => task.assignees;
}
