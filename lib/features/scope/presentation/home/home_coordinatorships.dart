import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/motion/page_content_entrance.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/coordinatorship_query_controller.dart';
import '../../domain/home_dashboard.dart';
import 'home_sections.dart';
import 'home_texts.dart';

/// Koordinatörlükler bölümü: başlık + sıralama denetimi, durum filtresi, 2'li kart ızgarası,
/// "Tümünü göster / Daralt". Durum ve komutlar [CoordinatorshipQueryController]'da.
class HomeCoordinatorships extends ConsumerWidget {
  const HomeCoordinatorships({
    super.key,
    required this.items,
    required this.onOpen,
  });

  final List<CoordinatorshipSummary> items;

  /// Karta dokunma → koordinatörlük ayrıntısı (kod).
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final query = ref.watch(coordinatorshipQueryControllerProvider);
    final commands = ref.read(coordinatorshipQueryControllerProvider.notifier);
    final filtered = query.filtered(items);
    final visible = query.visible(items);
    const filters = CoordinatorshipFilter.values;
    // Süzgeç/sıralama değişince kartlar yeniden girer; "tümünü göster"de yalnız yeni gelenler
    // (kimlik aynı kalan kart hareket etmez). Kademe satır satırdır.
    final order = (query.filter, query.sort, query.descending);
    const columns = 2;
    final sortLabel = l.sortLabel(query.sort);
    final direction = query.descending
        ? l.uiHomeSortDescending
        : l.uiHomeSortAscending;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  l.uiHomeCoordinatorships,
                  style: context.text.labelLg,
                ),
              ),
            ),
            NzSplitButton(
              label: sortLabel,
              semanticLabel: '${l.uiHomeSortChange}: $sortLabel',
              onPressed: commands.cycleSort,
              icon: NzIcons.chevronDown,
              iconTurns: query.descending ? 0 : 0.5,
              iconSemanticLabel: '${l.uiHomeSortFlip}: $direction',
              onIconPressed: commands.flipDirection,
            ),
          ],
        ),
        const Gap(NizamioSpacing.space3),
        NzFilterRail(
          semanticLabel: l.uiHomeFilterLabel,
          selected: filters.indexOf(query.filter),
          onSelected: (i) => commands.selectFilter(filters[i]),
          options: [
            for (final f in filters)
              NzFilterOption(
                label: l.filterLabel(f),
                count: items
                    .where((c) => CoordinatorshipQuery.matches(f, c))
                    .length,
              ),
          ],
        ),
        const Gap(NizamioSpacing.space3),
        if (visible.isEmpty)
          NzEntrance(
            replay: order,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: NizamioSpacing.space4,
              ),
              child: Text(
                l.uiHomeFilterEmpty,
                textAlign: TextAlign.center,
                style: context.text.bodyMd.copyWith(
                  color: context.colors.textMuted,
                ),
              ),
            ),
          )
        else
          HomeGrid(
            columns: columns,
            gap: NizamioSpacing.gapMd,
            children: [
              for (final (i, c) in visible.indexed)
                NzEntrance(
                  replay: (order, c.code),
                  index: i ~/ columns,
                  child: _CoordCard(c: c, onTap: () => onOpen(c.code)),
                ),
            ],
          ),
        if (filtered.length > CoordinatorshipQuery.collapsedCount) ...[
          const Gap(NizamioSpacing.space3),
          NzButton.secondary(
            label: query.expanded
                ? l.uiHomeCollapse
                : '${l.uiHomeShowAll} (${filtered.length})',
            expand: true,
            onPressed: commands.toggleExpanded,
          ),
        ],
      ],
    );
  }
}

class _CoordCard extends StatelessWidget {
  const _CoordCard({required this.c, required this.onTap});

  final CoordinatorshipSummary c;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final t = context.text;
    final lead = c.hasLead ? c.leads.join(', ') : l.uiHomeUnassigned;
    final progress = l.coordProgress(c);
    final late = l.coordLate(c);
    final mono = t.kicker.copyWith(fontWeight: FontWeight.w400);
    return NzCard.outlined(
      padding: const EdgeInsets.all(NizamioSpacing.rowPad),
      onTap: onTap,
      semanticLabel: '${c.name}. $lead. $progress. $late',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            c.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: t.bodyMd.copyWith(fontWeight: FontWeight.w600),
          ),
          const Gap(NizamioSpacing.space2),
          Row(
            children: [
              // Atanmamış: `warning` yalnız işarettir — açık temada metin olarak 4.25:1
              // (docs/design-tokens.md); yazı her iki temada ikincil metin rolüdür.
              if (!c.hasLead) ...[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.warning,
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(NizamioSize.statusDot / 2),
                  ),
                ),
                const Gap(NizamioSpacing.space1 + NizamioSpacing.space1 / 2),
              ],
              Expanded(
                child: Text(
                  lead,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.caption.copyWith(color: colors.textMuted),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Gap(NizamioSpacing.space2),
          NzProgressBar.segments(
            segments: [
              NzBarSegment(c.todo, colors.textFaint),
              NzBarSegment(c.inProgress, colors.inProgress),
              NzBarSegment(c.inReview, colors.warning),
              NzBarSegment(c.done, colors.accentText),
            ],
          ),
          const Gap(NizamioSpacing.space2),
          // Prototip: ilerleme solda, gecikme sağda tek satır; sığmazsa alt satıra sarılır.
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: NizamioSpacing.space2,
              children: [
                Text(progress, style: mono),
                Text(
                  late,
                  style: mono.copyWith(
                    color: c.late > 0 ? colors.danger : colors.textFaint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
