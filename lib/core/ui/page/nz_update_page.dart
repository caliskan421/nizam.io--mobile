import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../config/update_store.dart';
import '../../theme/generated/tokens.gen.dart';
import '../extensions/context_ext.dart';
import '../layout/layout.dart';
import '../widgets/buttons/buttons.dart';
import '../widgets/buttons/store_update_action.dart';
import '../widgets/navigation/nz_top_bar.dart';
import 'nz_page.dart';

/// A quiet full-screen release message, shared by remote and server gates.
/// Dismissal is supplied only for an optional recommendation.
class NzUpdatePage extends ConsumerWidget {
  const NzUpdatePage({
    super.key,
    required this.title,
    required this.message,
    this.details,
    this.onRecheck,
    this.checking = false,
    this.onDismiss,
  });

  static const _contentShift = 50.0;

  final String title;
  final String message;
  final Widget? details;
  final VoidCallback? onRecheck;
  final bool checking;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final storeAvailable = ref.watch(updateStoreProvider).available;
    final secondaryActions = <Widget>[
      if (storeAvailable && onRecheck != null)
        NzButton.ghost(
          label: l.uiServerUpdateRecheck,
          loading: checking,
          onPressed: onRecheck,
        ),
      if (onDismiss != null)
        TextButton(
          onPressed: onDismiss,
          style: TextButton.styleFrom(
            foregroundColor: context.colors.accentText,
            textStyle: context.text.bodyMd.copyWith(
              fontWeight: context.text.labelLg.fontWeight,
            ),
            minimumSize: const Size(
              NizamioSpacing.space16,
              NizamioSpacing.space12,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: NizamioSpacing.space4,
            ),
            overlayColor: context.colors.background.withValues(alpha: 0),
            splashFactory: NoSplash.splashFactory,
            animationDuration: Duration.zero,
            enableFeedback: false,
          ),
          child: Text(l.uiServerUpdateLater),
        ),
    ];
    return NzPage.bare(
      animateContent: false,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: NzContentWidth.form.maxWidth),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NizamioSpacing.space8,
                      vertical: NizamioSpacing.space4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Gap(
                          NizamioSpacing.space12 +
                              NizamioSpacing.space8 +
                              _contentShift,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: NzBrandMark(
                            monogram: l.uiHomeAppName.characters.first,
                            extent: NizamioSpacing.space12,
                          ),
                        ),
                        const Gap(NizamioSpacing.space6),
                        Semantics(
                          header: true,
                          child: Text(title, style: context.text.displayLg),
                        ),
                        const Gap(NizamioSpacing.space4),
                        Text(
                          message,
                          style: context.text.bodyMd.copyWith(
                            color: context.colors.textMuted,
                          ),
                        ),
                        if (details != null) ...[
                          const Gap(NizamioSpacing.space4),
                          details!,
                        ],
                        const Gap(NizamioSpacing.space8),
                        const Spacer(),
                        StoreUpdateAction(
                          onRecheck: onRecheck,
                          checking: checking,
                          unavailableMessage: onDismiss == null
                              ? l.uiServerUpdateStoreRequiredUnavailable
                              : l.uiServerUpdateStoreUnavailable,
                        ),
                        if (secondaryActions.isNotEmpty) ...[
                          const Gap(NizamioSpacing.space2),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: NizamioSpacing.space4,
                            runSpacing: NizamioSpacing.space1,
                            children: secondaryActions,
                          ),
                        ],
                        const Gap(NizamioSpacing.space4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
