import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/nz_button.dart';
import '../../../core/ui/widgets/inputs/nz_check_circle.dart';
import '../../../core/ui/widgets/lists/nz_menu_group.dart';
import '../../../core/ui/widgets/overlays/nz_bottom_sheet.dart';
import '../../tasks/tasks.dart';
import '../application/admin_controller.dart';

Future<void> showAdminUsersFilter(BuildContext context) =>
    NzBottomSheet.show<void>(
      context,
      title: context.l10n.uiTimelineCoord,
      description: context.l10n.uiUsersOneDepartment,
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
    final selected = ref.watch(adminUserDepartmentsProvider);
    final controller = ref.read(adminUserDepartmentsProvider.notifier);
    final coordinatorships =
        ref.watch(taskCatalogControllerProvider).value?.coordinatorships ?? [];
    return NzMenuGroup(
      rows: [
        for (final d in coordinatorships)
          AdminCoordinatorshipFilterRow(
            label: d.name,
            code: d.shortCode,
            selected: selected.contains(d.code),
            onTap: () => controller.toggle(d.code),
          ),
      ],
    );
  }
}

class AdminCoordinatorshipFilterRow extends StatelessWidget {
  const AdminCoordinatorshipFilterRow({
    super.key,
    required this.label,
    this.count,
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
