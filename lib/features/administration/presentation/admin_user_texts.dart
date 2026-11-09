import 'package:flutter/widgets.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../domain/organization_admin.dart';

String adminMembershipSummary(
  BuildContext context,
  KnownUser user,
  TaskCatalog? catalog, {
  String? programId,
}) {
  final l = context.l10n;
  if (user.memberships.isEmpty) return l.uiUsersUnassigned;
  if (user.teams.isEmpty) return l.uiUsersMembershipUnknown;
  return user.teams
      .map((membership) {
        final department = membership.programId == programId
            ? catalog?.coordinatorships
                  .where((d) => d.code == membership.departmentId)
                  .firstOrNull
            : null;
        final role = switch (membership.role) {
          DepartmentRole.coordinator => l.uiUsersCoordinator,
          DepartmentRole.member => l.uiUsersMember,
          _ => l.uiUsersMembershipUnknown,
        };
        return '${department?.name ?? l.uiUsersOtherDepartment} · $role';
      })
      .join(' / ');
}
