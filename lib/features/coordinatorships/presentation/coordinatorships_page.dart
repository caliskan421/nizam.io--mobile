import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/page/nz_shell_events.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/coordinatorships_controller.dart';
import '../domain/coordinatorship_overview.dart';
import 'coord_texts.dart';

/// Koordinatörlükler (prototip `coord`): kök üst çubuk, başlık + özet satırı, koordinatörlük
/// kartları (kod, ad, kişiler, "9/13 bitti", gecikme rozeti, ilerleme). Sıralama alt menüdeki
/// kısayol menüsünden (sekmeye yeniden dokunma). Kart → ayrıntı.
class CoordinatorshipsPage extends ConsumerWidget {
  const CoordinatorshipsPage({super.key});

  /// Kabukta bu sayfanın sekme sırası (kısayol olayı süzgeci).
  static const shellTab = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(shellReselectEventsProvider, (_, next) {
      final visible = ModalRoute.of(context)?.isCurrent ?? true;
      if (next?.tab != shellTab || !visible) return;
      showCoordinatorshipsShortcuts(context, ref);
    });
    final list = ref.watch(coordinatorshipListProvider);
    final nav = context.appNav;
    return NzPage.feed(
      onRetry: () => ref.invalidate(taskCatalogControllerProvider),
      topBar: const RootTopBar(),
      children: [
        NzAsyncView<List<CoordinatorshipStats>>(
          value: list,
          onRetry: () => ref.invalidate(taskCatalogControllerProvider),
          data: (items) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NzPageHeader(
                title: context.l10n.uiCoordTitle,
                subtitle: context.l10n.coordListSubtitle(items),
              ),
              const Gap(NizamioSpacing.space5),
              Semantics(
                container: true,
                label: context.l10n.uiCoordListLabel,
                explicitChildNodes: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: NizamioSpacing.gapMd,
                  children: [
                    for (final c in items)
                      CoordinatorshipCard(
                        stats: c,
                        onTap: () => nav.openCoordinatorship(c.code),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Liste kartı (prototip `.t-card`): kod + ad, kişiler; sağda "9/13 bitti" ve gecikme rozeti;
/// altta ilerleme çubuğu.
class CoordinatorshipCard extends StatelessWidget {
  const CoordinatorshipCard({
    super.key,
    required this.stats,
    required this.onTap,
  });

  final CoordinatorshipStats stats;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final s = stats;
    final people = l.coordPeople(s);
    return NzCard.outlined(
      padding: const EdgeInsets.all(NizamioSpacing.cardPad),
      onTap: onTap,
      semanticLabel: [
        s.code,
        s.name,
        people,
        l.coordDone(s),
        if (s.late > 0) l.coordLate(s),
      ].join('. '),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: NizamioSpacing.space1 / 2,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          s.code,
                          style: t.monoSm.copyWith(color: c.textMuted),
                        ),
                        const Gap(NizamioSpacing.space2),
                        Expanded(
                          child: Text(
                            s.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.labelLg.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      people,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.caption.copyWith(color: c.textMuted),
                    ),
                  ],
                ),
              ),
              const Gap(NizamioSpacing.space3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: NizamioSpacing.space1,
                children: [
                  Text(l.coordDone(s), style: t.mono),
                  if (s.late > 0)
                    NzStatusLabel.badge(
                      label: l.coordLate(s),
                      tone: NzTone.danger,
                    ),
                ],
              ),
            ],
          ),
          const Gap(NizamioSpacing.gapMd),
          NzProgressBar(value: s.ratio, color: c.accentText),
        ],
      ),
    );
  }
}

/// Alt menüde "Koordinatörlükler"e yeniden dokununca açılan kısayol menüsü: tümünü zaman
/// çizelgesinde gör, koordinatörlük ekle (yer tutucu), sıralama.
Future<void> showCoordinatorshipsShortcuts(
  BuildContext context,
  WidgetRef ref,
) {
  final l = context.l10n;
  final nav = context.appNav;
  final sort = ref.read(coordinatorshipsControllerProvider);
  final commands = ref.read(coordinatorshipsControllerProvider.notifier);
  final messenger = context;
  return NzFlyoutMenu.show(
    context,
    semanticLabel: l.uiCoordShortcuts,
    entries: [
      NzFlyoutSection(l.uiCoordFlySectionList),
      NzFlyoutItem(
        label: l.uiCoordFlyTimelineAll,
        icon: Icons.view_timeline_outlined,
        onSelected: nav.openTimeline,
      ),
      NzFlyoutItem(
        label: l.uiCoordFlyAdd,
        icon: Icons.add_rounded,
        onSelected: () {
          if (messenger.mounted) {
            NzToast.show(messenger, l.uiCoordToastAddForm);
          }
        },
      ),
      NzFlyoutSection(l.uiCoordFlySectionSort),
      for (final (s, icon) in const [
        (CoordinatorshipSort.name, Icons.sort_by_alpha_rounded),
        (CoordinatorshipSort.late, Icons.warning_amber_rounded),
        (CoordinatorshipSort.progress, Icons.show_chart_rounded),
      ])
        NzFlyoutItem(
          label: l.coordSortLabel(s),
          icon: icon,
          selected: s == sort,
          onSelected: () => commands.sortBy(s),
        ),
    ],
  );
}
