import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../messages/messages.dart';
import '../../tasks/tasks.dart';

/// Kişiye ait eylemler; atama yalnız seçili programda güncel ekip ve oluşturma yetkisi
/// birlikte varsa açılır. Mesajın kimliği sunucunun birebir sohbet yanıtından gelir.
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
    final catalog = value.isReloading ? null : value.value;
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
    return Wrap(
      spacing: NizamioSpacing.space2,
      runSpacing: NizamioSpacing.space2,
      children: [
        if (access != null && access.accountId != widget.accountId)
          NzButton.secondary(
            label: context.l10n.uiMessagesNewMessage,
            loading: _messaging,
            onPressed: _message,
          ),
        if (department != null)
          NzButton.secondary(
            label: context.l10n.uiTasksNewTask,
            onPressed: () => showNewTaskSheet(
              context,
              coordinatorship: department.code,
              initialAssignee: widget.accountId,
            ),
          ),
      ],
    );
  }
}
