import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/nz_button.dart';
import '../../../core/ui/widgets/nz_size.dart';
import '../domain/user_account_draft.dart';

class AdminUserAccountDock extends StatelessWidget {
  const AdminUserAccountDock({
    super.key,
    required this.draft,
    required this.onDiscard,
    required this.onSave,
  });
  final UserAccountDraft draft;
  final VoidCallback onDiscard;
  final VoidCallback? onSave;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return Container(
      height: 54,
      padding: const EdgeInsets.only(
        left: NizamioSpacing.space4 + NizamioSpacing.space1 / 2,
        right: NizamioSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(NizamioRadius.pill),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l.uiUsersAccountUnsaved,
              style: context.text.bodyMd,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(NizamioRadius.pill),
            child: NzButton.secondary(
              label: l.uiUsersAccountCancel,
              size: NzSize.sm,
              onPressed: draft.busy ? null : onDiscard,
            ),
          ),
          const Gap(NizamioSpacing.space2),
          ClipRRect(
            borderRadius: BorderRadius.circular(NizamioRadius.pill),
            child: NzButton.primary(
              label: l.uiUsersAccountSave,
              size: NzSize.sm,
              loading: draft.busy,
              onPressed: draft.busy || !draft.valid ? null : onSave,
            ),
          ),
        ],
      ),
    );
  }
}
