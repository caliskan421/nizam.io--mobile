import 'package:meta/meta.dart';

import 'task_catalog.dart';

/// Ekip satırındaki rol (`/v1/me/departments` `role`): `koordinator` / `uye`. Rol program ×
/// departman başınadır; şirket yöneticiliği rol değil ayrı bayraktır ([TaskAccess.companyAdmin]).
/// [unknown]: tanımsız sunucu değeri (yetki vermez).
enum SeatRole { coordinator, member, unknown }

/// Hesabın bir (program, departman) kapsamındaki ekip satırı (`/v1/me/departments` öğesi).
@immutable
final class TeamSeat {
  const TeamSeat({
    required this.programId,
    required this.departmentId,
    required this.departmentName,
    required this.role,
  });

  final String programId;
  final String departmentId;

  /// Departmanın bu programdaki adı (`display_name`).
  final String departmentName;
  final SeatRole role;

  @override
  bool operator ==(Object other) =>
      other is TeamSeat &&
      other.programId == programId &&
      other.departmentId == departmentId &&
      other.departmentName == departmentName &&
      other.role == role;

  @override
  int get hashCode =>
      Object.hash(programId, departmentId, departmentName, role);
}

/// Görev ayrıntısında bekleyen tarih talebinin okunduğu yüz (istemci akışları belgesi, F56 M-5):
/// - [reviewQueue]: şirket yöneticisi — `GET /v1/date-change-requests?status=pending` (S1);
/// - [mine]: kapsamda koordinatör — `GET /v1/date-change-requests/mine` (S3, görevin departmanı);
/// - [none]: üye ya da rolsüz — çağrı yapılmaz.
enum DateRequestFeed { reviewQueue, mine, none }

/// Oturumdaki hesabın görev erişimi: rol türetmenin TEK yeri. Kaynak `/v1/me`
/// (`company_admin`) + `/v1/me/departments` (program × departman rolleri). Birleşik rol:
/// yönetici aynı kapsamda koordinatör satırına da sahipse koordinatör yetkisi de vardır.
/// Yetki kararı sunucudadır; bu sınıf yalnız hangi ucun çağrılacağını seçer.
@immutable
final class TaskAccess {
  TaskAccess({
    required this.accountId,
    required this.companyAdmin,
    required List<TeamSeat> seats,
  }) : seats = List.unmodifiable(seats);

  final String accountId;
  final bool companyAdmin;
  final List<TeamSeat> seats;

  /// [programId] programındaki ekip satırları (departman başına bir; ilk satır geçerli).
  List<TeamSeat> seatsIn(String programId) {
    final seen = <String>{};
    return [
      for (final s in seats)
        if (s.programId == programId && seen.add(s.departmentId)) s,
    ];
  }

  /// Kapsamdaki ekip rolü; satır yoksa null.
  SeatRole? roleIn(String programId, String departmentId) {
    for (final s in seats) {
      if (s.programId == programId && s.departmentId == departmentId) {
        return s.role;
      }
    }
    return null;
  }

  /// Kapsamdaki koordinatör mü (yönetici bayrağından bağımsız).
  bool coordinatesIn(String programId, String departmentId) =>
      roleIn(programId, departmentId) == SeatRole.coordinator;

  /// Kapsamın tüm görevlerini görür mü (yönetici ya da koordinatör); üye yalnız kendine
  /// atananları görür (sunucu süzer).
  bool seesAllIn(String programId, String departmentId) =>
      companyAdmin || coordinatesIn(programId, departmentId);

  /// Kapsamda görev açabilir mi (yönetici ya da koordinatör; üye hayır — WORK-K05).
  bool canCreateIn(String programId, String departmentId) =>
      companyAdmin || coordinatesIn(programId, departmentId);

  /// Programda herhangi bir departmanda görev açabilir mi (yönetici ya da bir koordinatörlük).
  bool canCreateAnyIn(String programId) =>
      companyAdmin ||
      seats.any(
        (s) => s.programId == programId && s.role == SeatRole.coordinator,
      );

  /// Programdaki birincil departman (ana sayfa özeti): ilk koordinatörlük, yoksa ilk ekip
  /// satırı; satır yoksa null.
  String? primaryDepartmentIn(String programId) {
    final seats = seatsIn(programId);
    return (seats.where((s) => s.role == SeatRole.coordinator).firstOrNull ??
            seats.firstOrNull)
        ?.departmentId;
  }

  /// Departman ekibini (`listMembers`, görev ataması adayları) okuyabilir mi: yönetici ya da
  /// o departmanın koordinatörü; üye 403 alır → çağrılmaz.
  bool canReadTeamIn(String programId, String departmentId) =>
      companyAdmin || coordinatesIn(programId, departmentId);

  /// Görevin ([programId], [departmentId]) bekleyen tarih talebi hangi yüzden okunur.
  /// Yönetici inceleme kuyruğu bütün bekleyenleri kapsar; birleşik rolde o seçilir.
  DateRequestFeed dateRequestFeed(String? programId, String? departmentId) {
    if (companyAdmin) return DateRequestFeed.reviewQueue;
    if (programId == null || departmentId == null || departmentId.isEmpty) {
      return DateRequestFeed.none;
    }
    return coordinatesIn(programId, departmentId)
        ? DateRequestFeed.mine
        : DateRequestFeed.none;
  }

  /// Oturumdaki kişinin görünüm rolü ([programId] programında): yönetici bayrağı, yoksa
  /// programın herhangi bir departmanında koordinatörlük, yoksa üye.
  PersonRole personRoleIn(String programId) {
    if (companyAdmin) return PersonRole.admin;
    return seatsIn(programId).any((s) => s.role == SeatRole.coordinator)
        ? PersonRole.coordinator
        : PersonRole.member;
  }
}
