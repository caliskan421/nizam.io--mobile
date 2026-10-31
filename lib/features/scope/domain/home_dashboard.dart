import 'package:meta/meta.dart';

/// Ana sayfa özeti (seçili program kapsamında). Domain varlığı: sunum yalnız bunu görür;
/// kaynağı bugün geliştirme örneğidir (`data/sample/`), backend bağlanınca repository değişir,
/// bu sınıf değişmez. Sayılar sunucunun hesapladığı değerlerdir — istemci görev durumu ya da
/// yetki kuralı türetmez.
@immutable
final class HomeDashboard {
  const HomeDashboard({
    required this.greetingName,
    required this.tasks,
    required this.coordinatorships,
    required this.pending,
    required this.counts,
    this.team,
    this.lastActivity,
    this.greetingRole,
    this.greetingEmail,
    this.demoProgramName,
    this.demoProgramYear,
  });

  /// Karşılamadaki ad (oturumdaki kişinin görünen adı).
  final String greetingName;

  /// Oturumdaki kişinin rolü ve e-postası (çekmece başlığı "Admin · e-posta"); bilinmiyorsa null.
  final TeamRole? greetingRole;
  final String? greetingEmail;

  /// Yalnız örnek/demo fikstüründe: kapsam (program) yüklenemezken çekmece sezon kartında
  /// gösterilecek prototip program adı ve yılı. Gerçek kaynakta null; gerçek kapsam önceliklidir.
  final String? demoProgramName;
  final int? demoProgramYear;
  final TaskTotals tasks;

  /// Ekip sayıları; yönetici olmayan hesapta bilinmez (null → ekip kutusu gizlenir).
  final TeamTotals? team;
  final LastActivity? lastActivity;
  final List<CoordinatorshipSummary> coordinatorships;

  /// Kişiyi bekleyen işler (tarih talebi, onay).
  final List<PendingItem> pending;
  final ModuleCounts counts;
}

/// Görev sayıları. Sunucu karşılığı `DashboardReport` (`GET /v1/reports/dashboard`):
/// [total] ← `total_tasks`, [done] ← `completed_tasks`, [late] ← `overdue_tasks`,
/// [awaitingApproval] ← `pending_approvals`, [inProgress] ← `task_status_distribution`
/// içindeki `devam_ediyor` sayısı (sunucunun `active_tasks` alanı `total − completed`
/// olduğundan başlanmamışları da sayar; o değer `DashboardReport.activeTasks`'tadır).
@immutable
final class TaskTotals {
  const TaskTotals({
    required this.total,
    required this.done,
    required this.inProgress,
    required this.late,
    required this.awaitingApproval,
    this.inProgressOnTime,
  });

  final int total;
  final int done;
  final int inProgress;

  /// Zamanında ilerleyen görevler. Sunucuda yok — entegrasyonda karar (`overdue_tasks`
  /// başlanmamışları da kapsadığından çıkarma ile türetilemez); sunucu kaynağında null.
  final int? inProgressOnTime;
  final int late;
  final int awaitingApproval;

  /// Tamamlanmamış görevler.
  int get open => total - done;
}

/// Kullanıcı rolü (ekip kutuları, çekmece başlığı).
enum TeamRole { admin, coordinator, member }

/// Kullanıcı sayıları (rol dağılımı sunucudan gelir).
@immutable
final class TeamTotals {
  const TeamTotals({
    required this.admins,
    required this.coordinators,
    required this.members,
    this.userCount,
  });

  final int admins;
  final int coordinators;
  final int members;

  /// Toplam kullanıcı (sunucu ya da fikstür verdiyse); null → rol toplamı.
  final int? userCount;

  int get users => userCount ?? admins + coordinators + members;
}

/// Son işlem (işlem geçmişi giriş kartı).
@immutable
final class LastActivity {
  const LastActivity({required this.at, required this.actorName});

  final DateTime at;
  final String actorName;
}

/// Departman türü (sunucu `kind`: `koordinatorluk` | `calisma_grubu`).
enum CoordinatorshipKind { coordinatorship, workingGroup, unknown }

/// Koordinatörlük özeti: görev dağılımı sayılarla (yüzde sunumda hesaplanır). Sunucu
/// karşılığı `CoordinatorshipStat` (dashboard içinde ve
/// `GET /v1/reports/dashboard/coordinatorships`); isteğe bağlı alanlar yalnız sunucu
/// kaynağında dolar, örnek fikstürde null kalır.
@immutable
final class CoordinatorshipSummary {
  const CoordinatorshipSummary({
    required this.code,
    required this.name,
    required this.leads,
    required this.todo,
    required this.inProgress,
    required this.inReview,
    required this.done,
    required this.late,
    this.leadAccountIds = const [],
    this.kind,
    this.serverTotal,
    this.completionRate,
    this.memberCount,
    this.meetingCount,
    this.lastActivityAt,
    this.description,
  });

  /// Rota kimliği. Örnek fikstürde kısa kod (`ALT`); sunucu kaynağında `department_id`
  /// (backend'de kısa kod kavramı yok — entegrasyonda karar).
  final String code;
  final String name;

  /// Koordinatör adları; boş → atanmamış.
  final List<String> leads;

  /// Koordinatörlerin hesap kimlikleri ([leads] ile aynı sırada; örnekte boş).
  final List<String> leadAccountIds;

  /// Sunucu `not_started_tasks`.
  final int todo;

  /// Sunucu `in_progress_tasks` (yalnız `devam_ediyor`).
  final int inProgress;

  /// Sunucuda ayrı alan yok — kalan sayı (`total − completed − in_progress −
  /// not_started`; `onaya_sunuldu` + `iade_edildi`). Entegrasyonda karar.
  final int inReview;
  final int done;
  final int late;

  final CoordinatorshipKind? kind;

  /// Sunucunun `total_tasks` değeri; varsa [total] bunu döner.
  final int? serverTotal;

  /// Sunucu `completion_rate`: yüzde (0–100); görev yoksa 0.
  final double? completionRate;
  final int? memberCount;
  final int? meetingCount;

  /// Son görev güncellemesi (işlem geçmişi değil).
  final DateTime? lastActivityAt;
  final String? description;

  int get total => serverTotal ?? todo + inProgress + inReview + done;
  bool get hasLead => leads.isNotEmpty;

  /// 0–100, tam sayıya yuvarlanmış tamamlanma.
  int get donePercent => total == 0 ? 0 : (done * 100 / total).round();
}

/// Bekleyen işin türü.
enum PendingKind { dateChange, approval }

/// Kişiyi bekleyen tek iş.
@immutable
final class PendingItem {
  const PendingItem({
    required this.taskCode,
    required this.title,
    required this.kind,
    this.label,
    this.requestedDate,
    this.requestedShiftDays,
  });

  /// Rota kimliği: örnekte görev kodu (`ALT-7`), sunucu kaynağında `work_item_id`.
  final String taskCode;

  /// Satır altyazısının başı; null → [taskCode]. Sunucu kaynağında departman adı (kimlik
  /// kullanıcıya gösterilmez).
  final String? label;
  final String title;
  final PendingKind kind;

  /// Tarih talebinde istenen yeni bitiş.
  final DateTime? requestedDate;

  /// Tarih talebi kaydırma olarak gösterilecekse gün sayısı ("+51 gün"); [requestedDate]'ten
  /// önce gelir.
  final int? requestedShiftDays;
}

/// Modül rozet sayıları (çekmece).
@immutable
final class ModuleCounts {
  const ModuleCounts({
    required this.lateTasks,
    required this.tasksAwaitingApproval,
    required this.unreadMessages,
    required this.pendingRequests,
  });

  final int lateTasks;
  final int tasksAwaitingApproval;
  final int unreadMessages;
  final int pendingRequests;
}

/// Yönetici olmayan hesabın özetinde görev listesinden sayılamayan parçalar
/// ([HomeDashboardRepository.loadTeamExtras]).
@immutable
final class TeamDashboardExtras {
  const TeamDashboardExtras({
    required this.unreadMessages,
    this.pendingDateRequests = const [],
  });

  final int unreadMessages;

  /// Çağıranın bekleyen tarih talepleri (yalnız koordinatörde dolu).
  final List<PendingDateRequest> pendingDateRequests;
}

/// Bekleyen tarih talebi (görev, eski ve yeni bitiş).
@immutable
final class PendingDateRequest {
  const PendingDateRequest({
    required this.workItemId,
    required this.oldEnd,
    required this.newEnd,
  });

  final String workItemId;
  final DateTime oldEnd;
  final DateTime newEnd;
}
