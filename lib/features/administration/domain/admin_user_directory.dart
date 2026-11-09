import '../../../core/domain/turkish_collation.dart';
import '../../scope/scope.dart' show DepartmentRole;
import 'organization_admin.dart';

/// Şirket yöneticiliği üyelik rolü değildir. Ayrı görünüm indeksinden doğrulanır;
/// koordinatör/üye kümeleri birbirini dışlamaz.
enum AdminUserRoleFilter { all, admin, coordinator, member }

const unassignedDepartmentFilter = '__unassigned__';

class AdminUserCount {
  const AdminUserCount(this.value, {required this.exact});
  final int value;
  final bool exact;
  String get label => '$value${exact ? '' : '+'}';
}

class AdminUsersSummary {
  const AdminUsersSummary({
    required this.total,
    required this.all,
    required this.coordinators,
    required this.members,
    required this.shown,
    this.admins,
    this.adminAccountIds,
    this.matched,
  });
  final AdminUserCount? matched;
  final AdminUserCount? admins;
  final Set<String>? adminAccountIds;
  final AdminUserCount total;
  final AdminUserCount all;
  final AdminUserCount coordinators;
  final AdminUserCount members;
  final List<KnownUser> shown;
  AdminUserCount? countFor(AdminUserRoleFilter role) => switch (role) {
    AdminUserRoleFilter.all => all,
    AdminUserRoleFilter.admin => admins,
    AdminUserRoleFilter.coordinator => coordinators,
    AdminUserRoleFilter.member => members,
  };
}

bool userHasRole(
  KnownUser user,
  AdminUserRoleFilter role, {
  Set<String>? adminIds,
}) => switch (role) {
  AdminUserRoleFilter.all => true,
  AdminUserRoleFilter.admin => adminIds?.contains(user.accountId) ?? false,
  AdminUserRoleFilter.coordinator => user.teams.any(
    (m) => m.role == DepartmentRole.coordinator,
  ),
  AdminUserRoleFilter.member => user.teams.any(
    (m) => m.role == DepartmentRole.member,
  ),
};

/// Ad ile seçili programdaki koordinatörlük adı birlikte aranır. Sunucu yanıtında
/// e-posta yoktur; üyelik kimlikleri arama metni olarak gösterilmez.
bool userMatchesDirectory(
  KnownUser user, {
  required String search,
  required String? programId,
  required Set<String> departments,
  required String? Function(String departmentId) departmentName,
}) {
  if (departments.isNotEmpty &&
      !(user.teams.any(
            (m) =>
                m.programId == programId &&
                departments.contains(m.departmentId),
          ) ||
          (departments.contains(unassignedDepartmentFilter) &&
              !user.teams.any((m) => m.programId == programId)))) {
    return false;
  }
  final needle = trLower(search.trim());
  return needle.isEmpty ||
      trLower(user.fullName).contains(needle) ||
      user.teams.any(
        (m) =>
            m.programId == programId &&
            trLower(departmentName(m.departmentId) ?? '').contains(needle),
      );
}
