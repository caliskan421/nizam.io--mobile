import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/overlays/nz_bottom_sheet.dart';
import '../../tasks/tasks.dart';
import '../application/admin_controller.dart';
import '../domain/organization_admin.dart';

Future<void> showAdminUsersFilter(
  BuildContext context,
) => NzBottomSheet.show<void>(
  context,
  title: context.l10n.uiUsersFilters,
  builder: (_) => Consumer(
    builder: (context, ref, _) {
      final q = ref.watch(adminUserQueryProvider);
      final l = context.l10n;
      void set(UserSortField sort, SortDirection direction) =>
          ref.read(adminUserQueryProvider.notifier).set((
            search: q.search,
            role: q.role,
            sort: sort,
            direction: direction,
          ));
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioGroup<UserSortField>(
            groupValue: q.sort,
            onChanged: (v) {
              if (v != null) set(v, q.direction);
            },
            child: Column(
              children: [
                RadioListTile(
                  value: UserSortField.name,
                  title: Text(l.uiUsersSortName),
                ),
                RadioListTile(
                  value: UserSortField.createdAt,
                  title: Text(l.uiUsersSortCreated),
                ),
              ],
            ),
          ),
          for (final d
              in ref
                      .watch(taskCatalogControllerProvider)
                      .value
                      ?.coordinatorships ??
                  const <CoordinatorshipRef>[])
            CheckboxListTile(
              title: Text(d.name),
              value: ref.watch(adminUserDepartmentsProvider).contains(d.code),
              onChanged: (_) => ref
                  .read(adminUserDepartmentsProvider.notifier)
                  .toggle(d.code),
            ),
          TextButton(
            onPressed: ref.read(adminUserDepartmentsProvider.notifier).clear,
            child: Text(l.uiUsersClearDepartments),
          ),
          SwitchListTile(
            title: Text(l.uiUsersDescending),
            value: q.direction == SortDirection.desc,
            onChanged: (v) =>
                set(q.sort, v ? SortDirection.desc : SortDirection.asc),
          ),
        ],
      );
    },
  ),
);
