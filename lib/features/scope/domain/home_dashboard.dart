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
    required this.team,
    required this.coordinatorships,
    required this.pending,
    required this.counts,
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
  final TeamTotals team;
  final LastActivity? lastActivity;
  final List<CoordinatorshipSummary> coordinatorships;

  /// Kişiyi bekleyen işler (tarih talebi, onay).
  final List<PendingItem> pending;
  final ModuleCounts counts;
}

/// Görev sayıları.
@immutable
final class TaskTotals {
  const TaskTotals({
    required this.total,
    required this.done,
    required this.inProgress,
    required this.inProgressOnTime,
    required this.late,
    required this.awaitingApproval,
  });

  final int total;
  final int done;
  final int inProgress;
  final int inProgressOnTime;
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

/// Koordinatörlük özeti: görev dağılımı sayılarla (yüzde sunumda hesaplanır).
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
  });

  /// Kısa kod (`ALT`); rota kimliği.
  final String code;
  final String name;

  /// Koordinatör adları; boş → atanmamış.
  final List<String> leads;
  final int todo;
  final int inProgress;
  final int inReview;
  final int done;
  final int late;

  int get total => todo + inProgress + inReview + done;
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
    this.requestedDate,
    this.requestedShiftDays,
  });

  /// Görev kodu (`ALT-7`); rota kimliği.
  final String taskCode;
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
