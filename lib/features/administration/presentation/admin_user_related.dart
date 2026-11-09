import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../messages/messages.dart';
import '../../tasks/tasks.dart';

class AdminUserRelatedActions extends ConsumerStatefulWidget {
  const AdminUserRelatedActions({super.key, required this.accountId});
  final String accountId;
  @override
  ConsumerState<AdminUserRelatedActions> createState() =>
      _RelatedActionsState();
}

class _RelatedActionsState extends ConsumerState<AdminUserRelatedActions> {
  bool _messaging = false;
  Future<void> _message() async {
    if (_messaging) return;
    setState(() => _messaging = true);
    try {
      await openPersonChat(context, widget.accountId);
    } finally {
      if (mounted) setState(() => _messaging = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(taskCatalogControllerProvider);
    final catalog = value.isReloading || value.hasError ? null : value.value;
    final program = ref.watch(scopeStateProvider).programId;
    final access = catalog?.access;
    final department = catalog?.coordinatorships
        .where(
          (d) =>
              d.team.contains(widget.accountId) &&
              program != null &&
              (access?.canCreateIn(program, d.code) ?? false),
        )
        .firstOrNull;
    return Row(
      children: [
        Expanded(
          child: NzButton.secondary(
            label: context.l10n.uiUsersMessage,
            icon: NzIcons.mail,
            loading: _messaging,
            expand: true,
            onPressed: access != null && access.accountId != widget.accountId
                ? _message
                : null,
          ),
        ),
        const Gap(NizamioSpacing.space2),
        Expanded(
          child: NzButton.primary(
            label: context.l10n.uiUsersAssign,
            icon: NzIcons.add,
            expand: true,
            onPressed: department == null
                ? null
                : () => showNewTaskSheet(
                    context,
                    coordinatorship: department.code,
                    initialAssignee: widget.accountId,
                  ),
          ),
        ),
      ],
    );
  }
}
