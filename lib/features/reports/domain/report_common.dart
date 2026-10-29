import 'package:meta/meta.dart';

/// Rapordaki görev durumu (sunucu `baslanmadi`, `devam_ediyor`, `onaya_sunuldu`,
/// `iade_edildi`, `tamamlandi`). Rapor şemalarında durum serbest dizgedir; tanınmayan
/// değer [unknown] olur.
enum ReportTaskStatus {
  notStarted,
  inProgress,
  submitted,
  returned,
  completed,
  unknown,
}

/// Rapordaki görev önceliği (sunucu `dusuk`, `orta`, `yuksek`, `acil`).
enum ReportPriority { low, medium, high, urgent, unknown }

/// Rapordaki rol kopyası (sunucu `admin`, `coordinator`, `member`).
enum ReportRole { admin, coordinator, member, unknown }

/// Departman türü (sunucu `koordinatorluk`, `calisma_grubu`).
enum ReportDepartmentKind { coordinatorship, workingGroup, unknown }

/// Rapordaki kişi: yalnız ad-soyad (raporlar e-posta taşımaz — REPORTING-K13).
@immutable
final class ReportPerson {
  const ReportPerson({required this.accountId, required this.fullName});

  final String accountId;
  final String fullName;

  @override
  bool operator ==(Object other) =>
      other is ReportPerson &&
      other.accountId == accountId &&
      other.fullName == fullName;

  @override
  int get hashCode => Object.hash(accountId, fullName);
}

/// Rapordaki departman (koordinatörlük ya da çalışma grubu).
@immutable
final class ReportDepartment {
  const ReportDepartment({
    required this.departmentId,
    required this.name,
    this.kind,
  });

  final String departmentId;
  final String name;

  /// Sunucu alanı isteğe bağlı; yoksa null, tanınmıyorsa [ReportDepartmentKind.unknown].
  final ReportDepartmentKind? kind;
}

/// Koordinatörlük performansı (sunucu `CoordinatorshipStat`; dönem raporunda).
@immutable
final class ReportCoordinatorshipStat {
  const ReportCoordinatorshipStat({
    required this.departmentId,
    required this.name,
    required this.kind,
    required this.coordinators,
    required this.totalTasks,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.notStartedTasks,
    required this.overdueTasks,
    required this.completionRate,
    required this.memberCount,
    required this.meetingCount,
    this.lastActivityAt,
    this.description,
  });

  final String departmentId;
  final String name;
  final ReportDepartmentKind kind;
  final List<ReportPerson> coordinators;
  final int totalTasks;
  final int completedTasks;
  final int inProgressTasks;
  final int notStartedTasks;
  final int overdueTasks;

  /// Yüzde (0–100); görev yoksa 0.
  final double completionRate;
  final int memberCount;
  final int meetingCount;

  /// Son görev güncellemesi (işlem geçmişi değil); yoksa null.
  final DateTime? lastActivityAt;
  final String? description;
}
