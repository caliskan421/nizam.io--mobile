import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/motion/page_content_entrance.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../application/coordinatorship_query_controller.dart';
import '../../domain/home_dashboard.dart';
import 'home_sections.dart';
import 'home_texts.dart';

/// Koordinatörlükler bölümü: başlık + sıralama denetimi, 2'li kart ızgarası, "Tümünü göster /
/// Daralt". Durum ve komutlar [CoordinatorshipQueryController]'da. [wide] (tablette tam
/// genişlik ana sayfa): büyük başlık, 4'lü ızgara, daraltılmışken iki satır.
class HomeCoordinatorships extends ConsumerWidget {
  const HomeCoordinatorships({
    super.key,
    required this.items,
    required this.onOpen,
    this.wide = false,
    this.truncated = false,
  });

  final List<CoordinatorshipSummary> items;
  final bool wide;
  final bool truncated;

  static const _wideColumns = 4;

  /// Karta dokunma → koordinatörlük ayrıntısı (kod).
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final query = ref.watch(coordinatorshipQueryControllerProvider);
    final commands = ref.read(coordinatorshipQueryControllerProvider.notifier);
    final sorted = query.sorted(items);
    final columns = wide ? _wideColumns : 2;
    final collapsed = wide
        ? 2 * _wideColumns
        : CoordinatorshipQuery.collapsedCount;
    final visible = query.visible(items, collapsed: collapsed);
    // Sıralama değişince kartlar yeniden girer; "tümünü göster"de yalnız yeni gelenler
    // (kimlik aynı kalan kart hareket etmez). Kademe satır satırdır.
    final order = (query.sort, query.descending);
    final sortLabel = l.sortLabel(query.sort);
    final direction = query.descending
        ? l.uiHomeSortDescending
        : l.uiHomeSortAscending;
    final title = Semantics(
      header: true,
      child: Text(
        l.uiHomeCoordinatorships,
        style: wide ? context.text.titleLg : context.text.labelLg,
      ),
    );
    final sort = NzSplitButton(
      label: sortLabel,
      semanticLabel: '${l.uiHomeSortChange}: $sortLabel',
      onPressed: commands.cycleSort,
      icon: NzIcons.chevronDown,
      iconTurns: query.descending ? 0 : 0.5,
      iconSemanticLabel: '${l.uiHomeSortFlip}: $direction',
      onIconPressed: commands.flipDirection,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: title),
            const Gap(NizamioSpacing.space3),
            sort,
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
                l.uiHomeCoordinatorshipsEmpty,
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
                  child: _CoordCard(
                    c: c,
                    truncated: truncated,
                    onTap: () => onOpen(c.code),
                  ),
                ),
            ],
          ),
        if (sorted.length > collapsed) ...[
          const Gap(NizamioSpacing.space3),
          NzButton.secondary(
            label: query.expanded
                ? l.uiHomeCollapse
                : '${l.uiHomeShowAll} (${sorted.length})',
            expand: true,
            onPressed: commands.toggleExpanded,
          ),
        ],
      ],
    );
  }
}

class _CoordCard extends StatelessWidget {
  const _CoordCard({
    required this.c,
    required this.truncated,
    required this.onTap,
  });
  final CoordinatorshipSummary c;
  final bool truncated;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final t = context.text;
    final count = '${truncated ? '≥' : ''}${c.total} ${l.uiHomeTasksLc}';
    final late = c.late > 0
        ? '${truncated ? '≥' : ''}${c.late} ${l.uiHomeLateLc}'
        : l.uiHomeNoLate;
    final percent = l.percent(c.donePercent / 100);
    // Sunucu özeti kalan durumu onay ve iadeyi birlikte taşır; ayrıymış gibi renklendirilmez.
    final segments = <(int, Color)>[
      (c.done, colors.accentText),
      (c.inProgress, colors.inProgress),
      (c.inReview, colors.info),
      (c.todo, colors.textFaint),
    ].where((entry) => entry.$1 > 0).toList();
    return Semantics(
      button: true,
      label: '${c.name}. $percent. $count. $late',
      onTap: onTap,
      excludeSemantics: true,
      child: NzPressable.card(
        child: Material(
          color: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: colors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(NizamioSpacing.space5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodyMd.copyWith(
                      color: colors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(NizamioSpacing.space2),
                  Text(
                    percent,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.displayLg.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.text,
                    ),
                  ),
                  const Spacer(),
                  const Gap(NizamioSpacing.space3),
                  SizedBox(
                    key: const ValueKey('coord-task-distribution'),
                    height: 6,
                    child: segments.isEmpty
                        ? DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.surfaceRaised,
                              borderRadius: BorderRadius.circular(
                                NizamioRadius.pill,
                              ),
                            ),
                            child: const SizedBox(width: double.infinity),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 2,
                            children: [
                              for (final segment in segments)
                                Expanded(
                                  flex: segment.$1,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: segment.$2,
                                      borderRadius: BorderRadius.circular(
                                        NizamioRadius.pill,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),
                  const Gap(NizamioSpacing.space3),
                  Text.rich(
                    TextSpan(
                      style: t.bodySm.copyWith(color: colors.textMuted),
                      children: [
                        TextSpan(text: count),
                        const TextSpan(text: ' · '),
                        TextSpan(
                          text: late,
                          style: TextStyle(
                            color: c.late > 0
                                ? colors.danger
                                : colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
