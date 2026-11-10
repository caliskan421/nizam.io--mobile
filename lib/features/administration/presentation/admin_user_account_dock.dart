import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/theme/nz_motion.dart';
import '../../../core/ui/widgets/buttons/nz_button.dart';
import '../../../core/ui/widgets/nz_size.dart';
import '../application/user_account_draft_controller.dart';
import '../domain/user_account_draft.dart';

class AdminUserAccountDockSlot extends ConsumerWidget {
  const AdminUserAccountDockSlot({
    super.key,
    required this.accountId,
    required this.onSave,
    required this.active,
  });

  final String accountId;
  final bool active;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = userAccountDraftProvider(accountId);
    final draft = ref.watch(provider);
    final visible = active && draft != null && (draft.dirty || draft.busy);
    return AnimatedSwitcher(
      duration: NzMotion.of(context, const Duration(milliseconds: 260)),
      reverseDuration: NzMotion.of(context, const Duration(milliseconds: 200)),
      switchInCurve: const Cubic(.2, .8, .2, 1),
      switchOutCurve: Curves.easeIn.flipped,
      layoutBuilder: (current, previous) => SizedBox(
        height: 64,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [...previous, ?current],
        ),
      ),
      transitionBuilder: (child, animation) => AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) => FractionalTranslation(
          translation: Offset(0, (1 - animation.value) * 1.4),
          child: Opacity(
            opacity: (animation.value * 1.6).clamp(0, 1),
            child: child,
          ),
        ),
      ),
      child: visible
          ? AdminUserAccountDock(
              key: const ValueKey('account-dock'),
              draft: draft,
              onDiscard: ref.read(provider.notifier).discard,
              onSave: onSave,
            )
          : const Row(
              key: ValueKey('empty-dock'),
              mainAxisSize: MainAxisSize.min,
              children: [Gap(0)],
            ),
    );
  }
}

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
      height: 64,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              l.uiUsersAccountUnsaved,
              style: context.text.bodyMd,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 48,
            child: Center(
              child: NzButton.secondary(
                label: l.uiUsersAccountCancel,
                size: NzSize.sm,
                radius: NizamioRadius.pill,
                onPressed: draft.busy ? null : onDiscard,
              ),
            ),
          ),
          const Gap(NizamioSpacing.space2),
          SizedBox(
            height: 48,
            child: Center(
              child: NzButton.primary(
                label: l.uiUsersAccountSave,
                size: NzSize.sm,
                radius: NizamioRadius.pill,
                loading: draft.busy,
                onPressed: draft.busy || !draft.valid ? null : onSave,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
