import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/extensions/ref_ext.dart';
import '../../../core/ui/layout/layout.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/current_program_controller.dart';
import '../application/scope_selection_controller.dart';
import '../domain/program.dart';

/// Ana sayfa (boş kabuk sekmesi): seçili programın adı S2 `GET /v1/program` yanıtından gelir.
/// "Kapsamı değiştir" seçimi kaldırır; faz `sessionOpen`'a döner ve program seçimi açılır.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listenErrors(scopeSelectionControllerProvider, context);
    final l = context.l10n;
    return NzPage(
      title: l.uiScopeHomeTitle,
      width: NzContentWidth.reading,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space6),
        children: [
          NzAsyncView<Program?>(
            value: ref.watch(currentProgramControllerProvider),
            onRetry: () => ref.invalidate(currentProgramControllerProvider),
            data: (program) => program == null
                ? const SizedBox.shrink()
                : _ProgramCard(program),
          ),
          const Gap(NizamioSpacing.space6),
          NzButton.secondary(
            label: l.uiScopeHomeChange,
            expand: true,
            onPressed: () =>
                ref.read(scopeSelectionControllerProvider.notifier).clear(),
          ),
        ],
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard(this.program);

  final Program program;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final muted = context.text.bodyMd.copyWith(color: context.colors.textMuted);
    final year = program.year;
    return NzCard.outlined(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.uiScopeHomeProgram, style: muted),
          const Gap(NizamioSpacing.space1),
          Text(program.name, style: context.text.titleMd),
          if (year != null) ...[
            const Gap(NizamioSpacing.space2),
            MergeSemantics(
              child: Wrap(
                spacing: NizamioSpacing.space2,
                children: [
                  Text(l.uiScopeHomeYear, style: muted),
                  Text('$year', style: context.text.labelLg),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
