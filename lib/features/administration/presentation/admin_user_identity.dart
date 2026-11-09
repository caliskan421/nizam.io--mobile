import 'package:flutter/material.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../domain/organization_admin.dart';

/// One role and avatar interpretation shared by the directory and the profile.
class AdminUserIdentity {
  AdminUserIdentity(this.user, {required this.companyAdmin})
    : coordinator = user.teams.any((m) => m.role == DepartmentRole.coordinator),
      member = user.teams.any((m) => m.role == DepartmentRole.member);
  final KnownUser user;
  final bool companyAdmin;
  final bool coordinator;
  final bool member;

  Color fill(BuildContext context) => companyAdmin
      ? context.colors.roleAdmin
      : coordinator
      ? context.colors.avatar1
      : member
      ? context.colors.roleMember
      : context.colors.surfaceOverlay;
  Color ink(BuildContext context) => companyAdmin || coordinator || member
      ? context.colors.onAvatar
      : context.colors.text;
  List<String> roles(BuildContext context) => [
    if (companyAdmin) context.l10n.uiUsersAdmin,
    if (coordinator) context.l10n.uiUsersCoordinator,
    if (member) context.l10n.uiUsersMember,
  ];
  List<String> departmentNames(TaskCatalog? catalog, String? programId) => {
    for (final membership in user.teams.where((m) => m.programId == programId))
      if (catalog?.coordinatorship(membership.departmentId)
          case final department?)
        department.name,
  }.toList();
}
