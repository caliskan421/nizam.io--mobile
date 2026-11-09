import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/surfaces/nz_card.dart';
import '../../coordinatorships/coordinatorships.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/admin_controller.dart';
import '../domain/organization_admin.dart';
import 'admin_forms.dart';

/// Only edits memberships in the selected program. Server validates role changes and
/// asks for explicit confirmation when existing tasks are affected.
class AdminUserMemberships extends ConsumerWidget {
  const AdminUserMemberships({super.key, required this.user});
  final KnownUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final scope = ref.watch(scopeStateProvider);
    final session = ref.watch(sessionGenerationProvider);
    final programId = scope.programId;
    final busy = ref.watch(adminCommandProvider);
    final memberships = user.teams
        .where((m) => m.programId == programId)
        .toList();
    Future<void> run(
      Future<void> Function(DepartmentRepository repo, bool confirmed) action,
    ) async {
      if (scope != ref.read(scopeStateProvider) ||
          session != ref.read(sessionGenerationProvider)) {
        return;
      }
      final repo = ref.read(departmentRepositoryProvider);
      Future<void> attempt(bool confirmed) => ref
          .read(adminCommandProvider.notifier)
          .run((_, _) => action(repo, confirmed));
      try {
        try {
          await attempt(false);
        } on ApiError catch (e) {
          if (e.code != 'organization.confirmation_required' ||
              !context.mounted) {
            rethrow;
          }
          if (!await adminConfirm(
            context,
            l.uiUsersMemberships,
            l.uiUsersMembershipConfirm,
          )) {
            return;
          }
          if (scope != ref.read(scopeStateProvider) ||
              session != ref.read(sessionGenerationProvider)) {
            return;
          }
          await attempt(true);
        }
        if (context.mounted) NzToast.show(context, l.uiUsersSaved);
      } on Object catch (e) {
        if (context.mounted) NzToast.error(context, toApiError(e));
      }
    }

    return NzCard.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.uiUsersMemberships, style: context.text.titleSm),
          Text(l.uiUsersMembershipScope, style: context.text.caption),
          for (final d
              in catalog?.coordinatorships ?? const <CoordinatorshipRef>[])
            ListTile(
              title: Text(d.name),
              subtitle: Text(
                memberships
                            .where((m) => m.departmentId == d.code)
                            .firstOrNull
                            ?.role ==
                        DepartmentRole.coordinator
                    ? l.uiUsersCoordinator
                    : memberships.any((m) => m.departmentId == d.code)
                    ? l.uiUsersMember
                    : l.uiUsersNotMember,
              ),
              trailing: PopupMenuButton<String>(
                enabled: !busy,
                onSelected: (value) async {
                  if (scope != ref.read(scopeStateProvider) ||
                      session != ref.read(sessionGenerationProvider)) {
                    return;
                  }
                  if (value == 'open') {
                    context.appNav.openCoordinatorship(d.code);
                    return;
                  }
                  final existing = memberships.any(
                    (m) => m.departmentId == d.code,
                  );
                  if (value == 'remove') {
                    if (!await adminConfirm(
                      context,
                      l.uiUsersRemoveMembership,
                      l.uiUsersRemoveMembershipConfirm,
                    )) {
                      return;
                    }
                    await run((repo, confirmed) async {
                      await repo.removeMember(
                        d.code,
                        user.accountId,
                        confirm: confirmed,
                      );
                    });
                  } else {
                    final role = value == 'coordinator'
                        ? DepartmentRole.coordinator
                        : DepartmentRole.member;
                    await run((repo, confirmed) async {
                      if (existing) {
                        await repo.changeMembershipRole(
                          d.code,
                          user.accountId,
                          role: role,
                          confirm: confirmed,
                        );
                      } else {
                        await repo.assignMembership(
                          d.code,
                          accountId: user.accountId,
                          role: role,
                        );
                      }
                    });
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'member',
                    child: Text(l.uiUsersSetMember),
                  ),
                  PopupMenuItem(
                    value: 'coordinator',
                    child: Text(l.uiUsersSetCoordinator),
                  ),
                  if (memberships.any((m) => m.departmentId == d.code))
                    PopupMenuItem(
                      value: 'remove',
                      child: Text(l.uiUsersRemoveMembership),
                    ),
                  PopupMenuItem(
                    value: 'open',
                    child: Text(l.uiUsersOpenDepartment),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
