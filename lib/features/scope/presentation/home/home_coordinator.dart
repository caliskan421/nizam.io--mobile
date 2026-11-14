import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import 'home_coordinator_sections.dart';
import 'home_overview.dart';
import 'home_sections.dart';
import 'home_wide.dart';
import 'module_menu_texts.dart';

/// Ana sayfanın koordinatör bölümleri; yönetici ana sayfasının dili (genel durum halkası, özet
/// kutuları, ekip kutuları) etkin koordinatörlüğün görevleriyle ([coordinatorBoardProvider]).
/// Dar düzen tek sütun: genel durum (koordinatörlük adı), hızlı işlemler, 2×3 özet kutusu, onay
/// bekleyenler, atanmamış, ekip yükü, yaklaşan toplantılar (toplantı kartları), tarih taleplerim.
/// Geniş düzen: genel durum + 2×2 hızlı işlemler; dört özet kutusu; tamamlanma ve devam + ekip;
/// onay bekleyenler; atanmamış + tarih taleplerim; ekip yükü; yaklaşan toplantılar.
class HomeCoordinatorFeed extends ConsumerWidget {
  const HomeCoordinatorFeed({super.key, required this.wide, this.quick});

  final bool wide;

  /// Hızlı işlemler (boşsa null; bölüm çizilmez). Geniş düzende 2×2 kart, darda tek satır.
  final Widget? quick;

  /// Bölüm başına gösterilen satır.
  static const rowsPerSection = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(coordinatorBoardProvider);
    final today = ref.watch(
      taskCatalogControllerProvider.select((s) => s.value?.today),
    );
    final coord = ref.watch(
      taskCatalogControllerProvider.select(
        (s) =>
            board == null ? null : s.value?.coordinatorship(board.departmentId),
      ),
    );
    if (board == null || today == null) {
      return const NzSkeleton.block(height: 190);
    }
    final l = context.l10n;
    final pending = (ref.watch(myDateRequestsProvider).value ?? const [])
        .where((r) => r.isPending)
        .length;
    final overview = HomeOverview(
      statuses: [for (final t in board.tasks) t.status],
      truncated: board.truncated,
      title: board.departmentName,
      legendGrid: wide && quick != null,
    );
    final kpis = homeCoordinatorKpis(
      context,
      board: board,
      pendingRequests: pending,
    );
    final queue = HomeSectionFrame(
      title: l.uiHomeQueueTitle,
      count: board.queue.length,
      onAll: board.queue.length > rowsPerSection
          ? () => showReviewQueueSheet(context)
          : null,
      empty: l.uiHomeQueueEmpty,
      table: (l.uiHomeTableTask, l.uiHomeTableDue),
      children: [
        for (final t in board.queue.take(rowsPerSection))
          TaskQueueRow(task: t, today: today, flat: true, inline: wide),
      ],
    );
    Widget? unassigned({bool fill = false}) => board.unassigned.isEmpty
        ? null
        : HomeSectionFrame(
            fill: fill,
            title: l.uiHomeUnassignedTitle,
            count: board.unassigned.length,
            onAll: board.unassigned.length > rowsPerSection
                ? () => context.appNav.openTasks(view: NzTaskView.unassigned)
                : null,
            table: const (null, null),
            children: [
              for (final t in board.unassigned.take(rowsPerSection))
                TaskUnassignedRow(task: t, today: today, flat: true),
            ],
          );
    const meetings = HomeUpcomingMeetings();
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, w) in [
            overview,
            ?quick,
            HomeGrid(columns: 2, gap: NizamioSpacing.gapMd, children: kpis),
            queue,
            ?unassigned(),
            HomeTeamLoad(board: board),
            meetings,
            const HomeMyDateRequests(),
          ].indexed) ...[if (i > 0) const Gap(NizamioSpacing.gapXl), w],
        ],
      );
    }
    // Yan yana iki öğe aynı yükseklikte (veri az/boş olsa da); kartlar `fill` ile uzar.
    Widget pair(Widget a, Widget? b, {int flexA = 1, int flexB = 1}) =>
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: flexA, child: a),
              const Gap(homeWideGap),
              Expanded(flex: flexB, child: b ?? const SizedBox.shrink()),
            ],
          ),
        );
    final team = homeCoordinatorTeamTiles(context, coord);
    // Özet kutuları yöneticideki gibi 4 sütun: ilk dördü üst satır; tamamlanma ve devam alt
    // satırın solunda, ekip sağda ("Ekip" başlığı + kutular kutularla aynı yükseklikte).
    final lower = LayoutBuilder(
      builder: (context, box) {
        const g = NizamioSpacing.gapMd;
        final col = (box.maxWidth - 3 * g) / 4;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: col, child: kpis[4]),
              const Gap(g),
              SizedBox(width: col, child: kpis[5]),
              const Gap(g),
              SizedBox(
                width: 2 * col + g,
                child: team.isEmpty
                    ? null
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          NzKicker(l.uiHomeTeam),
                          const Gap(NizamioSpacing.gapMd),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: g,
                              children: [
                                for (final w in team) Expanded(child: w),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
    final open = unassigned(fill: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (quick case final q?)
          pair(overview, q, flexA: 5, flexB: 3)
        else
          overview,
        const Gap(NizamioSpacing.gapXl),
        HomeGrid(
          columns: 4,
          gap: NizamioSpacing.gapMd,
          children: kpis.take(4).toList(),
        ),
        const Gap(NizamioSpacing.gapXl),
        lower,
        const Gap(NizamioSpacing.gapXl),
        queue,
        const Gap(NizamioSpacing.gapXl),
        // Atanmamış yoksa tarih talepleri ekip yüküyle yan yana.
        if (open == null)
          pair(
            HomeTeamLoad(board: board, fill: true),
            const HomeMyDateRequests(fill: true),
          )
        else ...[
          pair(open, const HomeMyDateRequests(fill: true)),
          const Gap(NizamioSpacing.gapXl),
          HomeTeamLoad(board: board),
        ],
        const Gap(NizamioSpacing.gapXl),
        meetings,
      ],
    );
  }
}

/// Bölüm iskeleti: [NzSectionHeader] (başlık, sayı, "Tümü ›") ve tek [NzTableCard] içinde
/// ayraçlı satırlar (satırlar kendi dolgusunu taşır); boşsa boş metni de kart içinde. [table]
/// sütun adlarıdır (verilmezse şeritsiz). [below] başlık ile kart arasına girer (üyede
/// istatistik şeridi).
class HomeSectionFrame extends StatelessWidget {
  const HomeSectionFrame({
    super.key,
    required this.title,
    required this.children,
    this.count,
    this.onAll,
    this.empty,
    this.table,
    this.below,
    this.allLabel,
    this.fill = false,
  });

  final String title;
  final int? count;
  final List<Widget> children;
  final VoidCallback? onAll;
  final String? empty;
  final (String?, String?)? table;
  final Widget? below;

  /// "Tümü" yerine bağlantı metni (ör. "Takvim").
  final String? allLabel;

  /// Verilen yüksekliği kartla doldurur (yan yana çiftte iki kart aynı boyda; içerik üstten).
  /// Yalnız sınırlı yükseklikte (çiftin `IntrinsicHeight` satırı) açılır.
  final bool fill;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final empty = this.empty;
    final table = this.table;
    final card = children.isEmpty && empty != null
        ? NzTableCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(NizamioSpacing.space4),
                child: Text(
                  empty,
                  style: context.text.bodyMd.copyWith(color: c.textMuted),
                ),
              ),
            ],
          )
        : NzTableCard(
            leading: table?.$1,
            trailing: table?.$2,
            children: children,
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzSectionHeader(
          title,
          count: count,
          onAll: onAll,
          allLabel: allLabel ?? l.uiHomeSeeAll,
        ),
        const Gap(NizamioSpacing.gapMd),
        if (below case final w?) ...[w, const Gap(NizamioSpacing.gapMd)],
        if (fill) Expanded(child: card) else card,
      ],
    );
  }
}

/// Karşılamanın altındaki etkin görünüm kapsülü: rol noktası + "Koordinatör · Altyapı ve
/// tesisat".
class HomeViewLine extends StatelessWidget {
  const HomeViewLine({super.key, required this.view});

  final EffectiveAccess view;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: NzDotChip(
        color: effectiveRoleColor(context.colors, view.role),
        label: context.l10n.viewCaption(view),
      ),
    );
  }
}
