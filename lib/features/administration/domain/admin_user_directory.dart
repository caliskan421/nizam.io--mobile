import 'organization_admin.dart';

/// Şirket yöneticiliği üyelik rolü değildir. Ayrı görünüm indeksinden doğrulanır;
/// koordinatör/üye kümeleri birbirini dışlamaz.
enum AdminUserRoleFilter { all, admin, coordinator, member }

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
