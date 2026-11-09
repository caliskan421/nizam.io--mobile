import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/nz_button.dart';
import '../../../core/ui/widgets/inputs/nz_check_circle.dart';
import '../../../core/ui/widgets/lists/nz_menu_group.dart';
import '../../../core/ui/widgets/overlays/nz_bottom_sheet.dart';
import '../../tasks/tasks.dart';
import '../application/admin_controller.dart';
import '../domain/admin_user_directory.dart';

Future<void> showAdminUsersFilter(BuildContext context) =>
    NzBottomSheet.show<void>(
      context,
      title: context.l10n.uiTimelineCoord,
      description: 'Birden çok seçebilirsin',
      actionsDivider: false,
      actions: (sheet) => [
        Consumer(
          builder: (context, ref, _) => NzButton.secondary(
            label: context.l10n.uiTasksClear,
            onPressed: ref.read(adminUserDepartmentsProvider.notifier).clear,
          ),
        ),
        Consumer(
          builder: (context, ref, _) {
            final count =
                ref.watch(adminUsersSummaryProvider)?.matched?.label ?? '—';
            return NzButton.primary(
              label: '$count kişiyi göster',
              onPressed: () => Navigator.of(sheet).maybePop(),
            );
          },
        ),
      ],
      builder: (_) => const _CoordinatorshipFilter(),
    );

class _CoordinatorshipFilter extends ConsumerWidget {
  const _CoordinatorshipFilter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(adminUsersProvider);
    final directory = ref.read(adminUsersProvider.notifier).directory;
    final items = directory?.items ?? [];
    final exact =
        directory != null && !directory.hasMore && !directory.truncated;
    final programId = ref.watch(scopeStateProvider).programId;
    final selected = ref.watch(adminUserDepartmentsProvider);
    final controller = ref.read(adminUserDepartmentsProvider.notifier);
    final coordinatorships =
        ref.watch(taskCatalogControllerProvider).value?.coordinatorships ?? [];
    String count(int n) => '$n${exact ? '' : '+'} kişi';
    return NzMenuGroup(
      rows: [
        for (final d in coordinatorships)
          AdminCoordinatorshipFilterRow(
            label: d.name,
            code: d.shortCode,
            count: count(
              items
                  .where(
                    (u) => u.teams.any(
                      (m) =>
                          m.programId == programId && m.departmentId == d.code,
                    ),
                  )
                  .length,
            ),
            selected: selected.contains(d.code),
            onTap: () => controller.toggle(d.code),
          ),
        AdminCoordinatorshipFilterRow(
          label: context.l10n.uiUsersUnassigned,
          count: count(
            items
                .where((u) => !u.teams.any((m) => m.programId == programId))
                .length,
          ),
          selected: selected.contains(unassignedDepartmentFilter),
          onTap: () => controller.toggle(unassignedDepartmentFilter),
        ),
      ],
    );
  }
}

class AdminCoordinatorshipFilterRow extends StatelessWidget {
  const AdminCoordinatorshipFilterRow({
    super.key,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
    this.code,
  });
  final String label;
  final String? code;
  final String? count;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NizamioSpacing.space3,
        vertical: NizamioSpacing.space1,
      ),
      child: Row(
        children: [
          NzCheckCircle(value: selected, label: label, onChanged: onTap),
          const Gap(NizamioSpacing.space2),
          Expanded(child: Text(label, style: context.text.list)),
          if (code != null) ...[
            Text(
              code!,
              style: context.text.monoSm.copyWith(
                color: context.colors.textMuted,
              ),
            ),
            if (count != null) const Gap(NizamioSpacing.space4),
          ],
          if (count != null)
            Text(
              count!,
              style: context.text.monoSm.copyWith(
                color: context.colors.textMuted,
              ),
            ),
        ],
      ),
    ),
  );
}
