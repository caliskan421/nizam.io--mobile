import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/extensions/ref_ext.dart';
import '../../../core/ui/layout/layout.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../identity/identity.dart';
import '../application/program_list_controller.dart';
import '../application/scope_selection_controller.dart';

/// Program (kapsam) seçimi (faz: `sessionOpen`). Seçim `ScopeController`'a yazılır; faz
/// `scoped` olur ve yönlendirme faz makinesindedir — ekran kendisi gezinmez. Liste hatası
/// (`program.not_authorized` dahil) `errorText(code)` ile gösterilir.
class ScopePage extends ConsumerWidget {
  const ScopePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listenErrors(scopeSelectionControllerProvider, context);
    final l = context.l10n;
    return NzPage(
      title: l.uiScopeTitle,
      width: NzContentWidth.list,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: NizamioSpacing.space4,
            ),
            child: Text(l.uiScopeIntro, style: context.text.bodyMd),
          ),
          Expanded(
            child: NzAsyncView(
              value: ref.watch(programListControllerProvider),
              onRetry: () => ref.invalidate(programListControllerProvider),
              isEmpty: (slice) => slice.items.isEmpty,
              empty: NzEmptyState(
                title: l.uiScopeEmptyTitle,
                message: l.uiScopeEmptyMessage,
                icon: Icons.folder_off_outlined,
                actionLabel: l.uiScopeContinueWithSample,
                onAction: () => ref
                    .read(scopeSelectionControllerProvider.notifier)
                    .selectSample(),
              ),
              data: (slice) => ListView(
                children: [
                  if (slice.truncated) ...[
                    NzBanner.info(message: l.uiScopeTruncated),
                    const Gap(NizamioSpacing.space2),
                  ],
                  for (final program in slice.items)
                    NzListTile.navigation(
                      title: program.name,
                      onTap: () => ref
                          .read(scopeSelectionControllerProvider.notifier)
                          .select(program.id),
                    ),
                ],
              ),
            ),
          ),
          const Gap(NizamioSpacing.space2),
          const SignOutButton(),
          const Gap(NizamioSpacing.space4),
        ],
      ),
    );
  }
}
